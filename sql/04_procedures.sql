-- =====================================================================
-- MealBridge : STORED PROCEDURES                        Stage 4 deliverable
-- Run after 03_functions.sql, before 05_triggers.sql.
--
-- Reading guide for the viva:
--   * Every write an end user can make goes through a procedure. The
--     MySQL roles (07_roles_grants.sql) get EXECUTE on these procedures
--     but NO direct INSERT/UPDATE on the tables behind them. Procedures
--     run with SQL SECURITY DEFINER, i.e. with the privileges of their
--     creator, so they are the only door into the data ("least
--     privilege").
--   * p_user_id is the logged-in application user, passed by the API.
--     Each procedure checks that this user has the right role and site
--     (row-level ownership), because MySQL has no row-level security.
--
--   sp_register_site    platform admin adds a mess or shelter (site + subtype
--                       in one transaction = TOTAL specialization)
--   sp_post_batch       mess admin posts surplus (+ diet tags, + alerts)
--   sp_cancel_batch     mess admin withdraws an unclaimed batch
--   sp_rank_shelters    THE MATCHING PROCEDURE: ranks shelters for a
--                       batch on need, capacity, distance, perishability
--                       and fairness, and shows why others are excluded
--   sp_claim_batch      shelter claims a batch: TRANSACTION + FOR UPDATE
--   sp_cancel_claim     shelter backs out before pickup
--   sp_create_trip      volunteer pickup batching (multi-stop trip)
--   sp_record_pickup    volunteer confirms pickup at a mess
--   sp_record_delivery  volunteer confirms drop + hygiene check
--   sp_set_availability volunteer switches availability on/off
--   sp_expire_batches   auto-expire job (called by ev_auto_expire)
--   sp_generate_forecast surplus forecast + shelter pre-alerts
-- =====================================================================
USE mealbridge;

DROP PROCEDURE IF EXISTS sp_register_site;
DROP PROCEDURE IF EXISTS sp_post_batch;
DROP PROCEDURE IF EXISTS sp_cancel_batch;
DROP PROCEDURE IF EXISTS sp_rank_shelters;
DROP PROCEDURE IF EXISTS sp_claim_batch;
DROP PROCEDURE IF EXISTS sp_cancel_claim;
DROP PROCEDURE IF EXISTS sp_create_trip;
DROP PROCEDURE IF EXISTS sp_record_pickup;
DROP PROCEDURE IF EXISTS sp_record_delivery;
DROP PROCEDURE IF EXISTS sp_set_availability;
DROP PROCEDURE IF EXISTS sp_expire_batches;
DROP PROCEDURE IF EXISTS sp_generate_forecast;

DELIMITER $$

-- ---------------------------------------------------------------------
-- sp_register_site : adds a MESS or a SHELTER.
--   SQL cannot force "every SITE row has exactly one subtype row" with a
--   constraint (a parent cannot require a child). So the only way the
--   application creates sites is this procedure, which inserts the SITE
--   row and its subtype row in ONE transaction: both or neither. That is
--   how the TOTAL part of the SITE specialization is guaranteed.
--   p_details (JSON) carries the subtype's own attributes, e.g.
--   shelter: {"shelter_type":"ORPHANAGE","registration_no":"R1",
--             "beneficiary_count":40,"has_refrigeration":true,
--             "default_capacity_kg":20}
--   mess:    {"campus_id":1,"hostel_block":"G","mess_type":"VEG",
--             "daily_capacity_meals":1000,"fssai_license_no":"10000000000099"}
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_register_site(
  IN  p_type     VARCHAR(10),
  IN  p_name     VARCHAR(150),
  IN  p_address  VARCHAR(255),
  IN  p_city     VARCHAR(80),
  IN  p_pincode  CHAR(6),
  IN  p_lat      DOUBLE,
  IN  p_lon      DOUBLE,
  IN  p_phone    VARCHAR(15),
  IN  p_details  JSON,
  OUT p_site_id  INT UNSIGNED)
SQL SECURITY DEFINER
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
  START TRANSACTION;
    INSERT INTO site (site_type, name, address_line, city, pincode, location, contact_phone)
    VALUES (p_type, p_name, p_address, p_city, p_pincode,
            ST_SRID(POINT(p_lat, p_lon), 4326), p_phone);    -- (lat, lon) for SRID 4326
    SET p_site_id = LAST_INSERT_ID();
    IF p_type = 'MESS' THEN
      INSERT INTO mess (site_id, campus_id, hostel_block, mess_type,
                        daily_capacity_meals, fssai_license_no)
      VALUES (p_site_id, p_details->>'$.campus_id', p_details->>'$.hostel_block',
              p_details->>'$.mess_type', p_details->>'$.daily_capacity_meals',
              p_details->>'$.fssai_license_no');
    ELSEIF p_type = 'SHELTER' THEN
      INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count,
                           has_refrigeration, default_capacity_kg)
      VALUES (p_site_id, p_details->>'$.shelter_type', p_details->>'$.registration_no',
              p_details->>'$.beneficiary_count',
              COALESCE(p_details->'$.has_refrigeration' = TRUE, FALSE),
              p_details->>'$.default_capacity_kg');
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'p_type must be MESS or SHELTER';
    END IF;
  COMMIT;
END$$

-- ---------------------------------------------------------------------
-- sp_post_batch : a mess admin posts a surplus batch.
--   p_diet_tags is a JSON array, e.g. '["VEG","CONTAINS_DAIRY"]'.
--   The deadline is NOT a parameter: trg_batch_bi computes it.
--   After posting, the 3 best-matching shelters get a NEW_MATCH alert.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_post_batch(
  IN  p_user_id     INT UNSIGNED,
  IN  p_category_id SMALLINT UNSIGNED,
  IN  p_meal_slot   VARCHAR(10),
  IN  p_description VARCHAR(255),
  IN  p_qty_kg      DECIMAL(7,2),
  IN  p_storage     VARCHAR(10),
  IN  p_cooked_at   DATETIME,
  IN  p_packed_at   DATETIME,
  IN  p_diet_tags   JSON,
  OUT p_batch_id    INT UNSIGNED)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_mess INT UNSIGNED;
  -- any error: undo everything this call did, then re-raise to the caller
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

  SELECT site_id INTO v_mess FROM app_user
   WHERE user_id = p_user_id AND role = 'MESS_ADMIN' AND is_active;
  IF v_mess IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only an active mess admin can post a batch';
  END IF;

  START TRANSACTION;
    INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot,
                               description, quantity_kg, storage, cooked_at,
                               packed_at, safe_until)
    VALUES (v_mess, p_category_id, p_user_id, p_meal_slot, p_description,
            p_qty_kg, p_storage, p_cooked_at, p_packed_at,
            p_cooked_at + INTERVAL 1 SECOND);   -- placeholder, overwritten by trigger
    SET p_batch_id = LAST_INSERT_ID();

    -- JSON_TABLE turns the JSON array into rows (one per tag)
    INSERT INTO batch_diet_tag (batch_id, tag_code)
    SELECT p_batch_id, jt.tag
      FROM JSON_TABLE(COALESCE(p_diet_tags, JSON_ARRAY()), '$[*]'
                      COLUMNS (tag VARCHAR(30) PATH '$')) AS jt;

    -- alert staff of the top-3 eligible shelters
    INSERT INTO notification (user_id, kind, message, batch_id)
    SELECT u.user_id, 'NEW_MATCH',
           CONCAT('New batch #', p_batch_id, ': ', p_qty_kg, ' kg, match score ', r.score),
           p_batch_id
      FROM (SELECT s.site_id, fn_match_score(p_batch_id, s.site_id, NOW()) AS score
              FROM shelter s) r
      JOIN app_user u ON u.site_id = r.site_id AND u.role = 'SHELTER' AND u.is_active
     WHERE r.score IS NOT NULL
     ORDER BY r.score DESC
     LIMIT 3;
  COMMIT;
END$$

-- ---------------------------------------------------------------------
-- sp_cancel_batch : withdraw an AVAILABLE batch (e.g. mess found a use).
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_cancel_batch(IN p_user_id INT UNSIGNED,
                                 IN p_batch_id INT UNSIGNED)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_rows INT;
  UPDATE surplus_batch b
    JOIN app_user u ON u.user_id = p_user_id AND u.role = 'MESS_ADMIN'
                   AND u.site_id = b.mess_site_id
     SET b.status = 'CANCELLED'
   WHERE b.batch_id = p_batch_id AND b.status = 'AVAILABLE';
  SET v_rows = ROW_COUNT();
  IF v_rows = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Not cancelled: batch is not yours or is no longer AVAILABLE';
  END IF;
END$$

-- ---------------------------------------------------------------------
-- sp_rank_shelters : THE MATCHING PROCEDURE.
--   For one batch, returns every shelter with
--     distance, travel estimate, minutes of safe time left,
--     the five component scores, the weighted match score,
--     and, if it is excluded, the reason.
--   Eligible shelters come first, best score first.
--   p_as_of = NULL means "now" (it exists so past decisions can be
--   replayed for the fairness audit).
--
--   Spatial pre-filter: a bounding box around the mess lets the R-tree
--   index on site.location (IDX-1) discard far-away shelters before any
--   exact distance is computed. 1 degree of latitude ~ 111 km.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_rank_shelters(IN p_batch_id INT UNSIGNED, IN p_as_of DATETIME)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_as_of DATETIME DEFAULT COALESCE(p_as_of, NOW());
  DECLARE v_lat, v_lon, v_dlat, v_dlon DOUBLE;
  DECLARE v_box GEOMETRY;
  DECLARE c_radius_km DOUBLE DEFAULT 15;     -- same ASSUMPTION as fn_distance_score

  SELECT ST_Latitude(t.location), ST_Longitude(t.location)
    INTO v_lat, v_lon
    FROM surplus_batch b JOIN site t ON t.site_id = b.mess_site_id
   WHERE b.batch_id = p_batch_id;
  IF v_lat IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unknown batch';
  END IF;

  SET v_dlat = c_radius_km / 111.0;
  SET v_dlon = c_radius_km / (111.0 * COS(RADIANS(v_lat)));
  -- SRID 4326 axis order in MySQL is (latitude longitude)
  SET v_box = ST_GeomFromText(CONCAT('POLYGON((',
        v_lat - v_dlat, ' ', v_lon - v_dlon, ',', v_lat - v_dlat, ' ', v_lon + v_dlon, ',',
        v_lat + v_dlat, ' ', v_lon + v_dlon, ',', v_lat + v_dlat, ' ', v_lon - v_dlon, ',',
        v_lat - v_dlat, ' ', v_lon - v_dlon, '))'), 4326);

  SELECT x.shelter_id, x.shelter, x.km, x.travel_min, x.min_left,
         x.need, x.capacity, x.distance, x.perish, x.fairness,
         fn_match_score(p_batch_id, x.shelter_id, v_as_of) AS match_score,
         CASE
           WHEN NOT x.diet_ok             THEN 'EXCLUDED: diet exclusion'
           WHEN x.capacity IS NULL        THEN 'EXCLUDED: not enough capacity left today'
           WHEN x.distance IS NULL        THEN 'EXCLUDED: outside service radius'
           WHEN x.perish   IS NULL        THEN 'EXCLUDED: cannot arrive before safe-until'
           ELSE 'ELIGIBLE'
         END AS verdict
    FROM (
      SELECT s.site_id AS shelter_id, t.name AS shelter,
             ROUND(fn_distance_km(ms.location, t.location), 2)            AS km,
             ROUND(fn_travel_minutes(fn_distance_km(ms.location, t.location)))  AS travel_min,
             TIMESTAMPDIFF(MINUTE, v_as_of, b.safe_until)                 AS min_left,
             fn_is_diet_compatible(b.batch_id, s.site_id)                 AS diet_ok,
             ROUND(fn_need_score(s.site_id, DATE(v_as_of)), 1)            AS need,
             ROUND(fn_capacity_score(s.site_id, DATE(v_as_of), b.quantity_kg), 1) AS capacity,
             ROUND(fn_distance_score(fn_distance_km(ms.location, t.location)), 1) AS distance,
             ROUND(fn_perishability_score(
                     fn_travel_minutes(fn_distance_km(ms.location, t.location)),
                     TIMESTAMPDIFF(SECOND, v_as_of, b.safe_until) / 60), 1) AS perish,
             ROUND(fn_fairness_score(s.site_id, v_as_of), 1)              AS fairness
        FROM surplus_batch b
        JOIN site ms ON ms.site_id = b.mess_site_id
        JOIN shelter s
        JOIN site t  ON t.site_id = s.site_id
       WHERE b.batch_id = p_batch_id
         AND t.is_active
         AND MBRContains(v_box, t.location)          -- uses SPATIAL index IDX-1
    ) x
   ORDER BY (match_score IS NULL), match_score DESC, x.km;
END$$

-- ---------------------------------------------------------------------
-- sp_claim_batch : CONCURRENCY-SAFE CLAIM (double-claim guard, layer 1)
--
--  1. START TRANSACTION.
--  2. SELECT ... FOR UPDATE on the batch row: takes an exclusive row lock.
--     A second session running the same statement on the same batch
--     BLOCKS here until the first one commits or rolls back.
--  3. When it unblocks, a locking read always returns the LATEST
--     COMMITTED row (not the transaction's old snapshot), so the second
--     session sees status = 'CLAIMED' and is rejected cleanly.
--  4. Score is computed and snapshotted into the claim row; the claim
--     triggers then update capacity, batch status and custody.
--  5. COMMIT releases the lock.
--  Layer 2 is the UNIQUE index on claim.active_batch_id, which stops a
--  second live claim even if some code skipped this procedure.
--
--  @demo_hold_seconds (session variable, default 0) makes the procedure
--  sleep WHILE HOLDING THE LOCK, only so the race demo is visible to a
--  human. The API never sets it.
--
--  Result: p_result = 'CLAIMED' or 'REJECTED: <reason>' (never an
--  unhandled error, so the API can show a friendly message).
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_claim_batch(
  IN  p_user_id  INT UNSIGNED,
  IN  p_batch_id INT UNSIGNED,
  OUT p_claim_id INT UNSIGNED,
  OUT p_result   VARCHAR(255))
SQL SECURITY DEFINER
proc: BEGIN
  DECLARE v_shelter    INT UNSIGNED;
  DECLARE v_status     VARCHAR(12);
  DECLARE v_safe_until DATETIME;
  DECLARE v_score      DECIMAL(5,2);
  DECLARE v_km         DECIMAL(8,3);
  DECLARE v_msg        VARCHAR(255);

  -- Any SQL error (CHECK on capacity, UNIQUE on active_batch_id, a lock
  -- wait timeout, a deadlock...) -> roll back and report it.
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
    ROLLBACK;
    SET p_claim_id = NULL, p_result = CONCAT('REJECTED: ', v_msg);
  END;

  SET p_claim_id = NULL;

  -- who is claiming? (row-level ownership: the user's own shelter)
  SELECT site_id INTO v_shelter FROM app_user
   WHERE user_id = p_user_id AND role = 'SHELTER' AND is_active;
  IF v_shelter IS NULL THEN
    SET p_result = 'REJECTED: only active shelter staff can claim';
    LEAVE proc;
  END IF;

  START TRANSACTION;

    -- (2) the row lock
    SELECT status, safe_until INTO v_status, v_safe_until
      FROM surplus_batch
     WHERE batch_id = p_batch_id
       FOR UPDATE;

    DO SLEEP(COALESCE(@demo_hold_seconds, 0));   -- demo only, see header

    -- (3) re-check under the lock
    IF v_status IS NULL THEN
      ROLLBACK; SET p_result = 'REJECTED: no such batch'; LEAVE proc;
    END IF;
    IF v_status <> 'AVAILABLE' THEN
      ROLLBACK;
      SET p_result = CONCAT('REJECTED: batch already ', v_status, ' by another shelter');
      LEAVE proc;
    END IF;
    IF v_safe_until <= NOW() THEN
      ROLLBACK; SET p_result = 'REJECTED: batch has expired'; LEAVE proc;
    END IF;

    -- (4) eligibility + score snapshot
    SET v_score = fn_match_score(p_batch_id, v_shelter, NOW());
    IF v_score IS NULL THEN
      ROLLBACK;
      SET p_result = 'REJECTED: not eligible (diet, capacity, distance or time)';
      LEAVE proc;
    END IF;
    SELECT fn_distance_km(ms.location, ss.location) INTO v_km
      FROM surplus_batch b
      JOIN site ms ON ms.site_id = b.mess_site_id
      JOIN site ss ON ss.site_id = v_shelter
     WHERE b.batch_id = p_batch_id;

    INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
    VALUES (p_batch_id, v_shelter, p_user_id, v_score, v_km);
    SET p_claim_id = LAST_INSERT_ID();

  COMMIT;                                         -- (5) releases the lock
  SET p_result = 'CLAIMED';
END$$

-- ---------------------------------------------------------------------
-- sp_cancel_claim : shelter backs out before pickup. The claim AU
-- trigger releases capacity and re-offers the batch if still safe.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_cancel_claim(IN p_user_id INT UNSIGNED,
                                 IN p_claim_id INT UNSIGNED,
                                 IN p_reason VARCHAR(255))
SQL SECURITY DEFINER
BEGIN
  UPDATE claim c
    JOIN app_user u ON u.user_id = p_user_id AND u.role = 'SHELTER'
                   AND u.site_id = c.shelter_site_id
     SET c.status = 'CANCELLED', c.close_reason = p_reason
   WHERE c.claim_id = p_claim_id AND c.status = 'ACTIVE';
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not cancelled: claim is not yours or not ACTIVE';
  END IF;
END$$

-- ---------------------------------------------------------------------
-- sp_create_trip : VOLUNTEER PICKUP BATCHING.
--   One trip for several claims (several messes -> several shelters).
--   Stop order is a simple, explainable heuristic, not an optimal route:
--     1. all pickups first, nearest mess to the volunteer's home first;
--     2. then all drops, nearest shelter to the last pickup first.
--   Pickups-before-drops guarantees chk_item_order (pickup_seq < drop_seq).
--   planned_eta is a running total of leg travel times, computed with
--   LAG() and SUM() OVER () window functions. A route on which any batch
--   would arrive after its safe-until time is refused.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_create_trip(
  IN  p_user_id       INT UNSIGNED,
  IN  p_claim_ids     JSON,
  IN  p_planned_start DATETIME,
  OUT p_trip_id       INT UNSIGNED)
SQL SECURITY DEFINER
BEGIN
  DECLARE v_home POINT;
  DECLARE v_max_load, v_load DECIMAL(9,2);
  DECLARE v_n_claims, v_n_ok INT;
  DECLARE v_last_pickup POINT;
  DECLARE v_n_pickups INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    DROP TEMPORARY TABLE IF EXISTS tmp_trip_claims, tmp_trip_stops;
    RESIGNAL;
  END;

  SELECT v.home_location, v.max_load_kg INTO v_home, v_max_load
    FROM volunteer v JOIN app_user u ON u.user_id = v.user_id
   WHERE v.user_id = p_user_id AND u.is_active AND v.is_available
     AND v.verified_at IS NOT NULL;
  IF v_home IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Only an available, ID-verified volunteer can take a trip';
  END IF;

  DROP TEMPORARY TABLE IF EXISTS tmp_trip_claims, tmp_trip_stops;
  CREATE TEMPORARY TABLE tmp_trip_claims (
    claim_id INT UNSIGNED PRIMARY KEY,
    mess_id INT UNSIGNED, shelter_id INT UNSIGNED, qty DECIMAL(7,2));

  INSERT INTO tmp_trip_claims
  SELECT c.claim_id, b.mess_site_id, c.shelter_site_id, b.quantity_kg
    FROM JSON_TABLE(p_claim_ids, '$[*]' COLUMNS (id INT UNSIGNED PATH '$')) j
    JOIN claim c         ON c.claim_id = j.id AND c.status = 'ACTIVE'
    JOIN surplus_batch b ON b.batch_id = c.batch_id AND b.status = 'CLAIMED'
                        AND b.safe_until > p_planned_start      -- food still safe at start
   WHERE NOT EXISTS (SELECT 1 FROM trip_item ti
                       JOIN pickup_trip pt ON pt.trip_id = ti.trip_id
                      WHERE ti.claim_id = c.claim_id
                        AND pt.status IN ('PLANNED','IN_PROGRESS'));

  SELECT JSON_LENGTH(p_claim_ids), COUNT(*), COALESCE(SUM(qty), 0)
    INTO v_n_claims, v_n_ok, v_load FROM tmp_trip_claims;
  IF v_n_ok = 0 OR v_n_ok <> v_n_claims THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Every claim must be ACTIVE, still safe, waiting for pickup and not on another trip';
  END IF;
  IF v_load > v_max_load THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Total load exceeds the volunteer''s max_load_kg';
  END IF;

  -- pickups ordered from home; remember where the last pickup is
  CREATE TEMPORARY TABLE tmp_trip_stops (
    seq TINYINT UNSIGNED PRIMARY KEY, site_id INT UNSIGNED, stop_type VARCHAR(6));
  INSERT INTO tmp_trip_stops
  SELECT ROW_NUMBER() OVER (ORDER BY fn_distance_km(v_home, t.location)),
         t.site_id, 'PICKUP'
    FROM (SELECT DISTINCT mess_id FROM tmp_trip_claims) m
    JOIN site t ON t.site_id = m.mess_id;

  SELECT t.location INTO v_last_pickup
    FROM tmp_trip_stops s JOIN site t ON t.site_id = s.site_id
   ORDER BY s.seq DESC LIMIT 1;
  -- (a MySQL TEMPORARY table cannot be opened twice in one statement,
  --  so the number of pickups is read into a variable first)
  SELECT COUNT(*) INTO v_n_pickups FROM tmp_trip_stops;

  INSERT INTO tmp_trip_stops
  SELECT v_n_pickups
           + ROW_NUMBER() OVER (ORDER BY fn_distance_km(v_last_pickup, t.location)),
         t.site_id, 'DROP'
    FROM (SELECT DISTINCT shelter_id FROM tmp_trip_claims) sh
    JOIN site t ON t.site_id = sh.shelter_id;

  START TRANSACTION;
    INSERT INTO pickup_trip (volunteer_id, status, planned_start)
    VALUES (p_user_id, 'PLANNED', p_planned_start);
    SET p_trip_id = LAST_INSERT_ID();

    -- ETA per stop = start + running sum of leg travel times
    INSERT INTO trip_stop (trip_id, stop_seq, site_id, stop_type, planned_eta)
    SELECT p_trip_id, seq, site_id, stop_type,
           p_planned_start + INTERVAL ROUND(SUM(leg_min) OVER (ORDER BY seq)) MINUTE
      FROM (SELECT s.seq, s.site_id, s.stop_type,
                   fn_travel_minutes(fn_distance_km(
                       COALESCE(LAG(t.location) OVER (ORDER BY s.seq), v_home),
                       t.location)) AS leg_min
              FROM tmp_trip_stops s JOIN site t ON t.site_id = s.site_id) legs;

    UPDATE pickup_trip pt
       SET planned_distance_km = (
             SELECT ROUND(SUM(fn_distance_km(COALESCE(prev_loc, v_home), loc)), 2)
               FROM (SELECT t.location AS loc,
                            LAG(t.location) OVER (ORDER BY s.seq) AS prev_loc
                       FROM tmp_trip_stops s JOIN site t ON t.site_id = s.site_id) d)
     WHERE pt.trip_id = p_trip_id;

    -- PERISHABILITY CHECK for the whole route: every batch must reach its
    -- shelter before its safe-until time, otherwise the trip is refused
    -- (the volunteer app then plans smaller trips).
    IF EXISTS (SELECT 1
                 FROM tmp_trip_claims c
                 JOIN trip_stop sd     ON sd.trip_id = p_trip_id AND sd.site_id = c.shelter_id
                                      AND sd.stop_type = 'DROP'
                 JOIN claim cl         ON cl.claim_id = c.claim_id
                 JOIN surplus_batch b  ON b.batch_id = cl.batch_id
                WHERE sd.planned_eta >= b.safe_until) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Route too long: a batch would arrive after its safe-until time';
    END IF;

    -- joins the real trip_stop table twice (pickup side and drop side)
    INSERT INTO trip_item (trip_id, claim_id, pickup_seq, drop_seq)
    SELECT p_trip_id, c.claim_id, sp.stop_seq, sd.stop_seq
      FROM tmp_trip_claims c
      JOIN trip_stop sp ON sp.trip_id = p_trip_id AND sp.site_id = c.mess_id    AND sp.stop_type = 'PICKUP'
      JOIN trip_stop sd ON sd.trip_id = p_trip_id AND sd.site_id = c.shelter_id AND sd.stop_type = 'DROP';

    INSERT INTO notification (user_id, kind, message)
    VALUES (p_user_id, 'TRIP_ASSIGNED',
            CONCAT('Trip #', p_trip_id, ': ', v_n_ok, ' claim(s), ', v_load, ' kg'));
  COMMIT;

  DROP TEMPORARY TABLE IF EXISTS tmp_trip_claims, tmp_trip_stops;
END$$

-- ---------------------------------------------------------------------
-- sp_record_pickup : volunteer is at a PICKUP stop and loads the food.
--   Writes PICKED_UP custody events (with food temperature) and moves
--   every batch picked up here to IN_TRANSIT.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_record_pickup(IN p_user_id INT UNSIGNED,
                                  IN p_trip_id INT UNSIGNED,
                                  IN p_stop_seq TINYINT UNSIGNED,
                                  IN p_temperature_c DECIMAL(4,1))
SQL SECURITY DEFINER
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

  IF NOT EXISTS (SELECT 1 FROM pickup_trip pt JOIN trip_stop ts ON ts.trip_id = pt.trip_id
                  WHERE pt.trip_id = p_trip_id AND pt.volunteer_id = p_user_id
                    AND pt.status IN ('PLANNED','IN_PROGRESS')
                    AND ts.stop_seq = p_stop_seq AND ts.stop_type = 'PICKUP'
                    AND ts.departed_at IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not your open pickup stop';
  END IF;

  START TRANSACTION;
    UPDATE pickup_trip SET status = 'IN_PROGRESS', started_at = COALESCE(started_at, NOW())
     WHERE trip_id = p_trip_id;
    UPDATE trip_stop SET arrived_at = COALESCE(arrived_at, NOW()), departed_at = NOW()
     WHERE trip_id = p_trip_id AND stop_seq = p_stop_seq;

    INSERT INTO custody_event (batch_id, claim_id, trip_id, event_type, actor_user_id, temperature_c)
    SELECT c.batch_id, c.claim_id, p_trip_id, 'PICKED_UP', p_user_id, p_temperature_c
      FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id
     WHERE ti.trip_id = p_trip_id AND ti.pickup_seq = p_stop_seq AND c.status = 'ACTIVE';

    UPDATE surplus_batch b
      JOIN claim c      ON c.batch_id = b.batch_id AND c.status = 'ACTIVE'
      JOIN trip_item ti ON ti.claim_id = c.claim_id
       SET b.status = 'IN_TRANSIT'
     WHERE ti.trip_id = p_trip_id AND ti.pickup_seq = p_stop_seq;
  COMMIT;
END$$

-- ---------------------------------------------------------------------
-- sp_record_delivery : volunteer is at a DROP stop. The shelter's
--   hygiene check result decides the outcome for every claim dropped
--   here: pass -> DELIVERED / FULFILLED, fail -> REJECTED.
--   When the last stop is done, the trip is COMPLETED.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_record_delivery(IN p_user_id INT UNSIGNED,
                                    IN p_trip_id INT UNSIGNED,
                                    IN p_stop_seq TINYINT UNSIGNED,
                                    IN p_temperature_c DECIMAL(4,1),
                                    IN p_hygiene_ok BOOLEAN,
                                    IN p_notes VARCHAR(255))
SQL SECURITY DEFINER
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

  IF NOT EXISTS (SELECT 1 FROM pickup_trip pt JOIN trip_stop ts ON ts.trip_id = pt.trip_id
                  WHERE pt.trip_id = p_trip_id AND pt.volunteer_id = p_user_id
                    AND pt.status = 'IN_PROGRESS'
                    AND ts.stop_seq = p_stop_seq AND ts.stop_type = 'DROP'
                    AND ts.departed_at IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not your open drop stop';
  END IF;

  START TRANSACTION;
    UPDATE trip_stop SET arrived_at = COALESCE(arrived_at, NOW()), departed_at = NOW()
     WHERE trip_id = p_trip_id AND stop_seq = p_stop_seq;

    INSERT INTO custody_event (batch_id, claim_id, trip_id, event_type, actor_user_id,
                               temperature_c, hygiene_ok, notes)
    SELECT c.batch_id, c.claim_id, p_trip_id, 'HYGIENE_CHECK', p_user_id,
           p_temperature_c, p_hygiene_ok, p_notes
      FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id
     WHERE ti.trip_id = p_trip_id AND ti.drop_seq = p_stop_seq AND c.status = 'ACTIVE';

    IF p_hygiene_ok THEN
      INSERT INTO custody_event (batch_id, claim_id, trip_id, event_type, actor_user_id)
      SELECT c.batch_id, c.claim_id, p_trip_id, 'DELIVERED', p_user_id
        FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id
       WHERE ti.trip_id = p_trip_id AND ti.drop_seq = p_stop_seq AND c.status = 'ACTIVE';
    END IF;

    -- claim AU trigger turns these into DELIVERED / CANCELLED batches
    UPDATE claim c JOIN trip_item ti ON ti.claim_id = c.claim_id
       SET c.status = IF(p_hygiene_ok, 'FULFILLED', 'REJECTED'),
           c.close_reason = IF(p_hygiene_ok, NULL, COALESCE(p_notes, 'failed hygiene check'))
     WHERE ti.trip_id = p_trip_id AND ti.drop_seq = p_stop_seq AND c.status = 'ACTIVE';

    UPDATE pickup_trip
       SET status = 'COMPLETED', completed_at = NOW()
     WHERE trip_id = p_trip_id
       AND NOT EXISTS (SELECT 1 FROM trip_stop
                        WHERE trip_id = p_trip_id AND departed_at IS NULL);
  COMMIT;
END$$

-- ---------------------------------------------------------------------
-- sp_set_availability : a volunteer goes on / off duty. Exists so the
-- volunteer role needs no direct UPDATE on the volunteer table (which
-- would let one volunteer change another's row).
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_set_availability(IN p_user_id INT UNSIGNED, IN p_available BOOLEAN)
SQL SECURITY DEFINER
BEGIN
  UPDATE volunteer SET is_available = p_available WHERE user_id = p_user_id;
  IF ROW_COUNT() = 0 AND NOT EXISTS (SELECT 1 FROM volunteer WHERE user_id = p_user_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not a volunteer';
  END IF;
END$$

-- ---------------------------------------------------------------------
-- sp_expire_batches : the AUTO-EXPIRE job (run every 5 min by
--   ev_auto_expire, and once at the end of the seed).
--   1. Live claims whose food expired before pickup are cancelled
--      (trigger releases capacity and marks the batch EXPIRED).
--   2. Remaining AVAILABLE batches past safe_until become EXPIRED
--      (trigger writes the EXPIRED custody event).
--   Step 1 first copies ids into a temporary table: a trigger cannot
--   update surplus_batch while the outer UPDATE statement is reading it
--   (MySQL error 1442), so the outer statement must not read it.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_expire_batches()
SQL SECURITY DEFINER
BEGIN
  DECLARE v_now DATETIME(3) DEFAULT NOW(3);

  DROP TEMPORARY TABLE IF EXISTS tmp_expired_claims;
  CREATE TEMPORARY TABLE tmp_expired_claims (claim_id INT UNSIGNED PRIMARY KEY)
  SELECT c.claim_id
    FROM claim c JOIN surplus_batch b ON b.batch_id = c.batch_id
   WHERE c.status = 'ACTIVE' AND b.status = 'CLAIMED' AND b.safe_until <= v_now;

  UPDATE claim c JOIN tmp_expired_claims x ON x.claim_id = c.claim_id
     SET c.status = 'CANCELLED', c.closed_at = v_now,
         c.close_reason = 'food expired before pickup';

  UPDATE surplus_batch
     SET status = 'EXPIRED'
   WHERE status = 'AVAILABLE' AND safe_until <= v_now;   -- range scan on IDX-4

  DROP TEMPORARY TABLE IF EXISTS tmp_expired_claims;
END$$

-- ---------------------------------------------------------------------
-- sp_generate_forecast : SURPLUS FORECAST + PRE-ALERTS.
--   Method WEEKDAY_MA_4W: for each mess and meal slot, the predicted
--   leftover on p_date is the average leftover on the same weekday in
--   the previous 4 weeks (weekly rhythm of hostel attendance).
--   Simple, explainable, and its accuracy can be measured later by
--   comparing surplus_forecast with mess_meal_log.
--   If p_notify is TRUE, shelters get a FORECAST_PREALERT when a
--   mess/slot is predicted to have >= 10 kg left over. (FALSE is used to
--   back-fill forecasts for past days, to measure forecast accuracy.)
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_generate_forecast(IN p_date DATE, IN p_notify BOOLEAN)
SQL SECURITY DEFINER
BEGIN
  DECLARE c_alert_kg DECIMAL(7,2) DEFAULT 10.00;   -- ASSUMPTION

  INSERT INTO surplus_forecast (mess_site_id, forecast_date, meal_slot, method, predicted_kg)
  SELECT l.mess_site_id, p_date, l.meal_slot, 'WEEKDAY_MA_4W', ROUND(AVG(l.leftover_kg), 2)
    FROM mess_meal_log l
   WHERE l.service_date IN (p_date - INTERVAL 7 DAY,  p_date - INTERVAL 14 DAY,
                            p_date - INTERVAL 21 DAY, p_date - INTERVAL 28 DAY)
     AND l.leftover_kg IS NOT NULL
   GROUP BY l.mess_site_id, l.meal_slot
  ON DUPLICATE KEY UPDATE predicted_kg = VALUES(predicted_kg), generated_at = NOW();

  INSERT INTO notification (user_id, kind, message)
  SELECT u.user_id, 'FORECAST_PREALERT',
         CONCAT('Forecast for ', p_date, ': about ', ROUND(f.total_kg), ' kg surplus expected, peak ',
                f.peak_kg, ' kg at ', f.peak_mess, ' (', f.peak_slot, ')')
    FROM (SELECT SUM(sf.predicted_kg) AS total_kg,
                 MAX(sf.predicted_kg) AS peak_kg,
                 SUBSTRING_INDEX(GROUP_CONCAT(t.name ORDER BY sf.predicted_kg DESC SEPARATOR '#'), '#', 1) AS peak_mess,
                 SUBSTRING_INDEX(GROUP_CONCAT(sf.meal_slot ORDER BY sf.predicted_kg DESC), ',', 1) AS peak_slot
            FROM surplus_forecast sf JOIN site t ON t.site_id = sf.mess_site_id
           WHERE sf.forecast_date = p_date AND sf.method = 'WEEKDAY_MA_4W'
             AND sf.predicted_kg >= c_alert_kg) f
    JOIN app_user u ON u.role = 'SHELTER' AND u.is_active
   WHERE f.total_kg IS NOT NULL AND p_notify;
END$$

DELIMITER ;
