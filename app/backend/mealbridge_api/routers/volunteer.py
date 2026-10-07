"""
Volunteer screens: pickup queue, batched multi-stop trips on a map,
pickup and delivery with temperature and hygiene check.

Connection: mb_volunteer (role r_volunteer). The role cannot read the
claim table; it sees claims only through v_pickup_queue and
v_trip_manifest, which expose routing columns and nothing else.
"""
from datetime import datetime
from typing import List, Optional

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field

from ..auth import require, role_db
from ..common import Evidence, ok

router = APIRouter(prefix="/api/volunteer", tags=["volunteer"])
VOL = require("VOLUNTEER")


@router.get("/overview")
def overview(user=Depends(VOL), db=Depends(role_db)):
    uid = user["uid"]
    me = db.one(
        "SELECT vehicle_type, max_load_kg, is_available, verified_at, "
        "       ST_Latitude(home_location) AS home_lat, ST_Longitude(home_location) AS home_lon "
        "  FROM volunteer WHERE user_id = %s", (uid,))
    queue = db.query("SELECT * FROM v_pickup_queue ORDER BY safe_until")
    trips = db.query(
        "SELECT trip_id, status, planned_start, started_at, completed_at, planned_distance_km "
        "  FROM pickup_trip WHERE volunteer_id = %s "     # uses IDX-9 ix_trip_vol_status
        " ORDER BY FIELD(status, 'IN_PROGRESS', 'PLANNED', 'COMPLETED', 'ABORTED'), trip_id DESC "
        " LIMIT 6", (uid,))
    ids = [t["trip_id"] for t in trips]
    stops, manifest = [], []
    if ids:
        marks = ", ".join(["%s"] * len(ids))
        stops = db.query(
            "SELECT ts.trip_id, ts.stop_seq, ts.stop_type, ts.planned_eta, ts.arrived_at, ts.departed_at, "
            "       t.site_id, t.name, t.contact_phone, "
            "       ST_Latitude(t.location) AS lat, ST_Longitude(t.location) AS lon "
            "  FROM trip_stop ts JOIN site t ON t.site_id = ts.site_id "
            f" WHERE ts.trip_id IN ({marks}) ORDER BY ts.trip_id, ts.stop_seq", ids)
        manifest = db.query(
            f"SELECT * FROM v_trip_manifest WHERE trip_id IN ({marks}) ORDER BY trip_id, pickup_seq", ids)
    for t in trips:
        t["stops"] = [s for s in stops if s["trip_id"] == t["trip_id"]]
        t["items"] = [m for m in manifest if m["trip_id"] == t["trip_id"]]
    now = db.one("SELECT NOW() AS server_now")["server_now"]
    return ok(db, {"me": me, "queue": queue, "trips": trips, "server_now": now})


class TripIn(BaseModel):
    claim_ids: List[int] = Field(min_length=1, max_length=10)
    planned_start: Optional[datetime] = None


@router.post("/trips")
def create_trip(body: TripIn, user=Depends(VOL), db=Depends(role_db)):
    import json
    # the same claim ticked twice would hit tmp_trip_claims' primary key
    claim_ids = list(dict.fromkeys(body.claim_ids))
    start = body.planned_start or db.one("SELECT NOW() AS n")["n"]
    _, out = db.call("sp_create_trip", [user["uid"], json.dumps(claim_ids), start], outs=["trip_id"])
    return ok(db, {"trip_id": out["trip_id"]}, action="create_trip")


class PickupIn(BaseModel):
    temperature_c: Optional[float] = Field(default=None, ge=-30, le=120)


@router.post("/trips/{trip_id}/stops/{seq}/pickup")
def pickup(trip_id: int, seq: int, body: PickupIn, user=Depends(VOL), db=Depends(role_db)):
    ev = Evidence()
    db.call("sp_record_pickup", [user["uid"], trip_id, seq, body.temperature_c])
    return ok(db, {"trip_id": trip_id, "stop_seq": seq}, action="pickup", evidence=ev.collect())


class DeliverIn(BaseModel):
    temperature_c: Optional[float] = Field(default=None, ge=-30, le=120)
    hygiene_ok: bool = True
    notes: Optional[str] = Field(default=None, max_length=255)


@router.post("/trips/{trip_id}/stops/{seq}/deliver")
def deliver(trip_id: int, seq: int, body: DeliverIn, user=Depends(VOL), db=Depends(role_db)):
    ev = Evidence()
    db.call("sp_record_delivery", [user["uid"], trip_id, seq, body.temperature_c, body.hygiene_ok, body.notes])
    return ok(db, {"trip_id": trip_id, "stop_seq": seq}, action="deliver", evidence=ev.collect())


class AvailIn(BaseModel):
    available: bool


@router.post("/availability")
def availability(body: AvailIn, user=Depends(VOL), db=Depends(role_db)):
    db.call("sp_set_availability", [user["uid"], body.available])
    return ok(db, {"available": body.available})
