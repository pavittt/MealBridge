#!/usr/bin/env bash
# =====================================================================
# MealBridge : TWO SESSIONS RACE FOR ONE BATCH        Stage 4 deliverable
# Real output: 13_race_demo.output.txt
#
# Which shelters race is chosen at run time, not hard-coded. The seed
# gives every shelter a different capacity each day, so a fixed shelter
# can already be (nearly) full "today" and its claim would then fail the
# capacity guard (CHECK chk_sd_reserved) instead of losing the race. The
# script asks fn_match_score, the same eligibility test sp_claim_batch
# uses (diet, capacity left today, distance, time), for the two best
# eligible shelters per batch. Race 2 uses two other shelters than race 1,
# so race 1's reservation cannot eat into race 2's capacity.
#
# RACE 1 (the real claim procedure, layer 1 = row lock):
#   Session A (best eligible shelter) calls sp_claim_batch
#   and, for the demo only, holds the row lock for 3 s (@demo_hold_seconds).
#   Session B (second best eligible shelter) calls the same
#   procedure 0.5 s later for the SAME batch.
#   A monitor session reads performance_schema.data_locks / data_lock_waits
#   while B is blocked, to show the lock that B waits on.
#   Expected: A = CLAIMED, B waits ~2.5 s, then B = REJECTED (it re-reads
#   the row under its own lock and sees status CLAIMED).
#
# RACE 2 (buggy code that skips the procedure, layer 2 = UNIQUE index):
#   Two sessions INSERT INTO claim directly, without SELECT ... FOR UPDATE.
#   B's trigger check reads the batch from B's snapshot, still sees
#   AVAILABLE, and passes. B's INSERT then hits the UNIQUE index on
#   claim.active_batch_id held by A's uncommitted row, waits, and fails
#   with a duplicate-key error when A commits. Exactly one live claim.
#
# Each race uses its own live demo batch; everything is undone at the end
# so the demo can be re-run. Run from the mealbridge folder as an admin:
#     bash sql/13_race_demo.sh
# =====================================================================
set -u
cd "$(dirname "$0")"
OUT=13_race_demo.output.txt
M="mysql -uroot mealbridge -t"          # table output
Q="mysql -uroot mealbridge -N -B"       # bare value output
ts() { date +%H:%M:%S.%3N; }

B1=$($Q -e "SELECT batch_id FROM surplus_batch WHERE description='SYN Sambar rice (live demo)'")
B2=$($Q -e "SELECT batch_id FROM surplus_batch WHERE description='SYN Vegetable kurma (live demo)'")

# pick_shelters BATCH EXCLUDE_SITES -> "site user site user" of the two
# eligible shelters with the highest match score for BATCH right now.
pick_shelters() {
  $Q -e "SELECT s.site_id, u.user_id
           FROM shelter s
           JOIN app_user u ON u.site_id = s.site_id AND u.role = 'SHELTER' AND u.is_active
          WHERE s.site_id NOT IN ($2)
            AND fn_match_score($1, s.site_id, NOW()) IS NOT NULL
          ORDER BY fn_match_score($1, s.site_id, NOW()) DESC, s.site_id
          LIMIT 2" | tr '\n\t' '  '
}
read -r S1A U1A S1B U1B <<< "$(pick_shelters "$B1" 0)"
read -r S2A U2A S2B U2B <<< "$(pick_shelters "$B2" "${S1A:-0},${S1B:-0}")"
if [ -z "${U1B:-}" ] || [ -z "${U2B:-}" ]; then
  echo "Not enough eligible shelters with capacity left today. Reload sql/setup.sql and re-run." >&2
  exit 1
fi
# raw INSERT values for race 2: the real score and distance, as sp_claim_batch would store
claim_vals() {  # claim_vals BATCH SITE USER
  $Q -e "SELECT CONCAT_WS(', ', $1, $2, $3, fn_match_score($1, $2, NOW()),
                          ROUND(fn_distance_km(m.location, t.location), 2))
           FROM surplus_batch b JOIN site m ON m.site_id = b.mess_site_id
           JOIN site t ON t.site_id = $2 WHERE b.batch_id = $1"
}
V2A=$(claim_vals "$B2" "$S2A" "$U2A")
V2B=$(claim_vals "$B2" "$S2B" "$U2B")
shelter_name() { $Q -e "SELECT name FROM site WHERE site_id = $1"; }

{
echo "MealBridge race demo, $(date '+%Y-%m-%d %H:%M:%S'), MySQL $($Q -e 'SELECT VERSION()')"
echo "Isolation level: $($Q -e 'SELECT @@transaction_isolation')"
echo
echo "=================== RACE 1: two shelters call sp_claim_batch($B1) ==================="
echo "Session A: $(shelter_name $S1A) (site $S1A, user $U1A)"
echo "Session B: $(shelter_name $S1B) (site $S1B, user $U1B)"
$M -e "SELECT batch_id, description, quantity_kg, status, safe_until FROM surplus_batch WHERE batch_id=$B1"

# Session A: holds the lock for 3 seconds
( $M -e "SET @demo_hold_seconds = 3;
          SELECT 'A' AS session, NOW(3) AS calls_at;
          CALL sp_claim_batch($U1A, $B1, @claim, @result);
          SELECT 'A' AS session, NOW(3) AS returns_at, @claim AS claim_id, @result AS result;" > /tmp/race_a.txt 2>&1 ) &
sleep 0.5
# Session B: same batch, half a second later
( $M -e "SELECT 'B' AS session, NOW(3) AS calls_at;
          CALL sp_claim_batch($U1B, $B1, @claim, @result);
          SELECT 'B' AS session, NOW(3) AS returns_at, @claim AS claim_id, @result AS result;" > /tmp/race_b.txt 2>&1 ) &
sleep 1
echo
echo "--- monitor at $(ts): who holds which lock, and who is waiting (performance_schema) ---"
$M -e "SELECT t.PROCESSLIST_ID AS conn, l.OBJECT_NAME AS tbl, l.INDEX_NAME AS idx, l.LOCK_TYPE, l.LOCK_MODE,
              l.LOCK_STATUS, l.LOCK_DATA
         FROM performance_schema.data_locks l
         JOIN performance_schema.threads t ON t.THREAD_ID = l.THREAD_ID
        WHERE l.OBJECT_NAME = 'surplus_batch' AND l.LOCK_TYPE = 'RECORD'
        ORDER BY l.LOCK_STATUS, conn;
       SELECT r.PROCESSLIST_ID AS waiting_conn, b.PROCESSLIST_ID AS blocking_conn, w.REQUESTING_ENGINE_LOCK_ID IS NOT NULL AS is_waiting
         FROM performance_schema.data_lock_waits w
         JOIN performance_schema.threads r ON r.THREAD_ID = w.REQUESTING_THREAD_ID
         JOIN performance_schema.threads b ON b.THREAD_ID = w.BLOCKING_THREAD_ID;"
wait
echo
echo "--- session A output ---"; cat /tmp/race_a.txt
echo "--- session B output ---"; cat /tmp/race_b.txt
echo
echo "--- result in the database: exactly one live claim for batch $B1 ---"
$M -e "SELECT c.claim_id, t.name AS shelter, c.status, c.claimed_at, c.match_score
         FROM claim c JOIN site t ON t.site_id = c.shelter_site_id WHERE c.batch_id = $B1;
       SELECT status FROM surplus_batch WHERE batch_id = $B1;"

echo
echo "=================== RACE 2: raw INSERTs without FOR UPDATE, batch $B2 ==================="
echo "Session A: $(shelter_name $S2A) (site $S2A, user $U2A)"
echo "Session B: $(shelter_name $S2B) (site $S2B, user $U2B)"
( $M -e "START TRANSACTION;
          INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km) VALUES ($V2A);
          SELECT 'A' AS session, NOW(3) AS inserted_at, 'holding the transaction open 3 s' AS note;
          DO SLEEP(3);
          COMMIT;
          SELECT 'A' AS session, NOW(3) AS committed_at;" > /tmp/race_a2.txt 2>&1 ) &
sleep 1
( $M -e "START TRANSACTION;
          SELECT 'B' AS session, NOW(3) AS starts_at,
                 (SELECT status FROM surplus_batch WHERE batch_id = $B2) AS status_B_sees_in_its_snapshot;
          INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km) VALUES ($V2B);
          SELECT 'B' AS session, NOW(3) AS after_insert;
          COMMIT;" > /tmp/race_b2.txt 2>&1;
  echo "(B finished at $(ts))" >> /tmp/race_b2.txt ) &
wait
echo "--- session A output ---"; cat /tmp/race_a2.txt
echo "--- session B output ---"; cat /tmp/race_b2.txt
echo
echo "--- result: still exactly one live claim for batch $B2 ---"
$M -e "SELECT claim_id, shelter_site_id, status, active_batch_id FROM claim WHERE batch_id = $B2;"

echo
echo "=================== reset (so the demo can be re-run) ==================="
# Undo through the normal paths: cancel the claims (triggers release capacity
# and set the batches back to AVAILABLE). Claims and custody rows stay as
# history, exactly as they would in production.
$M -e "UPDATE claim SET status='CANCELLED', close_reason='race demo reset'
        WHERE batch_id IN ($B1, $B2) AND status='ACTIVE';
       SELECT batch_id, status FROM surplus_batch WHERE batch_id IN ($B1, $B2);"
} > "$OUT" 2>&1
cat "$OUT"
