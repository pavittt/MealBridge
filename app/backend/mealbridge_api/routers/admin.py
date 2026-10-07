"""
Platform admin: matching policy weights (audited by a trigger), the
audit log, and manual runs of the auto-expire job and the forecast.

Connection: mb_platform_admin (role r_platform_admin). It can read
everything but cannot change custody or audit history (tested).
"""
from datetime import date
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field

from ..auth import require, role_db
from ..common import Evidence, ok

router = APIRouter(prefix="/api/admin", tags=["platform admin"])
ADMIN = require("PLATFORM_ADMIN")


@router.get("/overview")
def overview(user=Depends(ADMIN), db=Depends(role_db)):
    weights = db.query("SELECT weight_key, weight_value, description FROM scoring_weight ORDER BY weight_value DESC")
    audit = db.query(
        "SELECT audit_id, table_name, row_pk, action, db_user, changed_at, old_values, new_values "
        "  FROM audit_log ORDER BY audit_id DESC LIMIT 40")
    counts = db.one(
        "SELECT (SELECT COUNT(*) FROM mess) AS messes, (SELECT COUNT(*) FROM shelter) AS shelters, "
        "       (SELECT COUNT(*) FROM volunteer) AS volunteers, "
        "       (SELECT COUNT(*) FROM surplus_batch WHERE status = 'AVAILABLE') AS available_batches, "
        "       (SELECT COUNT(*) FROM claim WHERE status = 'ACTIVE') AS active_claims, "
        "       (SELECT COUNT(*) FROM pickup_trip WHERE status IN ('PLANNED','IN_PROGRESS')) AS open_trips")
    return ok(db, {"weights": weights, "audit": audit, "counts": counts})


class WeightIn(BaseModel):
    weight_value: float = Field(ge=0, le=1)


@router.put("/weights/{key}")
def set_weight(key: str, body: WeightIn, user=Depends(ADMIN), db=Depends(role_db)):
    # an unknown key would update 0 rows and still look saved
    if not db.one("SELECT 1 AS known FROM scoring_weight WHERE weight_key = %s", (key,)):
        raise HTTPException(404, f"No matching weight called {key}")
    ev = Evidence()
    db.query("UPDATE scoring_weight SET weight_value = %s WHERE weight_key = %s", (body.weight_value, key))
    return ok(db, {"weight_key": key, "weight_value": body.weight_value}, action="set_weight", evidence=ev.collect())


@router.post("/expire")
def expire(user=Depends(ADMIN), db=Depends(role_db)):
    ev = Evidence()
    db.call("sp_expire_batches", [])
    return ok(db, {"done": True}, action="expire", evidence=ev.collect())


class ForecastIn(BaseModel):
    day: Optional[date] = None


@router.post("/forecast")
def forecast(body: ForecastIn, user=Depends(ADMIN), db=Depends(role_db)):
    day = body.day or db.one("SELECT CURDATE() + INTERVAL 1 DAY AS d")["d"]
    db.call("sp_generate_forecast", [day, True])
    rows = db.query("SELECT f.mess_site_id, t.name AS mess, f.meal_slot, f.predicted_kg "
                    "  FROM surplus_forecast f JOIN site t ON t.site_id = f.mess_site_id "
                    " WHERE f.forecast_date = %s ORDER BY f.predicted_kg DESC", (day,))
    return ok(db, {"day": day, "forecast": rows})
