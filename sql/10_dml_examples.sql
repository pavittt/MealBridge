-- =====================================================================
-- MealBridge : DML examples (INSERT, UPDATE, DELETE) with the reason
-- for each. Real output: 10_dml_examples.output.md
--
-- The whole file runs inside ONE transaction that is ROLLED BACK at the
-- end, so the demo dataset stays identical for the other reports. In the
-- application each of these would be its own committed transaction.
-- Statements marked EXPECT ERROR are meant to fail. All data SYNTHETIC.
-- =====================================================================
USE mealbridge;
START TRANSACTION;

-- @@ D1. INSERT a new shelter: supertype row first, then subtype row
-- Why: SITE -> SHELTER is an EER specialization. The SITE row gets the id; the SHELTER row reuses it, and its composite FK (site_id, site_type) proves the site really is a shelter.
INSERT INTO site (site_type, name, address_line, city, pincode, location, contact_phone)
VALUES ('SHELTER', 'SYN New Hope Shelter', 'SYN address', 'Vellore', '632004',
        ST_GeomFromText('POINT(12.9300 79.1450)', 4326), '9000000099');
SET @new_site = LAST_INSERT_ID();
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count,
                     has_refrigeration, default_capacity_kg)
VALUES (@new_site, 'HOMELESS_SHELTER', 'SYN-REG-099', 55, TRUE, 25.00);
SELECT s.site_id, t.name, t.site_type, s.site_type AS subtype_pinned, s.default_capacity_kg
  FROM shelter s JOIN site t ON t.site_id = s.site_id WHERE s.site_id = @new_site;

-- @@ D2. INSERT multi-valued attribute rows (diet exclusions) and a staff login
-- Why: "no non-veg, no egg" is a multivalued attribute, so it is one row per tag (1NF). The staff user must point at a SHELTER site (trigger trg_user_bi checks it).
INSERT INTO shelter_diet_exclusion (shelter_site_id, tag_code)
VALUES (@new_site, 'NON_VEG'), (@new_site, 'CONTAINS_EGG');
INSERT INTO app_user (full_name, email, phone, password_hash, role, site_id)
VALUES ('SYN Staff New Hope', 'newhope@example.org', '9100000098', REPEAT('x', 60), 'SHELTER', @new_site);
SELECT tag_code FROM shelter_diet_exclusion WHERE shelter_site_id = @new_site;

-- @@ D3. INSERT ... SELECT: plan tomorrow's need and capacity for every active shelter
-- Why: a set-based insert builds one row per active shelter in one statement from data already in the database; ON DUPLICATE KEY UPDATE makes it safe to re-run (an "upsert").
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg)
SELECT s.site_id, CURRENT_DATE + INTERVAL 2 DAY, s.beneficiary_count, s.default_capacity_kg
  FROM shelter s JOIN site t ON t.site_id = s.site_id
 WHERE t.is_active
ON DUPLICATE KEY UPDATE meals_needed = VALUES(meals_needed), capacity_kg = VALUES(capacity_kg);
SELECT COUNT(*) AS rows_for_day_plus_2 FROM shelter_day WHERE day = CURRENT_DATE + INTERVAL 2 DAY;

-- @@ D4. INSERT a surplus batch and its diet tags
-- Why: the core event of the system. The BEFORE INSERT trigger overwrites safe_until with the perishability clock and the AFTER INSERT trigger starts the custody chain. (The app does this through sp_post_batch; it is written out here because that procedure commits its own transaction, which would end this demo's transaction.)
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description,
                           quantity_kg, storage, cooked_at, packed_at, safe_until)
VALUES (2, 2, 4, 'DINNER', 'SYN Aloo gobi (DML demo)', 11.00, 'HOT_HELD',
        NOW() - INTERVAL 30 MINUTE, NOW() - INTERVAL 5 MINUTE, NOW());
SET @nb = LAST_INSERT_ID();
INSERT INTO batch_diet_tag (batch_id, tag_code)
VALUES (@nb, 'VEG'), (@nb, 'SPICY'), (@nb, 'CONTAINS_ONION_GARLIC');
SELECT batch_id, mess_site_id, quantity_kg, cooked_at, safe_until, status FROM surplus_batch WHERE batch_id = @nb;
SELECT event_type, event_time FROM custody_event WHERE batch_id = @nb ORDER BY event_id;

-- @@ D5. UPDATE a shelter's need for today
-- Why: need changes daily (more residents tonight). This raises its need score in matching. The shelter role may update only meals_needed and capacity_kg, never reserved_kg.
SELECT meals_needed, capacity_kg FROM shelter_day WHERE shelter_site_id = 9 AND day = CURRENT_DATE;
UPDATE shelter_day SET meals_needed = meals_needed + 30, capacity_kg = capacity_kg + 10
 WHERE shelter_site_id = 9 AND day = CURRENT_DATE;
SELECT meals_needed, capacity_kg FROM shelter_day WHERE shelter_site_id = 9 AND day = CURRENT_DATE;

-- @@ D6. UPDATE a batch description (allowed) and a deadline (refused, EXPECT ERROR)
-- Why: a typo fix is harmless; the deadline is a frozen snapshot. Each successful change is copied to audit_log by a trigger.
UPDATE surplus_batch SET description = 'SYN Aloo gobi, mildly spiced (DML demo)' WHERE batch_id = @nb;
UPDATE surplus_batch SET safe_until = safe_until + INTERVAL 1 DAY WHERE batch_id = @nb;
SELECT action, old_values, new_values FROM audit_log
 WHERE table_name = 'surplus_batch' AND row_pk = @nb ORDER BY audit_id;

-- @@ D7. UPDATE with a JOIN: deactivate a shelter and all its staff logins at once
-- Why: a multi-table UPDATE keeps the site and its users consistent in one statement. The role-change trigger writes the audit rows.
UPDATE site t JOIN app_user u ON u.site_id = t.site_id
   SET t.is_active = FALSE, u.is_active = FALSE
 WHERE t.site_id = @new_site;
SELECT t.name, t.is_active AS site_active, u.email, u.is_active AS user_active
  FROM site t JOIN app_user u ON u.site_id = t.site_id WHERE t.site_id = @new_site;

-- @@ D8. UPDATE via procedure: a shelter cancels its live claim
-- Why: cancelling must release the shelter's reserved capacity and re-offer the food; the claim triggers do both. (sp_cancel_claim has no transaction of its own, so it stays inside this demo's transaction.)
SET @live_claim = (SELECT claim_id FROM claim WHERE status = 'ACTIVE' AND shelter_site_id = 13 LIMIT 1);
SELECT reserved_kg FROM shelter_day WHERE shelter_site_id = 13 AND day = CURRENT_DATE;
CALL sp_cancel_claim(15, @live_claim, 'SYN demo: van broke down');
SELECT claim_id, status, close_reason FROM claim WHERE claim_id = @live_claim;
SELECT reserved_kg FROM shelter_day WHERE shelter_site_id = 13 AND day = CURRENT_DATE;

-- @@ D9. DELETE a wrongly entered diet tag
-- Why: the batch was tagged SPICY by mistake. Deleting the tag row is correct (it is a fact that is false), and trg_bdt_ad keeps a record of the deletion.
DELETE FROM batch_diet_tag WHERE batch_id = @nb AND tag_code = 'SPICY';
SELECT tag_code FROM batch_diet_tag WHERE batch_id = @nb;
SELECT action, row_pk, old_values FROM audit_log WHERE table_name = 'batch_diet_tag' ORDER BY audit_id DESC LIMIT 1;

-- @@ D10. DELETE notifications the volunteer has already read (housekeeping)
-- Why: once read, a trip alert has no further use; deleting read rows keeps the "my unread notifications" index (IDX-15) small. Safe because no table references notification.
UPDATE notification SET read_at = NOW() WHERE user_id = 19 AND kind = 'TRIP_ASSIGNED';
SELECT COUNT(*) AS read_trip_alerts FROM notification WHERE read_at IS NOT NULL;
DELETE FROM notification WHERE read_at IS NOT NULL AND kind = 'TRIP_ASSIGNED';
SELECT ROW_COUNT() AS deleted_rows;

-- @@ D11. DELETE that the database refuses (EXPECT ERROR x2)
-- Why: a mess with batches cannot be deleted (FK RESTRICT protects history), and custody events are append-only (trigger). Deactivate instead of delete.
DELETE FROM site WHERE site_id = 1;
DELETE FROM custody_event WHERE batch_id = @nb;

-- @@ D12. DELETE with ON DELETE CASCADE
-- Why: shelter_diet_exclusion rows belong to the shelter (ON DELETE CASCADE), so deleting the new shelter's subtype row removes its exclusions automatically. (Its site row has no history yet, so it can go too.)
DELETE FROM app_user WHERE site_id = @new_site;
DELETE FROM shelter_day WHERE shelter_site_id = @new_site;
DELETE FROM shelter WHERE site_id = @new_site;
SELECT COUNT(*) AS exclusions_left_for_deleted_shelter FROM shelter_diet_exclusion WHERE shelter_site_id = @new_site;
DELETE FROM site WHERE site_id = @new_site;

-- @@ D13. Undo everything in this file
ROLLBACK;
SELECT COUNT(*) AS shelters_after_rollback FROM shelter;
