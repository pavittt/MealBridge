-- =====================================================================
-- Stage 3 smoke test: proves the key constraints of 01_schema.sql really
-- reject bad data. Uses a handful of SYNTHETIC rows (names are invented,
-- coordinates are approximate points in Vellore). Each "EXPECT ERROR"
-- statement is meant to fail; run with:  mysql -uroot --force < this_file
-- =====================================================================
USE mealbridge;

INSERT INTO campus (name, city) VALUES ('SYNTHETIC Campus A', 'Vellore');
INSERT INTO site (site_type, name, address_line, city, pincode, location, contact_phone) VALUES
 ('MESS',    'SYNTHETIC Mess 1',    'Hostel Block A', 'Vellore', '632014', ST_GeomFromText('POINT(12.9692 79.1559)', 4326), '9000000001'),
 ('SHELTER', 'SYNTHETIC Shelter 1', 'Katpadi Road',   'Vellore', '632007', ST_GeomFromText('POINT(12.9716 79.1380)', 4326), '9000000002');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no)
  VALUES (1, 1, 'A', 'VEG', 1500, '10000000000001');
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, default_capacity_kg)
  VALUES (2, 'ORPHANAGE', 'SYN-REG-001', 60, 40.00);

SELECT '--- T1 EXPECT ERROR: a MESS row pointing at a SHELTER site (disjoint specialization)' AS test;
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no)
  VALUES (2, 1, 'B', 'VEG', 100, '10000000000002');

SELECT '--- T2 EXPECT ERROR: a VOLUNTEER user attached to a site' AS test;
INSERT INTO app_user (full_name, email, phone, password_hash, role, site_id)
  VALUES ('Synthetic Vol', 'vol@example.org', '9000000003', REPEAT('x',60), 'VOLUNTEER', 1);

INSERT INTO app_user (full_name, email, phone, password_hash, role, site_id) VALUES
 ('Synthetic Mess Admin', 'mess@example.org',    '9000000004', REPEAT('x',60), 'MESS_ADMIN', 1),
 ('Synthetic Shelter A',  'shelter@example.org', '9000000005', REPEAT('x',60), 'SHELTER',    2);
INSERT INTO food_category (name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal)
  VALUES ('UNVERIFIED Rice and dal', 'MEDIUM', 2.0, 4.0, 24.0, 0.400);
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, safe_until)
  VALUES (1, 1, 1, 'LUNCH', 'SYNTHETIC rice + dal', 25.00, 'HOT_HELD', NOW() - INTERVAL 1 HOUR, NOW() + INTERVAL 3 HOUR);

SELECT '--- T3 EXPECT ERROR: batch posted against a SHELTER site (FK to mess)' AS test;
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, safe_until)
  VALUES (2, 1, 1, 'LUNCH', 'bad', 5, 'AMBIENT', NOW(), NOW() + INTERVAL 1 HOUR);

SELECT '--- T4 EXPECT ERROR: negative quantity' AS test;
INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, safe_until)
  VALUES (1, 1, 1, 'LUNCH', 'bad', -3, 'AMBIENT', NOW(), NOW() + INTERVAL 1 HOUR);

INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
  VALUES (1, 2, 2, 81.5, 2.10);
SELECT '--- T5 EXPECT ERROR: second live claim on the same batch' AS test;
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
  VALUES (1, 2, 2, 70.0, 2.10);

SELECT '--- T6 cancel the first claim, then a new claim is allowed' AS test;
UPDATE claim SET status = 'CANCELLED', closed_at = NOW(3), close_reason = 'test' WHERE claim_id = 1;
INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km)
  VALUES (1, 2, 2, 70.0, 2.10);
SELECT claim_id, batch_id, status, active_batch_id FROM claim;

SELECT '--- T7 EXPECT ERROR: shelter reserved beyond its daily capacity' AS test;
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg, reserved_kg)
  VALUES (2, CURDATE(), 60, 40.00, 55.00);

SELECT '--- T8 Nearby-shelter query using the spatial column (km)' AS test;
SELECT s.name,
       ROUND(ST_Distance_Sphere(m.location, s.location) / 1000, 2) AS km_from_mess
FROM site m JOIN site s ON s.site_type = 'SHELTER'
WHERE m.site_id = 1;
