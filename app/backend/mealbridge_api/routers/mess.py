"""
Mess admin screens: post surplus, watch the perishability clock, see who
claimed, withdraw a batch, preview the matching.

Connection: mb_mess_admin (role r_mess_admin). Writes go only through
sp_post_batch and sp_cancel_batch; the role has no INSERT on surplus_batch.
"""
from datetime import datetime
from typing import List, Optional

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field

from ..auth import require, role_db
from ..common import Evidence, ok

router = APIRouter(prefix="/api/mess", tags=["mess admin"])
MESS = require("MESS_ADMIN")


@router.get("/overview")
def overview(user=Depends(MESS), db=Depends(role_db)):
    site = user["site"]
    mess = db.one(
        "SELECT t.site_id, t.name, t.city, m.hostel_block, m.mess_type, m.daily_capacity_meals, c.name AS campus "
        "  FROM site t JOIN mess m ON m.site_id = t.site_id JOIN campus c ON c.campus_id = m.campus_id "
        " WHERE t.site_id = %s", (site,))
    # today's and recent batches of THIS mess (uses IDX-5 ix_batch_mess_created)
    batches = db.query(
        "SELECT b.batch_id, b.description, fc.name AS category, b.meal_slot, b.quantity_kg, b.storage, "
        "       b.cooked_at, b.created_at, b.safe_until, b.status, "
        "       TIMESTAMPDIFF(SECOND, NOW(), b.safe_until) AS seconds_left, "
        "       TIMESTAMPDIFF(SECOND, b.cooked_at, b.safe_until) AS safe_window_s, "
        "       fn_meals(b.quantity_kg, b.category_id) AS meals_equiv, "
        "       st.name AS claimed_by_shelter, c.match_score, c.claimed_at "
        "  FROM surplus_batch b "
        "  JOIN food_category fc ON fc.category_id = b.category_id "
        "  LEFT JOIN claim c ON c.active_batch_id = b.batch_id "
        "  LEFT JOIN site st ON st.site_id = c.shelter_site_id "
        " WHERE b.mess_site_id = %s AND b.created_at >= CURDATE() - INTERVAL 1 DAY "
        " ORDER BY b.created_at DESC", (site,))
    forecast = db.query(
        "SELECT forecast_date, meal_slot, predicted_kg, method FROM surplus_forecast "
        " WHERE mess_site_id = %s AND forecast_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 DAY "
        " ORDER BY forecast_date, FIELD(meal_slot, 'BREAKFAST','LUNCH','SNACKS','DINNER')", (site,))
    now = db.one("SELECT NOW() AS server_now")["server_now"]
    return ok(db, {"mess": mess, "batches": batches, "forecast": forecast, "server_now": now})


@router.get("/form-options")
def form_options(user=Depends(MESS), db=Depends(role_db)):
    """Lookup data for the 'post surplus' form, straight from the reference tables."""
    cats = db.query(
        "SELECT category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, "
        "       safe_hours_chilled, kg_per_meal, values_source FROM food_category ORDER BY name")
    tags = db.query("SELECT tag_code, description FROM diet_tag ORDER BY tag_code")
    return ok(db, {"categories": cats, "diet_tags": tags})


class BatchIn(BaseModel):
    category_id: int
    meal_slot: str = Field(pattern="^(BREAKFAST|LUNCH|SNACKS|DINNER)$")
    description: str = Field(min_length=3, max_length=255)
    quantity_kg: float = Field(gt=0, le=2000)
    storage: str = Field(pattern="^(AMBIENT|HOT_HELD|CHILLED)$")
    cooked_at: datetime
    packed_at: Optional[datetime] = None
    diet_tags: List[str] = []


@router.post("/batches")
def post_batch(body: BatchIn, user=Depends(MESS), db=Depends(role_db)):
    import json
    ev = Evidence()
    _, out = db.call("sp_post_batch",
                     [user["uid"], body.category_id, body.meal_slot, body.description,
                      body.quantity_kg, body.storage, body.cooked_at, body.packed_at,
                      json.dumps(body.diet_tags)],
                     outs=["batch_id"])
    batch_id = out["batch_id"]
    # read back what the TRIGGER decided (we never sent safe_until)
    batch = db.one(
        "SELECT batch_id, description, quantity_kg, storage, cooked_at, safe_until, status, "
        "       TIMESTAMPDIFF(SECOND, NOW(), safe_until) AS seconds_left "
        "  FROM surplus_batch WHERE batch_id = %s", (batch_id,))
    return ok(db, batch, action="post_batch", evidence=ev.collect())


@router.post("/batches/{batch_id}/cancel")
def cancel_batch(batch_id: int, user=Depends(MESS), db=Depends(role_db)):
    ev = Evidence()
    db.call("sp_cancel_batch", [user["uid"], batch_id])
    return ok(db, {"batch_id": batch_id, "status": "CANCELLED"}, action="cancel_batch", evidence=ev.collect())


@router.get("/batches/{batch_id}/ranking")
def ranking(batch_id: int, user=Depends(MESS), db=Depends(role_db)):
    """The matching procedure: every shelter with its 5 component scores."""
    rows, _ = db.call("sp_rank_shelters", [batch_id, None])
    weights = None   # r_mess_admin may not read scoring_weight; the panel says so
    return ok(db, {"ranking": rows, "weights": weights})


@router.get("/history")
def history(user=Depends(MESS), db=Depends(role_db)):
    """Last 14 days of this mess from the v_batch_outcome view."""
    rows = db.query(
        "SELECT day, COUNT(*) AS batches, SUM(quantity_kg) AS kg_posted, "
        "       SUM(kg_delivered) AS kg_delivered, SUM(kg_expired) AS kg_expired, "
        "       SUM(meals_saved) AS meals_saved "
        "  FROM v_batch_outcome WHERE mess_site_id = %s AND day >= CURDATE() - INTERVAL 14 DAY "
        " GROUP BY day ORDER BY day", (user["site"],))
    return ok(db, rows)
