"""
What each write action does inside MySQL, for the "Under the hood" panel.

The SQL statements themselves are recorded live by db.DbSession. This
file adds what a recording cannot see from outside: which transaction
the procedure runs and which triggers MySQL fires as a consequence.
Each entry was written from the source in sql/04_procedures.sql and
sql/05_triggers.sql; the panel also shows live evidence (the custody
and audit rows the triggers actually wrote), so you can check it.
"""

ACTIONS = {
    "post_batch": {
        "procedure": "sp_post_batch",
        "transaction": "START TRANSACTION -> INSERT surplus_batch -> INSERT batch_diet_tag "
                       "(JSON_TABLE) -> INSERT notification for the top-3 shelters -> COMMIT. "
                       "Any error rolls back all of it (EXIT HANDLER ... ROLLBACK; RESIGNAL).",
        "triggers": [
            {"name": "trg_batch_bi", "on": "BEFORE INSERT surplus_batch",
             "does": "Perishability clock: overwrites safe_until with fn_safe_until(category, storage, cooked_at), "
                     "refuses food already past its deadline."},
            {"name": "trg_batch_ai", "on": "AFTER INSERT surplus_batch",
             "does": "Starts the chain of custody (COOKED, PACKED, POSTED events) and writes an audit_log row."},
            {"name": "trg_custody_bi", "on": "BEFORE INSERT custody_event (once per event)",
             "does": "Hash chain: row_hash = SHA2(prev_hash + this event's fields, 256)."},
        ],
    },
    "cancel_batch": {
        "procedure": "sp_cancel_batch",
        "transaction": "Single UPDATE (autocommit). The JOIN on app_user checks the batch belongs "
                       "to the caller's mess (row-level ownership done in SQL).",
        "triggers": [
            {"name": "trg_batch_bu", "on": "BEFORE UPDATE surplus_batch",
             "does": "State machine: only legal status transitions are allowed."},
            {"name": "trg_batch_au", "on": "AFTER UPDATE surplus_batch",
             "does": "Audit row plus a CANCELLED custody event."},
            {"name": "trg_custody_bi", "on": "BEFORE INSERT custody_event", "does": "Extends the hash chain."},
        ],
    },
    "claim": {
        "procedure": "sp_claim_batch",
        "transaction": "START TRANSACTION -> SELECT status, safe_until FROM surplus_batch WHERE batch_id = ? "
                       "FOR UPDATE (exclusive row lock; a second shelter waits here) -> re-check status and "
                       "expiry under the lock -> fn_match_score snapshot -> INSERT claim -> COMMIT (lock released).",
        "triggers": [
            {"name": "trg_claim_bi", "on": "BEFORE INSERT claim",
             "does": "Batch must be AVAILABLE, unexpired and diet-compatible; claimant must be that shelter's staff."},
            {"name": "trg_claim_ai", "on": "AFTER INSERT claim",
             "does": "Capacity update: shelter_day.reserved_kg += batch kg (CHECK reserved_kg <= capacity_kg), "
                     "batch -> CLAIMED, CLAIMED custody event, audit row."},
            {"name": "trg_batch_bu / trg_batch_au", "on": "UPDATE surplus_batch (from trg_claim_ai)",
             "does": "Legal transition AVAILABLE -> CLAIMED, audited."},
            {"name": "trg_custody_bi", "on": "BEFORE INSERT custody_event", "does": "Extends the hash chain."},
        ],
        "guard": "Layer 2: UNIQUE index on the generated column claim.active_batch_id allows at most one live claim per batch.",
    },
    "cancel_claim": {
        "procedure": "sp_cancel_claim",
        "transaction": "Single UPDATE (autocommit), joined to app_user so only the claiming shelter can cancel.",
        "triggers": [
            {"name": "trg_claim_bu", "on": "BEFORE UPDATE claim",
             "does": "Only an ACTIVE claim can change; food already picked up cannot be CANCELLED."},
            {"name": "trg_claim_au", "on": "AFTER UPDATE claim",
             "does": "Gives the kg back to shelter_day.reserved_kg and re-offers the batch (AVAILABLE) if still safe."},
            {"name": "trg_batch_bu / trg_batch_au", "on": "UPDATE surplus_batch", "does": "Status change, audited."},
        ],
    },
    "create_trip": {
        "procedure": "sp_create_trip",
        "transaction": "Checks volunteer, load and claims; orders stops (pickups nearest home first, then drops "
                       "nearest the last pickup); START TRANSACTION -> INSERT pickup_trip -> INSERT trip_stop with "
                       "ETAs from LAG() + SUM() OVER -> refuse if any batch would arrive after safe_until -> "
                       "INSERT trip_item -> notification -> COMMIT.",
        "triggers": [
            {"name": "trg_trip_item_bi", "on": "BEFORE INSERT trip_item",
             "does": "Pickup stop must be the batch's mess and the drop stop the claiming shelter."},
        ],
    },
    "pickup": {
        "procedure": "sp_record_pickup",
        "transaction": "START TRANSACTION -> trip IN_PROGRESS -> stop arrived/departed -> PICKED_UP custody "
                       "events with temperature -> batches IN_TRANSIT -> COMMIT.",
        "triggers": [
            {"name": "trg_custody_bi", "on": "BEFORE INSERT custody_event", "does": "Extends the hash chain."},
            {"name": "trg_batch_bu / trg_batch_au", "on": "UPDATE surplus_batch",
             "does": "Legal transition CLAIMED -> IN_TRANSIT, audited."},
        ],
    },
    "deliver": {
        "procedure": "sp_record_delivery",
        "transaction": "START TRANSACTION -> stop departed -> HYGIENE_CHECK event (+ DELIVERED event if passed) "
                       "-> claim FULFILLED or REJECTED -> trip COMPLETED when every stop is done -> COMMIT.",
        "triggers": [
            {"name": "trg_custody_bi", "on": "BEFORE INSERT custody_event", "does": "Extends the hash chain."},
            {"name": "trg_claim_bu / trg_claim_au", "on": "UPDATE claim",
             "does": "FULFILLED -> batch DELIVERED; REJECTED -> capacity released, batch CANCELLED with a REJECTED event."},
            {"name": "trg_batch_bu / trg_batch_au", "on": "UPDATE surplus_batch", "does": "Status change, audited."},
        ],
    },
    "set_capacity": {
        "procedure": None,
        "transaction": "Direct column-level write: r_shelter has UPDATE (meals_needed, capacity_kg) on shelter_day "
                       "but NOT on reserved_kg. UPDATE first, INSERT if today's row is missing.",
        "triggers": [],
        "guard": "CHECK chk_sd_reserved (reserved_kg <= capacity_kg): capacity cannot be cut below what is already reserved.",
    },
    "set_weight": {
        "procedure": None,
        "transaction": "Direct UPDATE of scoring_weight.weight_value (column-level grant to r_platform_admin).",
        "triggers": [
            {"name": "trg_weight_au", "on": "AFTER UPDATE scoring_weight",
             "does": "Writes the old and new weight to audit_log (policy changes are always traceable)."},
        ],
    },
    "expire": {
        "procedure": "sp_expire_batches",
        "transaction": "The same procedure the ev_auto_expire EVENT runs every 5 minutes: cancel live claims "
                       "whose food expired, then mark AVAILABLE batches past safe_until as EXPIRED.",
        "triggers": [
            {"name": "trg_claim_au", "on": "UPDATE claim", "does": "Releases capacity, batch -> EXPIRED."},
            {"name": "trg_batch_au", "on": "UPDATE surplus_batch", "does": "Writes the EXPIRED custody event."},
        ],
    },
}
