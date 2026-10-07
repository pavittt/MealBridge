"""
Shelter screens: live feed ranked by match score, one-click claim,
claim history, today's need and capacity.

Connection: mb_shelter (role r_shelter). The claim goes through
sp_claim_batch, the concurrency-safe procedure (SELECT ... FOR UPDATE).
"""
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field

from ..auth import require, role_db
from ..common import Evidence, ok

router = APIRouter(prefix="/api/shelter", tags=["shelter"])
SHELTER = require("SHELTER")


@router.get("/feed")
def feed(user=Depends(SHELTER), db=Depends(role_db)):
    site = user["site"]
    # The live feed VIEW (only AVAILABLE, unexpired) ranked by THIS shelter's
    # match score. fn_match_score returns NULL when a hard filter excludes
    # the shelter (diet, capacity, distance, time); those go last.
    batches = db.query(
        "SELECT f.*, fn_match_score(f.batch_id, %s, NOW()) AS match_score "
        "  FROM v_live_feed f "
        " ORDER BY (match_score IS NULL), match_score DESC, f.minutes_left", (site,))
    # Today's row, or the shelter's registered defaults when nobody has
    # entered today's figures yet: the same fallback fn_capacity_score and
    # fn_need_score use, so the card matches what the matching sees.
    today = db.one(
        "SELECT CURDATE() AS day, COALESCE(sd.meals_needed, s.beneficiary_count) AS meals_needed, "
        "       COALESCE(sd.capacity_kg, s.default_capacity_kg) AS capacity_kg, "
        "       COALESCE(sd.reserved_kg, 0) AS reserved_kg, "
        "       COALESCE(sd.capacity_kg, s.default_capacity_kg) - COALESCE(sd.reserved_kg, 0) AS free_kg "
        "  FROM shelter s LEFT JOIN shelter_day sd "
        "         ON sd.shelter_site_id = s.site_id AND sd.day = CURDATE() "
        " WHERE s.site_id = %s", (site,))
    shelter = db.one(
        "SELECT t.name, s.shelter_type, s.beneficiary_count, s.has_refrigeration, "
        "       (SELECT GROUP_CONCAT(tag_code) FROM shelter_diet_exclusion e "
        "         WHERE e.shelter_site_id = s.site_id) AS excludes "
        "  FROM shelter s JOIN site t ON t.site_id = s.site_id WHERE s.site_id = %s", (site,))
    now = db.one("SELECT NOW() AS server_now")["server_now"]
    return ok(db, {"batches": batches, "today": today, "shelter": shelter, "server_now": now})


@router.get("/batches/{batch_id}/why")
def why(batch_id: int, user=Depends(SHELTER), db=Depends(role_db)):
    """Why can (or can't) I claim this? One row per rule and score factor,
    for THIS shelter only (sp_explain_my_eligibility). The shelter role is
    not granted sp_rank_shelters, so other shelters' numbers never reach it."""
    rows, _ = db.call("sp_explain_my_eligibility", [user["uid"], batch_id])
    return ok(db, {"checks": rows})


@router.post("/batches/{batch_id}/claim")
def claim(batch_id: int, user=Depends(SHELTER), db=Depends(role_db)):
    ev = Evidence()
    _, out = db.call("sp_claim_batch", [user["uid"], batch_id], outs=["claim_id", "result"])
    result = {"claim_id": out["claim_id"], "result": out["result"]}
    if out["result"] != "CLAIMED":
        # the procedure never throws: it rolls back and explains (e.g. lost a race)
        raise HTTPException(409, {"message": out["result"], "hood": db.hood("claim")})
    return ok(db, result, action="claim", evidence=ev.collect())


@router.get("/claims")
def claims(user=Depends(SHELTER), db=Depends(role_db)):
    rows = db.query(
        "SELECT c.claim_id, c.batch_id, c.claimed_at, c.status, c.match_score, c.distance_km, "
        "       c.close_reason, b.description, b.quantity_kg, b.status AS batch_status, b.safe_until, "
        "       m.name AS mess, "
        "       (SELECT pt.status FROM trip_item ti JOIN pickup_trip pt ON pt.trip_id = ti.trip_id "
        "         WHERE ti.claim_id = c.claim_id ORDER BY pt.trip_id DESC LIMIT 1) AS trip_status "
        "  FROM claim c "
        "  JOIN surplus_batch b ON b.batch_id = c.batch_id "
        "  JOIN site m ON m.site_id = b.mess_site_id "
        " WHERE c.shelter_site_id = %s "            # uses IDX-7 ix_claim_shelter_time
        " ORDER BY c.claimed_at DESC LIMIT 25", (user["site"],))
    return ok(db, rows)


class CancelIn(BaseModel):
    reason: str = Field(default="Shelter cancelled", max_length=255)


@router.post("/claims/{claim_id}/cancel")
def cancel(claim_id: int, body: CancelIn, user=Depends(SHELTER), db=Depends(role_db)):
    ev = Evidence()
    db.call("sp_cancel_claim", [user["uid"], claim_id, body.reason])
    return ok(db, {"claim_id": claim_id, "status": "CANCELLED"}, action="cancel_claim", evidence=ev.collect())


class TodayIn(BaseModel):
    meals_needed: int = Field(ge=0)
    capacity_kg: float = Field(gt=0)


@router.put("/today")
def set_today(body: TodayIn, user=Depends(SHELTER), db=Depends(role_db)):
    """Column-level write: r_shelter may UPDATE meals_needed and capacity_kg,
    never reserved_kg. The CHECK constraint refuses cutting capacity below
    what is already reserved."""
    db.query("UPDATE shelter_day SET meals_needed = %s, capacity_kg = %s "
             " WHERE shelter_site_id = %s AND day = CURDATE()",
             (body.meals_needed, body.capacity_kg, user["site"]))
    if db.trace[-1]["rows"] == 0 and not db.one(
            "SELECT 1 AS x FROM shelter_day WHERE shelter_site_id = %s AND day = CURDATE()", (user["site"],)):
        db.query("INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) "
                 "VALUES (%s, CURDATE(), %s, %s)", (user["site"], body.meals_needed, body.capacity_kg))
    row = db.one("SELECT day, meals_needed, capacity_kg, reserved_kg FROM shelter_day "
                 " WHERE shelter_site_id = %s AND day = CURDATE()", (user["site"],))
    return ok(db, row, action="set_capacity")
