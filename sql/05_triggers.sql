-- =====================================================================
-- MealBridge : TRIGGERS and the auto-expire EVENT        Stage 4 deliverable
-- Run after 04_procedures.sql (the EVENT calls sp_expire_batches).
--
-- Reading guide for the viva. Each trigger enforces a rule that a CHECK
-- constraint cannot, because the rule looks at ANOTHER table or at the
-- OLD value of a row:
--
--   app_user        BI/BU  role must match site type (rule R10)
--   surplus_batch   BI     perishability clock: safe_until snapshot (R9)
--                   AI     custody chain COOKED/PACKED/POSTED + audit
--                   BU     legal status transitions, deadline is frozen
--                   AU     audit + custody EXPIRED / CANCELLED
--   claim           BI     batch must be AVAILABLE, unexpired, diet-safe
--                   AI     CAPACITY UPDATE (shelter_day.reserved_kg),
--                          batch -> CLAIMED, custody CLAIMED, audit
--                   BU     legal claim transitions
--                   AU     release capacity on cancel/reject, batch status
--   custody_event   BI     SHA-256 hash chain (tamper evidence, R8)
--                   BU/BD  append-only: no UPDATE, no DELETE, not even root
--   trip_item       BI     pickup stop = batch's mess, drop = claimant (R10)
--   batch_diet_tag  AD     audit of deleted tags
--   scoring_weight  AU     audit of policy changes
--   food_category   AU     audit of safe-hour / factor changes
--
--   EVENT ev_auto_expire (every 5 minutes) calls sp_expire_batches().
--   A trigger cannot fire "when the clock passes safe_until"; triggers
--   only fire on INSERT/UPDATE/DELETE. So the EVENT is the timer and
--   the batch AU trigger reacts to the status change. Between two runs
--   of the event, trg_claim_bi still refuses expired food and the live
--   feed view hides it, so expired food is never offered (R9).
--
-- Note on audit_log.db_user: inside a trigger CURRENT_USER() returns the
-- trigger's DEFINER, not the person connected. USER() returns the real
-- session login, so the triggers write USER() explicitly.
-- =====================================================================
USE mealbridge;
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;  -- also when run on its own; see 01_schema.sql

DROP TRIGGER IF EXISTS trg_user_bi;
DROP TRIGGER IF EXISTS trg_user_bu;
DROP TRIGGER IF EXISTS trg_user_au;
DROP TRIGGER IF EXISTS trg_batch_bi;
DROP TRIGGER IF EXISTS trg_batch_ai;
DROP TRIGGER IF EXISTS trg_batch_bu;
DROP TRIGGER IF EXISTS trg_batch_au;
DROP TRIGGER IF EXISTS trg_claim_bi;
DROP TRIGGER IF EXISTS trg_claim_ai;
DROP TRIGGER IF EXISTS trg_claim_bu;
DROP TRIGGER IF EXISTS trg_claim_au;
DROP TRIGGER IF EXISTS trg_custody_bi;
DROP TRIGGER IF EXISTS trg_custody_bu;
DROP TRIGGER IF EXISTS trg_custody_bd;
DROP TRIGGER IF EXISTS trg_trip_item_bi;
DROP TRIGGER IF EXISTS trg_bdt_ad;
DROP TRIGGER IF EXISTS trg_weight_au;
DROP TRIGGER IF EXISTS trg_category_au;
DROP EVENT   IF EXISTS ev_auto_expire;

DELIMITER $$

-- =====================================================================
-- APP_USER : a MESS_ADMIN must point at a MESS site, a SHELTER user at a
-- SHELTER site. (The CHECK in the table only knows whether site_id is
-- NULL; the site's type lives in another table.)
-- =====================================================================
CREATE TRIGGER trg_user_bi BEFORE INSERT ON app_user FOR EACH ROW
BEGIN
  IF NEW.role = 'MESS_ADMIN'
     AND NOT EXISTS (SELECT 1 FROM mess WHERE site_id = NEW.site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R10: a MESS_ADMIN must belong to a MESS site';
  END IF;
  IF NEW.role = 'SHELTER'
     AND NOT EXISTS (SELECT 1 FROM shelter WHERE site_id = NEW.site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R10: a SHELTER user must belong to a SHELTER site';
  END IF;
END$$

CREATE TRIGGER trg_user_bu BEFORE UPDATE ON app_user FOR EACH ROW
BEGIN
  IF NEW.role = 'MESS_ADMIN'
     AND NOT EXISTS (SELECT 1 FROM mess WHERE site_id = NEW.site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R10: a MESS_ADMIN must belong to a MESS site';
  END IF;
  IF NEW.role = 'SHELTER'
     AND NOT EXISTS (SELECT 1 FROM shelter WHERE site_id = NEW.site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R10: a SHELTER user must belong to a SHELTER site';
  END IF;
END$$

-- Audit role / activation changes. The password hash is deliberately
-- NOT copied into the audit log.
CREATE TRIGGER trg_user_au AFTER UPDATE ON app_user FOR EACH ROW
BEGIN
  IF NOT (OLD.role <=> NEW.role) OR NOT (OLD.site_id <=> NEW.site_id)
     OR NOT (OLD.is_active <=> NEW.is_active) THEN
    INSERT INTO audit_log (table_name, row_pk, action, db_user, old_values, new_values)
    VALUES ('app_user', NEW.user_id, 'UPDATE', USER(),
            JSON_OBJECT('role', OLD.role, 'site_id', OLD.site_id, 'is_active', OLD.is_active),
            JSON_OBJECT('role', NEW.role, 'site_id', NEW.site_id, 'is_active', NEW.is_active));
  END IF;
END$$

-- =====================================================================
-- SURPLUS_BATCH
-- =====================================================================

-- BI : the perishability clock. Whatever safe_until the client sent is
-- overwritten, so no client can extend a deadline. Also: the poster must
-- be a MESS_ADMIN of THIS mess.
CREATE TRIGGER trg_batch_bi BEFORE INSERT ON surplus_batch FOR EACH ROW
BEGIN
  IF NOT EXISTS (SELECT 1 FROM app_user
                  WHERE user_id = NEW.posted_by AND is_active
                    AND ( (role = 'MESS_ADMIN' AND site_id = NEW.mess_site_id)
                       OR  role = 'PLATFORM_ADMIN')) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Batch must be posted by an active admin of this mess';
  END IF;
  SET NEW.created_at = COALESCE(NEW.created_at, NOW());
  SET NEW.safe_until = fn_safe_until(NEW.category_id, NEW.storage, NEW.cooked_at);
  IF NEW.safe_until <= NEW.created_at THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'R9: food is already past its safe-until time, it cannot be posted';
  END IF;
  SET NEW.status = 'AVAILABLE';            -- every batch starts life available
END$$

-- AI : start the chain of custody and write the audit row.
CREATE TRIGGER trg_batch_ai AFTER INSERT ON surplus_batch FOR EACH ROW
BEGIN
  INSERT INTO custody_event (batch_id, event_type, event_time, actor_user_id, notes)
  VALUES (NEW.batch_id, 'COOKED', NEW.cooked_at, NEW.posted_by, NULL);
  IF NEW.packed_at IS NOT NULL THEN
    INSERT INTO custody_event (batch_id, event_type, event_time, actor_user_id, notes)
    VALUES (NEW.batch_id, 'PACKED', NEW.packed_at, NEW.posted_by, NULL);
  END IF;
  INSERT INTO custody_event (batch_id, event_type, event_time, actor_user_id, notes)
  VALUES (NEW.batch_id, 'POSTED', NEW.created_at, NEW.posted_by,
          CONCAT(NEW.quantity_kg, ' kg, safe until ', NEW.safe_until));

  INSERT INTO audit_log (table_name, row_pk, action, db_user, changed_at, new_values)
  VALUES ('surplus_batch', NEW.batch_id, 'INSERT', USER(), NEW.created_at,
          JSON_OBJECT('mess', NEW.mess_site_id, 'category', NEW.category_id,
                      'qty_kg', NEW.quantity_kg, 'storage', NEW.storage,
                      'safe_until', NEW.safe_until, 'status', NEW.status));
END$$

-- BU : state machine of a batch + frozen fields.
--   AVAILABLE  -> CLAIMED | EXPIRED | CANCELLED
--   CLAIMED    -> AVAILABLE (claim cancelled) | IN_TRANSIT | EXPIRED | CANCELLED
--   IN_TRANSIT -> DELIVERED | CANCELLED (rejected at the door)
--   DELIVERED, EXPIRED, CANCELLED are final.
CREATE TRIGGER trg_batch_bu BEFORE UPDATE ON surplus_batch FOR EACH ROW
BEGIN
  IF NOT (NEW.safe_until <=> OLD.safe_until) OR NOT (NEW.cooked_at <=> OLD.cooked_at)
     OR NOT (NEW.category_id <=> OLD.category_id) OR NOT (NEW.storage <=> OLD.storage) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Deadline inputs (cooked_at, category, storage, safe_until) are frozen once posted';
  END IF;
  IF NEW.quantity_kg <> OLD.quantity_kg AND OLD.status <> 'AVAILABLE' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity cannot change after the batch is claimed';
  END IF;
  IF NEW.status <> OLD.status AND NOT (
       (OLD.status = 'AVAILABLE'  AND NEW.status IN ('CLAIMED','EXPIRED','CANCELLED'))
    OR (OLD.status = 'CLAIMED'    AND NEW.status IN ('AVAILABLE','IN_TRANSIT','EXPIRED','CANCELLED'))
    OR (OLD.status = 'IN_TRANSIT' AND NEW.status IN ('DELIVERED','CANCELLED'))) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Illegal batch status transition';
  END IF;
END$$

-- AU : audit every change; status changes that end a batch's life are
-- also written to the chain of custody.
CREATE TRIGGER trg_batch_au AFTER UPDATE ON surplus_batch FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, row_pk, action, db_user, old_values, new_values)
  VALUES ('surplus_batch', NEW.batch_id, 'UPDATE', USER(),
          JSON_OBJECT('status', OLD.status, 'qty_kg', OLD.quantity_kg, 'description', OLD.description),
          JSON_OBJECT('status', NEW.status, 'qty_kg', NEW.quantity_kg, 'description', NEW.description));

  IF NEW.status = 'EXPIRED' AND OLD.status <> 'EXPIRED' THEN
    -- event time = the real deadline, not the moment the job noticed it
    INSERT INTO custody_event (batch_id, event_type, event_time, notes)
    VALUES (NEW.batch_id, 'EXPIRED', NEW.safe_until, 'auto-expired: safe-until time passed');
  ELSEIF NEW.status = 'CANCELLED' AND OLD.status = 'AVAILABLE' THEN
    INSERT INTO custody_event (batch_id, event_type, notes)
    VALUES (NEW.batch_id, 'CANCELLED', 'withdrawn by mess');
  END IF;
END$$

-- =====================================================================
-- CLAIM
-- =====================================================================

-- BI : the claim must make sense against the batch and the shelter.
-- (Concurrency is handled by the FOR UPDATE lock in sp_claim_batch and
-- by the UNIQUE index on active_batch_id; this trigger checks business
-- validity.)
CREATE TRIGGER trg_claim_bi BEFORE INSERT ON claim FOR EACH ROW
BEGIN
  DECLARE v_status VARCHAR(12);
  DECLARE v_safe_until DATETIME;

  SET NEW.claimed_at = COALESCE(NEW.claimed_at, NOW(3));

  SELECT status, safe_until INTO v_status, v_safe_until
    FROM surplus_batch WHERE batch_id = NEW.batch_id;

  IF v_status <> 'AVAILABLE' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R5: batch is not AVAILABLE (already claimed or closed)';
  END IF;
  IF NEW.claimed_at >= v_safe_until THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R9: batch has passed its safe-until time';
  END IF;
  IF NOT fn_is_diet_compatible(NEW.batch_id, NEW.shelter_site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Batch contains an item this shelter excludes';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM app_user
                  WHERE user_id = NEW.claimed_by AND is_active
                    AND ( (role = 'SHELTER' AND site_id = NEW.shelter_site_id)
                       OR  role = 'PLATFORM_ADMIN')) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Claim must be made by staff of the claiming shelter';
  END IF;
  -- a new claim is always live; it can only be closed by an UPDATE
  SET NEW.status = 'ACTIVE', NEW.closed_at = NULL, NEW.close_reason = NULL;
END$$

-- AI : CAPACITY UPDATE. Adds the batch's kg to the shelter's reserved_kg
-- for the claim's day (creating the day row from the shelter's defaults
-- if it does not exist). If this would exceed capacity_kg, the CHECK
-- chk_sd_reserved fails, and MySQL rolls back the WHOLE statement,
-- including the claim row itself. So over-allocation is impossible.
CREATE TRIGGER trg_claim_ai AFTER INSERT ON claim FOR EACH ROW
BEGIN
  DECLARE v_qty DECIMAL(7,2);
  SELECT quantity_kg INTO v_qty FROM surplus_batch WHERE batch_id = NEW.batch_id;

  -- UPDATE first, INSERT only if the day row is missing. (INSERT ... ON
  -- DUPLICATE KEY UPDATE would not work: MySQL checks the CHECK
  -- constraint on the row it TRIES to insert, with default capacity,
  -- before it notices the duplicate key and switches to the update.)
  UPDATE shelter_day
     SET reserved_kg = reserved_kg + v_qty
   WHERE shelter_site_id = NEW.shelter_site_id AND day = DATE(NEW.claimed_at);
  IF ROW_COUNT() = 0 THEN
    INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg, reserved_kg)
    SELECT s.site_id, DATE(NEW.claimed_at), s.beneficiary_count, s.default_capacity_kg, v_qty
      FROM shelter s WHERE s.site_id = NEW.shelter_site_id;
  END IF;

  UPDATE surplus_batch SET status = 'CLAIMED' WHERE batch_id = NEW.batch_id;

  INSERT INTO custody_event (batch_id, claim_id, event_type, event_time, actor_user_id, notes)
  VALUES (NEW.batch_id, NEW.claim_id, 'CLAIMED', NEW.claimed_at, NEW.claimed_by,
          CONCAT('shelter ', NEW.shelter_site_id, ', score ', NEW.match_score,
                 ', ', NEW.distance_km, ' km'));

  INSERT INTO audit_log (table_name, row_pk, action, db_user, changed_at, new_values)
  VALUES ('claim', NEW.claim_id, 'INSERT', USER(), NEW.claimed_at,
          JSON_OBJECT('batch', NEW.batch_id, 'shelter', NEW.shelter_site_id,
                      'score', NEW.match_score, 'km', NEW.distance_km));
END$$

-- BU : a claim may only move ACTIVE -> FULFILLED | CANCELLED | REJECTED,
-- and a claim cannot be "cancelled" once the food is on the road (that
-- is a REJECTED at the door instead).
CREATE TRIGGER trg_claim_bu BEFORE UPDATE ON claim FOR EACH ROW
BEGIN
  IF NEW.batch_id <> OLD.batch_id OR NEW.shelter_site_id <> OLD.shelter_site_id
     OR NEW.match_score <> OLD.match_score OR NEW.distance_km <> OLD.distance_km THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Claim snapshot fields are read-only';
  END IF;
  IF NEW.status <> OLD.status THEN
    IF OLD.status <> 'ACTIVE' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only an ACTIVE claim can change status';
    END IF;
    IF NEW.status = 'CANCELLED' AND EXISTS (SELECT 1 FROM surplus_batch
                       WHERE batch_id = NEW.batch_id AND status = 'IN_TRANSIT') THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Food already picked up: use REJECTED, not CANCELLED';
    END IF;
    SET NEW.closed_at = COALESCE(NEW.closed_at, NOW(3));
  END IF;
END$$

-- AU : keep shelter capacity and batch status in step with the claim.
CREATE TRIGGER trg_claim_au AFTER UPDATE ON claim FOR EACH ROW
BEGIN
  DECLARE v_qty DECIMAL(7,2);
  DECLARE v_safe_until DATETIME;

  IF NEW.status <> OLD.status THEN
    SELECT quantity_kg, safe_until INTO v_qty, v_safe_until
      FROM surplus_batch WHERE batch_id = NEW.batch_id;

    IF NEW.status IN ('CANCELLED','REJECTED') THEN
      -- CAPACITY UPDATE: give the reserved kilograms back to the shelter
      UPDATE shelter_day
         SET reserved_kg = reserved_kg - v_qty
       WHERE shelter_site_id = NEW.shelter_site_id AND day = DATE(NEW.claimed_at);
    END IF;

    IF NEW.status = 'FULFILLED' THEN
      UPDATE surplus_batch SET status = 'DELIVERED' WHERE batch_id = NEW.batch_id;
    ELSEIF NEW.status = 'REJECTED' THEN
      -- refused at the door (e.g. failed hygiene check): food is discarded
      UPDATE surplus_batch SET status = 'CANCELLED' WHERE batch_id = NEW.batch_id;
      INSERT INTO custody_event (batch_id, claim_id, event_type, event_time, notes)
      VALUES (NEW.batch_id, NEW.claim_id, 'REJECTED', NEW.closed_at, NEW.close_reason);
    ELSEIF NEW.status = 'CANCELLED' THEN
      -- shelter backed out before pickup: offer the food again if still safe
      INSERT INTO custody_event (batch_id, claim_id, event_type, event_time, notes)
      VALUES (NEW.batch_id, NEW.claim_id, 'CANCELLED', NEW.closed_at,
              CONCAT('claim cancelled: ', IFNULL(NEW.close_reason, '-')));
      UPDATE surplus_batch
         SET status = IF(v_safe_until > NEW.closed_at, 'AVAILABLE', 'EXPIRED')
       WHERE batch_id = NEW.batch_id;
    END IF;

    INSERT INTO audit_log (table_name, row_pk, action, db_user, changed_at, old_values, new_values)
    VALUES ('claim', NEW.claim_id, 'UPDATE', USER(), NEW.closed_at,
            JSON_OBJECT('status', OLD.status),
            JSON_OBJECT('status', NEW.status, 'reason', NEW.close_reason));
  END IF;
END$$

-- =====================================================================
-- CUSTODY_EVENT : append-only, hash-chained.
--   row_hash = SHA-256( previous row_hash of this batch (or 'GENESIS')
--                       | this row's fields )
--   Changing any old row changes its hash, so every later row's
--   prev_hash no longer matches: fn_custody_first_bad_event finds it.
-- =====================================================================
CREATE TRIGGER trg_custody_bi BEFORE INSERT ON custody_event FOR EACH ROW
BEGIN
  SET NEW.event_time = COALESCE(NEW.event_time, NOW(3));
  -- latest event of the same batch: one backward dive on IDX-12 / PK
  SET NEW.prev_hash = (SELECT row_hash FROM custody_event
                        WHERE batch_id = NEW.batch_id
                        ORDER BY event_id DESC LIMIT 1);
  SET NEW.row_hash = SHA2(CONCAT(IFNULL(NEW.prev_hash,'GENESIS'), '|',
        CONCAT_WS('|', NEW.batch_id, IFNULL(NEW.claim_id,'-'), IFNULL(NEW.trip_id,'-'),
                  NEW.event_type, DATE_FORMAT(NEW.event_time,'%Y-%m-%d %H:%i:%s.%f'),
                  IFNULL(NEW.actor_user_id,'-'), IFNULL(NEW.temperature_c,'-'),
                  IFNULL(NEW.hygiene_ok,'-'), IFNULL(NEW.notes,'-'))), 256);
END$$

CREATE TRIGGER trg_custody_bu BEFORE UPDATE ON custody_event FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R8: custody_event is append-only (UPDATE refused)';
END$$

CREATE TRIGGER trg_custody_bd BEFORE DELETE ON custody_event FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R8: custody_event is append-only (DELETE refused)';
END$$

-- =====================================================================
-- TRIP_ITEM : the pickup stop must be at the batch's mess and the drop
-- stop at the claiming shelter (spans trip_stop, claim, surplus_batch).
-- =====================================================================
CREATE TRIGGER trg_trip_item_bi BEFORE INSERT ON trip_item FOR EACH ROW
BEGIN
  IF NOT EXISTS (
      SELECT 1 FROM trip_stop ts
        JOIN claim c         ON c.claim_id = NEW.claim_id
        JOIN surplus_batch b ON b.batch_id = c.batch_id
       WHERE ts.trip_id = NEW.trip_id AND ts.stop_seq = NEW.pickup_seq
         AND ts.stop_type = 'PICKUP' AND ts.site_id = b.mess_site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R10: pickup stop is not the batch''s mess';
  END IF;
  IF NOT EXISTS (
      SELECT 1 FROM trip_stop ts
        JOIN claim c ON c.claim_id = NEW.claim_id
       WHERE ts.trip_id = NEW.trip_id AND ts.stop_seq = NEW.drop_seq
         AND ts.stop_type = 'DROP' AND ts.site_id = c.shelter_site_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'R10: drop stop is not the claiming shelter';
  END IF;
END$$

-- =====================================================================
-- Generic audit of small but important tables
-- =====================================================================
CREATE TRIGGER trg_bdt_ad AFTER DELETE ON batch_diet_tag FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, row_pk, action, db_user, old_values)
  VALUES ('batch_diet_tag', CONCAT(OLD.batch_id, '/', OLD.tag_code), 'DELETE', USER(),
          JSON_OBJECT('batch_id', OLD.batch_id, 'tag', OLD.tag_code));
END$$

CREATE TRIGGER trg_weight_au AFTER UPDATE ON scoring_weight FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, row_pk, action, db_user, old_values, new_values)
  VALUES ('scoring_weight', NEW.weight_key, 'UPDATE', USER(),
          JSON_OBJECT('weight', OLD.weight_value), JSON_OBJECT('weight', NEW.weight_value));
END$$

CREATE TRIGGER trg_category_au AFTER UPDATE ON food_category FOR EACH ROW
BEGIN
  INSERT INTO audit_log (table_name, row_pk, action, db_user, old_values, new_values)
  VALUES ('food_category', NEW.category_id, 'UPDATE', USER(),
          JSON_OBJECT('ambient', OLD.safe_hours_ambient, 'hot', OLD.safe_hours_hot_held,
                      'chilled', OLD.safe_hours_chilled, 'co2e', OLD.co2e_kg_per_kg),
          JSON_OBJECT('ambient', NEW.safe_hours_ambient, 'hot', NEW.safe_hours_hot_held,
                      'chilled', NEW.safe_hours_chilled, 'co2e', NEW.co2e_kg_per_kg));
END$$

-- =====================================================================
-- EVENT : the auto-expire timer. Needs event_scheduler=ON (MySQL 8
-- default). Calls sp_expire_batches from 04_procedures.sql.
-- =====================================================================
CREATE EVENT ev_auto_expire
  ON SCHEDULE EVERY 5 MINUTE
  COMMENT 'Auto-expire batches whose safe_until has passed'
  DO CALL sp_expire_batches()$$

DELIMITER ;
