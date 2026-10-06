"""
Small helpers shared by the routers.

ok()       wraps every response as {"data": ..., "hood": ...}; "hood" is
           what the "Under the hood" panel displays.
Evidence   proves which triggers fired: it notes the newest custody_event
           and audit_log ids BEFORE an action and returns the rows added
           AFTER it. Those rows are written only by triggers, so they are
           the triggers' own footprints. It reads with the platform-admin
           login, because the end-user roles may not read audit_log; that
           read is shown separately and is not part of the action.
"""
from .db import DbSession


def ok(db, data, action=None, evidence=None):
    hood = db.hood(action)
    if evidence is not None:
        hood["evidence"] = evidence
    return {"data": data, "hood": hood}


class Evidence:
    def __init__(self):
        with DbSession("PLATFORM_ADMIN") as adm:
            r = adm.one("SELECT (SELECT COALESCE(MAX(event_id), 0) FROM custody_event) AS ev, "
                        "       (SELECT COALESCE(MAX(audit_id), 0) FROM audit_log) AS au")
        self.ev, self.au = r["ev"], r["au"]

    def collect(self):
        with DbSession("PLATFORM_ADMIN") as adm:
            custody = adm.query(
                "SELECT event_id, batch_id, claim_id, trip_id, event_type, event_time, "
                "       actor_user_id, temperature_c, hygiene_ok, notes, "
                "       LEFT(prev_hash, 12) AS prev_hash, LEFT(row_hash, 12) AS row_hash "
                "  FROM custody_event WHERE event_id > %s ORDER BY event_id", (self.ev,))
            audit = adm.query(
                "SELECT audit_id, table_name, row_pk, action, db_user, changed_at, "
                "       old_values, new_values "
                "  FROM audit_log WHERE audit_id > %s ORDER BY audit_id", (self.au,))
        return {"read_with": "mb_platform_admin@localhost (separate read, after the action)",
                "custody_events": custody, "audit_rows": audit}
