-- =====================================================================
-- MealBridge : INDEXES, EXPLAIN before and after       Stage 4 deliverable
-- Real output: 12_explain_indexes.output.md
--
-- How "before" is produced without dropping anything: MySQL 8 INVISIBLE
-- indexes. ALTER TABLE ... ALTER INDEX x INVISIBLE hides an index from
-- the optimizer (it is still maintained), so the same query can be
-- EXPLAINed with and without it, then the index is made VISIBLE again.
--
-- Two scales:
--   E1      the real demo table (~500 batches)
--   E2-E5   scale copies perf_batch (200,000 rows) and perf_claim
--           (150,000 rows), built with recursive CTEs. They are
--           SYNTHETIC filler, created with CREATE TABLE ... LIKE (same
--           columns, keys and indexes) and dropped at the end.
--
-- Reading EXPLAIN: type ALL = full table scan; range/ref = index used;
-- rows = rows the optimizer expects to read; "Using filesort" = an extra
-- sort step. EXPLAIN ANALYZE runs the query and prints actual time (ms)
-- and actual rows read.
-- =====================================================================
USE mealbridge;

-- @@ E1. Live feed on the real table: IDX-4 surplus_batch(status, safe_until)
-- Before: full scan of every batch + sort. After: range scan on the index, already in safe_until order (no filesort).
ALTER TABLE surplus_batch ALTER INDEX ix_batch_status_deadline INVISIBLE;
EXPLAIN SELECT batch_id, safe_until FROM surplus_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until;
ALTER TABLE surplus_batch ALTER INDEX ix_batch_status_deadline VISIBLE;
EXPLAIN SELECT batch_id, safe_until FROM surplus_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until;

-- @@ E2. Build the scale copies (200,000 batches, 150,000 claims)
-- 0.2% of batches are AVAILABLE (like a real live feed); the rest are history spread over one year.
DROP TABLE IF EXISTS perf_claim, perf_batch;
CREATE TABLE perf_batch LIKE surplus_batch;
CREATE TABLE perf_claim LIKE claim;
SET SESSION cte_max_recursion_depth = 200000;
INSERT INTO perf_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description,
                        quantity_kg, storage, cooked_at, packed_at, safe_until, status, created_at)
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 200000)
SELECT i, 1 + i % 6, 1 + i % 8, 3, ELT(1 + i % 4, 'BREAKFAST','LUNCH','SNACKS','DINNER'),
       'SYN perf filler', 5 + i % 30, 'HOT_HELD',
       c, NULL, c + INTERVAL 4 HOUR,
       IF(i % 500 = 0, 'AVAILABLE', ELT(1 + i % 3, 'DELIVERED','DELIVERED','EXPIRED')),
       c + INTERVAL 1 HOUR
  FROM (SELECT i, IF(i % 500 = 0, NOW() - INTERVAL 90 MINUTE,
                     NOW() - INTERVAL 2 DAY - INTERVAL (i * 157) % 525600 MINUTE) AS c
          FROM n) x;
INSERT INTO perf_claim (claim_id, batch_id, shelter_site_id, claimed_by, claimed_at,
                        match_score, distance_km, status, closed_at)
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 150000)
SELECT i, i, 7 + i % 9, 9, NOW() - INTERVAL (i * 97) % 525600 MINUTE, 50, 3,
       'FULFILLED', NOW()
  FROM n;
ANALYZE TABLE perf_batch, perf_claim;
SELECT (SELECT COUNT(*) FROM perf_batch) AS perf_batches,
       (SELECT COUNT(*) FROM perf_batch WHERE status = 'AVAILABLE') AS available,
       (SELECT COUNT(*) FROM perf_claim) AS perf_claims;

-- @@ E3. Shelter live feed at scale: IDX-4 (status, safe_until)
-- Equality on status first, range on safe_until second: the index reads only the ~400 available rows, in order, and stops after 20.
ALTER TABLE perf_batch ALTER INDEX ix_batch_status_deadline INVISIBLE;
EXPLAIN SELECT batch_id, mess_site_id, quantity_kg, safe_until FROM perf_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until LIMIT 20;
EXPLAIN ANALYZE SELECT batch_id, mess_site_id, quantity_kg, safe_until FROM perf_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until LIMIT 20;
ALTER TABLE perf_batch ALTER INDEX ix_batch_status_deadline VISIBLE;
EXPLAIN SELECT batch_id, mess_site_id, quantity_kg, safe_until FROM perf_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until LIMIT 20;
EXPLAIN ANALYZE SELECT batch_id, mess_site_id, quantity_kg, safe_until FROM perf_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until LIMIT 20;

-- @@ E4. Mess dashboard "my latest batches" at scale: IDX-5 (mess_site_id, created_at)
-- Equality on mess, then the index is already sorted by created_at: read backwards, stop after 20 rows.
ALTER TABLE perf_batch ALTER INDEX ix_batch_mess_created INVISIBLE;
EXPLAIN SELECT batch_id, created_at, quantity_kg, status FROM perf_batch
         WHERE mess_site_id = 3 ORDER BY created_at DESC LIMIT 20;
EXPLAIN ANALYZE SELECT batch_id, created_at, quantity_kg, status FROM perf_batch
         WHERE mess_site_id = 3 ORDER BY created_at DESC LIMIT 20;
ALTER TABLE perf_batch ALTER INDEX ix_batch_mess_created VISIBLE;
EXPLAIN SELECT batch_id, created_at, quantity_kg, status FROM perf_batch
         WHERE mess_site_id = 3 ORDER BY created_at DESC LIMIT 20;
EXPLAIN ANALYZE SELECT batch_id, created_at, quantity_kg, status FROM perf_batch
         WHERE mess_site_id = 3 ORDER BY created_at DESC LIMIT 20;

-- @@ E5. Fairness window at scale: IDX-7 claim(shelter_site_id, claimed_at), and why the WHERE must be "sargable"
-- (a) without the index, (b) with it, (c) with it but the date wrapped in a function: DATE(claimed_at) hides the column, so only the shelter part of the index can be used and every claim of that shelter is read.
ALTER TABLE perf_claim ALTER INDEX ix_claim_shelter_time INVISIBLE;
EXPLAIN ANALYZE SELECT COUNT(*) FROM perf_claim
         WHERE shelter_site_id = 9 AND claimed_at >= NOW() - INTERVAL 7 DAY;
ALTER TABLE perf_claim ALTER INDEX ix_claim_shelter_time VISIBLE;
EXPLAIN SELECT COUNT(*) FROM perf_claim
         WHERE shelter_site_id = 9 AND claimed_at >= NOW() - INTERVAL 7 DAY;
EXPLAIN ANALYZE SELECT COUNT(*) FROM perf_claim
         WHERE shelter_site_id = 9 AND claimed_at >= NOW() - INTERVAL 7 DAY;
EXPLAIN ANALYZE SELECT COUNT(*) FROM perf_claim
         WHERE shelter_site_id = 9 AND DATE(claimed_at) >= CURRENT_DATE - INTERVAL 7 DAY;

-- @@ E6. Clean up the scale copies
DROP TABLE perf_claim, perf_batch;
SELECT INDEX_NAME, GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS columns_, IS_VISIBLE
  FROM information_schema.STATISTICS
 WHERE TABLE_SCHEMA = 'mealbridge' AND TABLE_NAME IN ('surplus_batch', 'claim')
 GROUP BY TABLE_NAME, INDEX_NAME, IS_VISIBLE ORDER BY TABLE_NAME, INDEX_NAME;
