# MealBridge: indexes, EXPLAIN before and after (real output)

Real output of `12_explain_indexes.sql`, run as MySQL user `root` on MySQL 8.0.46-0ubuntu0.24.04.4 at 2026-10-07 09:26:19.
All data is SYNTHETIC (see sql/07_seed_synthetic.sql).

## E1. Live feed on the real table: IDX-4 surplus_batch(status, safe_until)

Before: full scan of every batch + sort. After: range scan on the index, already in safe_until order (no filesort).

```sql
ALTER TABLE surplus_batch ALTER INDEX ix_batch_status_deadline INVISIBLE;
EXPLAIN SELECT batch_id, safe_until FROM surplus_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until;
ALTER TABLE surplus_batch ALTER INDEX ix_batch_status_deadline VISIBLE;
EXPLAIN SELECT batch_id, safe_until FROM surplus_batch
         WHERE status = 'AVAILABLE' AND safe_until > NOW() ORDER BY safe_until;
```

Output:

```text
+----+-------------+---------------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
| id | select_type | table         | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                       |
+----+-------------+---------------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
|  1 | SIMPLE      | surplus_batch | NULL       | ALL  | NULL          | NULL | NULL    | NULL |  418 |     8.33 | Using where; Using filesort |
+----+-------------+---------------+------------+------+---------------+------+---------+------+------+----------+-----------------------------+
+----+-------------+---------------+------------+-------+--------------------------+--------------------------+---------+------+------+----------+--------------------------+
| id | select_type | table         | partitions | type  | possible_keys            | key                      | key_len | ref  | rows | filtered | Extra                    |
+----+-------------+---------------+------------+-------+--------------------------+--------------------------+---------+------+------+----------+--------------------------+
|  1 | SIMPLE      | surplus_batch | NULL       | range | ix_batch_status_deadline | ix_batch_status_deadline | 6       | NULL |    4 |   100.00 | Using where; Using index |
+----+-------------+---------------+------------+-------+--------------------------+--------------------------+---------+------+------+----------+--------------------------+
```

## E2. Build the scale copies (200,000 batches, 150,000 claims)

0.2% of batches are AVAILABLE (like a real live feed); the rest are history spread over one year.

```sql
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
```

Output:

```text
+-----------------------+---------+----------+----------+
| Table                 | Op      | Msg_type | Msg_text |
+-----------------------+---------+----------+----------+
| mealbridge.perf_batch | analyze | status   | OK       |
| mealbridge.perf_claim | analyze | status   | OK       |
+-----------------------+---------+----------+----------+
+--------------+-----------+-------------+
| perf_batches | available | perf_claims |
+--------------+-----------+-------------+
|       200000 |       400 |      150000 |
+--------------+-----------+-------------+
```

## E3. Shelter live feed at scale: IDX-4 (status, safe_until)

Equality on status first, range on safe_until second: the index reads only the ~400 available rows, in order, and stops after 20.

```sql
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
```

Output:

```text
+----+-------------+------------+------------+------+---------------+------+---------+------+--------+----------+-----------------------------+
| id | select_type | table      | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra                       |
+----+-------------+------------+------------+------+---------------+------+---------+------+--------+----------+-----------------------------+
|  1 | SIMPLE      | perf_batch | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 199184 |    16.66 | Using where; Using filesort |
+----+-------------+------------+------------+------+---------------+------+---------+------+--------+----------+-----------------------------+
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Limit: 20 row(s)  (cost=13527 rows=20) (actual time=96.3..96.3 rows=20 loops=1)
    -> Sort: perf_batch.safe_until, limit input to 20 row(s) per chunk  (cost=13527 rows=199184) (actual time=96.3..96.3 rows=20 loops=1)
        -> Filter: ((perf_batch.`status` = 'AVAILABLE') and (perf_batch.safe_until > <cache>(now())))  (cost=13527 rows=199184) (actual time=0.293..96.1 rows=400 loops=1)
            -> Table scan on perf_batch  (cost=13527 rows=199184) (actual time=0.0663..81.2 rows=200000 loops=1)
 |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
+----+-------------+------------+------------+-------+--------------------------+--------------------------+---------+------+------+----------+-----------------------+
| id | select_type | table      | partitions | type  | possible_keys            | key                      | key_len | ref  | rows | filtered | Extra                 |
+----+-------------+------------+------------+-------+--------------------------+--------------------------+---------+------+------+----------+-----------------------+
|  1 | SIMPLE      | perf_batch | NULL       | range | ix_batch_status_deadline | ix_batch_status_deadline | 6       | NULL |  400 |   100.00 | Using index condition |
+----+-------------+------------+------------+-------+--------------------------+--------------------------+---------+------+------+----------+-----------------------+
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                               |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Limit: 20 row(s)  (cost=180 rows=20) (actual time=0.249..0.253 rows=20 loops=1)
    -> Index range scan on perf_batch using ix_batch_status_deadline over (status = 'AVAILABLE' AND '2026-10-07 09:26:19' < safe_until), with index condition: ((perf_batch.`status` = 'AVAILABLE') and (perf_batch.safe_until > <cache>(now())))  (cost=180 rows=400) (actual time=0.248..0.251 rows=20 loops=1)
 |
+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

## E4. Mess dashboard "my latest batches" at scale: IDX-5 (mess_site_id, created_at)

Equality on mess, then the index is already sorted by created_at: read backwards, stop after 20 rows.

```sql
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
```

Output:

```text
+----+-------------+------------+------------+------+---------------+------+---------+------+--------+----------+-----------------------------+
| id | select_type | table      | partitions | type | possible_keys | key  | key_len | ref  | rows   | filtered | Extra                       |
+----+-------------+------------+------------+------+---------------+------+---------+------+--------+----------+-----------------------------+
|  1 | SIMPLE      | perf_batch | NULL       | ALL  | NULL          | NULL | NULL    | NULL | 199184 |    20.00 | Using where; Using filesort |
+----+-------------+------------+------------+------+---------------+------+---------+------+--------+----------+-----------------------------+
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Limit: 20 row(s)  (cost=20167 rows=20) (actual time=95.4..95.4 rows=20 loops=1)
    -> Sort: perf_batch.created_at DESC, limit input to 20 row(s) per chunk  (cost=20167 rows=199184) (actual time=95.4..95.4 rows=20 loops=1)
        -> Filter: (perf_batch.mess_site_id = 3)  (cost=20167 rows=199184) (actual time=0.0942..90.9 rows=33334 loops=1)
            -> Table scan on perf_batch  (cost=20167 rows=199184) (actual time=0.0912..79.6 rows=200000 loops=1)
 |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
+----+-------------+------------+------------+------+-----------------------+-----------------------+---------+-------+-------+----------+---------------------+
| id | select_type | table      | partitions | type | possible_keys         | key                   | key_len | ref   | rows  | filtered | Extra               |
+----+-------------+------------+------------+------+-----------------------+-----------------------+---------+-------+-------+----------+---------------------+
|  1 | SIMPLE      | perf_batch | NULL       | ref  | ix_batch_mess_created | ix_batch_mess_created | 4       | const | 77328 |   100.00 | Backward index scan |
+----+-------------+------------+------------+------+-----------------------+-----------------------+---------+-------+-------+----------+---------------------+
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                          |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Limit: 20 row(s)  (cost=8478 rows=20) (actual time=0.606..0.613 rows=20 loops=1)
    -> Index lookup on perf_batch using ix_batch_mess_created (mess_site_id=3) (reverse)  (cost=8478 rows=77328) (actual time=0.605..0.611 rows=20 loops=1)
 |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

## E5. Fairness window at scale: IDX-7 claim(shelter_site_id, claimed_at), and why the WHERE must be "sargable"

(a) without the index, (b) with it, (c) with it but the date wrapped in a function: DATE(claimed_at) hides the column, so only the shelter part of the index can be used and every claim of that shelter is read.

```sql
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
```

Output:

```text
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Aggregate: count(0)  (cost=14503 rows=1) (actual time=85.5..85.5 rows=1 loops=1)
    -> Filter: ((perf_claim.shelter_site_id = 9) and (perf_claim.claimed_at >= <cache>((now() - interval 7 day))))  (cost=13879 rows=6239) (actual time=0.972..85.4 rows=321 loops=1)
        -> Table scan on perf_claim  (cost=13879 rows=149750) (actual time=0.959..70.3 rows=150000 loops=1)
 |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
+----+-------------+------------+------------+-------+-----------------------+-----------------------+---------+------+------+----------+--------------------------+
| id | select_type | table      | partitions | type  | possible_keys         | key                   | key_len | ref  | rows | filtered | Extra                    |
+----+-------------+------------+------------+-------+-----------------------+-----------------------+---------+------+------+----------+--------------------------+
|  1 | SIMPLE      | perf_claim | NULL       | range | ix_claim_shelter_time | ix_claim_shelter_time | 11      | NULL |  321 |   100.00 | Using where; Using index |
+----+-------------+------------+------------+-------+-----------------------+-----------------------+---------+------+------+----------+--------------------------+
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Aggregate: count(0)  (cost=96.7 rows=1) (actual time=0.317..0.317 rows=1 loops=1)
    -> Filter: ((perf_claim.shelter_site_id = 9) and (perf_claim.claimed_at >= <cache>((now() - interval 7 day))))  (cost=64.6 rows=321) (actual time=0.0933..0.289 rows=321 loops=1)
        -> Covering index range scan on perf_claim using ix_claim_shelter_time over (shelter_site_id = 9 AND '2026-09-30 09:26:19.000' <= claimed_at)  (cost=64.6 rows=321) (actual time=0.0873..0.213 rows=321 loops=1)
 |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| -> Aggregate: count(0)  (cost=6008 rows=1) (actual time=6.31..6.31 rows=1 loops=1)
    -> Filter: (cast(perf_claim.claimed_at as date) >= <cache>((curdate() - interval 7 day)))  (cost=3011 rows=29970) (actual time=6.23..6.28 rows=342 loops=1)
        -> Covering index lookup on perf_claim using ix_claim_shelter_time (shelter_site_id=9)  (cost=3011 rows=29970) (actual time=1.16..4.98 rows=16667 loops=1)
 |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

## E6. Clean up the scale copies

```sql
DROP TABLE perf_claim, perf_batch;
SELECT INDEX_NAME, GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS columns_, IS_VISIBLE
  FROM information_schema.STATISTICS
 WHERE TABLE_SCHEMA = 'mealbridge' AND TABLE_NAME IN ('surplus_batch', 'claim')
 GROUP BY TABLE_NAME, INDEX_NAME, IS_VISIBLE ORDER BY TABLE_NAME, INDEX_NAME;
```

Output:

```text
+-----------------------------+----------------------------+------------+
| INDEX_NAME                  | columns_                   | IS_VISIBLE |
+-----------------------------+----------------------------+------------+
| fk_claim_user               | claimed_by                 | YES        |
| ix_claim_batch              | batch_id                   | YES        |
| ix_claim_shelter_time       | shelter_site_id,claimed_at | YES        |
| PRIMARY                     | claim_id                   | YES        |
| uq_claim_one_live_per_batch | active_batch_id            | YES        |
| fk_batch_cat                | category_id                | YES        |
| fk_batch_user               | posted_by                  | YES        |
| ix_batch_mess_created       | mess_site_id,created_at    | YES        |
| ix_batch_status_deadline    | status,safe_until          | YES        |
| PRIMARY                     | batch_id                   | YES        |
+-----------------------------+----------------------------+------------+
```

