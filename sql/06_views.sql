-- =====================================================================
-- MealBridge : VIEWS for the live feed, the impact dashboard and the volunteer pickup queue
-- Stage 4 deliverable. Run after 05_triggers.sql.
--
-- Reading guide for the viva:
--   * A view is a stored SELECT. The dashboard reads ONLY these views,
--     so every number on screen has one SQL definition you can show.
--   * Layering: v_batch_outcome computes per-batch facts once; the
--     impact, response-time and leaderboard views aggregate it.
--   * Roles get SELECT on views without SELECT on the base tables
--     (07_roles_grants.sql). Views run with SQL SECURITY DEFINER by
--     default, which is what makes that work.
--   * "Carbon avoided" multiplies delivered kg by food_category.co2e_kg_per_kg.
--     The seed uses ONE global average factor (FAO 2013); see the
--     values_source column. If a factor is NULL the result is NULL,
--     never a guessed number.
-- =====================================================================
USE mealbridge;

-- ---------------------------------------------------------------------
-- v_live_feed : what a shelter sees right now. Only AVAILABLE batches
-- whose deadline has not passed (so expired food is never offered even
-- between two runs of the auto-expire job). Uses IDX-4 (status, safe_until).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_live_feed AS
SELECT b.batch_id,
       t.name                                   AS mess,
       fc.name                                  AS category,
       b.description,
       b.quantity_kg,
       fn_meals(b.quantity_kg, b.category_id)   AS meals_equiv,
       b.storage,
       (SELECT GROUP_CONCAT(tag_code ORDER BY tag_code)
          FROM batch_diet_tag d WHERE d.batch_id = b.batch_id) AS diet_tags,
       b.created_at                             AS posted_at,
       b.safe_until,
       TIMESTAMPDIFF(MINUTE, NOW(), b.safe_until) AS minutes_left
  FROM surplus_batch b
  JOIN site t           ON t.site_id = b.mess_site_id
  JOIN food_category fc ON fc.category_id = b.category_id
 WHERE b.status = 'AVAILABLE'
   AND b.safe_until > NOW();

-- ---------------------------------------------------------------------
-- v_batch_outcome : one row per batch with everything the impact
-- reports need. The live/fulfilled claim is found through the UNIQUE
-- generated column claim.active_batch_id (at most one per batch).
--   response_min = minutes from posting to the FIRST claim
--   delivery_min = minutes from posting to the DELIVERED custody event
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_batch_outcome AS
SELECT b.batch_id,
       b.mess_site_id,
       t.name                                   AS mess,
       DATE(b.created_at)                       AS day,
       b.created_at,
       b.meal_slot,
       fc.name                                  AS category,
       b.quantity_kg,
       b.status,
       c.shelter_site_id                        AS delivered_to,
       IF(b.status = 'DELIVERED', b.quantity_kg, 0)                          AS kg_delivered,
       IF(b.status = 'DELIVERED', fn_meals(b.quantity_kg, b.category_id), 0) AS meals_saved,
       IF(b.status = 'DELIVERED', b.quantity_kg * fc.co2e_kg_per_kg, 0)      AS co2e_avoided_kg,
       IF(b.status = 'EXPIRED', b.quantity_kg, 0)                            AS kg_expired,
       TIMESTAMPDIFF(MINUTE, b.created_at,
         (SELECT MIN(c2.claimed_at) FROM claim c2 WHERE c2.batch_id = b.batch_id)) AS response_min,
       TIMESTAMPDIFF(MINUTE, b.created_at,
         (SELECT MAX(e.event_time) FROM custody_event e
           WHERE e.batch_id = b.batch_id AND e.event_type = 'DELIVERED'))   AS delivery_min
  FROM surplus_batch b
  JOIN site t           ON t.site_id = b.mess_site_id
  JOIN food_category fc ON fc.category_id = b.category_id
  LEFT JOIN claim c     ON c.active_batch_id = b.batch_id;

-- ---------------------------------------------------------------------
-- v_impact_daily : the dashboard's time series (one row per day).
--   rescue_rate_pct = kg delivered / kg posted
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_impact_daily AS
SELECT day,
       COUNT(*)                                   AS batches_posted,
       SUM(quantity_kg)                           AS kg_posted,
       SUM(kg_delivered)                          AS kg_delivered,
       SUM(meals_saved)                           AS meals_saved,
       ROUND(SUM(co2e_avoided_kg), 1)             AS co2e_avoided_kg,
       SUM(kg_expired)                            AS kg_expired,
       ROUND(100 * SUM(kg_delivered) / SUM(quantity_kg), 1) AS rescue_rate_pct
  FROM v_batch_outcome
 GROUP BY day;

-- ---------------------------------------------------------------------
-- v_impact_summary : the headline counters (one row).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_impact_summary AS
SELECT MIN(day)                                   AS from_day,
       MAX(day)                                   AS to_day,
       COUNT(*)                                   AS batches_posted,
       SUM(status = 'DELIVERED')                  AS batches_delivered,
       SUM(meals_saved)                           AS meals_saved,
       SUM(kg_delivered)                          AS kg_diverted,
       ROUND(SUM(co2e_avoided_kg), 0)             AS co2e_avoided_kg,
       SUM(kg_expired)                            AS kg_expired,
       ROUND(100 * SUM(kg_delivered) / SUM(quantity_kg), 1) AS rescue_rate_pct,
       ROUND(AVG(response_min), 0)                AS avg_response_min,
       ROUND(AVG(delivery_min), 0)                AS avg_post_to_delivery_min
  FROM v_batch_outcome;

-- ---------------------------------------------------------------------
-- v_response_time : how fast each shelter responds and receives food.
--   median_response_min uses ROW_NUMBER() and COUNT() OVER () because
--   MySQL has no MEDIAN() aggregate: the median is the middle row(s).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_response_time AS
WITH r AS (
  SELECT c.shelter_site_id,
         TIMESTAMPDIFF(MINUTE, b.created_at, c.claimed_at) AS response_min,
         ROW_NUMBER() OVER (PARTITION BY c.shelter_site_id
                            ORDER BY TIMESTAMPDIFF(SECOND, b.created_at, c.claimed_at)) AS rn,
         COUNT(*)     OVER (PARTITION BY c.shelter_site_id) AS n
    FROM claim c JOIN surplus_batch b ON b.batch_id = c.batch_id
)
SELECT t.name                                   AS shelter,
       MAX(r.n)                                 AS claims,
       ROUND(AVG(r.response_min), 0)            AS avg_response_min,
       ROUND(AVG(CASE WHEN r.rn IN (FLOOR((r.n + 1) / 2), CEIL((r.n + 1) / 2))
                      THEN r.response_min END), 0) AS median_response_min,
       MIN(r.response_min)                      AS fastest_min,
       MAX(r.response_min)                      AS slowest_min
  FROM r JOIN site t ON t.site_id = r.shelter_site_id
 GROUP BY t.name;

-- ---------------------------------------------------------------------
-- v_shelter_fairness : is food shared in proportion to need?
--   Over the last 30 days, per shelter:
--     need_share_pct      = beneficiaries / all beneficiaries
--     received_share_pct  = kg received / all kg delivered
--     kg_per_beneficiary  = kg received / beneficiaries
--     fair_ratio          = received_share / need_share  (1.00 = fair)
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_shelter_fairness AS
WITH recv AS (
  SELECT s.site_id, t.name, s.beneficiary_count,
         COALESCE(SUM(b.quantity_kg), 0) AS kg_received,
         COUNT(b.batch_id)               AS batches
    FROM shelter s
    JOIN site t ON t.site_id = s.site_id
    LEFT JOIN claim c ON c.shelter_site_id = s.site_id AND c.status = 'FULFILLED'
                     AND c.claimed_at >= NOW() - INTERVAL 30 DAY
    LEFT JOIN surplus_batch b ON b.batch_id = c.batch_id
   WHERE t.is_active
   GROUP BY s.site_id, t.name, s.beneficiary_count
)
SELECT name                                                     AS shelter,
       beneficiary_count                                        AS beneficiaries,
       batches,
       kg_received,
       ROUND(kg_received / beneficiary_count, 2)                AS kg_per_beneficiary,
       ROUND(100 * beneficiary_count / SUM(beneficiary_count) OVER (), 1) AS need_share_pct,
       ROUND(100 * kg_received / NULLIF(SUM(kg_received) OVER (), 0), 1)  AS received_share_pct,
       ROUND((kg_received / NULLIF(SUM(kg_received) OVER (), 0))
             / (beneficiary_count / SUM(beneficiary_count) OVER ()), 2)   AS fair_ratio
  FROM recv;

-- ---------------------------------------------------------------------
-- v_fairness_index : ONE number for the fairness chart.
--   Jain's fairness index (Jain, Chiu & Hawe, 1984) over
--   x_i = kg per beneficiary of shelter i:
--        J = (sum x_i)^2 / (n * sum x_i^2)
--   J = 1.00 when every shelter gets the same kg per beneficiary,
--   J = 1/n when one shelter gets everything.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_fairness_index AS
SELECT COUNT(*)                                                   AS shelters,
       ROUND(POW(SUM(kg_per_beneficiary), 2)
             / (COUNT(*) * SUM(POW(kg_per_beneficiary, 2))), 3)   AS jain_index,
       ROUND(1 / COUNT(*), 3)                                     AS worst_possible
  FROM v_shelter_fairness;

-- ---------------------------------------------------------------------
-- v_mess_leaderboard : which messes post most and how much is rescued.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_mess_leaderboard AS
SELECT mess,
       COUNT(*)                                             AS batches,
       SUM(quantity_kg)                                     AS kg_posted,
       SUM(kg_delivered)                                    AS kg_rescued,
       ROUND(100 * SUM(kg_delivered) / SUM(quantity_kg), 1) AS rescue_rate_pct,
       RANK() OVER (ORDER BY SUM(kg_delivered) DESC)        AS rank_by_kg_rescued
  FROM v_batch_outcome
 GROUP BY mess;

-- ---------------------------------------------------------------------
-- v_pickup_queue : (Stage 6) what a VOLUNTEER needs to plan a trip.
--   Claims that are ACTIVE, whose batch is CLAIMED (not yet picked up),
--   still safe, and not already on a PLANNED / IN_PROGRESS trip.
--   Least privilege: the volunteer role has NO SELECT on claim or
--   shelter_day. This view exposes only the columns routing needs
--   (where, how much, until when); match scores and capacity stay hidden.
--   Coordinates are returned as numbers for the map (SRID 4326 order
--   is latitude, longitude).
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_pickup_queue AS
SELECT c.claim_id,
       b.batch_id,
       b.description,
       b.quantity_kg,
       b.safe_until,
       TIMESTAMPDIFF(MINUTE, NOW(), b.safe_until) AS minutes_left,
       ms.site_id                       AS mess_id,
       ms.name                          AS mess,
       ST_Latitude(ms.location)         AS mess_lat,
       ST_Longitude(ms.location)        AS mess_lon,
       ss.site_id                       AS shelter_id,
       ss.name                          AS shelter,
       ST_Latitude(ss.location)         AS shelter_lat,
       ST_Longitude(ss.location)        AS shelter_lon
  FROM claim c
  JOIN surplus_batch b ON b.batch_id = c.batch_id
  JOIN site ms         ON ms.site_id = b.mess_site_id
  JOIN site ss         ON ss.site_id = c.shelter_site_id
 WHERE c.status = 'ACTIVE'
   AND b.status = 'CLAIMED'
   AND b.safe_until > NOW()
   AND NOT EXISTS (SELECT 1
                     FROM trip_item ti
                     JOIN pickup_trip pt ON pt.trip_id = ti.trip_id
                    WHERE ti.claim_id = c.claim_id
                      AND pt.status IN ('PLANNED','IN_PROGRESS'));

-- ---------------------------------------------------------------------
-- v_trip_manifest : (Stage 6) what is on each trip: which batch is
--   loaded at which stop and dropped at which stop. Like v_pickup_queue
--   it lets the volunteer role see a trip's load without SELECT on claim.
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_trip_manifest AS
SELECT ti.trip_id,
       ti.claim_id,
       c.batch_id,
       b.description,
       b.quantity_kg,
       b.status       AS batch_status,
       b.safe_until,
       ti.pickup_seq,
       ti.drop_seq
  FROM trip_item ti
  JOIN claim c         ON c.claim_id = ti.claim_id
  JOIN surplus_batch b ON b.batch_id = c.batch_id;
