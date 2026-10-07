-- =====================================================================
-- MealBridge : stored FUNCTIONS                         Stage 4 deliverable
-- Run after 01_schema.sql.
--
-- Reading guide for the viva:
--   * A FUNCTION returns one value and can be used inside SELECT/WHERE.
--     A PROCEDURE (04_procedures.sql) is CALLed and may change data.
--   * The fair-matching score is split into one small function per
--     component, so each part can be shown and defended on its own:
--         fn_need_score, fn_capacity_score, fn_distance_score,
--         fn_perishability_score, fn_fairness_score
--     and fn_match_score combines them with the weights stored in the
--     scoring_weight table (policy is data, not code).
--   * Every function that reads tables is declared READS SQL DATA. With
--     binary logging on (MySQL 8 default) MySQL refuses to create a
--     function that does not declare its data access.
--   * Constants marked ASSUMPTION are planning values, not measured
--     facts. They must be checked in the field trial (TO VERIFY).
-- =====================================================================
USE mealbridge;
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;  -- also when run on its own; see 01_schema.sql

DROP FUNCTION IF EXISTS fn_distance_km;
DROP FUNCTION IF EXISTS fn_travel_minutes;
DROP FUNCTION IF EXISTS fn_safe_until;
DROP FUNCTION IF EXISTS fn_meals;
DROP FUNCTION IF EXISTS fn_is_diet_compatible;
DROP FUNCTION IF EXISTS fn_need_score;
DROP FUNCTION IF EXISTS fn_capacity_score;
DROP FUNCTION IF EXISTS fn_distance_score;
DROP FUNCTION IF EXISTS fn_perishability_score;
DROP FUNCTION IF EXISTS fn_fairness_score;
DROP FUNCTION IF EXISTS fn_match_score;
DROP FUNCTION IF EXISTS fn_custody_first_bad_event;

DELIMITER $$

-- ---------------------------------------------------------------------
-- fn_distance_km : great-circle distance between two SRID-4326 points.
-- ST_Distance_Sphere returns metres on a sphere of Earth's mean radius.
-- Straight-line distance UNDER-estimates road distance; the detour factor
-- in fn_travel_minutes compensates for that.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_distance_km(p_a POINT, p_b POINT)
RETURNS DECIMAL(8,3)
DETERMINISTIC NO SQL
BEGIN
  RETURN ST_Distance_Sphere(p_a, p_b) / 1000;
END$$

-- ---------------------------------------------------------------------
-- fn_travel_minutes : estimated door-to-door minutes for a volunteer.
--   ASSUMPTION (TO VERIFY): road distance = 1.4 x straight line,
--   average urban speed 20 km/h, plus 20 min handling (loading at the
--   mess, unloading at the shelter).
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_travel_minutes(p_km DECIMAL(8,3))
RETURNS DECIMAL(8,1)
DETERMINISTIC NO SQL
BEGIN
  DECLARE c_detour      DECIMAL(3,2) DEFAULT 1.40;   -- ASSUMPTION
  DECLARE c_speed_kmph  DECIMAL(5,2) DEFAULT 20.00;  -- ASSUMPTION
  DECLARE c_handling    DECIMAL(5,1) DEFAULT 20.0;   -- ASSUMPTION
  RETURN (p_km * c_detour / c_speed_kmph) * 60 + c_handling;
END$$

-- ---------------------------------------------------------------------
-- fn_safe_until : the PERISHABILITY CLOCK.
--   deadline = cooked_at + safe hours for (food category, storage mode).
--   Called once by the BEFORE INSERT trigger on surplus_batch, so the
--   deadline is a snapshot (see design doc 5.4).
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_safe_until(p_category_id SMALLINT UNSIGNED,
                              p_storage     VARCHAR(10),
                              p_cooked_at   DATETIME)
RETURNS DATETIME
READS SQL DATA
BEGIN
  DECLARE v_hours DECIMAL(4,1);
  SELECT CASE p_storage
           WHEN 'AMBIENT'  THEN safe_hours_ambient
           WHEN 'HOT_HELD' THEN safe_hours_hot_held
           WHEN 'CHILLED'  THEN safe_hours_chilled
         END
    INTO v_hours
    FROM food_category
   WHERE category_id = p_category_id;
  IF v_hours IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'fn_safe_until: unknown food category or storage mode';
  END IF;
  -- hours are DECIMAL (e.g. 2.5), so convert to minutes for DATE_ADD
  RETURN p_cooked_at + INTERVAL ROUND(v_hours * 60) MINUTE;
END$$

-- ---------------------------------------------------------------------
-- fn_meals : converts kilograms of a category into meal-equivalents.
--   "Meals saved" in every report is computed with this one function,
--   so the definition is the same everywhere.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_meals(p_kg DECIMAL(9,2), p_category_id SMALLINT UNSIGNED)
RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_kg_per_meal DECIMAL(4,3);
  SELECT kg_per_meal INTO v_kg_per_meal
    FROM food_category WHERE category_id = p_category_id;
  RETURN FLOOR(p_kg / v_kg_per_meal);
END$$

-- ---------------------------------------------------------------------
-- fn_is_diet_compatible : 1 if NO diet tag of the batch is on the
--   shelter's exclusion list, else 0. Classic NOT EXISTS (relational
--   "no element of set A is in set B").
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_is_diet_compatible(p_batch_id INT UNSIGNED,
                                      p_shelter_id INT UNSIGNED)
RETURNS TINYINT
READS SQL DATA
BEGIN
  RETURN NOT EXISTS (
    SELECT 1
      FROM batch_diet_tag         bdt
      JOIN shelter_diet_exclusion sde ON sde.tag_code = bdt.tag_code
     WHERE bdt.batch_id        = p_batch_id
       AND sde.shelter_site_id = p_shelter_id);
END$$

-- ---------------------------------------------------------------------
-- fn_need_score (0-100): share of the shelter's meals for that day that
--   are NOT yet covered by live claims. 100 = nothing covered yet.
--   If the shelter has not entered a shelter_day row, its registered
--   beneficiary_count is used as the day's need.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_need_score(p_shelter_id INT UNSIGNED, p_day DATE)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
  DECLARE v_needed  INT;
  DECLARE v_covered INT;

  SELECT COALESCE(sd.meals_needed, s.beneficiary_count)
    INTO v_needed
    FROM shelter s
    LEFT JOIN shelter_day sd
           ON sd.shelter_site_id = s.site_id AND sd.day = p_day
   WHERE s.site_id = p_shelter_id;

  -- meals already promised to this shelter today (live or delivered claims)
  SELECT COALESCE(SUM(fn_meals(b.quantity_kg, b.category_id)), 0)
    INTO v_covered
    FROM claim c
    JOIN surplus_batch b ON b.batch_id = c.batch_id
   WHERE c.shelter_site_id = p_shelter_id
     AND c.status IN ('ACTIVE','FULFILLED')
     AND c.claimed_at >= p_day
     AND c.claimed_at <  p_day + INTERVAL 1 DAY;   -- sargable range, uses IDX-7

  IF v_needed IS NULL OR v_needed = 0 THEN RETURN 0; END IF;
  RETURN 100 * GREATEST(0, v_needed - v_covered) / v_needed;
END$$

-- ---------------------------------------------------------------------
-- fn_capacity_score (0-100) : "best fit".
--   remaining = capacity_kg - reserved_kg for that day.
--   NULL      = the whole batch does not fit -> shelter is NOT eligible
--               (claims are whole-batch, design decision 4.1).
--   score     = quantity / remaining. A batch that fills the remaining
--               space scores high; this keeps big-capacity shelters free
--               for big batches (like best-fit bin packing).
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_capacity_score(p_shelter_id INT UNSIGNED, p_day DATE,
                                  p_qty_kg DECIMAL(7,2))
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
  DECLARE v_remaining DECIMAL(8,2);
  SELECT COALESCE(sd.capacity_kg, s.default_capacity_kg) - COALESCE(sd.reserved_kg, 0)
    INTO v_remaining
    FROM shelter s
    LEFT JOIN shelter_day sd
           ON sd.shelter_site_id = s.site_id AND sd.day = p_day
   WHERE s.site_id = p_shelter_id;
  IF v_remaining IS NULL OR v_remaining < p_qty_kg THEN
    RETURN NULL;
  END IF;
  RETURN 100 * p_qty_kg / v_remaining;
END$$

-- ---------------------------------------------------------------------
-- fn_distance_score (0-100): linear decay to 0 at the service radius.
--   NULL beyond the radius. ASSUMPTION (TO VERIFY): 15 km radius.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_distance_score(p_km DECIMAL(8,3))
RETURNS DECIMAL(5,2)
DETERMINISTIC NO SQL
BEGIN
  DECLARE c_radius_km DECIMAL(5,2) DEFAULT 15.00;    -- ASSUMPTION
  IF p_km > c_radius_km THEN RETURN NULL; END IF;
  RETURN 100 * (1 - p_km / c_radius_km);
END$$

-- ---------------------------------------------------------------------
-- fn_perishability_score (0-100): how much of the food's remaining safe
--   time the trip would use up.
--   NULL = the shelter cannot be reached before the deadline (with a
--          30 min safety buffer) -> NOT eligible. This is the rule
--          "matching only considers shelters reachable before expiry".
--   score = 100 x (1 - travel / minutes_left): the closer the deadline,
--          the more a long trip is penalised.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_perishability_score(p_travel_min DECIMAL(8,1),
                                       p_minutes_left DECIMAL(10,1))
RETURNS DECIMAL(5,2)
DETERMINISTIC NO SQL
BEGIN
  DECLARE c_buffer_min DECIMAL(5,1) DEFAULT 30.0;    -- ASSUMPTION
  IF p_minutes_left IS NULL OR p_travel_min + c_buffer_min >= p_minutes_left THEN
    RETURN NULL;
  END IF;
  RETURN 100 * (1 - p_travel_min / p_minutes_left);
END$$

-- ---------------------------------------------------------------------
-- fn_fairness_score (0-100): stops one shelter from hogging donations.
--   Over the 7 days before p_as_of:
--     received_share = kg this shelter received / kg all shelters received
--     need_share     = this shelter's beneficiaries / all active shelters'
--     ratio          = received_share / need_share   (1.0 = exactly fair)
--     score          = 100 / (1 + ratio)
--   ratio 0 -> 100 (has received nothing), 1 -> 50, 3 -> 25.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_fairness_score(p_shelter_id INT UNSIGNED, p_as_of DATETIME)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
  DECLARE v_mine  DECIMAL(12,2);
  DECLARE v_total DECIMAL(12,2);
  DECLARE v_benef DECIMAL(12,2);
  DECLARE v_benef_total DECIMAL(12,2);
  DECLARE v_ratio DECIMAL(12,4);

  SELECT COALESCE(SUM(IF(c.shelter_site_id = p_shelter_id, b.quantity_kg, 0)), 0),
         COALESCE(SUM(b.quantity_kg), 0)
    INTO v_mine, v_total
    FROM claim c
    JOIN surplus_batch b ON b.batch_id = c.batch_id
   WHERE c.status IN ('ACTIVE','FULFILLED')
     AND c.claimed_at >= p_as_of - INTERVAL 7 DAY
     AND c.claimed_at <  p_as_of;

  IF v_total = 0 THEN RETURN 100; END IF;   -- nobody received anything yet

  SELECT SUM(IF(s.site_id = p_shelter_id, s.beneficiary_count, 0)),
         SUM(s.beneficiary_count)
    INTO v_benef, v_benef_total
    FROM shelter s JOIN site t ON t.site_id = s.site_id
   WHERE t.is_active;

  IF v_benef = 0 THEN RETURN 0; END IF;
  SET v_ratio = (v_mine / v_total) / (v_benef / v_benef_total);
  RETURN 100 / (1 + v_ratio);
END$$

-- ---------------------------------------------------------------------
-- fn_match_score (0-100, or NULL = not eligible) for batch x shelter at
-- time p_as_of.
--   Hard filters (any one fails -> NULL):
--     shelter inactive, diet exclusion, batch does not fit remaining
--     capacity, outside service radius, cannot arrive before expiry.
--   Otherwise: weighted average of the five component scores, with the
--   weights read from scoring_weight and normalised to sum to 1.
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_match_score(p_batch_id INT UNSIGNED,
                               p_shelter_id INT UNSIGNED,
                               p_as_of DATETIME)
RETURNS DECIMAL(5,2)
READS SQL DATA
BEGIN
  DECLARE v_qty DECIMAL(7,2);
  DECLARE v_safe_until DATETIME;
  DECLARE v_mess_loc POINT;
  DECLARE v_shelter_loc POINT;
  DECLARE v_active BOOLEAN;
  DECLARE v_km DECIMAL(8,3);
  DECLARE v_need, v_cap, v_dist, v_perish, v_fair DECIMAL(5,2);
  DECLARE w_need, w_cap, w_dist, w_perish, w_fair DECIMAL(4,3);
  DECLARE v_day DATE DEFAULT DATE(p_as_of);

  SELECT b.quantity_kg, b.safe_until, ms.location
    INTO v_qty, v_safe_until, v_mess_loc
    FROM surplus_batch b JOIN site ms ON ms.site_id = b.mess_site_id
   WHERE b.batch_id = p_batch_id;

  SELECT t.location, t.is_active INTO v_shelter_loc, v_active
    FROM shelter s JOIN site t ON t.site_id = s.site_id
   WHERE s.site_id = p_shelter_id;

  IF v_qty IS NULL OR v_shelter_loc IS NULL OR NOT v_active THEN RETURN NULL; END IF;
  IF NOT fn_is_diet_compatible(p_batch_id, p_shelter_id) THEN RETURN NULL; END IF;

  SET v_km     = fn_distance_km(v_mess_loc, v_shelter_loc);
  SET v_need   = fn_need_score(p_shelter_id, v_day);
  SET v_cap    = fn_capacity_score(p_shelter_id, v_day, v_qty);
  SET v_dist   = fn_distance_score(v_km);
  SET v_perish = fn_perishability_score(fn_travel_minutes(v_km),
                   TIMESTAMPDIFF(SECOND, p_as_of, v_safe_until) / 60);
  SET v_fair   = fn_fairness_score(p_shelter_id, p_as_of);

  IF v_cap IS NULL OR v_dist IS NULL OR v_perish IS NULL THEN RETURN NULL; END IF;

  -- policy weights (platform admin can change them; changes are audited)
  SELECT MAX(IF(weight_key='NEED',          weight_value, NULL)),
         MAX(IF(weight_key='CAPACITY',      weight_value, NULL)),
         MAX(IF(weight_key='DISTANCE',      weight_value, NULL)),
         MAX(IF(weight_key='PERISHABILITY', weight_value, NULL)),
         MAX(IF(weight_key='FAIRNESS',      weight_value, NULL))
    INTO w_need, w_cap, w_dist, w_perish, w_fair
    FROM scoring_weight;

  RETURN ( COALESCE(w_need,0)*v_need + COALESCE(w_cap,0)*v_cap
         + COALESCE(w_dist,0)*v_dist + COALESCE(w_perish,0)*v_perish
         + COALESCE(w_fair,0)*v_fair )
       / NULLIF(COALESCE(w_need,0)+COALESCE(w_cap,0)+COALESCE(w_dist,0)
               +COALESCE(w_perish,0)+COALESCE(w_fair,0), 0);
END$$

-- ---------------------------------------------------------------------
-- fn_custody_first_bad_event : verifies the SHA-256 hash chain of one
--   batch. Walks the batch's events in insertion order, recomputes each
--   row_hash from the previous hash + the row's fields, and returns the
--   event_id of the FIRST row that does not match (0 = chain intact).
--   The formula must stay identical to trg_custody_bi (05_triggers.sql).
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_custody_first_bad_event(p_batch_id INT UNSIGNED)
RETURNS BIGINT UNSIGNED
READS SQL DATA
BEGIN
  DECLARE v_done BOOLEAN DEFAULT FALSE;
  DECLARE v_id BIGINT UNSIGNED;
  DECLARE v_prev_stored, v_row_hash, v_expected CHAR(64);
  DECLARE v_prev_running CHAR(64) DEFAULT NULL;
  DECLARE v_payload TEXT;
  DECLARE cur CURSOR FOR
    SELECT event_id, prev_hash, row_hash,
           CONCAT_WS('|', batch_id, IFNULL(claim_id,'-'), IFNULL(trip_id,'-'),
                     event_type, DATE_FORMAT(event_time,'%Y-%m-%d %H:%i:%s.%f'),
                     IFNULL(actor_user_id,'-'), IFNULL(temperature_c,'-'),
                     IFNULL(hygiene_ok,'-'), IFNULL(notes,'-'))
      FROM custody_event
     WHERE batch_id = p_batch_id
     ORDER BY event_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;

  OPEN cur;
  walk: LOOP
    FETCH cur INTO v_id, v_prev_stored, v_row_hash, v_payload;
    IF v_done THEN LEAVE walk; END IF;
    SET v_expected = SHA2(CONCAT(IFNULL(v_prev_running,'GENESIS'), '|', v_payload), 256);
    -- a row is bad if its own hash is wrong OR it does not point at the
    -- real previous row (someone deleted/reordered rows)
    IF v_row_hash <> v_expected OR NOT (v_prev_stored <=> v_prev_running) THEN
      CLOSE cur;
      RETURN v_id;
    END IF;
    SET v_prev_running = v_row_hash;
  END LOOP;
  CLOSE cur;
  RETURN 0;
END$$

DELIMITER ;
