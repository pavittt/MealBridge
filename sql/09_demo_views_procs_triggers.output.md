# MealBridge: views, matching procedure, functions and triggers (real output)

Real output of `09_demo_views_procs_triggers.sql`, run as MySQL user `root` on MySQL 8.0.46-0ubuntu0.24.04.4 at 2026-10-05 12:37:39.
All data is SYNTHETIC (see sql/07_seed_synthetic.sql).

## V1. Impact dashboard headline (v_impact_summary)

Meals saved, kg diverted, carbon avoided, expiry and response time in one row. Carbon uses the FAO 2013 global average factor (values_source says TO VERIFY).

```sql
SELECT * FROM v_impact_summary\G
```

Output:

```text
*************************** 1. row ***************************
                from_day: 2026-08-31
                  to_day: 2026-10-05
          batches_posted: 491
       batches_delivered: 310
             meals_saved: 10271
             kg_diverted: 3134.13
         co2e_avoided_kg: 6456
              kg_expired: 1894.11
         rescue_rate_pct: 59.3
        avg_response_min: 67
avg_post_to_delivery_min: 177
```

## V2. Impact time series, last 10 days (v_impact_daily)

One row per day for the dashboard charts.

```sql
SELECT * FROM v_impact_daily ORDER BY day DESC LIMIT 10;
```

Output:

```text
+------------+----------------+-----------+--------------+-------------+-----------------+------------+-----------------+
| day        | batches_posted | kg_posted | kg_delivered | meals_saved | co2e_avoided_kg | kg_expired | rescue_rate_pct |
+------------+----------------+-----------+--------------+-------------+-----------------+------------+-----------------+
| 2026-10-05 |              6 |     84.50 |         0.00 |           0 |             0.0 |       0.00 |             0.0 |
| 2026-10-04 |             26 |    251.41 |       161.31 |         586 |           332.3 |      73.00 |            64.2 |
| 2026-10-03 |             27 |    256.78 |       162.90 |         520 |           335.6 |      87.66 |            63.4 |
| 2026-10-02 |              4 |     31.27 |        17.78 |          38 |            36.6 |       0.00 |            56.9 |
| 2026-10-01 |              4 |     25.57 |        12.51 |          27 |            25.8 |      13.06 |            48.9 |
| 2026-09-30 |              6 |     47.59 |        26.64 |          66 |            54.9 |      20.95 |            56.0 |
| 2026-09-29 |              6 |     42.97 |        36.42 |          99 |            75.0 |       0.00 |            84.8 |
| 2026-09-28 |              1 |      6.99 |         0.00 |           0 |             0.0 |       0.00 |             0.0 |
| 2026-09-27 |             28 |    262.30 |       196.50 |         643 |           404.8 |      58.97 |            74.9 |
| 2026-09-26 |             33 |    341.61 |       233.89 |         727 |           481.8 |     100.66 |            68.5 |
+------------+----------------+-----------+--------------+-------------+-----------------+------------+-----------------+
```

## V3. Response time per shelter (v_response_time)

Average and median minutes from posting to claim. The median is computed with ROW_NUMBER() because MySQL has no MEDIAN().

```sql
SELECT * FROM v_response_time ORDER BY median_response_min;
```

Output:

```text
+------------------------------------+--------+------------------+---------------------+-------------+-------------+
| shelter                            | claims | avg_response_min | median_response_min | fastest_min | slowest_min |
+------------------------------------+--------+------------------+---------------------+-------------+-------------+
| SYN Sri Sai Old Age Home           |     34 |               41 |                  16 |           6 |         633 |
| SYN Little Steps Orphanage         |     35 |               82 |                  16 |           6 |         643 |
| SYN Gandhi Nagar Community Kitchen |     47 |               45 |                  16 |           0 |         609 |
| SYN Arcot Road Old Age Home        |     16 |               20 |                  16 |          11 |          47 |
| SYN Temple Annadhanam Kitchen      |     39 |               63 |                  17 |           4 |        1021 |
| SYN Anbu Children's Home           |     41 |               49 |                  18 |           0 |         603 |
| SYN Katpadi Night Shelter          |     55 |               91 |                  19 |           6 |        1073 |
| SYN Sathuvachari Women's Shelter   |     33 |              144 |                  19 |           6 |         638 |
| SYN Hospital Attendants Rest House |     80 |               52 |                  20 |           3 |         614 |
+------------------------------------+--------+------------------+---------------------+-------------+-------------+
```

## V4. Fairness per shelter and Jain's index (v_shelter_fairness, v_fairness_index)

fair_ratio 1.00 = the shelter got exactly its share by number of beneficiaries. Jain's index 1.0 = perfectly even kg per beneficiary.

```sql
SELECT * FROM v_shelter_fairness ORDER BY fair_ratio DESC;
SELECT * FROM v_fairness_index;
```

Output:

```text
+------------------------------------+---------------+---------+-------------+--------------------+----------------+--------------------+------------+
| shelter                            | beneficiaries | batches | kg_received | kg_per_beneficiary | need_share_pct | received_share_pct | fair_ratio |
+------------------------------------+---------------+---------+-------------+--------------------+----------------+--------------------+------------+
| SYN Little Steps Orphanage         |            35 |      27 |      233.61 |               6.67 |            4.3 |                8.0 |       1.85 |
| SYN Sathuvachari Women's Shelter   |            40 |      27 |      238.38 |               5.96 |            4.9 |                8.2 |       1.65 |
| SYN Sri Sai Old Age Home           |            45 |      26 |      256.14 |               5.69 |            5.6 |                8.8 |       1.58 |
| SYN Anbu Children's Home           |            60 |      28 |      314.02 |               5.23 |            7.4 |               10.7 |       1.45 |
| SYN Gandhi Nagar Community Kitchen |            90 |      37 |      418.79 |               4.65 |           11.1 |               14.3 |       1.29 |
| SYN Katpadi Night Shelter          |           120 |      44 |      469.29 |               3.91 |           14.8 |               16.1 |       1.08 |
| SYN Hospital Attendants Rest House |           200 |      54 |      536.21 |               2.68 |           24.7 |               18.3 |       0.74 |
| SYN Temple Annadhanam Kitchen      |           150 |      31 |      328.69 |               2.19 |           18.5 |               11.2 |       0.61 |
| SYN Arcot Road Old Age Home        |            70 |      10 |      128.08 |               1.83 |            8.6 |                4.4 |       0.51 |
+------------------------------------+---------------+---------+-------------+--------------------+----------------+--------------------+------------+
+----------+------------+----------------+
| shelters | jain_index | worst_possible |
+----------+------------+----------------+
|        9 |      0.872 |          0.111 |
+----------+------------+----------------+
```

## V5. Mess leaderboard (v_mess_leaderboard)

```sql
SELECT * FROM v_mess_leaderboard ORDER BY rank_by_kg_rescued;
```

Output:

```text
+----------------------+---------+-----------+------------+-----------------+--------------------+
| mess                 | batches | kg_posted | kg_rescued | rescue_rate_pct | rank_by_kg_rescued |
+----------------------+---------+-----------+------------+-----------------+--------------------+
| SYN Mess A (Veg)     |     140 |   1748.67 |    1140.97 |            65.2 |                  1 |
| SYN Mess C (Mixed)   |     122 |   1302.07 |     843.49 |            64.8 |                  2 |
| SYN Mess E (Mixed)   |      78 |    755.56 |     459.07 |            60.8 |                  3 |
| SYN Mess B (Non-veg) |      89 |    887.77 |     411.08 |            46.3 |                  4 |
| SYN Mess F (Veg)     |      40 |    387.60 |     207.47 |            53.5 |                  5 |
| SYN Mess D (Special) |      22 |    199.34 |      72.05 |            36.1 |                  6 |
+----------------------+---------+-----------+------------+-----------------+--------------------+
```

## P1. MATCHING PROCEDURE: rank every shelter for a live batch (sp_rank_shelters)

Shows the five component scores (0-100), the weighted match score, and why excluded shelters are excluded. Weights come from the scoring_weight table.

```sql
SELECT weight_key, weight_value FROM scoring_weight ORDER BY weight_value DESC;
SET @b = (SELECT batch_id FROM surplus_batch WHERE description = 'SYN Chicken curry (live demo)');
CALL sp_rank_shelters(@b, NULL);
```

Output:

```text
+---------------+--------------+
| weight_key    | weight_value |
+---------------+--------------+
| NEED          |        0.300 |
| FAIRNESS      |        0.250 |
| DISTANCE      |        0.200 |
| PERISHABILITY |        0.150 |
| CAPACITY      |        0.100 |
+---------------+--------------+
+------------+------------------------------------+-------+------------+----------+-------+----------+----------+--------+----------+-------------+--------------------------+
| shelter_id | shelter                            | km    | travel_min | min_left | need  | capacity | distance | perish | fairness | match_score | verdict                  |
+------------+------------------------------------+-------+------------+----------+-------+----------+----------+--------+----------+-------------+--------------------------+
|         12 | SYN Little Steps Orphanage         |  2.15 |         29 |     1349 | 100.0 |     61.0 |     85.7 |   97.9 |     41.3 |       78.23 | ELIGIBLE                 |
|          9 | SYN Katpadi Night Shelter          |  3.00 |         33 |     1349 | 100.0 |     17.3 |     80.0 |   97.6 |     56.1 |       76.38 | ELIGIBLE                 |
|         10 | SYN Hospital Attendants Rest House |  5.43 |         43 |     1349 | 100.0 |     12.3 |     63.8 |   96.8 |     54.6 |       72.17 | ELIGIBLE                 |
|         13 | SYN Gandhi Nagar Community Kitchen |  3.40 |         34 |     1349 |  61.6 |     42.2 |     77.4 |   97.5 |     35.4 |       61.65 | ELIGIBLE                 |
|          7 | SYN Anbu Children's Home           |  2.76 |         32 |     1349 |  31.0 |     67.5 |     81.6 |   97.7 |     32.9 |       55.26 | ELIGIBLE                 |
|          8 | SYN Sri Sai Old Age Home           |  1.75 |         27 |     1349 | 100.0 |     48.1 |     88.4 |   98.0 |     34.6 |        NULL | EXCLUDED: diet exclusion |
|         14 | SYN Sathuvachari Women's Shelter   |  3.04 |         33 |     1349 | 100.0 |     45.6 |     79.7 |   97.6 |     41.9 |        NULL | EXCLUDED: diet exclusion |
|         11 | SYN Temple Annadhanam Kitchen      |  6.46 |         47 |     1349 | 100.0 |     13.7 |     57.0 |   96.5 |     80.5 |        NULL | EXCLUDED: diet exclusion |
|         15 | SYN Arcot Road Old Age Home        | 13.35 |         76 |     1349 | 100.0 |     32.7 |     11.0 |   94.4 |     65.7 |        NULL | EXCLUDED: diet exclusion |
+------------+------------------------------------+-------+------------+----------+-------+----------+----------+--------+----------+-------------+--------------------------+
```

## P2. Policy change re-ranks shelters (weights are data, change is audited)

Doubling the FAIRNESS weight inside a transaction, re-ranking, then rolling back.

```sql
START TRANSACTION;
UPDATE scoring_weight SET weight_value = 0.500 WHERE weight_key = 'FAIRNESS';
CALL sp_rank_shelters(@b, NULL);
SELECT table_name, row_pk, action, db_user, old_values, new_values
  FROM audit_log WHERE table_name = 'scoring_weight' ORDER BY audit_id DESC LIMIT 1;
ROLLBACK;
```

Output:

```text
+------------+------------------------------------+-------+------------+----------+-------+----------+----------+--------+----------+-------------+--------------------------+
| shelter_id | shelter                            | km    | travel_min | min_left | need  | capacity | distance | perish | fairness | match_score | verdict                  |
+------------+------------------------------------+-------+------------+----------+-------+----------+----------+--------+----------+-------------+--------------------------+
|          9 | SYN Katpadi Night Shelter          |  3.00 |         33 |     1349 | 100.0 |     17.3 |     80.0 |   97.6 |     56.1 |       72.31 | ELIGIBLE                 |
|         12 | SYN Little Steps Orphanage         |  2.15 |         29 |     1349 | 100.0 |     61.0 |     85.7 |   97.9 |     41.3 |       70.84 | ELIGIBLE                 |
|         10 | SYN Hospital Attendants Rest House |  5.43 |         43 |     1349 | 100.0 |     12.3 |     63.8 |   96.8 |     54.6 |       68.66 | ELIGIBLE                 |
|         13 | SYN Gandhi Nagar Community Kitchen |  3.40 |         34 |     1349 |  61.6 |     42.2 |     77.4 |   97.5 |     35.4 |       56.40 | ELIGIBLE                 |
|          7 | SYN Anbu Children's Home           |  2.76 |         32 |     1349 |  31.0 |     67.5 |     81.6 |   97.7 |     32.9 |       50.80 | ELIGIBLE                 |
|          8 | SYN Sri Sai Old Age Home           |  1.75 |         27 |     1349 | 100.0 |     48.1 |     88.4 |   98.0 |     34.6 |        NULL | EXCLUDED: diet exclusion |
|         14 | SYN Sathuvachari Women's Shelter   |  3.04 |         33 |     1349 | 100.0 |     45.6 |     79.7 |   97.6 |     41.9 |        NULL | EXCLUDED: diet exclusion |
|         11 | SYN Temple Annadhanam Kitchen      |  6.46 |         47 |     1349 | 100.0 |     13.7 |     57.0 |   96.5 |     80.5 |        NULL | EXCLUDED: diet exclusion |
|         15 | SYN Arcot Road Old Age Home        | 13.35 |         76 |     1349 | 100.0 |     32.7 |     11.0 |   94.4 |     65.7 |        NULL | EXCLUDED: diet exclusion |
+------------+------------------------------------+-------+------------+----------+-------+----------+----------+--------+----------+-------------+--------------------------+
+----------------+----------+--------+----------------+-------------------+-------------------+
| table_name     | row_pk   | action | db_user        | old_values        | new_values        |
+----------------+----------+--------+----------------+-------------------+-------------------+
| scoring_weight | FAIRNESS | UPDATE | root@localhost | {"weight": 0.250} | {"weight": 0.500} |
+----------------+----------+--------+----------------+-------------------+-------------------+
```

## P3. TOTAL specialization: sites are created only with their subtype (sp_register_site)

A good registration creates SITE + SHELTER together. A bad one (missing registration_no) fails in the subtype insert and the SITE row is rolled back too, so no "orphan" site is left. The demo shelter is then removed.

```sql
SELECT COUNT(*) AS sites_before FROM site;
CALL sp_register_site('SHELTER', 'SYN Demo Registration Home', 'SYN address', 'Vellore', '632001',
       12.9400, 79.1300, '9000000077',
       '{"shelter_type":"ORPHANAGE","registration_no":"SYN-REG-077","beneficiary_count":30,"has_refrigeration":true,"default_capacity_kg":15}', @ns);
SELECT t.site_id, t.name, t.site_type, s.shelter_type, s.has_refrigeration
  FROM site t JOIN shelter s ON s.site_id = t.site_id WHERE t.site_id = @ns;
CALL sp_register_site('SHELTER', 'SYN Broken Registration', 'SYN address', 'Vellore', '632001',
       12.9400, 79.1300, '9000000078', '{"shelter_type":"ORPHANAGE","beneficiary_count":30,"default_capacity_kg":15}', @bad);
SELECT (SELECT COUNT(*) FROM site) AS sites_after_failed_call, (SELECT COUNT(*) FROM site WHERE name = 'SYN Broken Registration') AS orphan_sites;
SELECT COUNT(*) AS sites_without_subtype
  FROM site t WHERE NOT EXISTS (SELECT 1 FROM mess m WHERE m.site_id = t.site_id)
                AND NOT EXISTS (SELECT 1 FROM shelter s WHERE s.site_id = t.site_id);
DELETE FROM shelter WHERE site_id = @ns;
DELETE FROM site WHERE site_id = @ns;
```

Output:

```text
+--------------+
| sites_before |
+--------------+
|           16 |
+--------------+
+---------+----------------------------+-----------+--------------+-------------------+
| site_id | name                       | site_type | shelter_type | has_refrigeration |
+---------+----------------------------+-----------+--------------+-------------------+
|      17 | SYN Demo Registration Home | SHELTER   | ORPHANAGE    |                 1 |
+---------+----------------------------+-----------+--------------+-------------------+
ERROR 1048 (23000): Column 'registration_no' cannot be null
+-------------------------+--------------+
| sites_after_failed_call | orphan_sites |
+-------------------------+--------------+
|                      17 |            0 |
+-------------------------+--------------+
+-----------------------+
| sites_without_subtype |
+-----------------------+
|                     0 |
+-----------------------+
```

## F1. Functions used on their own

Perishability clock, meal conversion, distance and travel estimate, diet check.

```sql
SELECT fn_safe_until(3, 'AMBIENT',  '2026-10-05 12:00:00') AS nonveg_ambient_deadline,
       fn_safe_until(3, 'HOT_HELD', '2026-10-05 12:00:00') AS nonveg_hot_deadline,
       fn_safe_until(3, 'CHILLED',  '2026-10-05 12:00:00') AS nonveg_chilled_deadline,
       fn_meals(10, 1)                                    AS meals_in_10kg_rice,
       (SELECT ROUND(fn_distance_km(a.location, b.location), 2)
          FROM site a, site b WHERE a.site_id = 1 AND b.site_id = 9) AS km_messA_to_katpadi,
       ROUND(fn_travel_minutes(2.46))                     AS est_minutes_for_2_46_km,
       fn_is_diet_compatible(@b, 8)                       AS chicken_ok_for_old_age_home,
       fn_is_diet_compatible(@b, 9)                       AS chicken_ok_for_night_shelter;
```

Output:

```text
+-------------------------+---------------------+-------------------------+--------------------+---------------------+-------------------------+-----------------------------+------------------------------+
| nonveg_ambient_deadline | nonveg_hot_deadline | nonveg_chilled_deadline | meals_in_10kg_rice | km_messA_to_katpadi | est_minutes_for_2_46_km | chicken_ok_for_old_age_home | chicken_ok_for_night_shelter |
+-------------------------+---------------------+-------------------------+--------------------+---------------------+-------------------------+-----------------------------+------------------------------+
| 2026-10-05 13:30:00     | 2026-10-05 15:00:00 | 2026-10-06 12:00:00     |                 22 |                2.46 |                      30 |                           0 |                            1 |
+-------------------------+---------------------+-------------------------+--------------------+---------------------+-------------------------+-----------------------------+------------------------------+
```

## T1. Trigger: perishability clock overrides any client-sent deadline (trg_batch_bi)

The client tries to post safe_until = +3 days; the trigger replaces it with cooked_at + safe hours.

```sql
START TRANSACTION;
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (1, 1, 3, 'LUNCH', 'SYN trigger demo', 10, 'HOT_HELD', NOW() - INTERVAL 1 HOUR, NOW() + INTERVAL 3 DAY);
SELECT batch_id, cooked_at, storage, safe_until, status
  FROM surplus_batch WHERE batch_id = LAST_INSERT_ID();
SELECT event_type, event_time, notes FROM custody_event
 WHERE batch_id = LAST_INSERT_ID() ORDER BY event_id;
ROLLBACK;
```

Output:

```text
+----------+---------------------+----------+---------------------+-----------+
| batch_id | cooked_at           | storage  | safe_until          | status    |
+----------+---------------------+----------+---------------------+-----------+
|      492 | 2026-10-05 11:37:35 | HOT_HELD | 2026-10-05 15:37:35 | AVAILABLE |
+----------+---------------------+----------+---------------------+-----------+
+------------+-------------------------+------------------------------------------+
| event_type | event_time              | notes                                    |
+------------+-------------------------+------------------------------------------+
| COOKED     | 2026-10-05 11:37:35.000 | NULL                                     |
| POSTED     | 2026-10-05 12:37:35.000 | 10.00 kg, safe until 2026-10-05 15:37:35 |
+------------+-------------------------+------------------------------------------+
```

## T2. Trigger: food already past its deadline cannot be posted (EXPECT ERROR)

```sql
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (1, 3, 3, 'LUNCH', 'SYN too old', 10, 'AMBIENT', NOW() - INTERVAL 3 HOUR, NOW());
```

Output:

```text
ERROR 1644 (45000): R9: food is already past its safe-until time, it cannot be posted
```

## T3. Trigger: a mess admin cannot post for another mess (EXPECT ERROR)

User 3 is the admin of mess 1; here they try to post for mess 2.

```sql
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (2, 1, 3, 'LUNCH', 'SYN wrong mess', 10, 'HOT_HELD', NOW() - INTERVAL 1 HOUR, NOW());
```

Output:

```text
ERROR 1644 (45000): Batch must be posted by an active admin of this mess
```

## T4. Trigger: CAPACITY UPDATE on claim and on cancel (trg_claim_ai / trg_claim_au)

reserved_kg of the shelter's day goes up when it claims and back down when the claim is cancelled; the batch is offered again.

```sql
START TRANSACTION;
SET @b4 = (SELECT batch_id FROM surplus_batch WHERE description = 'SYN Chapati (live demo)');
SELECT shelter_site_id, day, capacity_kg, reserved_kg AS reserved_before
  FROM shelter_day WHERE shelter_site_id = 10 AND day = CURRENT_DATE;
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
VALUES (@b4, 10, 12, 70, 5.4);
SET @cl = LAST_INSERT_ID();
SELECT reserved_kg AS reserved_after_claim FROM shelter_day WHERE shelter_site_id = 10 AND day = CURRENT_DATE;
SELECT status AS batch_status_after_claim FROM surplus_batch WHERE batch_id = @b4;
UPDATE claim SET status = 'CANCELLED', close_reason = 'SYN demo cancel' WHERE claim_id = @cl;
SELECT reserved_kg AS reserved_after_cancel FROM shelter_day WHERE shelter_site_id = 10 AND day = CURRENT_DATE;
SELECT status AS batch_status_after_cancel FROM surplus_batch WHERE batch_id = @b4;
ROLLBACK;
```

Output:

```text
+-----------------+------------+-------------+-----------------+
| shelter_site_id | day        | capacity_kg | reserved_before |
+-----------------+------------+-------------+-----------------+
|              10 | 2026-10-05 |       73.42 |            0.00 |
+-----------------+------------+-------------+-----------------+
+----------------------+
| reserved_after_claim |
+----------------------+
|                 6.00 |
+----------------------+
+--------------------------+
| batch_status_after_claim |
+--------------------------+
| CLAIMED                  |
+--------------------------+
+-----------------------+
| reserved_after_cancel |
+-----------------------+
|                  0.00 |
+-----------------------+
+---------------------------+
| batch_status_after_cancel |
+---------------------------+
| AVAILABLE                 |
+---------------------------+
```

## T5. Trigger + CHECK: a shelter can never be over-filled (EXPECT ERROR)

Shelter 12 (Little Steps) can take about 15 kg a day; claiming the 24 kg batch breaks CHECK chk_sd_reserved inside the trigger, so the whole INSERT is undone.

```sql
SET @b1 = (SELECT batch_id FROM surplus_batch WHERE description = 'SYN Sambar rice (live demo)');
SELECT capacity_kg, reserved_kg FROM shelter_day WHERE shelter_site_id = 12 AND day = CURRENT_DATE;
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
VALUES (@b1, 12, 14, 50, 2.1);
SELECT COUNT(*) AS claims_on_batch_after_failed_insert FROM claim WHERE batch_id = @b1;
```

Output:

```text
+-------------+-------------+
| capacity_kg | reserved_kg |
+-------------+-------------+
|       14.75 |        0.00 |
+-------------+-------------+
ERROR 3819 (HY000): Check constraint 'chk_sd_reserved' is violated.
+-------------------------------------+
| claims_on_batch_after_failed_insert |
+-------------------------------------+
|                                   0 |
+-------------------------------------+
```

## T6. Trigger: diet exclusion blocks a claim (EXPECT ERROR)

The temple kitchen (site 11) excludes NON_VEG; the chicken curry batch is refused.

```sql
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
VALUES (@b, 11, 13, 50, 6.0);
```

Output:

```text
ERROR 1644 (45000): Batch contains an item this shelter excludes
```

## T7. Trigger: deadline inputs are frozen after posting (EXPECT ERROR)

```sql
UPDATE surplus_batch SET safe_until = safe_until + INTERVAL 2 HOUR WHERE batch_id = @b1;
```

Output:

```text
ERROR 1644 (45000): Deadline inputs (cooked_at, category, storage, safe_until) are frozen once posted
```

## T8. Trigger: illegal status jump (EXPECT ERROR)

An AVAILABLE batch cannot jump straight to DELIVERED.

```sql
UPDATE surplus_batch SET status = 'DELIVERED' WHERE batch_id = @b1;
```

Output:

```text
ERROR 1644 (45000): Illegal batch status transition
```

## T9. Trigger: role must match site type (EXPECT ERROR)

A SHELTER user attached to a MESS site.

```sql
INSERT INTO app_user (full_name, email, phone, password_hash, role, site_id)
VALUES ('SYN wrong', 'wrong@example.org', '9100000099', REPEAT('x', 60), 'SHELTER', 1);
```

Output:

```text
ERROR 1644 (45000): R10: a SHELTER user must belong to a SHELTER site
```

## T10. Trigger: custody log is append-only, even for root (EXPECT ERROR x2)

```sql
UPDATE custody_event SET notes = 'edited' WHERE event_id = 1;
DELETE FROM custody_event WHERE event_id = 1;
```

Output:

```text
ERROR 1644 (45000): R8: custody_event is append-only (UPDATE refused)
ERROR 1644 (45000): R8: custody_event is append-only (DELETE refused)
```

## T11. AUTO-EXPIRE: event + procedure + trigger

A batch posted with 3 seconds of safe time left; after 4 s the job (the same procedure ev_auto_expire runs every 5 minutes) expires it and the trigger writes the EXPIRED custody event at the true deadline.

```sql
SELECT EVENT_NAME, STATUS, INTERVAL_VALUE, INTERVAL_FIELD, LAST_EXECUTED
  FROM information_schema.EVENTS WHERE EVENT_SCHEMA = 'mealbridge';
START TRANSACTION;
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (1, 1, 3, 'LUNCH', 'SYN expiry demo', 8, 'AMBIENT', NOW() - INTERVAL 120 MINUTE + INTERVAL 3 SECOND, NOW());
SET @e = LAST_INSERT_ID();
SELECT batch_id, status, safe_until, NOW() AS now_ FROM surplus_batch WHERE batch_id = @e;
DO SLEEP(4);
CALL sp_expire_batches();
SELECT batch_id, status, safe_until, NOW() AS now_ FROM surplus_batch WHERE batch_id = @e;
SELECT event_type, event_time, notes FROM custody_event WHERE batch_id = @e ORDER BY event_id;
ROLLBACK;
```

Output:

```text
+----------------+---------+----------------+----------------+---------------------+
| EVENT_NAME     | STATUS  | INTERVAL_VALUE | INTERVAL_FIELD | LAST_EXECUTED       |
+----------------+---------+----------------+----------------+---------------------+
| ev_auto_expire | ENABLED | 5              | MINUTE         | 2026-10-05 12:37:19 |
+----------------+---------+----------------+----------------+---------------------+
+----------+-----------+---------------------+---------------------+
| batch_id | status    | safe_until          | now_                |
+----------+-----------+---------------------+---------------------+
|      493 | AVAILABLE | 2026-10-05 12:37:38 | 2026-10-05 12:37:35 |
+----------+-----------+---------------------+---------------------+
+----------+---------+---------------------+---------------------+
| batch_id | status  | safe_until          | now_                |
+----------+---------+---------------------+---------------------+
|      493 | EXPIRED | 2026-10-05 12:37:38 | 2026-10-05 12:37:39 |
+----------+---------+---------------------+---------------------+
+------------+-------------------------+-----------------------------------------+
| event_type | event_time              | notes                                   |
+------------+-------------------------+-----------------------------------------+
| COOKED     | 2026-10-05 10:37:38.000 | NULL                                    |
| POSTED     | 2026-10-05 12:37:35.000 | 8.00 kg, safe until 2026-10-05 12:37:38 |
| EXPIRED    | 2026-10-05 12:37:38.000 | auto-expired: safe-until time passed    |
+------------+-------------------------+-----------------------------------------+
```

## T12. Audit log written by triggers (last 6 rows)

db_user is USER() (the real login), not CURRENT_USER() (which inside a trigger is the trigger's definer).

```sql
SELECT audit_id, table_name, row_pk, action, db_user, changed_at,
       LEFT(CAST(new_values AS CHAR), 70) AS new_values
  FROM audit_log ORDER BY audit_id DESC LIMIT 6;
```

Output:

```text
+----------+---------------+--------+--------+----------------+-------------------------+------------------------------------------------------------------------+
| audit_id | table_name    | row_pk | action | db_user        | changed_at              | new_values                                                             |
+----------+---------------+--------+--------+----------------+-------------------------+------------------------------------------------------------------------+
|     2468 | surplus_batch | 491    | UPDATE | root@localhost | 2026-10-05 12:37:34.883 | {"qty_kg": 18.00, "status": "IN_TRANSIT", "description": "SYN Veg biry |
|     2467 | claim         | 380    | INSERT | root@localhost | 2026-10-05 12:37:34.873 | {"km": 4.62, "batch": 491, "score": 70.56, "shelter": 7}               |
|     2466 | surplus_batch | 491    | UPDATE | root@localhost | 2026-10-05 12:37:34.873 | {"qty_kg": 18.00, "status": "CLAIMED", "description": "SYN Veg biryani |
|     2465 | claim         | 379    | INSERT | root@localhost | 2026-10-05 12:37:34.869 | {"km": 3.75, "batch": 490, "score": 73.19, "shelter": 13}              |
|     2464 | surplus_batch | 490    | UPDATE | root@localhost | 2026-10-05 12:37:34.869 | {"qty_kg": 15.00, "status": "CLAIMED", "description": "SYN Curd rice ( |
|     2463 | surplus_batch | 491    | INSERT | root@localhost | 2026-10-05 12:37:34.000 | {"mess": 6, "qty_kg": 18.00, "status": "AVAILABLE", "storage": "HOT_HE |
+----------+---------------+--------+--------+----------------+-------------------------+------------------------------------------------------------------------+
```

## T13. Tamper detection with the SHA-256 hash chain

Simulates an attacker who has DROP TRIGGER rights: drops the append-only trigger, edits one old custody note, and the verifier names the altered event. Then everything is restored and re-checked.

```sql
SET @tb = (SELECT batch_id FROM custody_event WHERE event_type = 'DELIVERED' ORDER BY event_id LIMIT 1);
SELECT fn_custody_first_bad_event(@tb) AS bad_event_before;
DROP TRIGGER trg_custody_bu;
SET @victim = (SELECT event_id FROM custody_event WHERE batch_id = @tb AND event_type = 'POSTED');
SET @orig = (SELECT notes FROM custody_event WHERE event_id = @victim);
UPDATE custody_event SET notes = REPLACE(notes, ' kg', '0 kg') WHERE event_id = @victim;
SELECT @victim AS edited_event, fn_custody_first_bad_event(@tb) AS bad_event_detected;
UPDATE custody_event SET notes = @orig WHERE event_id = @victim;
CREATE TRIGGER trg_custody_bu BEFORE UPDATE ON custody_event FOR EACH ROW
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R8: custody_event is append-only (UPDATE refused)';
SELECT fn_custody_first_bad_event(@tb) AS bad_event_after_restore;
```

Output:

```text
+------------------+
| bad_event_before |
+------------------+
|                0 |
+------------------+
+--------------+--------------------+
| edited_event | bad_event_detected |
+--------------+--------------------+
|            6 |                  6 |
+--------------+--------------------+
+-------------------------+
| bad_event_after_restore |
+-------------------------+
|                       0 |
+-------------------------+
```

