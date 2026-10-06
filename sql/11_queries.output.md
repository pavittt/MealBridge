# MealBridge: 20 queries with real output

Real output of `11_queries.sql`, run as MySQL user `root` on MySQL 8.0.46-0ubuntu0.24.04.4 at 2026-10-05 12:37:40.
All data is SYNTHETIC (see sql/07_seed_synthetic.sql).

## Q1. Shelter's live feed, best match first (JOIN + function)

Purpose: what staff of "SYN Katpadi Night Shelter" (site 9) see right now: every available batch with its fair-match score for them, NULL = not eligible.

```sql
SELECT f.batch_id, f.mess, f.category, f.quantity_kg AS kg, f.meals_equiv AS meals,
       f.storage, f.minutes_left,
       fn_match_score(f.batch_id, 9, NOW()) AS my_match_score
  FROM v_live_feed f
 ORDER BY my_match_score IS NULL, my_match_score DESC;
```

Output:

```text
+----------+----------------------+---------------------------+-------+-------+----------+--------------+----------------+
| batch_id | mess                 | category                  | kg    | meals | storage  | minutes_left | my_match_score |
+----------+----------------------+---------------------------+-------+-------+----------+--------------+----------------+
|      486 | SYN Mess A (Veg)     | Rice, dal and sambar      | 24.00 |    53 | HOT_HELD |          169 |          77.66 |
|      488 | SYN Mess C (Mixed)   | Non-veg curry             |  9.00 |    30 | CHILLED  |         1349 |          76.38 |
|      487 | SYN Mess B (Non-veg) | Vegetable curry and gravy | 12.50 |    41 | HOT_HELD |          179 |          75.41 |
|      489 | SYN Mess E (Mixed)   | Breads (chapati, parotta) |  6.00 |    30 | AMBIENT  |          314 |          71.43 |
+----------+----------------------+---------------------------+-------+-------+----------+--------------+----------------+
```

## Q2. Shelters within 5 km of a mess, nearest first (spatial JOIN)

Purpose: the reachable neighbourhood of "SYN Mess A (Veg)", using great-circle distance on SRID 4326 points.

```sql
SELECT t.name AS shelter, sh.shelter_type,
       ROUND(ST_Distance_Sphere(m.location, t.location) / 1000, 2) AS km,
       ROUND(fn_travel_minutes(ST_Distance_Sphere(m.location, t.location) / 1000)) AS est_travel_min
  FROM site m
  JOIN site t     ON t.site_type = 'SHELTER' AND t.is_active
  JOIN shelter sh ON sh.site_id = t.site_id
 WHERE m.site_id = 1
   AND ST_Distance_Sphere(m.location, t.location) <= 5000
 ORDER BY km;
```

Output:

```text
+------------------------------------+-------------------+------+----------------+
| shelter                            | shelter_type      | km   | est_travel_min |
+------------------------------------+-------------------+------+----------------+
| SYN Little Steps Orphanage         | ORPHANAGE         |  2.1 |             29 |
| SYN Anbu Children's Home           | ORPHANAGE         |  2.2 |             29 |
| SYN Sri Sai Old Age Home           | OLD_AGE_HOME      | 2.28 |             30 |
| SYN Katpadi Night Shelter          | HOMELESS_SHELTER  | 2.46 |             30 |
| SYN Gandhi Nagar Community Kitchen | COMMUNITY_KITCHEN | 2.99 |             33 |
| SYN Sathuvachari Women's Shelter   | OTHER             | 3.39 |             34 |
+------------------------------------+-------------------+------+----------------+
```

## Q3. Which shelters may receive a given batch? (nested NOT EXISTS)

Purpose: dietary suitability for the live chicken-curry batch: a shelter qualifies only if NONE of the batch's tags is on its exclusion list.

```sql
SELECT t.name AS shelter,
       (SELECT GROUP_CONCAT(tag_code) FROM shelter_diet_exclusion x
         WHERE x.shelter_site_id = s.site_id) AS excludes
  FROM shelter s JOIN site t ON t.site_id = s.site_id
 WHERE t.is_active
   AND NOT EXISTS (SELECT 1
                     FROM batch_diet_tag b
                     JOIN shelter_diet_exclusion e ON e.tag_code = b.tag_code
                    WHERE b.batch_id = (SELECT batch_id FROM surplus_batch
                                         WHERE description = 'SYN Chicken curry (live demo)')
                      AND e.shelter_site_id = s.site_id)
 ORDER BY shelter;
```

Output:

```text
+------------------------------------+---------------+
| shelter                            | excludes      |
+------------------------------------+---------------+
| SYN Anbu Children's Home           | NULL          |
| SYN Gandhi Nagar Community Kitchen | NULL          |
| SYN Hospital Attendants Rest House | NULL          |
| SYN Katpadi Night Shelter          | NULL          |
| SYN Little Steps Orphanage         | CONTAINS_NUTS |
+------------------------------------+---------------+
```

## Q4. Full journey of batches on one multi-stop trip (6-table JOIN)

Purpose: trace food from mess to shelter through claim, trip and volunteer, for the first trip that carried more than one batch.

```sql
SELECT b.batch_id, ms.name AS from_mess, ss.name AS to_shelter, u.full_name AS volunteer,
       b.created_at AS posted, c.claimed_at, sp.departed_at AS picked_up, sd.arrived_at AS dropped,
       c.status AS claim_status
  FROM trip_item ti
  JOIN claim c          ON c.claim_id = ti.claim_id
  JOIN surplus_batch b  ON b.batch_id = c.batch_id
  JOIN site ms          ON ms.site_id = b.mess_site_id
  JOIN site ss          ON ss.site_id = c.shelter_site_id
  JOIN pickup_trip pt   ON pt.trip_id = ti.trip_id
  JOIN app_user u       ON u.user_id = pt.volunteer_id
  JOIN trip_stop sp     ON sp.trip_id = ti.trip_id AND sp.stop_seq = ti.pickup_seq
  JOIN trip_stop sd     ON sd.trip_id = ti.trip_id AND sd.stop_seq = ti.drop_seq
 WHERE ti.trip_id = (SELECT trip_id FROM trip_item GROUP BY trip_id
                      HAVING COUNT(*) > 1 ORDER BY trip_id LIMIT 1)
 ORDER BY ti.pickup_seq;
```

Output:

```text
+----------+----------------------+-------------------------------+---------------------+---------------------+-------------------------+---------------------+---------------------+--------------+
| batch_id | from_mess            | to_shelter                    | volunteer           | posted              | claimed_at              | picked_up           | dropped             | claim_status |
+----------+----------------------+-------------------------------+---------------------+---------------------+-------------------------+---------------------+---------------------+--------------+
|        8 | SYN Mess A (Veg)     | SYN Katpadi Night Shelter     | SYN Volunteer Farah | 2026-09-01 14:34:25 | 2026-09-01 14:46:38.000 | 2026-09-01 15:37:52 | 2026-09-01 16:28:52 | FULFILLED    |
|        9 | SYN Mess B (Non-veg) | SYN Temple Annadhanam Kitchen | SYN Volunteer Farah | 2026-09-01 14:13:52 | 2026-09-01 14:24:35.000 | 2026-09-01 16:00:52 | 2026-09-01 17:23:52 | REJECTED     |
+----------+----------------------+-------------------------------+---------------------+---------------------+-------------------------+---------------------+---------------------+--------------+
```

## Q5. Surplus posted and rescued per mess and meal slot, with subtotals (GROUP BY ... WITH ROLLUP)

Purpose: where the surplus comes from; ROLLUP adds a per-mess subtotal row and a grand total (NULL slot / NULL mess).

```sql
SELECT IF(GROUPING(t.name), 'ALL MESSES', t.name)  AS mess,
       IF(GROUPING(b.meal_slot), '(all slots)', b.meal_slot) AS slot,
       COUNT(*)                                      AS batches,
       SUM(b.quantity_kg)                            AS kg_posted,
       SUM(IF(b.status = 'DELIVERED', b.quantity_kg, 0)) AS kg_rescued
  FROM surplus_batch b JOIN site t ON t.site_id = b.mess_site_id
 GROUP BY t.name, b.meal_slot WITH ROLLUP;
```

Output:

```text
+----------------------+-------------+---------+-----------+------------+
| mess                 | slot        | batches | kg_posted | kg_rescued |
+----------------------+-------------+---------+-----------+------------+
| SYN Mess A (Veg)     | BREAKFAST   |      32 |    307.59 |     242.26 |
| SYN Mess A (Veg)     | DINNER      |      50 |    667.69 |     338.07 |
| SYN Mess A (Veg)     | LUNCH       |      56 |    759.61 |     546.86 |
| SYN Mess A (Veg)     | SNACKS      |       2 |     13.78 |      13.78 |
| SYN Mess A (Veg)     | (all slots) |     140 |   1748.67 |    1140.97 |
| SYN Mess B (Non-veg) | BREAKFAST   |      18 |    170.34 |     162.42 |
| SYN Mess B (Non-veg) | DINNER      |      35 |    346.72 |      94.38 |
| SYN Mess B (Non-veg) | LUNCH       |      36 |    370.71 |     154.28 |
| SYN Mess B (Non-veg) | (all slots) |      89 |    887.77 |     411.08 |
| SYN Mess C (Mixed)   | BREAKFAST   |      26 |    235.75 |     199.53 |
| SYN Mess C (Mixed)   | DINNER      |      48 |    545.84 |     282.37 |
| SYN Mess C (Mixed)   | LUNCH       |      48 |    520.48 |     361.59 |
| SYN Mess C (Mixed)   | (all slots) |     122 |   1302.07 |     843.49 |
| SYN Mess D (Special) | BREAKFAST   |       4 |     25.93 |      19.12 |
| SYN Mess D (Special) | DINNER      |       6 |     58.36 |       7.90 |
| SYN Mess D (Special) | LUNCH       |      12 |    115.05 |      45.03 |
| SYN Mess D (Special) | (all slots) |      22 |    199.34 |      72.05 |
| SYN Mess E (Mixed)   | BREAKFAST   |      13 |    106.70 |      74.43 |
| SYN Mess E (Mixed)   | DINNER      |      27 |    271.71 |     149.74 |
| SYN Mess E (Mixed)   | LUNCH       |      38 |    377.15 |     234.90 |
| SYN Mess E (Mixed)   | (all slots) |      78 |    755.56 |     459.07 |
| SYN Mess F (Veg)     | BREAKFAST   |       9 |     70.92 |      53.91 |
| SYN Mess F (Veg)     | DINNER      |      15 |    147.17 |      29.06 |
| SYN Mess F (Veg)     | LUNCH       |      16 |    169.51 |     124.50 |
| SYN Mess F (Veg)     | (all slots) |      40 |    387.60 |     207.47 |
| ALL MESSES           | (all slots) |     491 |   5281.01 |    3134.13 |
+----------------------+-------------+---------+-----------+------------+
```

## Q6. Food categories losing more than 30% of their kg to expiry (aggregate + HAVING)

Purpose: tells the platform which kinds of food need faster handling or chilling.

```sql
SELECT fc.name AS category, fc.risk_level,
       COUNT(*)                                             AS batches,
       SUM(b.quantity_kg)                                   AS kg_posted,
       SUM(IF(b.status = 'EXPIRED', b.quantity_kg, 0))      AS kg_expired,
       ROUND(100 * SUM(IF(b.status = 'EXPIRED', b.quantity_kg, 0)) / SUM(b.quantity_kg), 1) AS pct_expired
  FROM surplus_batch b JOIN food_category fc ON fc.category_id = b.category_id
 GROUP BY fc.category_id, fc.name, fc.risk_level
HAVING pct_expired > 30
 ORDER BY pct_expired DESC;
```

Output:

```text
+---------------------------+------------+---------+-----------+------------+-------------+
| category                  | risk_level | batches | kg_posted | kg_expired | pct_expired |
+---------------------------+------------+---------+-----------+------------+-------------+
| Non-veg curry             | HIGH       |      48 |    445.09 |     312.61 |        70.2 |
| Vegetable curry and gravy | MEDIUM     |      53 |    559.14 |     223.39 |        40.0 |
| Rice, dal and sambar      | MEDIUM     |     206 |   2493.82 |     959.05 |        38.5 |
| Sweets and dairy desserts | HIGH       |      42 |    427.44 |     132.40 |        31.0 |
+---------------------------+------------+---------+-----------+------------+-------------+
```

## Q7. Messes whose average batch is larger than the platform average (scalar subquery)

Purpose: big-batch messes are the ones where whole-batch claiming may not fit small shelters; candidates for splitting batches.

```sql
SELECT t.name AS mess, COUNT(*) AS batches, ROUND(AVG(b.quantity_kg), 2) AS avg_batch_kg,
       (SELECT ROUND(AVG(quantity_kg), 2) FROM surplus_batch) AS platform_avg_kg
  FROM surplus_batch b JOIN site t ON t.site_id = b.mess_site_id
 GROUP BY t.name
HAVING AVG(b.quantity_kg) > (SELECT AVG(quantity_kg) FROM surplus_batch)
 ORDER BY avg_batch_kg DESC;
```

Output:

```text
+------------------+---------+--------------+-----------------+
| mess             | batches | avg_batch_kg | platform_avg_kg |
+------------------+---------+--------------+-----------------+
| SYN Mess A (Veg) |     140 |        12.49 |           10.76 |
+------------------+---------+--------------+-----------------+
```

## Q8. Each mess's worst weekday for leftovers (correlated subquery)

Purpose: the inner query is re-evaluated for every mess (it references the outer row), returning that mess's weekday with the highest average leftover.

```sql
SELECT t.name AS mess,
       (SELECT DAYNAME(l2.service_date)
          FROM mess_meal_log l2
         WHERE l2.mess_site_id = m.site_id
         GROUP BY DAYNAME(l2.service_date)
         ORDER BY AVG(l2.leftover_kg) DESC LIMIT 1) AS worst_weekday,
       (SELECT ROUND(AVG(l3.leftover_kg), 1) FROM mess_meal_log l3
         WHERE l3.mess_site_id = m.site_id)           AS avg_leftover_kg_per_meal
  FROM mess m JOIN site t ON t.site_id = m.site_id
 ORDER BY t.name;
```

Output:

```text
+----------------------+---------------+--------------------------+
| mess                 | worst_weekday | avg_leftover_kg_per_meal |
+----------------------+---------------+--------------------------+
| SYN Mess A (Veg)     | Saturday      |                     27.8 |
| SYN Mess B (Non-veg) | Saturday      |                     20.0 |
| SYN Mess C (Mixed)   | Saturday      |                     23.0 |
| SYN Mess D (Special) | Saturday      |                     12.6 |
| SYN Mess E (Mixed)   | Sunday        |                     17.4 |
| SYN Mess F (Veg)     | Sunday        |                     13.3 |
+----------------------+---------------+--------------------------+
```

## Q9. Shelters ranked by food received in the last 30 days (RANK window)

Purpose: RANK() and the share of total (SUM() OVER ()) show at a glance whether a few shelters dominate.

```sql
SELECT t.name AS shelter, s.beneficiary_count AS beneficiaries,
       SUM(b.quantity_kg)                                    AS kg_received,
       RANK() OVER (ORDER BY SUM(b.quantity_kg) DESC)        AS rank_kg,
       ROUND(100 * SUM(b.quantity_kg) / SUM(SUM(b.quantity_kg)) OVER (), 1) AS pct_of_all,
       RANK() OVER (ORDER BY SUM(b.quantity_kg) / s.beneficiary_count DESC) AS rank_kg_per_person
  FROM claim c
  JOIN surplus_batch b ON b.batch_id = c.batch_id
  JOIN shelter s       ON s.site_id = c.shelter_site_id
  JOIN site t          ON t.site_id = s.site_id
 WHERE c.status = 'FULFILLED' AND c.claimed_at >= NOW() - INTERVAL 30 DAY
 GROUP BY t.name, s.beneficiary_count
 ORDER BY rank_kg;
```

Output:

```text
+------------------------------------+---------------+-------------+---------+------------+--------------------+
| shelter                            | beneficiaries | kg_received | rank_kg | pct_of_all | rank_kg_per_person |
+------------------------------------+---------------+-------------+---------+------------+--------------------+
| SYN Hospital Attendants Rest House |           200 |      536.21 |       1 |       18.3 |                  7 |
| SYN Katpadi Night Shelter          |           120 |      469.29 |       2 |       16.1 |                  6 |
| SYN Gandhi Nagar Community Kitchen |            90 |      418.79 |       3 |       14.3 |                  5 |
| SYN Temple Annadhanam Kitchen      |           150 |      328.69 |       4 |       11.2 |                  8 |
| SYN Anbu Children's Home           |            60 |      314.02 |       5 |       10.7 |                  4 |
| SYN Sri Sai Old Age Home           |            45 |      256.14 |       6 |        8.8 |                  3 |
| SYN Sathuvachari Women's Shelter   |            40 |      238.38 |       7 |        8.2 |                  2 |
| SYN Little Steps Orphanage         |            35 |      233.61 |       8 |        8.0 |                  1 |
| SYN Arcot Road Old Age Home        |            70 |      128.08 |       9 |        4.4 |                  9 |
+------------------------------------+---------------+-------------+---------+------------+--------------------+
```

## Q10. Cumulative meals saved, day by day (running SUM window)

Purpose: the "meals saved" counter of the impact dashboard as a growing curve.

```sql
SELECT day, meals_saved,
       SUM(meals_saved) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING) AS cumulative_meals_saved,
       SUM(kg_delivered) OVER (ORDER BY day ROWS UNBOUNDED PRECEDING) AS cumulative_kg
  FROM v_impact_daily
 ORDER BY day;
```

Output:

```text
+------------+-------------+------------------------+---------------+
| day        | meals_saved | cumulative_meals_saved | cumulative_kg |
+------------+-------------+------------------------+---------------+
| 2026-08-31 |         241 |                    241 |         61.69 |
| 2026-09-01 |          50 |                    291 |         81.54 |
| 2026-09-02 |          75 |                    366 |        109.83 |
| 2026-09-03 |          88 |                    454 |        150.34 |
| 2026-09-04 |          88 |                    542 |        180.18 |
| 2026-09-05 |         542 |                   1084 |        354.27 |
| 2026-09-06 |         626 |                   1710 |        535.95 |
| 2026-09-07 |          51 |                   1761 |        559.07 |
| 2026-09-08 |         144 |                   1905 |        597.97 |
| 2026-09-09 |         119 |                   2024 |        633.67 |
| 2026-09-10 |         108 |                   2132 |        680.96 |
| 2026-09-11 |         399 |                   2531 |        767.91 |
| 2026-09-12 |         555 |                   3086 |        952.17 |
| 2026-09-13 |         607 |                   3693 |       1161.39 |
| 2026-09-14 |         137 |                   3830 |       1210.77 |
| 2026-09-15 |          30 |                   3860 |       1224.97 |
| 2026-09-16 |           0 |                   3860 |       1224.97 |
| 2026-09-17 |         130 |                   3990 |       1268.62 |
| 2026-09-18 |         719 |                   4709 |       1500.78 |
| 2026-09-19 |        1201 |                   5910 |       1807.53 |
| 2026-09-20 |         905 |                   6815 |       2065.76 |
| 2026-09-21 |          80 |                   6895 |       2098.93 |
| 2026-09-22 |         204 |                   7099 |       2156.70 |
| 2026-09-23 |         140 |                   7239 |       2197.39 |
| 2026-09-24 |         210 |                   7449 |       2248.50 |
| 2026-09-25 |         116 |                   7565 |       2286.18 |
| 2026-09-26 |         727 |                   8292 |       2520.07 |
| 2026-09-27 |         643 |                   8935 |       2716.57 |
| 2026-09-28 |           0 |                   8935 |       2716.57 |
| 2026-09-29 |          99 |                   9034 |       2752.99 |
| 2026-09-30 |          66 |                   9100 |       2779.63 |
| 2026-10-01 |          27 |                   9127 |       2792.14 |
| 2026-10-02 |          38 |                   9165 |       2809.92 |
| 2026-10-03 |         520 |                   9685 |       2972.82 |
| 2026-10-04 |         586 |                  10271 |       3134.13 |
| 2026-10-05 |           0 |                  10271 |       3134.13 |
+------------+-------------+------------------------+---------------+
```

## Q11. Surplus peaks: days above 1.3x the 7-day moving average (moving AVG window + CTE)

Purpose: finds the peak days (weekends, the long weekend) that need extra shelters and volunteers on standby.

```sql
WITH daily AS (
  SELECT DATE(created_at) AS day, DAYNAME(created_at) AS weekday, SUM(quantity_kg) AS kg_posted
    FROM surplus_batch GROUP BY DATE(created_at), DAYNAME(created_at)
), ma AS (
  SELECT day, weekday, kg_posted,
         ROUND(AVG(kg_posted) OVER (ORDER BY day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 1) AS ma7
    FROM daily
)
SELECT day, weekday, kg_posted, ma7,
       IF(kg_posted > 1.3 * ma7, 'PEAK', '') AS flag
  FROM ma ORDER BY day;
```

Output:

```text
+------------+-----------+-----------+-------+------+
| day        | weekday   | kg_posted | ma7   | flag |
+------------+-----------+-----------+-------+------+
| 2026-08-31 | Monday    |     61.69 |  61.7 |      |
| 2026-09-01 | Tuesday   |     28.90 |  45.3 |      |
| 2026-09-02 | Wednesday |     51.34 |  47.3 |      |
| 2026-09-03 | Thursday  |     57.28 |  49.8 |      |
| 2026-09-04 | Friday    |     36.16 |  47.1 |      |
| 2026-09-05 | Saturday  |    205.57 |  73.5 | PEAK |
| 2026-09-06 | Sunday    |    246.12 |  98.2 | PEAK |
| 2026-09-07 | Monday    |     23.12 |  92.6 |      |
| 2026-09-08 | Tuesday   |     52.90 |  96.1 |      |
| 2026-09-09 | Wednesday |     45.38 |  95.2 |      |
| 2026-09-10 | Thursday  |     53.33 |  94.7 |      |
| 2026-09-11 | Friday    |    115.06 | 105.9 |      |
| 2026-09-12 | Saturday  |    212.17 | 106.9 | PEAK |
| 2026-09-13 | Sunday    |    273.29 | 110.8 | PEAK |
| 2026-09-14 | Monday    |     49.38 | 114.5 |      |
| 2026-09-15 | Tuesday   |     23.22 | 110.3 |      |
| 2026-09-16 | Wednesday |      6.38 | 104.7 |      |
| 2026-09-17 | Thursday  |     64.83 | 106.3 |      |
| 2026-09-18 | Friday    |    509.90 | 162.7 | PEAK |
| 2026-09-19 | Saturday  |    727.85 | 236.4 | PEAK |
| 2026-09-20 | Sunday    |    741.09 | 303.2 | PEAK |
| 2026-09-21 | Monday    |     39.66 | 301.8 |      |
| 2026-09-22 | Tuesday   |     97.99 | 312.5 |      |
| 2026-09-23 | Wednesday |     56.01 | 319.6 |      |
| 2026-09-24 | Thursday  |     90.71 | 323.3 |      |
| 2026-09-25 | Friday    |     60.69 | 259.1 |      |
| 2026-09-26 | Saturday  |    341.61 | 204.0 | PEAK |
| 2026-09-27 | Sunday    |    262.30 | 135.6 | PEAK |
| 2026-09-28 | Monday    |      6.99 | 130.9 |      |
| 2026-09-29 | Tuesday   |     42.97 | 123.0 |      |
| 2026-09-30 | Wednesday |     47.59 | 121.8 |      |
| 2026-10-01 | Thursday  |     25.57 | 112.5 |      |
| 2026-10-02 | Friday    |     31.27 | 108.3 |      |
| 2026-10-03 | Saturday  |    256.78 |  96.2 | PEAK |
| 2026-10-04 | Sunday    |    251.41 |  94.7 | PEAK |
| 2026-10-05 | Monday    |     84.50 | 105.7 |      |
+------------+-----------+-----------+-------+------+
```

## Q12. Week-over-week change in surplus per mess (LAG window)

Purpose: LAG() reads the previous week's value of the same mess, so each mess's trend is visible without a self-join.

```sql
WITH weekly AS (
  SELECT t.name AS mess, YEARWEEK(b.created_at, 3) AS iso_week, SUM(b.quantity_kg) AS kg
    FROM surplus_batch b JOIN site t ON t.site_id = b.mess_site_id
   WHERE b.description NOT LIKE '%(live demo)'
   GROUP BY t.name, YEARWEEK(b.created_at, 3)
)
SELECT mess, iso_week, kg,
       LAG(kg) OVER (PARTITION BY mess ORDER BY iso_week)        AS prev_week_kg,
       ROUND(100 * (kg - LAG(kg) OVER (PARTITION BY mess ORDER BY iso_week))
             / LAG(kg) OVER (PARTITION BY mess ORDER BY iso_week), 1) AS pct_change
  FROM weekly ORDER BY mess, iso_week;
```

Output:

```text
+----------------------+----------+--------+--------------+------------+
| mess                 | iso_week | kg     | prev_week_kg | pct_change |
+----------------------+----------+--------+--------------+------------+
| SYN Mess A (Veg)     |   202636 | 211.92 |         NULL |       NULL |
| SYN Mess A (Veg)     |   202637 | 345.77 |       211.92 |       63.2 |
| SYN Mess A (Veg)     |   202638 | 576.33 |       345.77 |       66.7 |
| SYN Mess A (Veg)     |   202639 | 335.21 |       576.33 |      -41.8 |
| SYN Mess A (Veg)     |   202640 | 255.44 |       335.21 |      -23.8 |
| SYN Mess B (Non-veg) |   202636 | 131.89 |         NULL |       NULL |
| SYN Mess B (Non-veg) |   202637 | 117.07 |       131.89 |      -11.2 |
| SYN Mess B (Non-veg) |   202638 | 338.18 |       117.07 |      188.9 |
| SYN Mess B (Non-veg) |   202639 | 171.27 |       338.18 |      -49.4 |
| SYN Mess B (Non-veg) |   202640 | 116.86 |       171.27 |      -31.8 |
| SYN Mess C (Mixed)   |   202636 | 200.88 |         NULL |       NULL |
| SYN Mess C (Mixed)   |   202637 | 182.78 |       200.88 |       -9.0 |
| SYN Mess C (Mixed)   |   202638 | 473.61 |       182.78 |      159.1 |
| SYN Mess C (Mixed)   |   202639 | 270.76 |       473.61 |      -42.8 |
| SYN Mess C (Mixed)   |   202640 | 165.04 |       270.76 |      -39.0 |
| SYN Mess D (Special) |   202636 |   7.90 |         NULL |       NULL |
| SYN Mess D (Special) |   202638 | 150.19 |         7.90 |     1801.1 |
| SYN Mess D (Special) |   202639 |  18.81 |       150.19 |      -87.5 |
| SYN Mess D (Special) |   202640 |   7.44 |        18.81 |      -60.4 |
| SYN Mess E (Mixed)   |   202636 |  95.98 |         NULL |       NULL |
| SYN Mess E (Mixed)   |   202637 |  92.61 |        95.98 |       -3.5 |
| SYN Mess E (Mixed)   |   202638 | 344.48 |        92.61 |      272.0 |
| SYN Mess E (Mixed)   |   202639 | 121.32 |       344.48 |      -64.8 |
| SYN Mess E (Mixed)   |   202640 |  95.17 |       121.32 |      -21.6 |
| SYN Mess F (Veg)     |   202636 |  38.49 |         NULL |       NULL |
| SYN Mess F (Veg)     |   202637 |  37.02 |        38.49 |       -3.8 |
| SYN Mess F (Veg)     |   202638 | 239.86 |        37.02 |      547.9 |
| SYN Mess F (Veg)     |   202639 |  31.60 |       239.86 |      -86.8 |
| SYN Mess F (Veg)     |   202640 |  22.63 |        31.60 |      -28.4 |
+----------------------+----------+--------+--------------+------------+
```

## Q13. Response-time quartiles by meal slot (NTILE window)

Purpose: NTILE(4) splits all claims into four equal groups by response time; counting slots per quartile shows that late (dinner) posts get the slowest answers.

```sql
WITH r AS (
  SELECT b.meal_slot, TIMESTAMPDIFF(MINUTE, b.created_at, c.claimed_at) AS response_min,
         NTILE(4) OVER (ORDER BY TIMESTAMPDIFF(SECOND, b.created_at, c.claimed_at)) AS quartile
    FROM claim c JOIN surplus_batch b ON b.batch_id = c.batch_id
)
SELECT quartile, MIN(response_min) AS from_min, MAX(response_min) AS to_min,
       SUM(meal_slot = 'BREAKFAST') AS breakfast, SUM(meal_slot = 'LUNCH') AS lunch,
       SUM(meal_slot = 'SNACKS') AS snacks, SUM(meal_slot = 'DINNER') AS dinner
  FROM r GROUP BY quartile ORDER BY quartile;
```

Output:

```text
+----------+----------+--------+-----------+-------+--------+--------+
| quartile | from_min | to_min | breakfast | lunch | snacks | dinner |
+----------+----------+--------+-----------+-------+--------+--------+
|        1 |        0 |     11 |        37 |    56 |      1 |      1 |
|        2 |       11 |     17 |        26 |    60 |      0 |      9 |
|        3 |       17 |     30 |        26 |    36 |      1 |     32 |
|        4 |       30 |   1073 |        12 |    18 |      0 |     65 |
+----------+----------+--------+-----------+-------+--------+--------+
```

## Q14. Rescue rate by storage mode (conditional aggregation)

Purpose: the case for the perishability clock: on this synthetic data, chilled food has a far longer safe window and is rescued far more often.

```sql
SELECT storage, COUNT(*) AS batches,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_at, safe_until))) AS avg_window_min,
       SUM(status = 'DELIVERED') AS delivered, SUM(status = 'EXPIRED') AS expired,
       ROUND(100 * SUM(status = 'DELIVERED') / COUNT(*), 1) AS rescue_rate_pct
  FROM surplus_batch
 WHERE description NOT LIKE '%(live demo)'
 GROUP BY storage ORDER BY rescue_rate_pct DESC;
```

Output:

```text
+----------+---------+----------------+-----------+---------+-----------------+
| storage  | batches | avg_window_min | delivered | expired | rescue_rate_pct |
+----------+---------+----------------+-----------+---------+-----------------+
| CHILLED  |     133 |           1305 |       118 |       9 |            88.7 |
| HOT_HELD |     267 |            143 |       161 |      93 |            60.3 |
| AMBIENT  |      85 |            150 |        31 |      52 |            36.5 |
+----------+---------+----------------+-----------+---------+-----------------+
```

## Q15. Volunteer workload, including volunteers with no trips (LEFT JOIN)

Purpose: LEFT JOIN keeps volunteers who never drove (unverified or unavailable), which an INNER JOIN would silently drop.

```sql
SELECT u.full_name AS volunteer, v.vehicle_type, v.max_load_kg,
       IF(v.verified_at IS NULL, 'NOT VERIFIED', 'verified') AS id_check,
       COUNT(DISTINCT pt.trip_id)                             AS trips,
       COUNT(ti.claim_id)                                     AS batches_carried,
       COALESCE(SUM(b.quantity_kg), 0)                        AS kg_carried,
       COUNT(DISTINCT IF(pt.trip_id IN (SELECT trip_id FROM trip_item GROUP BY trip_id HAVING COUNT(*) > 1),
                         pt.trip_id, NULL))                   AS multi_stop_trips
  FROM volunteer v
  JOIN app_user u          ON u.user_id = v.user_id
  LEFT JOIN pickup_trip pt ON pt.volunteer_id = v.user_id
  LEFT JOIN trip_item ti   ON ti.trip_id = pt.trip_id
  LEFT JOIN claim c        ON c.claim_id = ti.claim_id
  LEFT JOIN surplus_batch b ON b.batch_id = c.batch_id
 GROUP BY u.full_name, v.vehicle_type, v.max_load_kg, v.verified_at
 ORDER BY kg_carried DESC;
```

Output:

```text
+-----------------------+--------------+-------------+--------------+-------+-----------------+------------+------------------+
| volunteer             | vehicle_type | max_load_kg | id_check     | trips | batches_carried | kg_carried | multi_stop_trips |
+-----------------------+--------------+-------------+--------------+-------+-----------------+------------+------------------+
| SYN Volunteer Arjun   | TWO_WHEELER  |       25.00 | verified     |    31 |              37 |     391.12 |                5 |
| SYN Volunteer Eshan   | VAN          |      150.00 | verified     |    30 |              33 |     357.13 |                2 |
| SYN Volunteer Imran   | AUTO         |       60.00 | verified     |    30 |              32 |     353.54 |                2 |
| SYN Volunteer Divya   | TWO_WHEELER  |       25.00 | verified     |    30 |              37 |     351.08 |                6 |
| SYN Volunteer Charan  | AUTO         |       60.00 | verified     |    30 |              36 |     349.91 |                4 |
| SYN Volunteer Farah   | CAR          |       80.00 | verified     |    30 |              34 |     336.56 |                4 |
| SYN Volunteer Janani  | CAR          |       80.00 | verified     |    30 |              31 |     325.86 |                1 |
| SYN Volunteer Bhavya  | CAR          |       80.00 | verified     |    31 |              31 |     316.00 |                0 |
| SYN Volunteer Harini  | TWO_WHEELER  |       25.00 | verified     |    30 |              30 |     299.87 |                0 |
| SYN Volunteer Gokul   | BICYCLE      |       12.00 | verified     |    31 |              31 |     239.33 |                0 |
| SYN Volunteer Karthik | TWO_WHEELER  |       25.00 | NOT VERIFIED |     0 |               0 |       0.00 |                0 |
| SYN Volunteer Lakshmi | CAR          |       80.00 | verified     |     0 |               0 |       0.00 |                0 |
+-----------------------+--------------+-------------+--------------+-------+-----------------+------------+------------------+
```

## Q16. Missed opportunities: expired batches that DID have an eligible shelter when posted (EXISTS)

Purpose: separates "nobody could take it" from "someone could have, but nobody acted in time": the second group is what faster alerts would save.

```sql
WITH exp AS (
  SELECT b.batch_id, b.meal_slot, b.storage, b.quantity_kg,
         EXISTS (SELECT 1 FROM shelter s
                  WHERE fn_match_score(b.batch_id, s.site_id, b.created_at) IS NOT NULL) AS had_match
    FROM surplus_batch b
   WHERE b.status = 'EXPIRED'
)
SELECT meal_slot,
       COUNT(*)                         AS expired_batches,
       SUM(had_match)                   AS had_eligible_shelter,
       SUM(NOT had_match)               AS no_shelter_possible,
       SUM(IF(had_match, quantity_kg, 0)) AS kg_saveable
  FROM exp GROUP BY meal_slot ORDER BY expired_batches DESC;
```

Output:

```text
+-----------+-----------------+----------------------+---------------------+-------------+
| meal_slot | expired_batches | had_eligible_shelter | no_shelter_possible | kg_saveable |
+-----------+-----------------+----------------------+---------------------+-------------+
| DINNER    |              84 |                   55 |                  29 |      615.07 |
| LUNCH     |              57 |                   31 |                  26 |      310.97 |
| BREAKFAST |              13 |                   10 |                   3 |       87.09 |
+-----------+-----------------+----------------------+---------------------+-------------+
```

## Q17. Forecast accuracy over the last 7 forecast days (JOIN forecast to actual)

Purpose: mean absolute error of the WEEKDAY_MA_4W forecast per mess, the honest test of whether pre-alerts are worth sending.

```sql
SELECT t.name AS mess,
       COUNT(*)                                        AS forecasts,
       ROUND(AVG(l.leftover_kg), 1)                    AS avg_actual_kg,
       ROUND(AVG(f.predicted_kg), 1)                   AS avg_predicted_kg,
       ROUND(AVG(ABS(f.predicted_kg - l.leftover_kg)), 1) AS mae_kg,
       ROUND(100 * AVG(ABS(f.predicted_kg - l.leftover_kg)) / AVG(l.leftover_kg), 1) AS mae_pct
  FROM surplus_forecast f
  JOIN mess_meal_log l ON l.mess_site_id = f.mess_site_id
                      AND l.service_date = f.forecast_date AND l.meal_slot = f.meal_slot
  JOIN site t          ON t.site_id = f.mess_site_id
 WHERE f.method = 'WEEKDAY_MA_4W'
 GROUP BY t.name ORDER BY mae_pct;
```

Output:

```text
+----------------------+-----------+---------------+------------------+--------+---------+
| mess                 | forecasts | avg_actual_kg | avg_predicted_kg | mae_kg | mae_pct |
+----------------------+-----------+---------------+------------------+--------+---------+
| SYN Mess B (Non-veg) |        52 |          18.3 |             21.9 |    7.0 |    38.1 |
| SYN Mess A (Veg)     |        52 |          25.7 |             30.0 |   10.1 |    39.3 |
| SYN Mess C (Mixed)   |        52 |          20.7 |             25.6 |    8.3 |    39.9 |
| SYN Mess E (Mixed)   |        52 |          15.8 |             19.3 |    6.5 |    41.1 |
| SYN Mess D (Special) |        39 |          10.7 |             14.2 |    5.0 |    46.4 |
| SYN Mess F (Veg)     |        52 |          11.8 |             14.8 |    5.8 |    49.7 |
+----------------------+-----------+---------------+------------------+--------+---------+
```

## Q18. Latest three custody events per batch, for today's live batches (ROW_NUMBER window)

Purpose: "top-N per group": ROW_NUMBER() restarts for every batch (PARTITION BY), so the outer filter keeps each batch's newest 3 events; the hash column shows the chain link.

```sql
SELECT batch_id, rn, event_type, event_time, LEFT(row_hash, 12) AS hash_prefix,
       LEFT(prev_hash, 12) AS prev_prefix
  FROM (SELECT e.*, ROW_NUMBER() OVER (PARTITION BY e.batch_id ORDER BY e.event_id DESC) AS rn
          FROM custody_event e
          JOIN surplus_batch b ON b.batch_id = e.batch_id
         WHERE b.description LIKE '%(live demo)') x
 WHERE rn <= 3
 ORDER BY batch_id, rn;
```

Output:

```text
+----------+----+------------+-------------------------+--------------+--------------+
| batch_id | rn | event_type | event_time              | hash_prefix  | prev_prefix  |
+----------+----+------------+-------------------------+--------------+--------------+
|      486 |  1 | POSTED     | 2026-10-05 12:37:34.000 | c51f748c4056 | d67e31d177bf |
|      486 |  2 | PACKED     | 2026-10-05 12:27:34.000 | d67e31d177bf | 5ef72cf8843a |
|      486 |  3 | COOKED     | 2026-10-05 11:27:34.000 | 5ef72cf8843a | NULL         |
|      487 |  1 | POSTED     | 2026-10-05 12:37:34.000 | 25c8d9a2396e | 13d2cef72050 |
|      487 |  2 | PACKED     | 2026-10-05 12:29:34.000 | 13d2cef72050 | a100886597cc |
|      487 |  3 | COOKED     | 2026-10-05 11:37:34.000 | a100886597cc | NULL         |
|      488 |  1 | POSTED     | 2026-10-05 12:37:34.000 | bedad7c21154 | 9cb8b96a5389 |
|      488 |  2 | PACKED     | 2026-10-05 12:17:34.000 | 9cb8b96a5389 | 6c22e8a6c7d7 |
|      488 |  3 | COOKED     | 2026-10-05 11:07:34.000 | 6c22e8a6c7d7 | NULL         |
|      489 |  1 | POSTED     | 2026-10-05 12:37:34.000 | 8d7515c63183 | 9b7dac618108 |
|      489 |  2 | PACKED     | 2026-10-05 12:32:34.000 | 9b7dac618108 | cf9916c1480e |
|      489 |  3 | COOKED     | 2026-10-05 11:52:34.000 | cf9916c1480e | NULL         |
|      490 |  1 | CLAIMED    | 2026-10-05 12:37:34.869 | 01bc8973b79f | af6c31650557 |
|      490 |  2 | POSTED     | 2026-10-05 12:37:34.000 | af6c31650557 | 752998ad8a82 |
|      490 |  3 | PACKED     | 2026-10-05 12:07:34.000 | 752998ad8a82 | faecffd1df4a |
|      491 |  1 | PICKED_UP  | 2026-10-05 12:37:34.883 | ad32c54c61a5 | d5c4a40111cf |
|      491 |  2 | CLAIMED    | 2026-10-05 12:37:34.873 | d5c4a40111cf | 924bd3108123 |
|      491 |  3 | POSTED     | 2026-10-05 12:37:34.000 | 924bd3108123 | fb6b0855f5b9 |
+----------+----+------------+-------------------------+--------------+--------------+
```

## Q19. Dishes that leave the most surplus when served (M:N JOIN through mess_menu)

Purpose: a forecasting feature: average leftover of the meals in which each dish was on the menu.

```sql
SELECT mi.name AS dish, fc.name AS category,
       COUNT(*)                     AS times_served,
       ROUND(AVG(l.leftover_kg), 1) AS avg_leftover_kg_of_meal,
       ROUND(AVG(100 * l.leftover_kg / l.prepared_kg), 1) AS avg_leftover_pct
  FROM mess_menu mm
  JOIN menu_item mi     ON mi.menu_item_id = mm.menu_item_id
  JOIN food_category fc ON fc.category_id = mi.category_id
  JOIN mess_meal_log l  ON l.mess_site_id = mm.mess_site_id
                       AND l.service_date = mm.service_date AND l.meal_slot = mm.meal_slot
 GROUP BY mi.name, fc.name
HAVING times_served >= 10
 ORDER BY avg_leftover_pct DESC LIMIT 8;
```

Output:

```text
+----------------------+---------------------------+--------------+-------------------------+------------------+
| dish                 | category                  | times_served | avg_leftover_kg_of_meal | avg_leftover_pct |
+----------------------+---------------------------+--------------+-------------------------+------------------+
| Sambar rice          | Rice, dal and sambar      |          102 |                    33.4 |             15.0 |
| Masala dosa          | South Indian breakfast    |           92 |                    15.0 |             14.6 |
| Idli with sambar     | South Indian breakfast    |           92 |                    14.0 |             14.4 |
| Paneer butter masala | Vegetable curry and gravy |           44 |                    29.8 |             14.1 |
| Fish fry             | Non-veg curry             |           30 |                    29.9 |             14.1 |
| Semiya payasam       | Sweets and dairy desserts |          115 |                    31.4 |             14.0 |
| Egg curry            | Non-veg curry             |           79 |                    28.8 |             14.0 |
| Bread omelette       | Breads (chapati, parotta) |           53 |                    13.9 |             13.8 |
+----------------------+---------------------------+--------------+-------------------------+------------------+
```

## Q20. Custody chain integrity across the whole database (function in aggregate)

Purpose: re-computes every SHA-256 link of every batch's chain of custody; 0 broken chains = no record was altered.

```sql
SELECT COUNT(*)                                            AS batches_checked,
       (SELECT COUNT(*) FROM custody_event)                AS events_checked,
       SUM(fn_custody_first_bad_event(batch_id) <> 0)      AS broken_chains
  FROM surplus_batch;
```

Output:

```text
+-----------------+----------------+---------------+
| batches_checked | events_checked | broken_chains |
+-----------------+----------------+---------------+
|             491 |           3048 |             0 |
+-----------------+----------------+---------------+
```

