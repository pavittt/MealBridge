# MealBridge: 20 queries with real output

Real output of `11_queries.sql`, run as MySQL user `root` on MySQL 8.0.46-0ubuntu0.24.04.4 at 2026-10-07 09:26:08.
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
|      419 | SYN Mess A (Veg)     | Rice, dal and sambar      | 24.00 |    53 | HOT_HELD |          169 |          75.73 |
|      421 | SYN Mess C (Mixed)   | Non-veg curry             |  9.00 |    30 | CHILLED  |         1349 |          74.48 |
|      420 | SYN Mess B (Non-veg) | Vegetable curry and gravy | 12.50 |    41 | HOT_HELD |          179 |          73.51 |
|      422 | SYN Mess E (Mixed)   | Breads (chapati, parotta) |  6.00 |    30 | AMBIENT  |          314 |          69.54 |
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
|        8 | SYN Mess A (Veg)     | SYN Katpadi Night Shelter     | SYN Volunteer Farah | 2026-09-08 14:34:25 | 2026-09-08 14:46:38.000 | 2026-09-08 15:37:52 | 2026-09-08 16:28:52 | FULFILLED    |
|        9 | SYN Mess B (Non-veg) | SYN Temple Annadhanam Kitchen | SYN Volunteer Farah | 2026-09-08 14:13:52 | 2026-09-08 14:24:35.000 | 2026-09-08 16:00:52 | 2026-09-08 17:23:52 | REJECTED     |
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
| SYN Mess A (Veg)     | BREAKFAST   |      28 |    277.59 |     224.97 |
| SYN Mess A (Veg)     | DINNER      |      42 |    571.61 |     293.63 |
| SYN Mess A (Veg)     | LUNCH       |      46 |    645.07 |     460.71 |
| SYN Mess A (Veg)     | SNACKS      |       2 |     13.78 |      13.78 |
| SYN Mess A (Veg)     | (all slots) |     118 |   1508.05 |     993.09 |
| SYN Mess B (Non-veg) | BREAKFAST   |      16 |    155.48 |     147.56 |
| SYN Mess B (Non-veg) | DINNER      |      30 |    302.54 |      81.51 |
| SYN Mess B (Non-veg) | LUNCH       |      31 |    327.77 |     128.77 |
| SYN Mess B (Non-veg) | (all slots) |      77 |    785.79 |     357.84 |
| SYN Mess C (Mixed)   | BREAKFAST   |      23 |    214.77 |     178.55 |
| SYN Mess C (Mixed)   | DINNER      |      41 |    479.13 |     242.73 |
| SYN Mess C (Mixed)   | LUNCH       |      40 |    450.37 |     307.40 |
| SYN Mess C (Mixed)   | (all slots) |     104 |   1144.27 |     728.68 |
| SYN Mess D (Special) | BREAKFAST   |       4 |     25.93 |      19.12 |
| SYN Mess D (Special) | DINNER      |       6 |     58.36 |       7.90 |
| SYN Mess D (Special) | LUNCH       |      11 |    107.61 |      37.59 |
| SYN Mess D (Special) | (all slots) |      21 |    191.90 |      64.61 |
| SYN Mess E (Mixed)   | BREAKFAST   |      11 |     92.79 |      67.51 |
| SYN Mess E (Mixed)   | DINNER      |      22 |    233.60 |     118.42 |
| SYN Mess E (Mixed)   | LUNCH       |      33 |    340.03 |     222.75 |
| SYN Mess E (Mixed)   | (all slots) |      66 |    666.42 |     408.68 |
| SYN Mess F (Veg)     | BREAKFAST   |       9 |     70.92 |      53.91 |
| SYN Mess F (Veg)     | DINNER      |      14 |    138.91 |      29.06 |
| SYN Mess F (Veg)     | LUNCH       |      15 |    162.13 |     117.12 |
| SYN Mess F (Veg)     | (all slots) |      38 |    371.96 |     200.09 |
| ALL MESSES           | (all slots) |     424 |   4668.39 |    2752.99 |
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
| Non-veg curry             | HIGH       |      42 |    393.74 |     261.26 |        66.4 |
| Vegetable curry and gravy | MEDIUM     |      46 |    494.21 |     199.25 |        40.3 |
| Rice, dal and sambar      | MEDIUM     |     173 |   2163.89 |     847.94 |        39.2 |
| Sweets and dairy desserts | HIGH       |      37 |    387.01 |     132.40 |        34.2 |
| Breads (chapati, parotta) | LOW        |      35 |    376.51 |     117.51 |        31.2 |
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
| SYN Mess A (Veg) |     118 |        12.78 |           11.01 |
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
| SYN Mess A (Veg)     | Saturday      |                     28.0 |
| SYN Mess B (Non-veg) | Saturday      |                     20.4 |
| SYN Mess C (Mixed)   | Saturday      |                     23.6 |
| SYN Mess D (Special) | Saturday      |                     12.8 |
| SYN Mess E (Mixed)   | Sunday        |                     17.6 |
| SYN Mess F (Veg)     | Sunday        |                     13.9 |
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
| SYN Hospital Attendants Rest House |           200 |      473.92 |       1 |       17.2 |                  7 |
| SYN Katpadi Night Shelter          |           120 |      457.41 |       2 |       16.6 |                  6 |
| SYN Gandhi Nagar Community Kitchen |            90 |      377.47 |       3 |       13.7 |                  5 |
| SYN Temple Annadhanam Kitchen      |           150 |      323.49 |       4 |       11.8 |                  8 |
| SYN Anbu Children's Home           |            60 |      296.89 |       5 |       10.8 |                  4 |
| SYN Little Steps Orphanage         |            35 |      243.77 |       6 |        8.9 |                  1 |
| SYN Sathuvachari Women's Shelter   |            40 |      242.19 |       7 |        8.8 |                  2 |
| SYN Sri Sai Old Age Home           |            45 |      230.13 |       8 |        8.4 |                  3 |
| SYN Arcot Road Old Age Home        |            70 |      107.72 |       9 |        3.9 |                  9 |
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
| 2026-09-07 |         241 |                    241 |         61.69 |
| 2026-09-08 |          50 |                    291 |         81.54 |
| 2026-09-09 |          75 |                    366 |        109.83 |
| 2026-09-10 |          88 |                    454 |        150.34 |
| 2026-09-11 |          88 |                    542 |        180.18 |
| 2026-09-12 |         542 |                   1084 |        354.27 |
| 2026-09-13 |         626 |                   1710 |        535.95 |
| 2026-09-14 |          51 |                   1761 |        559.07 |
| 2026-09-15 |         144 |                   1905 |        597.97 |
| 2026-09-16 |         119 |                   2024 |        633.67 |
| 2026-09-17 |         108 |                   2132 |        680.96 |
| 2026-09-18 |         399 |                   2531 |        767.91 |
| 2026-09-19 |         555 |                   3086 |        952.17 |
| 2026-09-20 |         607 |                   3693 |       1161.39 |
| 2026-09-21 |         137 |                   3830 |       1210.77 |
| 2026-09-22 |          30 |                   3860 |       1224.97 |
| 2026-09-23 |           0 |                   3860 |       1224.97 |
| 2026-09-24 |         130 |                   3990 |       1268.62 |
| 2026-09-25 |         719 |                   4709 |       1500.78 |
| 2026-09-26 |        1201 |                   5910 |       1807.53 |
| 2026-09-27 |         905 |                   6815 |       2065.76 |
| 2026-09-28 |          80 |                   6895 |       2098.93 |
| 2026-09-29 |         204 |                   7099 |       2156.70 |
| 2026-09-30 |         140 |                   7239 |       2197.39 |
| 2026-10-01 |         210 |                   7449 |       2248.50 |
| 2026-10-02 |         116 |                   7565 |       2286.18 |
| 2026-10-03 |         727 |                   8292 |       2520.07 |
| 2026-10-04 |         643 |                   8935 |       2716.57 |
| 2026-10-05 |           0 |                   8935 |       2716.57 |
| 2026-10-06 |          99 |                   9034 |       2752.99 |
| 2026-10-07 |           0 |                   9034 |       2752.99 |
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
| 2026-09-07 | Monday    |     61.69 |  61.7 |      |
| 2026-09-08 | Tuesday   |     28.90 |  45.3 |      |
| 2026-09-09 | Wednesday |     51.34 |  47.3 |      |
| 2026-09-10 | Thursday  |     57.28 |  49.8 |      |
| 2026-09-11 | Friday    |     36.16 |  47.1 |      |
| 2026-09-12 | Saturday  |    205.57 |  73.5 | PEAK |
| 2026-09-13 | Sunday    |    246.12 |  98.2 | PEAK |
| 2026-09-14 | Monday    |     23.12 |  92.6 |      |
| 2026-09-15 | Tuesday   |     52.90 |  96.1 |      |
| 2026-09-16 | Wednesday |     45.38 |  95.2 |      |
| 2026-09-17 | Thursday  |     53.33 |  94.7 |      |
| 2026-09-18 | Friday    |    115.06 | 105.9 |      |
| 2026-09-19 | Saturday  |    212.17 | 106.9 | PEAK |
| 2026-09-20 | Sunday    |    273.29 | 110.8 | PEAK |
| 2026-09-21 | Monday    |     49.38 | 114.5 |      |
| 2026-09-22 | Tuesday   |     23.22 | 110.3 |      |
| 2026-09-23 | Wednesday |      6.38 | 104.7 |      |
| 2026-09-24 | Thursday  |     64.83 | 106.3 |      |
| 2026-09-25 | Friday    |    509.90 | 162.7 | PEAK |
| 2026-09-26 | Saturday  |    727.85 | 236.4 | PEAK |
| 2026-09-27 | Sunday    |    741.09 | 303.2 | PEAK |
| 2026-09-28 | Monday    |     39.66 | 301.8 |      |
| 2026-09-29 | Tuesday   |     97.99 | 312.5 |      |
| 2026-09-30 | Wednesday |     56.01 | 319.6 |      |
| 2026-10-01 | Thursday  |     90.71 | 323.3 |      |
| 2026-10-02 | Friday    |     60.69 | 259.1 |      |
| 2026-10-03 | Saturday  |    341.61 | 204.0 | PEAK |
| 2026-10-04 | Sunday    |    262.30 | 135.6 | PEAK |
| 2026-10-05 | Monday    |      6.99 | 130.9 |      |
| 2026-10-06 | Tuesday   |     42.97 | 123.0 |      |
| 2026-10-07 | Wednesday |     84.50 | 127.1 |      |
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
| SYN Mess A (Veg)     |   202637 | 211.92 |         NULL |       NULL |
| SYN Mess A (Veg)     |   202638 | 345.77 |       211.92 |       63.2 |
| SYN Mess A (Veg)     |   202639 | 576.33 |       345.77 |       66.7 |
| SYN Mess A (Veg)     |   202640 | 335.21 |       576.33 |      -41.8 |
| SYN Mess A (Veg)     |   202641 |  14.82 |       335.21 |      -95.6 |
| SYN Mess B (Non-veg) |   202637 | 131.89 |         NULL |       NULL |
| SYN Mess B (Non-veg) |   202638 | 117.07 |       131.89 |      -11.2 |
| SYN Mess B (Non-veg) |   202639 | 338.18 |       117.07 |      188.9 |
| SYN Mess B (Non-veg) |   202640 | 171.27 |       338.18 |      -49.4 |
| SYN Mess B (Non-veg) |   202641 |  14.88 |       171.27 |      -91.3 |
| SYN Mess C (Mixed)   |   202637 | 200.88 |         NULL |       NULL |
| SYN Mess C (Mixed)   |   202638 | 182.78 |       200.88 |       -9.0 |
| SYN Mess C (Mixed)   |   202639 | 473.61 |       182.78 |      159.1 |
| SYN Mess C (Mixed)   |   202640 | 270.76 |       473.61 |      -42.8 |
| SYN Mess C (Mixed)   |   202641 |   7.24 |       270.76 |      -97.3 |
| SYN Mess D (Special) |   202637 |   7.90 |         NULL |       NULL |
| SYN Mess D (Special) |   202639 | 150.19 |         7.90 |     1801.1 |
| SYN Mess D (Special) |   202640 |  18.81 |       150.19 |      -87.5 |
| SYN Mess E (Mixed)   |   202637 |  95.98 |         NULL |       NULL |
| SYN Mess E (Mixed)   |   202638 |  92.61 |        95.98 |       -3.5 |
| SYN Mess E (Mixed)   |   202639 | 344.48 |        92.61 |      272.0 |
| SYN Mess E (Mixed)   |   202640 | 121.32 |       344.48 |      -64.8 |
| SYN Mess E (Mixed)   |   202641 |   6.03 |       121.32 |      -95.0 |
| SYN Mess F (Veg)     |   202637 |  38.49 |         NULL |       NULL |
| SYN Mess F (Veg)     |   202638 |  37.02 |        38.49 |       -3.8 |
| SYN Mess F (Veg)     |   202639 | 239.86 |        37.02 |      547.9 |
| SYN Mess F (Veg)     |   202640 |  31.60 |       239.86 |      -86.8 |
| SYN Mess F (Veg)     |   202641 |   6.99 |        31.60 |      -77.9 |
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
|        1 |        0 |     11 |        32 |    49 |      1 |      1 |
|        2 |       11 |     17 |        25 |    50 |      0 |      7 |
|        3 |       17 |     29 |        22 |    29 |      1 |     30 |
|        4 |       30 |   1073 |        11 |    14 |      0 |     57 |
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
| CHILLED  |     113 |           1305 |       100 |       9 |            88.5 |
| HOT_HELD |     233 |            144 |       143 |      79 |            61.4 |
| AMBIENT  |      72 |            153 |        27 |      44 |            37.5 |
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
| SYN Volunteer Arjun   | TWO_WHEELER  |       25.00 | verified     |    26 |              32 |     326.37 |                5 |
| SYN Volunteer Eshan   | VAN          |      150.00 | verified     |    26 |              29 |     321.18 |                2 |
| SYN Volunteer Divya   | TWO_WHEELER  |       25.00 | verified     |    26 |              33 |     313.56 |                6 |
| SYN Volunteer Farah   | CAR          |       80.00 | verified     |    26 |              29 |     297.10 |                3 |
| SYN Volunteer Imran   | AUTO         |       60.00 | verified     |    26 |              27 |     295.45 |                1 |
| SYN Volunteer Charan  | AUTO         |       60.00 | verified     |    26 |              30 |     292.50 |                2 |
| SYN Volunteer Janani  | CAR          |       80.00 | verified     |    26 |              27 |     290.16 |                1 |
| SYN Volunteer Bhavya  | CAR          |       80.00 | verified     |    27 |              27 |     289.46 |                0 |
| SYN Volunteer Harini  | TWO_WHEELER  |       25.00 | verified     |    26 |              26 |     265.06 |                0 |
| SYN Volunteer Gokul   | BICYCLE      |       12.00 | verified     |    27 |              27 |     211.61 |                0 |
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
| DINNER    |              70 |                   44 |                  26 |      515.26 |
| LUNCH     |              49 |                   27 |                  22 |      281.26 |
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
| SYN Mess C (Mixed)   |        32 |          21.2 |             24.0 |    7.7 |    36.1 |
| SYN Mess B (Non-veg) |        32 |          18.7 |             20.7 |    6.9 |    36.9 |
| SYN Mess F (Veg)     |        32 |          13.0 |             14.0 |    5.2 |    40.1 |
| SYN Mess A (Veg)     |        32 |          25.0 |             27.9 |   10.7 |    42.8 |
| SYN Mess E (Mixed)   |        32 |          15.5 |             18.1 |    6.9 |    44.7 |
| SYN Mess D (Special) |        24 |          10.3 |             13.4 |    5.4 |    52.0 |
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
|      419 |  1 | POSTED     | 2026-10-07 09:26:02.000 | c00f00be3618 | c81211d5b212 |
|      419 |  2 | PACKED     | 2026-10-07 09:16:02.000 | c81211d5b212 | 20018e2f23c6 |
|      419 |  3 | COOKED     | 2026-10-07 08:16:02.000 | 20018e2f23c6 | NULL         |
|      420 |  1 | POSTED     | 2026-10-07 09:26:02.000 | 4767073d30c3 | 33aa7f7f53db |
|      420 |  2 | PACKED     | 2026-10-07 09:18:02.000 | 33aa7f7f53db | deb816f01523 |
|      420 |  3 | COOKED     | 2026-10-07 08:26:02.000 | deb816f01523 | NULL         |
|      421 |  1 | POSTED     | 2026-10-07 09:26:02.000 | bdb11472f643 | b3260498c79d |
|      421 |  2 | PACKED     | 2026-10-07 09:06:02.000 | b3260498c79d | 23b23d88bafd |
|      421 |  3 | COOKED     | 2026-10-07 07:56:02.000 | 23b23d88bafd | NULL         |
|      422 |  1 | POSTED     | 2026-10-07 09:26:02.000 | 8709ee83ee27 | d5d6c9ce268a |
|      422 |  2 | PACKED     | 2026-10-07 09:21:02.000 | d5d6c9ce268a | 9eac120db97b |
|      422 |  3 | COOKED     | 2026-10-07 08:41:02.000 | 9eac120db97b | NULL         |
|      423 |  1 | CLAIMED    | 2026-10-07 09:26:02.512 | 09b6712ae360 | f4973bd76b0b |
|      423 |  2 | POSTED     | 2026-10-07 09:26:02.000 | f4973bd76b0b | a88bd77a8f82 |
|      423 |  3 | PACKED     | 2026-10-07 08:56:02.000 | a88bd77a8f82 | 26ebc3165311 |
|      424 |  1 | PICKED_UP  | 2026-10-07 09:26:02.533 | 22557806296f | 1ff74e1a53ea |
|      424 |  2 | CLAIMED    | 2026-10-07 09:26:02.519 | 1ff74e1a53ea | 19cb2a859bc2 |
|      424 |  3 | POSTED     | 2026-10-07 09:26:02.000 | 19cb2a859bc2 | 35ac1d9bbb25 |
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
| Masala dosa          | South Indian breakfast    |           76 |                    16.3 |             15.8 |
| Sambar rice          | Rice, dal and sambar      |           86 |                    35.0 |             15.8 |
| Paneer butter masala | Vegetable curry and gravy |           38 |                    31.3 |             14.8 |
| Idli with sambar     | South Indian breakfast    |           74 |                    14.3 |             14.8 |
| Semiya payasam       | Sweets and dairy desserts |           99 |                    32.3 |             14.5 |
| Egg curry            | Non-veg curry             |           68 |                    29.4 |             14.3 |
| Fish fry             | Non-veg curry             |           28 |                    30.5 |             14.3 |
| Upma                 | South Indian breakfast    |           86 |                    14.1 |             14.1 |
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
|             424 |           2633 |             0 |
+-----------------+----------------+---------------+
```

