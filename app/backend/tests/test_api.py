"""
End-to-end API tests against the REAL MySQL database (no mocks).

Run (after loading sql/setup.sql):
    cd app/backend && python -m pytest -v

The tests walk the whole workflow the way the UI does it:
mess posts -> shelter claims -> a second shelter is rejected ->
volunteer plans a trip, picks up, delivers -> the custody chain verifies.
They also check that MySQL (not just the API) refuses what a role may
not do. They add a few SYN rows; reload setup.sql to start clean.
"""
import pytest
from fastapi.testclient import TestClient

from mealbridge_api.main import app

client = TestClient(app)
PW = "demo1234"


def login(email):
    r = client.post("/api/auth/login", json={"email": email, "password": PW})
    assert r.status_code == 200, r.text
    return {"Authorization": "Bearer " + r.json()["data"]["token"]}


MESS = login("mess.a@example.org")
VOL = login("eshan.vol@example.org")          # van, 150 kg, verified
ADMIN = login("admin1@example.org")


def shelter_headers(site_id):
    return login(f"shelter{site_id}@example.org")


# ---------------------------------------------------------------- auth
def test_wrong_password_is_refused():
    r = client.post("/api/auth/login", json={"email": "mess.a@example.org", "password": "nope"})
    assert r.status_code == 401


def test_no_token_is_refused():
    assert client.get("/api/mess/overview").status_code == 401


def test_role_guard_blocks_other_roles_pages():
    assert client.get("/api/shelter/feed", headers=MESS).status_code == 403


def test_hood_reports_the_role_login():
    r = client.get("/api/mess/overview", headers=MESS).json()
    assert r["hood"]["login"] == "mb_mess_admin@localhost"
    assert r["hood"]["mysql_role"] == "r_mess_admin"
    assert any("FROM surplus_batch" in s["sql"] for s in r["hood"]["statements"])


# ---------------------------------------------------------------- workflow
@pytest.fixture(scope="module")
def flow():
    """Posts one batch and returns ids shared by the workflow tests."""
    ov = client.get("/api/mess/overview", headers=MESS).json()["data"]
    now = ov["server_now"]
    r = client.post("/api/mess/batches", headers=MESS, json={
        "category_id": 1, "meal_slot": "LUNCH", "description": "SYN pytest sambar rice",
        "quantity_kg": 4.5, "storage": "HOT_HELD", "cooked_at": now, "diet_tags": ["VEG"]})
    assert r.status_code == 200, r.text
    body = r.json()
    batch = body["data"]
    rank = client.get(f"/api/mess/batches/{batch['batch_id']}/ranking", headers=MESS).json()["data"]["ranking"]
    eligible = [x["shelter_id"] for x in rank if x["verdict"] == "ELIGIBLE"]
    assert len(eligible) >= 2
    return {"batch": batch, "post": body, "eligible": eligible}


def test_trigger_sets_the_perishability_deadline(flow):
    b = flow["batch"]
    # we never sent safe_until; trg_batch_bi computed cooked_at + 4.0 h (hot-held rice)
    assert b["status"] == "AVAILABLE"
    assert 3.9 * 3600 <= b["seconds_left"] <= 4 * 3600
    kinds = [e["event_type"] for e in flow["post"]["hood"]["evidence"]["custody_events"]]
    assert "COOKED" in kinds and "POSTED" in kinds
    assert flow["post"]["hood"]["procedure"] == "sp_post_batch"


def test_shelter_feed_ranks_and_claims(flow):
    first = shelter_headers(flow["eligible"][0])
    feed = client.get("/api/shelter/feed", headers=first).json()["data"]["batches"]
    assert any(x["batch_id"] == flow["batch"]["batch_id"] and x["match_score"] is not None for x in feed)
    r = client.post(f"/api/shelter/batches/{flow['batch']['batch_id']}/claim", headers=first)
    assert r.status_code == 200, r.text
    assert r.json()["data"]["result"] == "CLAIMED"
    flow["claim_id"] = r.json()["data"]["claim_id"]
    audit = r.json()["hood"]["evidence"]["audit_rows"]
    assert any(a["table_name"] == "claim" and a["db_user"].startswith("mb_shelter") for a in audit)


def test_second_shelter_is_rejected(flow):
    second = shelter_headers(flow["eligible"][1])
    r = client.post(f"/api/shelter/batches/{flow['batch']['batch_id']}/claim", headers=second)
    assert r.status_code == 409
    assert "REJECTED" in r.json()["detail"]["message"]


def test_capacity_check_constraint(flow):
    first = shelter_headers(flow["eligible"][0])
    today = client.get("/api/shelter/feed", headers=first).json()["data"]["today"]
    r = client.put("/api/shelter/today", headers=first,
                   json={"meals_needed": today["meals_needed"], "capacity_kg": 0.5})
    assert r.status_code == 400 and r.json()["detail"]["mysql_error"] == 3819   # CHECK violated


def test_volunteer_trip_pickup_delivery(flow):
    ov = client.get("/api/volunteer/overview", headers=VOL).json()["data"]
    assert any(q["claim_id"] == flow["claim_id"] for q in ov["queue"])
    r = client.post("/api/volunteer/trips", headers=VOL, json={"claim_ids": [flow["claim_id"]]})
    assert r.status_code == 200, r.text
    trip_id = r.json()["data"]["trip_id"]
    trip = [t for t in client.get("/api/volunteer/overview", headers=VOL).json()["data"]["trips"]
            if t["trip_id"] == trip_id][0]
    assert [s["stop_type"] for s in trip["stops"]] == ["PICKUP", "DROP"]
    r = client.post(f"/api/volunteer/trips/{trip_id}/stops/1/pickup", headers=VOL, json={"temperature_c": 68})
    assert r.status_code == 200, r.text
    r = client.post(f"/api/volunteer/trips/{trip_id}/stops/2/deliver", headers=VOL,
                    json={"temperature_c": 63, "hygiene_ok": True})
    assert r.status_code == 200, r.text
    kinds = [e["event_type"] for e in r.json()["hood"]["evidence"]["custody_events"]]
    assert kinds == ["HYGIENE_CHECK", "DELIVERED"]


def test_custody_chain_is_intact(flow):
    r = client.get(f"/api/lab/custody?batch_id={flow['batch']['batch_id']}", headers=ADMIN).json()["data"]
    assert r["batch"]["status"] == "DELIVERED"
    assert r["chain"]["intact"] is True
    assert [e["event_type"] for e in r["events"]][-1] == "DELIVERED"


# ---------------------------------------------------------------- RBAC visible
def test_impact_views_follow_grants():
    mess = client.get("/api/impact", headers=MESS).json()["data"]
    assert "rows" in mess["summary"]
    assert "1142" in mess["fairness"]["denied"]          # r_mess_admin has no SELECT on it
    admin = client.get("/api/impact", headers=ADMIN).json()["data"]
    assert all("rows" in v for v in admin.values())


def test_mess_cannot_cancel_other_mess_batch():
    other = login("mess.b@example.org")
    ov = client.get("/api/mess/overview", headers=MESS).json()["data"]
    mine = [b for b in ov["batches"] if b["status"] == "AVAILABLE"]
    if not mine:
        pytest.skip("no AVAILABLE batch left at mess A")
    r = client.post(f"/api/mess/batches/{mine[0]['batch_id']}/cancel", headers=other)
    assert r.status_code == 400 and r.json()["detail"]["mysql_error"] == 1644   # SIGNAL in procedure


# ---------------------------------------------------------------- lab pages
def test_race_has_one_winner_one_loser():
    d = client.post("/api/lab/race", headers=ADMIN).json()["data"]
    res = sorted(c["result"] for c in d["contenders"].values())
    assert res[0] == "CLAIMED" and res[1].startswith("REJECTED")
    assert d["contenders"]["B"]["took_ms"] >= 1500        # B really waited for A's lock
    assert any(l["LOCK_STATUS"] == "WAITING" for l in d["locks"])
    assert len([c for c in d["claims"] if c["active_batch_id"]]) == 1


def test_explain_before_and_after():
    cases = client.get("/api/lab/explain", headers=ADMIN).json()["data"]["cases"]
    feed = [c for c in cases if c["id"] == "feed"][0]
    assert feed["before"]["key"] is None and feed["before"]["type"] == "ALL"
    assert feed["after"]["key"] == "ix_batch_status_deadline"


def test_schema_explorer():
    d = client.get("/api/lab/schema", headers=MESS).json()["data"]
    assert len([t for t in d["tables"] if t["type"] == "BASE TABLE"]) == 24
    kinds = {o["kind"] for o in d["objects"]}
    assert {"PROCEDURE", "FUNCTION", "TRIGGER", "VIEW"} <= kinds
    assert any(c["type"] == "CHECK" for c in d["constraints"])


# ---------------------------------------------------------------- audit fixes (7 Oct 2026)
def test_late_delivery_is_rejected_not_counted():
    """Food handed over after safe_until must not count as a meal saved.
    The clock is moved forward with SET timestamp (session only), so the
    volunteer 'arrives' after the deadline that trg_batch_bi set."""
    from mealbridge_api.db import DbSession
    now = client.get("/api/mess/overview", headers=MESS).json()["data"]["server_now"]
    b = client.post("/api/mess/batches", headers=MESS, json={
        "category_id": 1, "meal_slot": "DINNER", "description": "SYN pytest late rice",
        "quantity_kg": 2, "storage": "HOT_HELD", "cooked_at": now, "diet_tags": ["VEG"]}).json()["data"]
    rank = client.get(f"/api/mess/batches/{b['batch_id']}/ranking", headers=MESS).json()["data"]["ranking"]
    shelter = [x["shelter_id"] for x in rank if x["verdict"] == "ELIGIBLE"][0]
    claim = client.post(f"/api/shelter/batches/{b['batch_id']}/claim", headers=shelter_headers(shelter)).json()["data"]
    trip = client.post("/api/volunteer/trips", headers=VOL, json={"claim_ids": [claim["claim_id"]]}).json()["data"]["trip_id"]
    assert client.post(f"/api/volunteer/trips/{trip}/stops/1/pickup", headers=VOL, json={}).status_code == 200
    uid = client.get("/api/auth/me", headers=VOL).json()["data"]["uid"]
    with DbSession("VOLUNTEER") as db:
        db.query("SET timestamp = UNIX_TIMESTAMP(%s) + 60", (b["safe_until"],))
        db.call("sp_record_delivery", [uid, trip, 2, 60, True, None])
    with DbSession("PLATFORM_ADMIN") as adm:
        c = adm.one("SELECT status, close_reason FROM claim WHERE claim_id = %s", (claim["claim_id"],))
        kinds = [e["event_type"] for e in adm.query(
            "SELECT event_type FROM custody_event WHERE batch_id = %s ORDER BY event_id", (b["batch_id"],))]
        o = adm.one("SELECT status, meals_saved FROM v_batch_outcome WHERE batch_id = %s", (b["batch_id"],))
    assert c["status"] == "REJECTED" and c["close_reason"] == "arrived after safe-until time"
    assert "DELIVERED" not in kinds and kinds[-1] == "REJECTED"
    assert o["status"] == "CANCELLED" and o["meals_saved"] == 0


def test_mess_cannot_rank_other_mess_batch():
    other = login("mess.b@example.org")
    mine = client.get("/api/mess/overview", headers=MESS).json()["data"]["batches"][0]["batch_id"]
    assert client.get(f"/api/mess/batches/{mine}/ranking", headers=other).status_code == 404


def test_bad_input_is_400_not_500():
    now = client.get("/api/mess/overview", headers=MESS).json()["data"]["server_now"]
    r = client.post("/api/mess/batches", headers=MESS, json={
        "category_id": 1, "meal_slot": "LUNCH", "description": "SYN pytest bad tag",
        "quantity_kg": 1, "storage": "HOT_HELD", "cooked_at": now, "diet_tags": ["NOT_A_TAG"]})
    assert r.status_code == 400 and r.json()["detail"]["mysql_error"] == 1452
    assert client.put("/api/admin/weights/NOT_A_WEIGHT", headers=ADMIN, json={"weight_value": 0.2}).status_code == 404


def test_closed_shelter_is_told_why():
    closed = login("shelter16@example.org")          # SYN Bagayam Boys Home (closed)
    batch = client.get("/api/mess/overview", headers=MESS).json()["data"]["batches"][0]["batch_id"]
    checks = client.get(f"/api/shelter/batches/{batch}/why", headers=closed).json()["data"]["checks"]
    rule = [c for c in checks if c["code"] == "OPEN"][0]
    assert rule["passed"] == 0
