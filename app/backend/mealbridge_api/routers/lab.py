"""
"Database lab": pages that make the database itself visible.

  POST /api/lab/race         two shelters race for one batch, live
  GET  /api/lab/explain      query plans with and without each index
  GET  /api/lab/custody      chain-of-custody timeline + hash-chain check
  GET  /api/lab/schema       schema explorer (information_schema + sources)
"""
import os
import re
import threading
import time

from fastapi import APIRouter, Depends, HTTPException

from .. import config
from ..auth import current_user, role_db
from ..common import ok
from ..db import DbError, DbSession

router = APIRouter(prefix="/api/lab", tags=["database lab"])


# ======================================================================
# 1. LIVE CONCURRENCY DEMO
# ======================================================================
HOLD_SECONDS = 2.5      # how long shelter A keeps the row lock (demo only)
B_DELAY = 0.4           # shelter B starts this much later, while A holds the lock


@router.post("/race")
def race(user=Depends(current_user)):
    """Posts a fresh synthetic batch, then two shelter sessions call
    sp_claim_batch on it at (almost) the same time. Session A is told to
    hold its lock for a moment (@demo_hold_seconds, a demo-only switch in
    the procedure) so a human can see B waiting. A third session (platform
    admin) looks at performance_schema.data_locks while B waits."""
    # -- 1. a fresh batch, posted through the real procedure as mess admin 3
    with DbSession("MESS_ADMIN") as mess:
        mess.call("sp_post_batch",
                  [3, 4, "SNACKS", "SYN Chapati (concurrency demo)", 3.0, "AMBIENT",
                   mess.one("SELECT NOW() - INTERVAL 10 MINUTE AS t")["t"], None, '["VEG"]'],
                  outs=["batch_id"])
        batch_id = mess.one("SELECT @batch_id AS b")["b"]
        setup_sql = list(mess.trace)

    # -- 2. the two best ELIGIBLE shelters for it, and one staff user of each
    with DbSession("SHELTER") as sh:
        # the full ranking is a mess-admin view (shelters cannot read it)
        with DbSession("MESS_ADMIN") as ranker:
            ranking, _ = ranker.call("sp_rank_shelters", [batch_id, None])
        eligible = [r for r in ranking if r["verdict"] == "ELIGIBLE"][:2]
        if len(eligible) < 2:
            raise HTTPException(409, "Fewer than two shelters are eligible right now (capacity used up). "
                                     "Reload the database with sql/setup.sql to reset the demo day.")
        staff = {}
        for r in eligible:
            staff[r["shelter_id"]] = sh.one(
                "SELECT user_id FROM app_user WHERE role = 'SHELTER' AND site_id = %s LIMIT 1",
                (r["shelter_id"],))["user_id"]

    t0 = time.perf_counter()
    ms = lambda: round((time.perf_counter() - t0) * 1000)       # noqa: E731
    timeline, results, threads_ids = [], {}, {}
    lock = threading.Lock()

    def log(who, what):
        with lock:
            timeline.append({"t_ms": ms(), "who": who, "what": what})

    def contender(label, shelter, delay, hold):
        time.sleep(delay)
        db = DbSession("SHELTER")
        try:
            threads_ids[label] = db.one("SELECT PS_CURRENT_THREAD_ID() AS t")["t"]
            db.query("SET @demo_hold_seconds = %s", (hold,))
            log(label, f"CALL sp_claim_batch(user {staff[shelter['shelter_id']]}, batch {batch_id}) "
                       f"-> START TRANSACTION; SELECT ... FOR UPDATE")
            start = ms()
            _, out = db.call("sp_claim_batch", [staff[shelter["shelter_id"]], batch_id],
                             outs=["claim_id", "result"])
            took = ms() - start
            log(label, f"returned {out['result']} after {took} ms")
            results[label] = {"shelter": shelter["shelter"], "shelter_id": shelter["shelter_id"],
                              "score": shelter["match_score"], "result": out["result"],
                              "claim_id": out["claim_id"], "took_ms": took,
                              "statements": db.trace[1:]}
        finally:
            db.close()

    a = threading.Thread(target=contender, args=("A", eligible[0], 0, HOLD_SECONDS))
    b = threading.Thread(target=contender, args=("B", eligible[1], B_DELAY, 0))
    a.start(); b.start()

    # -- 3. the monitor: what does InnoDB say while B is waiting?
    locks_seen, waits_seen = [], []
    time.sleep(B_DELAY + 0.6)
    with DbSession("PLATFORM_ADMIN") as mon:
        locks_seen = mon.query(
            "SELECT THREAD_ID, OBJECT_NAME, INDEX_NAME, LOCK_TYPE, LOCK_MODE, LOCK_STATUS, LOCK_DATA "
            "  FROM performance_schema.data_locks "
            " WHERE OBJECT_SCHEMA = 'mealbridge' AND OBJECT_NAME = 'surplus_batch' AND LOCK_TYPE = 'RECORD'")
        waits_seen = mon.query(
            "SELECT REQUESTING_THREAD_ID, BLOCKING_THREAD_ID FROM performance_schema.data_lock_waits")
        monitor_sql = mon.trace
    log("monitor", f"performance_schema.data_locks: {len(locks_seen)} record lock(s) on surplus_batch, "
                   f"{len(waits_seen)} waiting")
    a.join(); b.join()

    names = {v: k for k, v in threads_ids.items()}
    for l in locks_seen:
        l["session"] = names.get(l["THREAD_ID"], "other")
    with DbSession("SHELTER") as sh:
        final = sh.one("SELECT batch_id, status FROM surplus_batch WHERE batch_id = %s", (batch_id,))
        claims = sh.query("SELECT claim_id, shelter_site_id, status, active_batch_id FROM claim WHERE batch_id = %s",
                          (batch_id,))
    timeline.sort(key=lambda e: e["t_ms"])
    return {"data": {"batch_id": batch_id, "contenders": results, "timeline": timeline,
                     "locks": locks_seen, "waits": waits_seen, "final_batch": final,
                     "claims": claims, "hold_seconds": HOLD_SECONDS, "b_delay_s": B_DELAY,
                     "setup_sql": setup_sql, "monitor_sql": monitor_sql},
            "hood": {"action": "race", "login": "mb_shelter@localhost (two sessions) + mb_platform_admin (monitor)",
                     "mysql_role": "r_shelter", "statements": []}}


# ======================================================================
# 2. EXPLAIN: before and after each index
# ======================================================================
# Each case: a query the app really runs, and the index it relies on.
# "Before" uses IGNORE INDEX so nothing has to be dropped on a live DB.
CASES = [
    {"id": "feed", "title": "Live feed and auto-expire", "index": "ix_batch_status_deadline",
     "columns": "surplus_batch (status, safe_until)",
     "sql": "SELECT batch_id, safe_until FROM surplus_batch {hint} "
            "WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until"},
    {"id": "mess", "title": "Mess dashboard: this mess, last 7 days", "index": "ix_batch_mess_created",
     "columns": "surplus_batch (mess_site_id, created_at)",
     "sql": "SELECT batch_id, created_at FROM surplus_batch {hint} "
            "WHERE mess_site_id = 1 AND created_at >= NOW() - INTERVAL 7 DAY ORDER BY created_at DESC"},
    {"id": "custody", "title": "Audit timeline of one batch", "index": "ix_ev_batch_time",
     "columns": "custody_event (batch_id, event_time)",
     "sql": "SELECT event_type, event_time FROM custody_event {hint} "
            "WHERE batch_id = 100 ORDER BY event_time"},
    {"id": "fairness", "title": "Fairness: one shelter's claims, last 30 days", "index": "ix_claim_shelter_time",
     "columns": "claim (shelter_site_id, claimed_at)",
     "sql": "SELECT claim_id, claimed_at FROM claim {hint} "
            "WHERE shelter_site_id = 7 AND claimed_at >= NOW() - INTERVAL 30 DAY"},
    {"id": "notif", "title": "My unread notifications", "index": "ix_notif_user_unread",
     "columns": "notification (user_id, read_at, created_at)",
     "sql": "SELECT notification_id, message FROM notification {hint} "
            "WHERE user_id = 9 AND read_at IS NULL ORDER BY created_at DESC"},
]


def _plan(db, sql):
    row = db.one("EXPLAIN " + sql)
    tree = db.query("EXPLAIN ANALYZE " + sql)
    text = list(tree[0].values())[0] if tree else ""
    m = re.search(r"actual time=[\d.]+\.\.([\d.]+)", text)
    return {"type": row.get("type"), "key": row.get("key"), "rows": row.get("rows"),
            "filtered": row.get("filtered"), "extra": row.get("Extra"),
            "analyze": text, "actual_ms": float(m.group(1)) if m else None}


@router.get("/explain")
def explain(user=Depends(current_user)):
    with DbSession("PLATFORM_ADMIN") as db:
        sizes = {r["t"]: r["n"] for r in db.query(
            "SELECT 'surplus_batch' AS t, COUNT(*) AS n FROM surplus_batch UNION ALL "
            "SELECT 'custody_event', COUNT(*) FROM custody_event UNION ALL "
            "SELECT 'claim', COUNT(*) FROM claim UNION ALL SELECT 'notification', COUNT(*) FROM notification")}
        out = []
        for c in CASES:
            before_sql = c["sql"].format(hint=f"IGNORE INDEX ({c['index']})")
            after_sql = c["sql"].format(hint="")
            out.append({**c, "before_sql": before_sql, "after_sql": " ".join(after_sql.split()),
                        "before": _plan(db, before_sql), "after": _plan(db, after_sql)})
        return ok(db, {"cases": out, "table_rows": sizes})


# ======================================================================
# 3. CHAIN OF CUSTODY TIMELINE
# ======================================================================
@router.get("/custody")
def custody(batch_id: int = 0, db=Depends(role_db)):
    recent = db.query(
        "SELECT b.batch_id, b.description, b.status, b.created_at, COUNT(e.event_id) AS events "
        "  FROM surplus_batch b JOIN custody_event e ON e.batch_id = b.batch_id "
        " GROUP BY b.batch_id ORDER BY b.batch_id DESC LIMIT 30")
    if not batch_id and recent:
        batch_id = recent[0]["batch_id"]
    batch = db.one(
        "SELECT b.batch_id, b.description, b.quantity_kg, b.storage, b.cooked_at, b.safe_until, b.status, "
        "       t.name AS mess FROM surplus_batch b JOIN site t ON t.site_id = b.mess_site_id "
        " WHERE b.batch_id = %s", (batch_id,))
    events = db.query(
        "SELECT event_id, event_type, event_time, actor_user_id, claim_id, trip_id, temperature_c, "
        "       hygiene_ok, notes, prev_hash, row_hash "
        "  FROM custody_event WHERE batch_id = %s ORDER BY event_time, event_id", (batch_id,))  # IDX-12
    # The verifier function is granted to the platform admin only.
    with DbSession("PLATFORM_ADMIN") as adm:
        bad = adm.one("SELECT fn_custody_first_bad_event(%s) AS first_bad", (batch_id,))["first_bad"]
        verify_sql = adm.trace
    return ok(db, {"recent": recent, "batch": batch, "events": events,
                   "chain": {"first_bad_event": bad, "intact": bad == 0, "sql": verify_sql}})


# ======================================================================
# 4. SCHEMA EXPLORER
# ======================================================================
def _sources():
    """Procedures, functions, triggers and views, read from the .sql files
    (the source of truth). Each object keeps the comment block above it,
    which explains the design decision."""
    objs = []
    pat = re.compile(r"((?:--[^\n]*\n)*)\s*CREATE\s+(?:OR\s+REPLACE\s+)?(PROCEDURE|FUNCTION|TRIGGER|VIEW|EVENT)\s+(\w+)"
                     r"(.*?)(?:END\$\$|;\n)", re.S | re.I)
    for fname in ("03_functions.sql", "04_procedures.sql", "05_triggers.sql", "06_views.sql"):
        path = os.path.join(config.SQL_DIR, fname)
        if not os.path.exists(path):
            continue
        text = open(path, encoding="utf-8").read()
        for m in pat.finditer(text):
            comment = "\n".join(l[2:].strip() for l in m.group(1).strip().splitlines()
                                if l.startswith("--") and not set(l[2:].strip()) <= set("-="))
            kind = m.group(2).upper()
            body = m.group(0)[len(m.group(1)):].strip()
            objs.append({"kind": kind, "name": m.group(3), "file": f"sql/{fname}",
                         "comment": comment, "source": body})
    return objs


@router.get("/schema")
def schema(user=Depends(current_user)):
    with DbSession("PLATFORM_ADMIN") as db:
        tables = db.query(
            "SELECT TABLE_NAME AS name, TABLE_TYPE AS type, TABLE_ROWS AS approx_rows "
            "  FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'mealbridge' ORDER BY TABLE_TYPE, TABLE_NAME")
        columns = db.query(
            "SELECT TABLE_NAME AS tbl, COLUMN_NAME AS name, COLUMN_TYPE AS type, IS_NULLABLE AS nullable, "
            "       COLUMN_KEY AS col_key, COLUMN_DEFAULT AS dflt, EXTRA AS extra, "
            "       GENERATION_EXPRESSION AS gen_expr "
            "  FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = 'mealbridge' "
            " ORDER BY TABLE_NAME, ORDINAL_POSITION")
        constraints = db.query(
            "SELECT tc.TABLE_NAME AS tbl, tc.CONSTRAINT_NAME AS name, tc.CONSTRAINT_TYPE AS type, "
            "       GROUP_CONCAT(k.COLUMN_NAME ORDER BY k.ORDINAL_POSITION) AS cols, "
            "       MAX(k.REFERENCED_TABLE_NAME) AS ref_table, "
            "       GROUP_CONCAT(k.REFERENCED_COLUMN_NAME ORDER BY k.ORDINAL_POSITION) AS ref_cols, "
            "       MAX(cc.CHECK_CLAUSE) AS check_clause "
            "  FROM information_schema.TABLE_CONSTRAINTS tc "
            "  LEFT JOIN information_schema.KEY_COLUMN_USAGE k "
            "         ON k.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA AND k.CONSTRAINT_NAME = tc.CONSTRAINT_NAME "
            "        AND k.TABLE_NAME = tc.TABLE_NAME "
            "  LEFT JOIN information_schema.CHECK_CONSTRAINTS cc "
            "         ON cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA AND cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME "
            " WHERE tc.TABLE_SCHEMA = 'mealbridge' "
            " GROUP BY tc.TABLE_NAME, tc.CONSTRAINT_NAME, tc.CONSTRAINT_TYPE "
            " ORDER BY tc.TABLE_NAME, FIELD(tc.CONSTRAINT_TYPE,'PRIMARY KEY','UNIQUE','FOREIGN KEY','CHECK'), tc.CONSTRAINT_NAME")
        indexes = db.query(
            "SELECT TABLE_NAME AS tbl, INDEX_NAME AS name, NON_UNIQUE AS non_unique, INDEX_TYPE AS type, "
            "       GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS cols "
            "  FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = 'mealbridge' "
            " GROUP BY TABLE_NAME, INDEX_NAME, NON_UNIQUE, INDEX_TYPE ORDER BY TABLE_NAME, INDEX_NAME")
        diagrams = sorted(f for f in os.listdir(config.DIAGRAM_DIR) if f.endswith(".png")) \
            if os.path.isdir(config.DIAGRAM_DIR) else []
        return ok(db, {"tables": tables, "columns": columns, "constraints": constraints,
                       "indexes": indexes, "objects": _sources(), "diagrams": diagrams})
