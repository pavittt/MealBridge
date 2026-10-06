-- =====================================================================
-- MealBridge : demo of VIEWS, the MATCHING PROCEDURE, FUNCTIONS and
-- TRIGGERS, with real output in 09_demo_views_procs_triggers.output.md
--
-- Everything that changes data runs inside START TRANSACTION ... ROLLBACK
-- so the demo can be re-run and leaves the dataset unchanged. The only
-- exception is the last section (tamper detection), which needs DDL and
-- restores what it changes. Expected errors are labelled EXPECT ERROR.
-- All data is SYNTHETIC.
-- =====================================================================
USE mealbridge;

-- @@ V1. Impact dashboard headline (v_impact_summary)
-- Meals saved, kg diverted, carbon avoided, expiry and response time in one row. Carbon uses the FAO 2013 global average factor (values_source says TO VERIFY).
SELECT * FROM v_impact_summary\G

-- @@ V2. Impact time series, last 10 days (v_impact_daily)
-- One row per day for the dashboard charts.
SELECT * FROM v_impact_daily ORDER BY day DESC LIMIT 10;

-- @@ V3. Response time per shelter (v_response_time)
-- Average and median minutes from posting to claim. The median is computed with ROW_NUMBER() because MySQL has no MEDIAN().
SELECT * FROM v_response_time ORDER BY median_response_min;

-- @@ V4. Fairness per shelter and Jain's index (v_shelter_fairness, v_fairness_index)
-- fair_ratio 1.00 = the shelter got exactly its share by number of beneficiaries. Jain's index 1.0 = perfectly even kg per beneficiary.
SELECT * FROM v_shelter_fairness ORDER BY fair_ratio DESC;
SELECT * FROM v_fairness_index;

-- @@ V5. Mess leaderboard (v_mess_leaderboard)
SELECT * FROM v_mess_leaderboard ORDER BY rank_by_kg_rescued;

-- @@ P1. MATCHING PROCEDURE: rank every shelter for a live batch (sp_rank_shelters)
-- Shows the five component scores (0-100), the weighted match score, and why excluded shelters are excluded. Weights come from the scoring_weight table.
SELECT weight_key, weight_value FROM scoring_weight ORDER BY weight_value DESC;
SET @b = (SELECT batch_id FROM surplus_batch WHERE description = 'SYN Chicken curry (live demo)');
CALL sp_rank_shelters(@b, NULL);

-- @@ P2. Policy change re-ranks shelters (weights are data, change is audited)
-- Doubling the FAIRNESS weight inside a transaction, re-ranking, then rolling back.
START TRANSACTION;
UPDATE scoring_weight SET weight_value = 0.500 WHERE weight_key = 'FAIRNESS';
CALL sp_rank_shelters(@b, NULL);
SELECT table_name, row_pk, action, db_user, old_values, new_values
  FROM audit_log WHERE table_name = 'scoring_weight' ORDER BY audit_id DESC LIMIT 1;
ROLLBACK;

-- @@ P3. TOTAL specialization: sites are created only with their subtype (sp_register_site)
-- A good registration creates SITE + SHELTER together. A bad one (missing registration_no) fails in the subtype insert and the SITE row is rolled back too, so no "orphan" site is left. The demo shelter is then removed.
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

-- @@ F1. Functions used on their own
-- Perishability clock, meal conversion, distance and travel estimate, diet check.
SELECT fn_safe_until(3, 'AMBIENT',  '2026-10-05 12:00:00') AS nonveg_ambient_deadline,
       fn_safe_until(3, 'HOT_HELD', '2026-10-05 12:00:00') AS nonveg_hot_deadline,
       fn_safe_until(3, 'CHILLED',  '2026-10-05 12:00:00') AS nonveg_chilled_deadline,
       fn_meals(10, 1)                                    AS meals_in_10kg_rice,
       (SELECT ROUND(fn_distance_km(a.location, b.location), 2)
          FROM site a, site b WHERE a.site_id = 1 AND b.site_id = 9) AS km_messA_to_katpadi,
       ROUND(fn_travel_minutes(2.46))                     AS est_minutes_for_2_46_km,
       fn_is_diet_compatible(@b, 8)                       AS chicken_ok_for_old_age_home,
       fn_is_diet_compatible(@b, 9)                       AS chicken_ok_for_night_shelter;

-- @@ T1. Trigger: perishability clock overrides any client-sent deadline (trg_batch_bi)
-- The client tries to post safe_until = +3 days; the trigger replaces it with cooked_at + safe hours.
START TRANSACTION;
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (1, 1, 3, 'LUNCH', 'SYN trigger demo', 10, 'HOT_HELD', NOW() - INTERVAL 1 HOUR, NOW() + INTERVAL 3 DAY);
SELECT batch_id, cooked_at, storage, safe_until, status
  FROM surplus_batch WHERE batch_id = LAST_INSERT_ID();
SELECT event_type, event_time, notes FROM custody_event
 WHERE batch_id = LAST_INSERT_ID() ORDER BY event_id;
ROLLBACK;

-- @@ T2. Trigger: food already past its deadline cannot be posted (EXPECT ERROR)
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (1, 3, 3, 'LUNCH', 'SYN too old', 10, 'AMBIENT', NOW() - INTERVAL 3 HOUR, NOW());

-- @@ T3. Trigger: a mess admin cannot post for another mess (EXPECT ERROR)
-- User 3 is the admin of mess 1; here they try to post for mess 2.
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, safe_until)
VALUES (2, 1, 3, 'LUNCH', 'SYN wrong mess', 10, 'HOT_HELD', NOW() - INTERVAL 1 HOUR, NOW());

-- @@ T4. Trigger: CAPACITY UPDATE on claim and on cancel (trg_claim_ai / trg_claim_au)
-- reserved_kg of the shelter's day goes up when it claims and back down when the claim is cancelled; the batch is offered again.
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

-- @@ T5. Trigger + CHECK: a shelter can never be over-filled (EXPECT ERROR)
-- Shelter 12 (Little Steps) can take about 15 kg a day; claiming the 24 kg batch breaks CHECK chk_sd_reserved inside the trigger, so the whole INSERT is undone.
SET @b1 = (SELECT batch_id FROM surplus_batch WHERE description = 'SYN Sambar rice (live demo)');
SELECT capacity_kg, reserved_kg FROM shelter_day WHERE shelter_site_id = 12 AND day = CURRENT_DATE;
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
VALUES (@b1, 12, 14, 50, 2.1);
SELECT COUNT(*) AS claims_on_batch_after_failed_insert FROM claim WHERE batch_id = @b1;

-- @@ T6. Trigger: diet exclusion blocks a claim (EXPECT ERROR)
-- The temple kitchen (site 11) excludes NON_VEG; the chicken curry batch is refused.
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
VALUES (@b, 11, 13, 50, 6.0);

-- @@ T7. Trigger: deadline inputs are frozen after posting (EXPECT ERROR)
UPDATE surplus_batch SET safe_until = safe_until + INTERVAL 2 HOUR WHERE batch_id = @b1;

-- @@ T8. Trigger: illegal status jump (EXPECT ERROR)
-- An AVAILABLE batch cannot jump straight to DELIVERED.
UPDATE surplus_batch SET status = 'DELIVERED' WHERE batch_id = @b1;

-- @@ T9. Trigger: role must match site type (EXPECT ERROR)
-- A SHELTER user attached to a MESS site.
INSERT INTO app_user (full_name, email, phone, password_hash, role, site_id)
VALUES ('SYN wrong', 'wrong@example.org', '9100000099', REPEAT('x', 60), 'SHELTER', 1);

-- @@ T10. Trigger: custody log is append-only, even for root (EXPECT ERROR x2)
UPDATE custody_event SET notes = 'edited' WHERE event_id = 1;
DELETE FROM custody_event WHERE event_id = 1;

-- @@ T11. AUTO-EXPIRE: event + procedure + trigger
-- A batch posted with 3 seconds of safe time left; after 4 s the job (the same procedure ev_auto_expire runs every 5 minutes) expires it and the trigger writes the EXPIRED custody event at the true deadline.
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

-- @@ T12. Audit log written by triggers (last 6 rows)
-- db_user is USER() (the real login), not CURRENT_USER() (which inside a trigger is the trigger's definer).
SELECT audit_id, table_name, row_pk, action, db_user, changed_at,
       LEFT(CAST(new_values AS CHAR), 70) AS new_values
  FROM audit_log ORDER BY audit_id DESC LIMIT 6;

-- @@ T13. Tamper detection with the SHA-256 hash chain
-- Simulates an attacker who has DROP TRIGGER rights: drops the append-only trigger, edits one old custody note, and the verifier names the altered event. Then everything is restored and re-checked.
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
