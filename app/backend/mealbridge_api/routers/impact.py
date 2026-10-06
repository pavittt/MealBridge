"""
Impact dashboard and the public landing-page counters.

Every number comes from a SQL VIEW (sql/06_views.sql), so each figure on
screen has exactly one SQL definition you can show the examiner.

The dashboard asks for every view with the CALLER'S role login. Views a
role is not granted come back as "denied" with MySQL's own error, and
the UI shows that card as locked. That makes the grants visible.
"""
from fastapi import APIRouter, Depends

from ..auth import role_db
from ..common import ok
from ..db import DbError, DbSession

router = APIRouter(tags=["impact"])

VIEWS = {
    "summary":    "SELECT * FROM v_impact_summary",
    "daily":      "SELECT * FROM v_impact_daily ORDER BY day",
    "response":   "SELECT * FROM v_response_time ORDER BY avg_response_min",
    "fairness":   "SELECT * FROM v_shelter_fairness ORDER BY fair_ratio DESC",
    "jain":       "SELECT * FROM v_fairness_index",
    "leaderboard": "SELECT * FROM v_mess_leaderboard ORDER BY rank_by_kg_rescued",
}


@router.get("/api/impact")
def impact(db=Depends(role_db)):
    out = {}
    for key, sql in VIEWS.items():
        try:
            out[key] = {"rows": db.query(sql)}
        except DbError as e:
            out[key] = {"denied": f"ERROR {e.code}: {e.message}"}
    return ok(db, out)


@router.get("/api/public/impact")
def public_impact():
    """Landing page: no login. Uses mb_public, which can read only three
    aggregate views (tested in tools/rbac_test.py)."""
    with DbSession("PUBLIC") as db:
        data = {"summary": db.one("SELECT * FROM v_impact_summary"),
                "daily": db.query("SELECT day, kg_delivered, meals_saved, co2e_avoided_kg, rescue_rate_pct "
                                  "FROM v_impact_daily ORDER BY day"),
                "jain": db.one("SELECT * FROM v_fairness_index")}
        return ok(db, data)
