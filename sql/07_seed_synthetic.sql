-- =====================================================================
-- MealBridge : SYNTHETIC SEED DATA            (generated, do not edit)
-- Generator: tools/gen_seed.py  (random seed 302, deterministic)
--
-- *** ALL DATA IN THIS FILE IS SYNTHETIC. ***  Names start with 'SYN',
-- e-mails use example.org, phones are dummies; every user's password is
-- the demo password 'demo1234' (bcrypt-hashed). DEMO ONLY.
-- Food safe-hours are planning values marked TO VERIFY (see
-- food_category.values_source). Statistics computed from this data
-- demonstrate the queries; they are NOT evidence about real messes.
--
-- Timeline: @d0 = the Monday on or before 30 days ago. History runs to yesterday,
-- replayed in time order through the real functions and triggers;
-- 'today' is created with the live procedures (sp_post_batch, ...).
-- =====================================================================
USE mealbridge;
SET SESSION max_sp_recursion_depth = 2;   -- seed_trip falls back to single-batch trips
-- the Monday on or before 30 days ago, so day 5 and 6 of each week are real weekends
SET @d0 = CURRENT_DATE - INTERVAL 30 DAY - INTERVAL WEEKDAY(CURRENT_DATE - INTERVAL 30 DAY) DAY;

-- ---------- reference data ----------
INSERT INTO campus (campus_id, name, city) VALUES (1, 'SYN North Campus', 'Vellore');
INSERT INTO campus (campus_id, name, city) VALUES (2, 'SYN South Campus', 'Vellore');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES (1, 'MESS', 'SYN Mess A (Veg)', 'Hostel block A, SYN North Campus', 'Vellore', '632014', ST_GeomFromText('POINT(12.96920 79.15590)', 4326), '9000000001');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES (1, 1, 'A', 'VEG', 2400, '10000000000001');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES (2, 'MESS', 'SYN Mess B (Non-veg)', 'Hostel block B, SYN North Campus', 'Vellore', '632014', ST_GeomFromText('POINT(12.97150 79.15900)', 4326), '9000000002');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES (2, 1, 'B', 'NON_VEG', 1800, '10000000000002');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES (3, 'MESS', 'SYN Mess C (Mixed)', 'Hostel block C, SYN North Campus', 'Vellore', '632014', ST_GeomFromText('POINT(12.96700 79.16050)', 4326), '9000000003');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES (3, 1, 'C', 'MIXED', 2000, '10000000000003');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES (4, 'MESS', 'SYN Mess D (Special)', 'Hostel block D, SYN North Campus', 'Vellore', '632014', ST_GeomFromText('POINT(12.97000 79.16300)', 4326), '9000000004');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES (4, 1, 'D', 'SPECIAL', 900, '10000000000004');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES (5, 'MESS', 'SYN Mess E (Mixed)', 'Hostel block E, SYN South Campus', 'Vellore', '632014', ST_GeomFromText('POINT(12.93850 79.14300)', 4326), '9000000005');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES (5, 2, 'E', 'MIXED', 1500, '10000000000005');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES (6, 'MESS', 'SYN Mess F (Veg)', 'Hostel block F, SYN South Campus', 'Vellore', '632014', ST_GeomFromText('POINT(12.93600 79.14650)', 4326), '9000000006');
INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES (6, 2, 'F', 'VEG', 1200, '10000000000006');
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (7, 'SHELTER', 'SYN Anbu Children''s Home', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.97650 79.13700)', 4326), '9000000007', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (7, 'ORPHANAGE', 'SYN-REG-007', 60, TRUE, 30.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (8, 'SHELTER', 'SYN Sri Sai Old Age Home', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.95600 79.17200)', 4326), '9000000008', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (8, 'OLD_AGE_HOME', 'SYN-REG-008', 45, FALSE, 20.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (9, 'SHELTER', 'SYN Katpadi Night Shelter', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.98400 79.13900)', 4326), '9000000009', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (9, 'HOMELESS_SHELTER', 'SYN-REG-009', 120, FALSE, 50.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (10, 'SHELTER', 'SYN Hospital Attendants Rest House', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.92500 79.13500)', 4326), '9000000010', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (10, 'HOSPITAL_ATTENDANTS', 'SYN-REG-010', 200, TRUE, 80.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (11, 'SHELTER', 'SYN Temple Annadhanam Kitchen', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.91600 79.13200)', 4326), '9000000011', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (11, 'COMMUNITY_KITCHEN', 'SYN-REG-011', 150, FALSE, 60.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (12, 'SHELTER', 'SYN Little Steps Orphanage', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.95200 79.14800)', 4326), '9000000012', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (12, 'ORPHANAGE', 'SYN-REG-012', 35, FALSE, 15.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (13, 'SHELTER', 'SYN Gandhi Nagar Community Kitchen', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.96000 79.13000)', 4326), '9000000013', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (13, 'COMMUNITY_KITCHEN', 'SYN-REG-013', 90, TRUE, 40.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (14, 'SHELTER', 'SYN Sathuvachari Women''s Shelter', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.94000 79.16500)', 4326), '9000000014', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (14, 'OTHER', 'SYN-REG-014', 40, FALSE, 18.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (15, 'SHELTER', 'SYN Arcot Road Old Age Home', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.90500 79.05500)', 4326), '9000000015', TRUE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (15, 'OLD_AGE_HOME', 'SYN-REG-015', 70, TRUE, 30.00);
INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES (16, 'SHELTER', 'SYN Bagayam Boys Home (closed)', 'SYN address', 'Vellore', '632006', ST_GeomFromText('POINT(12.88000 79.13000)', 4326), '9000000016', FALSE);
INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES (16, 'ORPHANAGE', 'SYN-REG-016', 50, FALSE, 25.00);
INSERT INTO diet_tag VALUES ('VEG', 'Vegetarian');
INSERT INTO diet_tag VALUES ('NON_VEG', 'Contains meat, fish or poultry');
INSERT INTO diet_tag VALUES ('CONTAINS_EGG', 'Contains egg');
INSERT INTO diet_tag VALUES ('CONTAINS_DAIRY', 'Contains milk, curd, ghee or paneer');
INSERT INTO diet_tag VALUES ('CONTAINS_NUTS', 'Contains nuts (allergen)');
INSERT INTO diet_tag VALUES ('CONTAINS_ONION_GARLIC', 'Contains onion or garlic');
INSERT INTO diet_tag VALUES ('SPICY', 'Strongly spiced');
INSERT INTO shelter_diet_exclusion VALUES (8, 'SPICY');
INSERT INTO shelter_diet_exclusion VALUES (8, 'NON_VEG');
INSERT INTO shelter_diet_exclusion VALUES (11, 'NON_VEG');
INSERT INTO shelter_diet_exclusion VALUES (11, 'CONTAINS_EGG');
INSERT INTO shelter_diet_exclusion VALUES (11, 'CONTAINS_ONION_GARLIC');
INSERT INTO shelter_diet_exclusion VALUES (12, 'CONTAINS_NUTS');
INSERT INTO shelter_diet_exclusion VALUES (14, 'NON_VEG');
INSERT INTO shelter_diet_exclusion VALUES (15, 'SPICY');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (1, 'Rice, dal and sambar', 'MEDIUM', 2.0, 4.0, 24.0, 0.45, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (2, 'Vegetable curry and gravy', 'MEDIUM', 2.0, 4.0, 24.0, 0.3, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (3, 'Non-veg curry', 'HIGH', 1.5, 3.0, 24.0, 0.3, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (4, 'Breads (chapati, parotta)', 'LOW', 6.0, 6.0, 48.0, 0.2, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (5, 'South Indian breakfast', 'MEDIUM', 3.0, 4.0, 24.0, 0.3, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (6, 'Fried snacks', 'LOW', 6.0, 6.0, 48.0, 0.15, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (7, 'Sweets and dairy desserts', 'HIGH', 1.5, 2.0, 24.0, 0.15, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES (8, 'Cut fruit and salad', 'HIGH', 2.0, 2.0, 12.0, 0.2, 2.06, 'Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average 3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.');
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (1, 'Idli with sambar', 5);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (2, 'Pongal', 5);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (3, 'Upma', 5);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (4, 'Masala dosa', 5);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (5, 'Bread omelette', 4);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (6, 'Steamed rice', 1);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (7, 'Sambar rice', 1);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (8, 'Dal tadka', 1);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (9, 'Curd rice', 1);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (10, 'Vegetable kurma', 2);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (11, 'Aloo gobi', 2);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (12, 'Paneer butter masala', 2);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (13, 'Chicken curry', 3);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (14, 'Egg curry', 3);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (15, 'Fish fry', 3);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (16, 'Chapati', 4);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (17, 'Parotta', 4);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (18, 'Samosa', 6);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (19, 'Medu vada', 6);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (20, 'Onion bajji', 6);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (21, 'Semiya payasam', 7);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (22, 'Gulab jamun', 7);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (23, 'Fruit salad', 8);
INSERT INTO menu_item (menu_item_id, name, category_id) VALUES (24, 'Veg biryani', 1);
INSERT INTO scoring_weight VALUES
 ('NEED',          0.300, 'Share of today''s meals the shelter still lacks'),
 ('FAIRNESS',      0.250, 'Shelters that received less than their share in the last 7 days rank higher'),
 ('DISTANCE',      0.200, 'Closer shelters rank higher (0 at the 15 km service radius)'),
 ('PERISHABILITY', 0.150, 'Trip uses a small part of the food''s remaining safe time'),
 ('CAPACITY',      0.100, 'Best fit: batch fills the shelter''s remaining capacity');

-- ---------- users (demo password demo1234, bcrypt) ----------
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (1, 'SYN Platform Admin 1', 'admin1@example.org', '9100000001', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'PLATFORM_ADMIN', NULL);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (2, 'SYN Platform Admin 2', 'admin2@example.org', '9100000002', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'PLATFORM_ADMIN', NULL);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (3, 'SYN Mess Admin A', 'mess.a@example.org', '9100000003', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'MESS_ADMIN', 1);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (4, 'SYN Mess Admin B', 'mess.b@example.org', '9100000004', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'MESS_ADMIN', 2);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (5, 'SYN Mess Admin C', 'mess.c@example.org', '9100000005', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'MESS_ADMIN', 3);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (6, 'SYN Mess Admin D', 'mess.d@example.org', '9100000006', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'MESS_ADMIN', 4);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (7, 'SYN Mess Admin E', 'mess.e@example.org', '9100000007', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'MESS_ADMIN', 5);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (8, 'SYN Mess Admin F', 'mess.f@example.org', '9100000008', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'MESS_ADMIN', 6);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (9, 'SYN Staff Anbu Children''s Home', 'shelter7@example.org', '9100000009', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 7);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (10, 'SYN Staff Sri Sai Old Age Home', 'shelter8@example.org', '9100000010', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 8);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (11, 'SYN Staff Katpadi Night Shelter', 'shelter9@example.org', '9100000011', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 9);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (12, 'SYN Staff Hospital Attendants Rest House', 'shelter10@example.org', '9100000012', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 10);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (13, 'SYN Staff Temple Annadhanam Kitchen', 'shelter11@example.org', '9100000013', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 11);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (14, 'SYN Staff Little Steps Orphanage', 'shelter12@example.org', '9100000014', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 12);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (15, 'SYN Staff Gandhi Nagar Community Kitchen', 'shelter13@example.org', '9100000015', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 13);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (16, 'SYN Staff Sathuvachari Women''s Shelter', 'shelter14@example.org', '9100000016', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 14);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (17, 'SYN Staff Arcot Road Old Age Home', 'shelter15@example.org', '9100000017', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 15);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (18, 'SYN Staff Bagayam Boys Home (closed)', 'shelter16@example.org', '9100000018', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'SHELTER', 16);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (19, 'SYN Volunteer Arjun', 'arjun.vol@example.org', '9100000019', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (19, 'TWO_WHEELER', 25, ST_GeomFromText('POINT(12.97000 79.15000)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (20, 'SYN Volunteer Bhavya', 'bhavya.vol@example.org', '9100000020', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (20, 'CAR', 80, ST_GeomFromText('POINT(12.96200 79.14100)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (21, 'SYN Volunteer Charan', 'charan.vol@example.org', '9100000021', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (21, 'AUTO', 60, ST_GeomFromText('POINT(12.94500 79.15000)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (22, 'SYN Volunteer Divya', 'divya.vol@example.org', '9100000022', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (22, 'TWO_WHEELER', 25, ST_GeomFromText('POINT(12.97500 79.16200)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (23, 'SYN Volunteer Eshan', 'eshan.vol@example.org', '9100000023', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (23, 'VAN', 150, ST_GeomFromText('POINT(12.93000 79.14000)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (24, 'SYN Volunteer Farah', 'farah.vol@example.org', '9100000024', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (24, 'CAR', 80, ST_GeomFromText('POINT(12.95500 79.16000)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (25, 'SYN Volunteer Gokul', 'gokul.vol@example.org', '9100000025', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (25, 'BICYCLE', 12, ST_GeomFromText('POINT(12.96900 79.15700)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (26, 'SYN Volunteer Harini', 'harini.vol@example.org', '9100000026', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (26, 'TWO_WHEELER', 25, ST_GeomFromText('POINT(12.98000 79.14500)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (27, 'SYN Volunteer Imran', 'imran.vol@example.org', '9100000027', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (27, 'AUTO', 60, ST_GeomFromText('POINT(12.92000 79.13300)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (28, 'SYN Volunteer Janani', 'janani.vol@example.org', '9100000028', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (28, 'CAR', 80, ST_GeomFromText('POINT(12.94000 79.17000)', 4326), TRUE, @d0 - INTERVAL 20 DAY);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (29, 'SYN Volunteer Karthik', 'karthik.vol@example.org', '9100000029', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (29, 'TWO_WHEELER', 25, ST_GeomFromText('POINT(12.96500 79.15200)', 4326), TRUE, NULL);
INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES (30, 'SYN Volunteer Lakshmi', 'lakshmi.vol@example.org', '9100000030', '$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi', 'VOLUNTEER', NULL);
INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES (30, 'CAR', 80, ST_GeomFromText('POINT(12.95000 79.13500)', 4326), FALSE, @d0 - INTERVAL 20 DAY);

-- ---------- shelter_day: need and capacity per day (covers history, today, tomorrow) ----------
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 0 DAY, 65, 30.23),
 (8, @d0 + INTERVAL 0 DAY, 44, 19.90),
 (9, @d0 + INTERVAL 0 DAY, 107, 45.38),
 (10, @d0 + INTERVAL 0 DAY, 189, 80.06),
 (11, @d0 + INTERVAL 0 DAY, 156, 58.07),
 (12, @d0 + INTERVAL 0 DAY, 38, 13.84),
 (13, @d0 + INTERVAL 0 DAY, 91, 36.23),
 (14, @d0 + INTERVAL 0 DAY, 36, 16.66),
 (15, @d0 + INTERVAL 0 DAY, 76, 31.07),
 (16, @d0 + INTERVAL 0 DAY, 49, 26.81),
 (7, @d0 + INTERVAL 1 DAY, 65, 29.26),
 (8, @d0 + INTERVAL 1 DAY, 47, 19.16),
 (9, @d0 + INTERVAL 1 DAY, 123, 53.28),
 (10, @d0 + INTERVAL 1 DAY, 188, 82.50),
 (11, @d0 + INTERVAL 1 DAY, 154, 55.06),
 (12, @d0 + INTERVAL 1 DAY, 36, 14.09),
 (13, @d0 + INTERVAL 1 DAY, 83, 37.93),
 (14, @d0 + INTERVAL 1 DAY, 36, 19.60),
 (15, @d0 + INTERVAL 1 DAY, 67, 32.14),
 (16, @d0 + INTERVAL 1 DAY, 44, 23.74),
 (7, @d0 + INTERVAL 2 DAY, 51, 29.84),
 (8, @d0 + INTERVAL 2 DAY, 48, 20.08),
 (9, @d0 + INTERVAL 2 DAY, 123, 46.64),
 (10, @d0 + INTERVAL 2 DAY, 172, 75.57),
 (11, @d0 + INTERVAL 2 DAY, 163, 62.37),
 (12, @d0 + INTERVAL 2 DAY, 37, 15.82),
 (13, @d0 + INTERVAL 2 DAY, 82, 37.53),
 (14, @d0 + INTERVAL 2 DAY, 40, 16.71),
 (15, @d0 + INTERVAL 2 DAY, 67, 30.23),
 (16, @d0 + INTERVAL 2 DAY, 45, 27.36),
 (7, @d0 + INTERVAL 3 DAY, 51, 32.55),
 (8, @d0 + INTERVAL 3 DAY, 38, 21.87),
 (9, @d0 + INTERVAL 3 DAY, 114, 46.52),
 (10, @d0 + INTERVAL 3 DAY, 201, 83.33),
 (11, @d0 + INTERVAL 3 DAY, 142, 59.71),
 (12, @d0 + INTERVAL 3 DAY, 35, 14.32),
 (13, @d0 + INTERVAL 3 DAY, 83, 41.59),
 (14, @d0 + INTERVAL 3 DAY, 38, 19.20),
 (15, @d0 + INTERVAL 3 DAY, 67, 31.35),
 (16, @d0 + INTERVAL 3 DAY, 49, 23.69);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 4 DAY, 56, 30.35),
 (8, @d0 + INTERVAL 4 DAY, 43, 20.82),
 (9, @d0 + INTERVAL 4 DAY, 122, 51.95),
 (10, @d0 + INTERVAL 4 DAY, 182, 85.87),
 (11, @d0 + INTERVAL 4 DAY, 161, 58.30),
 (12, @d0 + INTERVAL 4 DAY, 37, 14.93),
 (13, @d0 + INTERVAL 4 DAY, 82, 36.50),
 (14, @d0 + INTERVAL 4 DAY, 40, 18.68),
 (15, @d0 + INTERVAL 4 DAY, 71, 29.54),
 (16, @d0 + INTERVAL 4 DAY, 43, 22.52),
 (7, @d0 + INTERVAL 5 DAY, 60, 30.92),
 (8, @d0 + INTERVAL 5 DAY, 48, 21.22),
 (9, @d0 + INTERVAL 5 DAY, 118, 54.78),
 (10, @d0 + INTERVAL 5 DAY, 170, 86.99),
 (11, @d0 + INTERVAL 5 DAY, 146, 59.60),
 (12, @d0 + INTERVAL 5 DAY, 35, 14.56),
 (13, @d0 + INTERVAL 5 DAY, 87, 43.05),
 (14, @d0 + INTERVAL 5 DAY, 40, 19.49),
 (15, @d0 + INTERVAL 5 DAY, 68, 28.11),
 (16, @d0 + INTERVAL 5 DAY, 48, 26.25),
 (7, @d0 + INTERVAL 6 DAY, 55, 30.73),
 (8, @d0 + INTERVAL 6 DAY, 45, 19.45),
 (9, @d0 + INTERVAL 6 DAY, 102, 52.09),
 (10, @d0 + INTERVAL 6 DAY, 185, 87.79),
 (11, @d0 + INTERVAL 6 DAY, 127, 62.44),
 (12, @d0 + INTERVAL 6 DAY, 34, 16.16),
 (13, @d0 + INTERVAL 6 DAY, 95, 43.00),
 (14, @d0 + INTERVAL 6 DAY, 41, 18.57),
 (15, @d0 + INTERVAL 6 DAY, 72, 31.40),
 (16, @d0 + INTERVAL 6 DAY, 48, 24.37),
 (7, @d0 + INTERVAL 7 DAY, 53, 29.36),
 (8, @d0 + INTERVAL 7 DAY, 44, 21.60),
 (9, @d0 + INTERVAL 7 DAY, 109, 53.89),
 (10, @d0 + INTERVAL 7 DAY, 209, 77.62),
 (11, @d0 + INTERVAL 7 DAY, 152, 65.74),
 (12, @d0 + INTERVAL 7 DAY, 37, 15.77),
 (13, @d0 + INTERVAL 7 DAY, 84, 39.06),
 (14, @d0 + INTERVAL 7 DAY, 37, 17.21),
 (15, @d0 + INTERVAL 7 DAY, 67, 32.00),
 (16, @d0 + INTERVAL 7 DAY, 51, 23.91);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 8 DAY, 60, 30.50),
 (8, @d0 + INTERVAL 8 DAY, 39, 18.94),
 (9, @d0 + INTERVAL 8 DAY, 109, 45.80),
 (10, @d0 + INTERVAL 8 DAY, 204, 82.17),
 (11, @d0 + INTERVAL 8 DAY, 141, 65.21),
 (12, @d0 + INTERVAL 8 DAY, 33, 14.07),
 (13, @d0 + INTERVAL 8 DAY, 86, 39.33),
 (14, @d0 + INTERVAL 8 DAY, 35, 17.47),
 (15, @d0 + INTERVAL 8 DAY, 71, 30.75),
 (16, @d0 + INTERVAL 8 DAY, 43, 25.81),
 (7, @d0 + INTERVAL 9 DAY, 59, 27.58),
 (8, @d0 + INTERVAL 9 DAY, 41, 20.85),
 (9, @d0 + INTERVAL 9 DAY, 125, 52.85),
 (10, @d0 + INTERVAL 9 DAY, 186, 86.12),
 (11, @d0 + INTERVAL 9 DAY, 147, 61.86),
 (12, @d0 + INTERVAL 9 DAY, 32, 14.46),
 (13, @d0 + INTERVAL 9 DAY, 79, 37.04),
 (14, @d0 + INTERVAL 9 DAY, 41, 16.52),
 (15, @d0 + INTERVAL 9 DAY, 71, 29.52),
 (16, @d0 + INTERVAL 9 DAY, 46, 24.76),
 (7, @d0 + INTERVAL 10 DAY, 63, 30.63),
 (8, @d0 + INTERVAL 10 DAY, 43, 20.34),
 (9, @d0 + INTERVAL 10 DAY, 119, 45.32),
 (10, @d0 + INTERVAL 10 DAY, 181, 86.14),
 (11, @d0 + INTERVAL 10 DAY, 157, 62.31),
 (12, @d0 + INTERVAL 10 DAY, 38, 15.57),
 (13, @d0 + INTERVAL 10 DAY, 91, 42.96),
 (14, @d0 + INTERVAL 10 DAY, 35, 17.79),
 (15, @d0 + INTERVAL 10 DAY, 72, 28.04),
 (16, @d0 + INTERVAL 10 DAY, 50, 22.87),
 (7, @d0 + INTERVAL 11 DAY, 52, 29.07),
 (8, @d0 + INTERVAL 11 DAY, 46, 21.16),
 (9, @d0 + INTERVAL 11 DAY, 115, 51.71),
 (10, @d0 + INTERVAL 11 DAY, 189, 77.32),
 (11, @d0 + INTERVAL 11 DAY, 134, 58.76),
 (12, @d0 + INTERVAL 11 DAY, 38, 15.37),
 (13, @d0 + INTERVAL 11 DAY, 86, 40.54),
 (14, @d0 + INTERVAL 11 DAY, 40, 18.86),
 (15, @d0 + INTERVAL 11 DAY, 68, 30.25),
 (16, @d0 + INTERVAL 11 DAY, 46, 26.24);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 12 DAY, 64, 30.56),
 (8, @d0 + INTERVAL 12 DAY, 39, 19.47),
 (9, @d0 + INTERVAL 12 DAY, 121, 46.82),
 (10, @d0 + INTERVAL 12 DAY, 213, 74.07),
 (11, @d0 + INTERVAL 12 DAY, 161, 62.92),
 (12, @d0 + INTERVAL 12 DAY, 34, 15.20),
 (13, @d0 + INTERVAL 12 DAY, 96, 39.91),
 (14, @d0 + INTERVAL 12 DAY, 43, 19.74),
 (15, @d0 + INTERVAL 12 DAY, 61, 32.50),
 (16, @d0 + INTERVAL 12 DAY, 48, 26.74),
 (7, @d0 + INTERVAL 13 DAY, 53, 31.92),
 (8, @d0 + INTERVAL 13 DAY, 43, 20.80),
 (9, @d0 + INTERVAL 13 DAY, 113, 46.01),
 (10, @d0 + INTERVAL 13 DAY, 198, 86.73),
 (11, @d0 + INTERVAL 13 DAY, 141, 58.00),
 (12, @d0 + INTERVAL 13 DAY, 36, 14.85),
 (13, @d0 + INTERVAL 13 DAY, 76, 39.21),
 (14, @d0 + INTERVAL 13 DAY, 36, 19.28),
 (15, @d0 + INTERVAL 13 DAY, 71, 30.77),
 (16, @d0 + INTERVAL 13 DAY, 48, 23.89),
 (7, @d0 + INTERVAL 14 DAY, 57, 31.64),
 (8, @d0 + INTERVAL 14 DAY, 42, 20.73),
 (9, @d0 + INTERVAL 14 DAY, 108, 48.09),
 (10, @d0 + INTERVAL 14 DAY, 219, 76.55),
 (11, @d0 + INTERVAL 14 DAY, 138, 60.09),
 (12, @d0 + INTERVAL 14 DAY, 36, 16.30),
 (13, @d0 + INTERVAL 14 DAY, 82, 43.83),
 (14, @d0 + INTERVAL 14 DAY, 38, 16.90),
 (15, @d0 + INTERVAL 14 DAY, 60, 27.92),
 (16, @d0 + INTERVAL 14 DAY, 46, 24.41),
 (7, @d0 + INTERVAL 15 DAY, 60, 32.03),
 (8, @d0 + INTERVAL 15 DAY, 49, 21.92),
 (9, @d0 + INTERVAL 15 DAY, 123, 51.42),
 (10, @d0 + INTERVAL 15 DAY, 210, 86.78),
 (11, @d0 + INTERVAL 15 DAY, 139, 60.38),
 (12, @d0 + INTERVAL 15 DAY, 30, 15.65),
 (13, @d0 + INTERVAL 15 DAY, 98, 43.65),
 (14, @d0 + INTERVAL 15 DAY, 39, 18.33),
 (15, @d0 + INTERVAL 15 DAY, 73, 28.55),
 (16, @d0 + INTERVAL 15 DAY, 53, 24.21);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 16 DAY, 63, 29.55),
 (8, @d0 + INTERVAL 16 DAY, 45, 21.67),
 (9, @d0 + INTERVAL 16 DAY, 104, 52.57),
 (10, @d0 + INTERVAL 16 DAY, 182, 81.73),
 (11, @d0 + INTERVAL 16 DAY, 139, 60.06),
 (12, @d0 + INTERVAL 16 DAY, 30, 15.59),
 (13, @d0 + INTERVAL 16 DAY, 94, 37.77),
 (14, @d0 + INTERVAL 16 DAY, 40, 19.57),
 (15, @d0 + INTERVAL 16 DAY, 67, 28.59),
 (16, @d0 + INTERVAL 16 DAY, 43, 24.80),
 (7, @d0 + INTERVAL 17 DAY, 64, 32.71),
 (8, @d0 + INTERVAL 17 DAY, 42, 20.76),
 (9, @d0 + INTERVAL 17 DAY, 103, 48.06),
 (10, @d0 + INTERVAL 17 DAY, 211, 86.22),
 (11, @d0 + INTERVAL 17 DAY, 151, 57.17),
 (12, @d0 + INTERVAL 17 DAY, 33, 14.11),
 (13, @d0 + INTERVAL 17 DAY, 77, 40.43),
 (14, @d0 + INTERVAL 17 DAY, 41, 17.73),
 (15, @d0 + INTERVAL 17 DAY, 61, 32.11),
 (16, @d0 + INTERVAL 17 DAY, 53, 24.55),
 (7, @d0 + INTERVAL 18 DAY, 51, 28.95),
 (8, @d0 + INTERVAL 18 DAY, 43, 18.38),
 (9, @d0 + INTERVAL 18 DAY, 126, 45.02),
 (10, @d0 + INTERVAL 18 DAY, 217, 83.15),
 (11, @d0 + INTERVAL 18 DAY, 131, 64.98),
 (12, @d0 + INTERVAL 18 DAY, 32, 14.21),
 (13, @d0 + INTERVAL 18 DAY, 98, 36.67),
 (14, @d0 + INTERVAL 18 DAY, 39, 17.63),
 (15, @d0 + INTERVAL 18 DAY, 67, 30.09),
 (16, @d0 + INTERVAL 18 DAY, 46, 24.25),
 (7, @d0 + INTERVAL 19 DAY, 62, 28.09),
 (8, @d0 + INTERVAL 19 DAY, 47, 19.69),
 (9, @d0 + INTERVAL 19 DAY, 128, 53.54),
 (10, @d0 + INTERVAL 19 DAY, 177, 83.46),
 (11, @d0 + INTERVAL 19 DAY, 132, 62.66),
 (12, @d0 + INTERVAL 19 DAY, 35, 15.74),
 (13, @d0 + INTERVAL 19 DAY, 76, 37.23),
 (14, @d0 + INTERVAL 19 DAY, 42, 16.61),
 (15, @d0 + INTERVAL 19 DAY, 68, 27.63),
 (16, @d0 + INTERVAL 19 DAY, 44, 27.36);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 20 DAY, 59, 30.04),
 (8, @d0 + INTERVAL 20 DAY, 46, 18.56),
 (9, @d0 + INTERVAL 20 DAY, 108, 51.01),
 (10, @d0 + INTERVAL 20 DAY, 215, 80.48),
 (11, @d0 + INTERVAL 20 DAY, 163, 55.45),
 (12, @d0 + INTERVAL 20 DAY, 35, 15.22),
 (13, @d0 + INTERVAL 20 DAY, 88, 42.42),
 (14, @d0 + INTERVAL 20 DAY, 39, 19.73),
 (15, @d0 + INTERVAL 20 DAY, 61, 27.03),
 (16, @d0 + INTERVAL 20 DAY, 44, 24.86),
 (7, @d0 + INTERVAL 21 DAY, 60, 27.85),
 (8, @d0 + INTERVAL 21 DAY, 45, 19.04),
 (9, @d0 + INTERVAL 21 DAY, 105, 50.97),
 (10, @d0 + INTERVAL 21 DAY, 200, 80.00),
 (11, @d0 + INTERVAL 21 DAY, 135, 56.10),
 (12, @d0 + INTERVAL 21 DAY, 36, 16.06),
 (13, @d0 + INTERVAL 21 DAY, 90, 43.73),
 (14, @d0 + INTERVAL 21 DAY, 35, 18.71),
 (15, @d0 + INTERVAL 21 DAY, 74, 28.88),
 (16, @d0 + INTERVAL 21 DAY, 42, 23.51),
 (7, @d0 + INTERVAL 22 DAY, 59, 27.10),
 (8, @d0 + INTERVAL 22 DAY, 49, 21.50),
 (9, @d0 + INTERVAL 22 DAY, 110, 53.30),
 (10, @d0 + INTERVAL 22 DAY, 195, 77.09),
 (11, @d0 + INTERVAL 22 DAY, 144, 57.82),
 (12, @d0 + INTERVAL 22 DAY, 33, 15.31),
 (13, @d0 + INTERVAL 22 DAY, 86, 36.29),
 (14, @d0 + INTERVAL 22 DAY, 35, 19.75),
 (15, @d0 + INTERVAL 22 DAY, 69, 29.73),
 (16, @d0 + INTERVAL 22 DAY, 44, 23.37),
 (7, @d0 + INTERVAL 23 DAY, 64, 30.80),
 (8, @d0 + INTERVAL 23 DAY, 44, 18.33),
 (9, @d0 + INTERVAL 23 DAY, 116, 48.37),
 (10, @d0 + INTERVAL 23 DAY, 187, 72.27),
 (11, @d0 + INTERVAL 23 DAY, 147, 54.94),
 (12, @d0 + INTERVAL 23 DAY, 33, 15.28),
 (13, @d0 + INTERVAL 23 DAY, 87, 39.76),
 (14, @d0 + INTERVAL 23 DAY, 34, 18.67),
 (15, @d0 + INTERVAL 23 DAY, 60, 29.06),
 (16, @d0 + INTERVAL 23 DAY, 45, 22.70);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 24 DAY, 51, 30.15),
 (8, @d0 + INTERVAL 24 DAY, 40, 19.87),
 (9, @d0 + INTERVAL 24 DAY, 119, 51.71),
 (10, @d0 + INTERVAL 24 DAY, 184, 73.78),
 (11, @d0 + INTERVAL 24 DAY, 133, 58.54),
 (12, @d0 + INTERVAL 24 DAY, 31, 15.30),
 (13, @d0 + INTERVAL 24 DAY, 78, 43.05),
 (14, @d0 + INTERVAL 24 DAY, 36, 17.07),
 (15, @d0 + INTERVAL 24 DAY, 60, 31.96),
 (16, @d0 + INTERVAL 24 DAY, 42, 24.84),
 (7, @d0 + INTERVAL 25 DAY, 53, 29.85),
 (8, @d0 + INTERVAL 25 DAY, 46, 21.05),
 (9, @d0 + INTERVAL 25 DAY, 112, 50.36),
 (10, @d0 + INTERVAL 25 DAY, 174, 85.21),
 (11, @d0 + INTERVAL 25 DAY, 141, 61.30),
 (12, @d0 + INTERVAL 25 DAY, 30, 15.92),
 (13, @d0 + INTERVAL 25 DAY, 98, 43.83),
 (14, @d0 + INTERVAL 25 DAY, 36, 16.50),
 (15, @d0 + INTERVAL 25 DAY, 68, 28.36),
 (16, @d0 + INTERVAL 25 DAY, 43, 22.93),
 (7, @d0 + INTERVAL 26 DAY, 63, 32.99),
 (8, @d0 + INTERVAL 26 DAY, 48, 18.07),
 (9, @d0 + INTERVAL 26 DAY, 123, 49.80),
 (10, @d0 + INTERVAL 26 DAY, 175, 74.51),
 (11, @d0 + INTERVAL 26 DAY, 142, 60.36),
 (12, @d0 + INTERVAL 26 DAY, 37, 14.87),
 (13, @d0 + INTERVAL 26 DAY, 77, 39.21),
 (14, @d0 + INTERVAL 26 DAY, 36, 16.22),
 (15, @d0 + INTERVAL 26 DAY, 75, 28.11),
 (16, @d0 + INTERVAL 26 DAY, 45, 24.71),
 (7, @d0 + INTERVAL 27 DAY, 62, 29.06),
 (8, @d0 + INTERVAL 27 DAY, 48, 21.19),
 (9, @d0 + INTERVAL 27 DAY, 107, 50.05),
 (10, @d0 + INTERVAL 27 DAY, 199, 74.36),
 (11, @d0 + INTERVAL 27 DAY, 155, 62.79),
 (12, @d0 + INTERVAL 27 DAY, 37, 14.54),
 (13, @d0 + INTERVAL 27 DAY, 82, 43.09),
 (14, @d0 + INTERVAL 27 DAY, 36, 17.98),
 (15, @d0 + INTERVAL 27 DAY, 65, 27.40),
 (16, @d0 + INTERVAL 27 DAY, 48, 25.16);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 28 DAY, 62, 30.13),
 (8, @d0 + INTERVAL 28 DAY, 49, 20.11),
 (9, @d0 + INTERVAL 28 DAY, 124, 45.60),
 (10, @d0 + INTERVAL 28 DAY, 179, 84.20),
 (11, @d0 + INTERVAL 28 DAY, 153, 54.10),
 (12, @d0 + INTERVAL 28 DAY, 30, 15.03),
 (13, @d0 + INTERVAL 28 DAY, 97, 36.72),
 (14, @d0 + INTERVAL 28 DAY, 41, 19.40),
 (15, @d0 + INTERVAL 28 DAY, 67, 29.75),
 (16, @d0 + INTERVAL 28 DAY, 43, 25.67),
 (7, @d0 + INTERVAL 29 DAY, 63, 28.42),
 (8, @d0 + INTERVAL 29 DAY, 46, 18.12),
 (9, @d0 + INTERVAL 29 DAY, 131, 46.02),
 (10, @d0 + INTERVAL 29 DAY, 176, 79.19),
 (11, @d0 + INTERVAL 29 DAY, 144, 61.97),
 (12, @d0 + INTERVAL 29 DAY, 32, 15.17),
 (13, @d0 + INTERVAL 29 DAY, 83, 43.37),
 (14, @d0 + INTERVAL 29 DAY, 41, 18.55),
 (15, @d0 + INTERVAL 29 DAY, 62, 27.78),
 (16, @d0 + INTERVAL 29 DAY, 51, 26.41),
 (7, @d0 + INTERVAL 30 DAY, 52, 28.79),
 (8, @d0 + INTERVAL 30 DAY, 45, 19.96),
 (9, @d0 + INTERVAL 30 DAY, 123, 52.90),
 (10, @d0 + INTERVAL 30 DAY, 189, 84.73),
 (11, @d0 + INTERVAL 30 DAY, 161, 60.63),
 (12, @d0 + INTERVAL 30 DAY, 33, 14.85),
 (13, @d0 + INTERVAL 30 DAY, 91, 43.76),
 (14, @d0 + INTERVAL 30 DAY, 36, 17.81),
 (15, @d0 + INTERVAL 30 DAY, 73, 28.53),
 (16, @d0 + INTERVAL 30 DAY, 45, 25.72),
 (7, @d0 + INTERVAL 31 DAY, 62, 27.41),
 (8, @d0 + INTERVAL 31 DAY, 48, 21.60),
 (9, @d0 + INTERVAL 31 DAY, 114, 52.76),
 (10, @d0 + INTERVAL 31 DAY, 184, 82.78),
 (11, @d0 + INTERVAL 31 DAY, 158, 54.10),
 (12, @d0 + INTERVAL 31 DAY, 36, 14.80),
 (13, @d0 + INTERVAL 31 DAY, 95, 37.18),
 (14, @d0 + INTERVAL 31 DAY, 39, 17.88),
 (15, @d0 + INTERVAL 31 DAY, 65, 29.69),
 (16, @d0 + INTERVAL 31 DAY, 43, 26.86);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 32 DAY, 60, 30.67),
 (8, @d0 + INTERVAL 32 DAY, 42, 20.81),
 (9, @d0 + INTERVAL 32 DAY, 123, 54.54),
 (10, @d0 + INTERVAL 32 DAY, 188, 81.40),
 (11, @d0 + INTERVAL 32 DAY, 156, 59.28),
 (12, @d0 + INTERVAL 32 DAY, 34, 15.68),
 (13, @d0 + INTERVAL 32 DAY, 96, 40.80),
 (14, @d0 + INTERVAL 32 DAY, 42, 16.70),
 (15, @d0 + INTERVAL 32 DAY, 75, 28.16),
 (16, @d0 + INTERVAL 32 DAY, 51, 26.44),
 (7, @d0 + INTERVAL 33 DAY, 58, 27.94),
 (8, @d0 + INTERVAL 33 DAY, 47, 19.39),
 (9, @d0 + INTERVAL 33 DAY, 115, 50.69),
 (10, @d0 + INTERVAL 33 DAY, 215, 84.89),
 (11, @d0 + INTERVAL 33 DAY, 150, 59.39),
 (12, @d0 + INTERVAL 33 DAY, 33, 14.02),
 (13, @d0 + INTERVAL 33 DAY, 98, 37.50),
 (14, @d0 + INTERVAL 33 DAY, 35, 16.68),
 (15, @d0 + INTERVAL 33 DAY, 62, 32.08),
 (16, @d0 + INTERVAL 33 DAY, 46, 22.64),
 (7, @d0 + INTERVAL 34 DAY, 61, 32.95),
 (8, @d0 + INTERVAL 34 DAY, 38, 20.11),
 (9, @d0 + INTERVAL 34 DAY, 125, 50.50),
 (10, @d0 + INTERVAL 34 DAY, 212, 73.69),
 (11, @d0 + INTERVAL 34 DAY, 162, 56.93),
 (12, @d0 + INTERVAL 34 DAY, 31, 14.33),
 (13, @d0 + INTERVAL 34 DAY, 78, 42.79),
 (14, @d0 + INTERVAL 34 DAY, 38, 16.29),
 (15, @d0 + INTERVAL 34 DAY, 63, 28.91),
 (16, @d0 + INTERVAL 34 DAY, 53, 25.07),
 (7, @d0 + INTERVAL 35 DAY, 58, 31.34),
 (8, @d0 + INTERVAL 35 DAY, 44, 18.71),
 (9, @d0 + INTERVAL 35 DAY, 128, 52.14),
 (10, @d0 + INTERVAL 35 DAY, 177, 73.42),
 (11, @d0 + INTERVAL 35 DAY, 144, 65.48),
 (12, @d0 + INTERVAL 35 DAY, 34, 14.75),
 (13, @d0 + INTERVAL 35 DAY, 86, 36.34),
 (14, @d0 + INTERVAL 35 DAY, 38, 19.75),
 (15, @d0 + INTERVAL 35 DAY, 63, 27.51),
 (16, @d0 + INTERVAL 35 DAY, 51, 26.79);
INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES
 (7, @d0 + INTERVAL 36 DAY, 52, 30.06),
 (8, @d0 + INTERVAL 36 DAY, 38, 20.82),
 (9, @d0 + INTERVAL 36 DAY, 124, 49.84),
 (10, @d0 + INTERVAL 36 DAY, 186, 84.20),
 (11, @d0 + INTERVAL 36 DAY, 144, 60.51),
 (12, @d0 + INTERVAL 36 DAY, 36, 15.61),
 (13, @d0 + INTERVAL 36 DAY, 84, 36.25),
 (14, @d0 + INTERVAL 36 DAY, 42, 18.58),
 (15, @d0 + INTERVAL 36 DAY, 64, 32.13),
 (16, @d0 + INTERVAL 36 DAY, 43, 25.00),
 (7, @d0 + INTERVAL 37 DAY, 59, 27.17),
 (8, @d0 + INTERVAL 37 DAY, 47, 20.64),
 (9, @d0 + INTERVAL 37 DAY, 124, 54.59),
 (10, @d0 + INTERVAL 37 DAY, 219, 81.01),
 (11, @d0 + INTERVAL 37 DAY, 140, 60.93),
 (12, @d0 + INTERVAL 37 DAY, 33, 13.88),
 (13, @d0 + INTERVAL 37 DAY, 86, 40.07),
 (14, @d0 + INTERVAL 37 DAY, 42, 17.91),
 (15, @d0 + INTERVAL 37 DAY, 61, 29.59),
 (16, @d0 + INTERVAL 37 DAY, 42, 24.67);

-- ---------- mess_meal_log and mess_menu (~30 days) ----------
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (1, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 553, 553, 142.40, 0.00),
 (1, @d0 + INTERVAL 0 DAY, 'LUNCH', 741, 654, 343.45, 55.09),
 (1, @d0 + INTERVAL 0 DAY, 'SNACKS', 385, 370, 47.59, 4.83),
 (1, @d0 + INTERVAL 0 DAY, 'DINNER', 726, 691, 314.07, 29.85),
 (2, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 442, 432, 113.81, 11.12),
 (2, @d0 + INTERVAL 0 DAY, 'LUNCH', 533, 492, 247.05, 19.87),
 (2, @d0 + INTERVAL 0 DAY, 'SNACKS', 289, 257, 35.72, 3.82),
 (2, @d0 + INTERVAL 0 DAY, 'DINNER', 513, 513, 221.92, 10.44),
 (3, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 475, 458, 122.31, 12.00),
 (3, @d0 + INTERVAL 0 DAY, 'LUNCH', 582, 563, 269.76, 26.94),
 (3, @d0 + INTERVAL 0 DAY, 'SNACKS', 325, 317, 40.17, 2.68),
 (3, @d0 + INTERVAL 0 DAY, 'DINNER', 574, 546, 248.31, 14.41),
 (4, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 222, 215, 57.16, 2.68),
 (4, @d0 + INTERVAL 0 DAY, 'LUNCH', 271, 256, 125.61, 10.31),
 (4, @d0 + INTERVAL 0 DAY, 'DINNER', 276, 257, 119.40, 11.54),
 (5, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 350, 314, 90.12, 12.09),
 (5, @d0 + INTERVAL 0 DAY, 'LUNCH', 467, 466, 216.45, 8.35),
 (5, @d0 + INTERVAL 0 DAY, 'SNACKS', 228, 207, 28.18, 2.46),
 (5, @d0 + INTERVAL 0 DAY, 'DINNER', 454, 415, 196.40, 27.10),
 (6, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 292, 292, 75.19, 4.10),
 (6, @d0 + INTERVAL 0 DAY, 'LUNCH', 371, 345, 171.96, 15.81),
 (6, @d0 + INTERVAL 0 DAY, 'SNACKS', 189, 177, 23.36, 1.76),
 (6, @d0 + INTERVAL 0 DAY, 'DINNER', 355, 353, 153.57, 0.13),
 (1, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 582, 552, 149.87, 8.66),
 (1, @d0 + INTERVAL 1 DAY, 'LUNCH', 700, 653, 324.45, 24.75),
 (1, @d0 + INTERVAL 1 DAY, 'SNACKS', 373, 341, 46.10, 5.85),
 (1, @d0 + INTERVAL 1 DAY, 'DINNER', 719, 700, 311.04, 15.48),
 (2, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 442, 423, 113.81, 10.59),
 (2, @d0 + INTERVAL 1 DAY, 'LUNCH', 561, 524, 260.02, 32.08),
 (2, @d0 + INTERVAL 1 DAY, 'SNACKS', 280, 268, 34.61, 2.31),
 (2, @d0 + INTERVAL 1 DAY, 'DINNER', 522, 494, 225.82, 10.81),
 (3, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 484, 484, 124.63, 7.69),
 (3, @d0 + INTERVAL 1 DAY, 'LUNCH', 595, 591, 275.78, 24.53),
 (3, @d0 + INTERVAL 1 DAY, 'SNACKS', 316, 304, 39.06, 3.17),
 (3, @d0 + INTERVAL 1 DAY, 'DINNER', 623, 618, 269.51, 0.00),
 (4, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 222, 210, 57.16, 5.60),
 (4, @d0 + INTERVAL 1 DAY, 'LUNCH', 270, 257, 125.15, 9.59),
 (4, @d0 + INTERVAL 1 DAY, 'DINNER', 272, 254, 117.67, 10.63),
 (5, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 342, 328, 88.06, 6.11),
 (5, @d0 + INTERVAL 1 DAY, 'LUNCH', 446, 420, 206.72, 15.79),
 (5, @d0 + INTERVAL 1 DAY, 'SNACKS', 236, 228, 29.17, 1.26),
 (5, @d0 + INTERVAL 1 DAY, 'DINNER', 453, 403, 195.97, 25.65),
 (6, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 279, 264, 71.84, 3.00),
 (6, @d0 + INTERVAL 1 DAY, 'LUNCH', 368, 335, 170.57, 17.76),
 (6, @d0 + INTERVAL 1 DAY, 'SNACKS', 197, 181, 24.35, 3.52),
 (6, @d0 + INTERVAL 1 DAY, 'DINNER', 350, 336, 151.41, 11.30),
 (1, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 592, 514, 152.44, 22.14),
 (1, @d0 + INTERVAL 2 DAY, 'LUNCH', 728, 695, 337.43, 12.19),
 (1, @d0 + INTERVAL 2 DAY, 'SNACKS', 377, 350, 46.60, 4.40),
 (1, @d0 + INTERVAL 2 DAY, 'DINNER', 687, 647, 297.20, 33.28),
 (2, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 440, 409, 113.30, 13.72),
 (2, @d0 + INTERVAL 2 DAY, 'LUNCH', 551, 506, 255.39, 21.33),
 (2, @d0 + INTERVAL 2 DAY, 'SNACKS', 295, 277, 36.46, 3.62),
 (2, @d0 + INTERVAL 2 DAY, 'DINNER', 520, 490, 224.95, 26.29),
 (3, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 490, 459, 126.17, 10.06),
 (3, @d0 + INTERVAL 2 DAY, 'LUNCH', 604, 553, 279.95, 24.45),
 (3, @d0 + INTERVAL 2 DAY, 'SNACKS', 326, 300, 40.29, 4.23),
 (3, @d0 + INTERVAL 2 DAY, 'DINNER', 606, 559, 262.16, 31.70),
 (4, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 208, 196, 53.56, 4.41),
 (4, @d0 + INTERVAL 2 DAY, 'LUNCH', 265, 256, 122.83, 11.51);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (4, @d0 + INTERVAL 2 DAY, 'DINNER', 257, 246, 111.18, 7.56),
 (5, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 358, 349, 92.19, 6.49),
 (5, @d0 + INTERVAL 2 DAY, 'LUNCH', 449, 434, 208.11, 22.77),
 (5, @d0 + INTERVAL 2 DAY, 'SNACKS', 249, 230, 30.78, 3.10),
 (5, @d0 + INTERVAL 2 DAY, 'DINNER', 460, 430, 199.00, 18.51),
 (6, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 286, 275, 73.64, 8.30),
 (6, @d0 + INTERVAL 2 DAY, 'LUNCH', 343, 342, 158.98, 7.79),
 (6, @d0 + INTERVAL 2 DAY, 'SNACKS', 184, 182, 22.74, 0.33),
 (6, @d0 + INTERVAL 2 DAY, 'DINNER', 359, 351, 155.30, 3.56),
 (1, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 565, 545, 145.49, 4.93),
 (1, @d0 + INTERVAL 3 DAY, 'LUNCH', 739, 712, 342.53, 17.60),
 (1, @d0 + INTERVAL 3 DAY, 'SNACKS', 372, 363, 45.98, 1.61),
 (1, @d0 + INTERVAL 3 DAY, 'DINNER', 739, 718, 319.69, 13.11),
 (2, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 415, 387, 106.86, 9.25),
 (2, @d0 + INTERVAL 3 DAY, 'LUNCH', 543, 519, 251.68, 15.25),
 (2, @d0 + INTERVAL 3 DAY, 'SNACKS', 301, 284, 37.20, 3.02),
 (2, @d0 + INTERVAL 3 DAY, 'DINNER', 560, 502, 242.26, 41.09),
 (3, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 495, 457, 127.46, 13.53),
 (3, @d0 + INTERVAL 3 DAY, 'LUNCH', 605, 553, 280.42, 37.67),
 (3, @d0 + INTERVAL 3 DAY, 'SNACKS', 324, 307, 40.05, 3.30),
 (3, @d0 + INTERVAL 3 DAY, 'DINNER', 586, 547, 253.50, 24.43),
 (4, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 223, 211, 57.42, 5.75),
 (4, @d0 + INTERVAL 3 DAY, 'LUNCH', 262, 256, 121.44, 6.04),
 (4, @d0 + INTERVAL 3 DAY, 'DINNER', 267, 262, 115.50, 7.27),
 (5, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 353, 323, 90.90, 10.30),
 (5, @d0 + INTERVAL 3 DAY, 'LUNCH', 443, 382, 205.33, 35.23),
 (5, @d0 + INTERVAL 3 DAY, 'SNACKS', 250, 234, 30.90, 3.34),
 (5, @d0 + INTERVAL 3 DAY, 'DINNER', 471, 448, 203.75, 13.03),
 (6, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 300, 282, 77.25, 4.47),
 (6, @d0 + INTERVAL 3 DAY, 'LUNCH', 376, 347, 174.28, 17.26),
 (6, @d0 + INTERVAL 3 DAY, 'SNACKS', 184, 164, 22.74, 3.38),
 (6, @d0 + INTERVAL 3 DAY, 'DINNER', 342, 329, 147.95, 7.79),
 (1, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 564, 501, 145.23, 14.47),
 (1, @d0 + INTERVAL 4 DAY, 'LUNCH', 695, 666, 322.13, 16.08),
 (1, @d0 + INTERVAL 4 DAY, 'SNACKS', 380, 375, 46.97, 0.80),
 (1, @d0 + INTERVAL 4 DAY, 'DINNER', 727, 689, 314.50, 15.28),
 (2, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 434, 365, 111.76, 17.83),
 (2, @d0 + INTERVAL 4 DAY, 'LUNCH', 557, 509, 258.17, 15.42),
 (2, @d0 + INTERVAL 4 DAY, 'SNACKS', 295, 278, 36.46, 3.17),
 (2, @d0 + INTERVAL 4 DAY, 'DINNER', 546, 515, 236.20, 21.98),
 (3, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 499, 431, 128.49, 25.61),
 (3, @d0 + INTERVAL 4 DAY, 'LUNCH', 614, 564, 284.59, 29.05),
 (3, @d0 + INTERVAL 4 DAY, 'SNACKS', 332, 303, 41.04, 4.54),
 (3, @d0 + INTERVAL 4 DAY, 'DINNER', 596, 547, 257.83, 29.86),
 (4, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 208, 195, 53.56, 4.22),
 (4, @d0 + INTERVAL 4 DAY, 'LUNCH', 273, 265, 126.54, 10.94),
 (4, @d0 + INTERVAL 4 DAY, 'DINNER', 281, 264, 121.56, 9.22),
 (5, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 364, 340, 93.73, 5.27),
 (5, @d0 + INTERVAL 4 DAY, 'LUNCH', 430, 416, 199.31, 12.60),
 (5, @d0 + INTERVAL 4 DAY, 'SNACKS', 236, 229, 29.17, 0.33),
 (5, @d0 + INTERVAL 4 DAY, 'DINNER', 453, 432, 195.97, 15.85),
 (6, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 296, 272, 76.22, 8.89),
 (6, @d0 + INTERVAL 4 DAY, 'LUNCH', 342, 335, 158.52, 7.55),
 (6, @d0 + INTERVAL 4 DAY, 'SNACKS', 191, 176, 23.61, 1.32),
 (6, @d0 + INTERVAL 4 DAY, 'DINNER', 364, 337, 157.47, 8.17),
 (1, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 549, 492, 141.37, 19.73),
 (1, @d0 + INTERVAL 5 DAY, 'LUNCH', 715, 596, 331.40, 63.83),
 (1, @d0 + INTERVAL 5 DAY, 'SNACKS', 374, 325, 46.23, 7.60),
 (1, @d0 + INTERVAL 5 DAY, 'DINNER', 700, 607, 302.82, 45.36),
 (2, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 417, 346, 107.38, 25.14);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (2, @d0 + INTERVAL 5 DAY, 'LUNCH', 530, 451, 245.66, 35.52),
 (2, @d0 + INTERVAL 5 DAY, 'SNACKS', 296, 250, 36.59, 6.42),
 (2, @d0 + INTERVAL 5 DAY, 'DINNER', 547, 478, 236.63, 34.82),
 (3, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 466, 405, 120.00, 24.69),
 (3, @d0 + INTERVAL 5 DAY, 'LUNCH', 593, 500, 274.86, 52.20),
 (3, @d0 + INTERVAL 5 DAY, 'SNACKS', 313, 270, 38.69, 6.24),
 (3, @d0 + INTERVAL 5 DAY, 'DINNER', 607, 504, 262.59, 43.93),
 (4, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 210, 172, 54.08, 12.12),
 (4, @d0 + INTERVAL 5 DAY, 'LUNCH', 271, 233, 125.61, 21.89),
 (4, @d0 + INTERVAL 5 DAY, 'DINNER', 269, 227, 116.37, 19.37),
 (5, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 342, 304, 88.06, 10.75),
 (5, @d0 + INTERVAL 5 DAY, 'LUNCH', 470, 408, 217.84, 37.49),
 (5, @d0 + INTERVAL 5 DAY, 'SNACKS', 250, 221, 30.90, 3.25),
 (5, @d0 + INTERVAL 5 DAY, 'DINNER', 442, 388, 191.21, 26.07),
 (6, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 294, 253, 75.70, 13.47),
 (6, @d0 + INTERVAL 5 DAY, 'LUNCH', 376, 311, 174.28, 34.47),
 (6, @d0 + INTERVAL 5 DAY, 'SNACKS', 191, 160, 23.61, 4.78),
 (6, @d0 + INTERVAL 5 DAY, 'DINNER', 356, 305, 154.01, 24.66),
 (1, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 575, 521, 148.06, 17.07),
 (1, @d0 + INTERVAL 6 DAY, 'LUNCH', 691, 566, 320.28, 62.12),
 (1, @d0 + INTERVAL 6 DAY, 'SNACKS', 382, 346, 47.22, 6.64),
 (1, @d0 + INTERVAL 6 DAY, 'DINNER', 720, 598, 311.47, 61.94),
 (2, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 434, 376, 111.76, 14.78),
 (2, @d0 + INTERVAL 6 DAY, 'LUNCH', 514, 418, 238.24, 49.02),
 (2, @d0 + INTERVAL 6 DAY, 'SNACKS', 276, 223, 34.11, 8.26),
 (2, @d0 + INTERVAL 6 DAY, 'DINNER', 529, 461, 228.85, 34.79),
 (3, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 456, 380, 117.42, 17.92),
 (3, @d0 + INTERVAL 6 DAY, 'LUNCH', 587, 522, 272.07, 42.70),
 (3, @d0 + INTERVAL 6 DAY, 'SNACKS', 320, 271, 39.55, 7.77),
 (3, @d0 + INTERVAL 6 DAY, 'DINNER', 615, 523, 266.05, 48.90),
 (4, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 207, 172, 53.30, 10.10),
 (4, @d0 + INTERVAL 6 DAY, 'LUNCH', 271, 231, 125.61, 21.90),
 (4, @d0 + INTERVAL 6 DAY, 'DINNER', 278, 219, 120.26, 27.69),
 (5, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 342, 286, 88.06, 16.31),
 (5, @d0 + INTERVAL 6 DAY, 'LUNCH', 437, 366, 202.55, 41.76),
 (5, @d0 + INTERVAL 6 DAY, 'SNACKS', 233, 188, 28.80, 6.64),
 (5, @d0 + INTERVAL 6 DAY, 'DINNER', 450, 386, 194.67, 31.67),
 (6, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 299, 247, 76.99, 17.46),
 (6, @d0 + INTERVAL 6 DAY, 'LUNCH', 368, 317, 170.57, 33.05),
 (6, @d0 + INTERVAL 6 DAY, 'SNACKS', 186, 171, 22.99, 1.75),
 (6, @d0 + INTERVAL 6 DAY, 'DINNER', 363, 302, 157.03, 27.63),
 (1, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 592, 568, 152.44, 7.20),
 (1, @d0 + INTERVAL 7 DAY, 'LUNCH', 718, 683, 332.79, 13.96),
 (1, @d0 + INTERVAL 7 DAY, 'SNACKS', 369, 369, 45.61, 0.00),
 (1, @d0 + INTERVAL 7 DAY, 'DINNER', 684, 635, 295.90, 28.82),
 (2, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 412, 373, 106.09, 10.71),
 (2, @d0 + INTERVAL 7 DAY, 'LUNCH', 540, 522, 250.29, 24.25),
 (2, @d0 + INTERVAL 7 DAY, 'SNACKS', 295, 282, 36.46, 2.41),
 (2, @d0 + INTERVAL 7 DAY, 'DINNER', 534, 497, 231.01, 25.66),
 (3, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 467, 462, 120.25, 1.82),
 (3, @d0 + INTERVAL 7 DAY, 'LUNCH', 605, 580, 280.42, 10.47),
 (3, @d0 + INTERVAL 7 DAY, 'SNACKS', 305, 281, 37.70, 3.91),
 (3, @d0 + INTERVAL 7 DAY, 'DINNER', 619, 619, 267.78, 9.63),
 (4, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 224, 224, 57.68, 0.00),
 (4, @d0 + INTERVAL 7 DAY, 'LUNCH', 260, 242, 120.51, 14.56),
 (4, @d0 + INTERVAL 7 DAY, 'DINNER', 275, 275, 118.97, 1.42),
 (5, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 359, 334, 92.44, 10.38),
 (5, @d0 + INTERVAL 7 DAY, 'LUNCH', 446, 427, 206.72, 15.29),
 (5, @d0 + INTERVAL 7 DAY, 'SNACKS', 249, 243, 30.78, 3.77),
 (5, @d0 + INTERVAL 7 DAY, 'DINNER', 463, 446, 200.29, 8.62);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (6, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 295, 273, 75.96, 9.24),
 (6, @d0 + INTERVAL 7 DAY, 'LUNCH', 360, 324, 166.86, 17.31),
 (6, @d0 + INTERVAL 7 DAY, 'SNACKS', 187, 173, 23.11, 2.10),
 (6, @d0 + INTERVAL 7 DAY, 'DINNER', 351, 331, 151.84, 9.84),
 (1, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 588, 516, 151.41, 23.71),
 (1, @d0 + INTERVAL 8 DAY, 'LUNCH', 709, 647, 328.62, 35.78),
 (1, @d0 + INTERVAL 8 DAY, 'SNACKS', 399, 392, 49.32, 1.69),
 (1, @d0 + INTERVAL 8 DAY, 'DINNER', 707, 694, 305.85, 17.94),
 (2, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 434, 395, 111.76, 16.65),
 (2, @d0 + INTERVAL 8 DAY, 'LUNCH', 554, 534, 256.78, 23.45),
 (2, @d0 + INTERVAL 8 DAY, 'SNACKS', 295, 265, 36.46, 3.39),
 (2, @d0 + INTERVAL 8 DAY, 'DINNER', 560, 522, 242.26, 24.10),
 (3, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 457, 412, 117.68, 15.29),
 (3, @d0 + INTERVAL 8 DAY, 'LUNCH', 607, 567, 281.34, 26.39),
 (3, @d0 + INTERVAL 8 DAY, 'SNACKS', 308, 303, 38.07, 1.84),
 (3, @d0 + INTERVAL 8 DAY, 'DINNER', 623, 560, 269.51, 35.06),
 (4, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 210, 204, 54.08, 4.11),
 (4, @d0 + INTERVAL 8 DAY, 'LUNCH', 283, 264, 131.17, 17.73),
 (4, @d0 + INTERVAL 8 DAY, 'DINNER', 257, 247, 111.18, 4.87),
 (5, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 368, 355, 94.76, 5.40),
 (5, @d0 + INTERVAL 8 DAY, 'LUNCH', 457, 424, 211.82, 21.44),
 (5, @d0 + INTERVAL 8 DAY, 'SNACKS', 238, 222, 29.42, 2.81),
 (5, @d0 + INTERVAL 8 DAY, 'DINNER', 439, 405, 189.91, 17.36),
 (6, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 275, 261, 70.81, 4.32),
 (6, @d0 + INTERVAL 8 DAY, 'LUNCH', 351, 324, 162.69, 23.39),
 (6, @d0 + INTERVAL 8 DAY, 'SNACKS', 185, 173, 22.87, 1.49),
 (6, @d0 + INTERVAL 8 DAY, 'DINNER', 351, 323, 151.84, 11.55),
 (1, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 578, 560, 148.84, 12.83),
 (1, @d0 + INTERVAL 9 DAY, 'LUNCH', 711, 668, 329.55, 33.06),
 (1, @d0 + INTERVAL 9 DAY, 'SNACKS', 376, 355, 46.47, 4.40),
 (1, @d0 + INTERVAL 9 DAY, 'DINNER', 747, 712, 323.15, 25.67),
 (2, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 431, 413, 110.98, 6.05),
 (2, @d0 + INTERVAL 9 DAY, 'LUNCH', 557, 557, 258.17, 7.88),
 (2, @d0 + INTERVAL 9 DAY, 'SNACKS', 289, 287, 35.72, 1.36),
 (2, @d0 + INTERVAL 9 DAY, 'DINNER', 554, 523, 239.66, 15.15),
 (3, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 467, 438, 120.25, 10.78),
 (3, @d0 + INTERVAL 9 DAY, 'LUNCH', 571, 538, 264.66, 28.57),
 (3, @d0 + INTERVAL 9 DAY, 'SNACKS', 319, 297, 39.43, 4.87),
 (3, @d0 + INTERVAL 9 DAY, 'DINNER', 619, 560, 267.78, 31.79),
 (4, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 209, 200, 53.82, 5.22),
 (4, @d0 + INTERVAL 9 DAY, 'LUNCH', 260, 254, 120.51, 7.14),
 (4, @d0 + INTERVAL 9 DAY, 'DINNER', 277, 262, 119.83, 11.20),
 (5, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 368, 348, 94.76, 7.54),
 (5, @d0 + INTERVAL 9 DAY, 'LUNCH', 460, 418, 213.21, 22.18),
 (5, @d0 + INTERVAL 9 DAY, 'SNACKS', 243, 230, 30.03, 3.03),
 (5, @d0 + INTERVAL 9 DAY, 'DINNER', 442, 416, 191.21, 14.48),
 (6, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 296, 296, 76.22, 1.65),
 (6, @d0 + INTERVAL 9 DAY, 'LUNCH', 347, 336, 160.83, 13.19),
 (6, @d0 + INTERVAL 9 DAY, 'SNACKS', 191, 189, 23.61, 1.20),
 (6, @d0 + INTERVAL 9 DAY, 'DINNER', 376, 351, 162.66, 15.69),
 (1, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 548, 540, 141.11, 6.49),
 (1, @d0 + INTERVAL 10 DAY, 'LUNCH', 711, 645, 329.55, 30.50),
 (1, @d0 + INTERVAL 10 DAY, 'SNACKS', 381, 353, 47.09, 5.12),
 (1, @d0 + INTERVAL 10 DAY, 'DINNER', 717, 677, 310.17, 28.37),
 (2, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 451, 417, 116.13, 13.87),
 (2, @d0 + INTERVAL 10 DAY, 'LUNCH', 556, 525, 257.71, 21.59),
 (2, @d0 + INTERVAL 10 DAY, 'SNACKS', 291, 279, 35.97, 2.42),
 (2, @d0 + INTERVAL 10 DAY, 'DINNER', 560, 541, 242.26, 13.84),
 (3, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 472, 466, 121.54, 8.37),
 (3, @d0 + INTERVAL 10 DAY, 'LUNCH', 585, 576, 271.15, 5.17);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (3, @d0 + INTERVAL 10 DAY, 'SNACKS', 322, 302, 39.80, 4.05),
 (3, @d0 + INTERVAL 10 DAY, 'DINNER', 623, 556, 269.51, 40.74),
 (4, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 223, 213, 57.42, 4.30),
 (4, @d0 + INTERVAL 10 DAY, 'LUNCH', 266, 242, 123.29, 14.15),
 (4, @d0 + INTERVAL 10 DAY, 'DINNER', 258, 234, 111.61, 12.90),
 (5, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 377, 377, 97.08, 2.25),
 (5, @d0 + INTERVAL 10 DAY, 'LUNCH', 427, 422, 197.91, 10.53),
 (5, @d0 + INTERVAL 10 DAY, 'SNACKS', 237, 216, 29.29, 4.34),
 (5, @d0 + INTERVAL 10 DAY, 'DINNER', 431, 407, 186.45, 19.72),
 (6, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 286, 270, 73.64, 4.87),
 (6, @d0 + INTERVAL 10 DAY, 'LUNCH', 369, 347, 171.03, 14.82),
 (6, @d0 + INTERVAL 10 DAY, 'SNACKS', 183, 167, 22.62, 2.08),
 (6, @d0 + INTERVAL 10 DAY, 'DINNER', 365, 353, 157.90, 13.19),
 (1, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 560, 541, 144.20, 12.13),
 (1, @d0 + INTERVAL 11 DAY, 'LUNCH', 724, 664, 335.57, 40.59),
 (1, @d0 + INTERVAL 11 DAY, 'SNACKS', 372, 361, 45.98, 3.03),
 (1, @d0 + INTERVAL 11 DAY, 'DINNER', 704, 675, 378.47, 97.60),
 (2, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 415, 414, 106.86, 1.95),
 (2, @d0 + INTERVAL 11 DAY, 'LUNCH', 543, 541, 251.68, 8.59),
 (2, @d0 + INTERVAL 11 DAY, 'SNACKS', 278, 265, 34.36, 3.19),
 (2, @d0 + INTERVAL 11 DAY, 'DINNER', 540, 508, 233.60, 33.07),
 (3, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 474, 469, 122.06, 2.79),
 (3, @d0 + INTERVAL 11 DAY, 'LUNCH', 594, 571, 275.32, 14.80),
 (3, @d0 + INTERVAL 11 DAY, 'SNACKS', 320, 297, 39.55, 2.45),
 (3, @d0 + INTERVAL 11 DAY, 'DINNER', 605, 565, 261.72, 16.69),
 (4, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 220, 203, 56.65, 7.02),
 (4, @d0 + INTERVAL 11 DAY, 'LUNCH', 268, 249, 124.22, 13.53),
 (4, @d0 + INTERVAL 11 DAY, 'DINNER', 262, 254, 140.85, 29.81),
 (5, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 375, 355, 96.56, 7.24),
 (5, @d0 + INTERVAL 11 DAY, 'LUNCH', 446, 393, 206.72, 45.95),
 (5, @d0 + INTERVAL 11 DAY, 'SNACKS', 235, 224, 29.05, 2.33),
 (5, @d0 + INTERVAL 11 DAY, 'DINNER', 463, 442, 200.29, 13.12),
 (6, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 276, 259, 71.07, 4.91),
 (6, @d0 + INTERVAL 11 DAY, 'LUNCH', 372, 357, 172.42, 17.16),
 (6, @d0 + INTERVAL 11 DAY, 'SNACKS', 186, 171, 22.99, 3.23),
 (6, @d0 + INTERVAL 11 DAY, 'DINNER', 353, 324, 152.71, 14.35),
 (1, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 566, 505, 145.75, 17.82),
 (1, @d0 + INTERVAL 12 DAY, 'LUNCH', 711, 615, 329.55, 64.26),
 (1, @d0 + INTERVAL 12 DAY, 'SNACKS', 397, 330, 49.07, 10.33),
 (1, @d0 + INTERVAL 12 DAY, 'DINNER', 722, 579, 312.34, 68.86),
 (2, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 420, 365, 108.15, 13.75),
 (2, @d0 + INTERVAL 12 DAY, 'LUNCH', 561, 456, 260.02, 49.51),
 (2, @d0 + INTERVAL 12 DAY, 'SNACKS', 284, 231, 35.10, 6.94),
 (2, @d0 + INTERVAL 12 DAY, 'DINNER', 544, 469, 235.33, 35.49),
 (3, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 474, 397, 122.06, 22.30),
 (3, @d0 + INTERVAL 12 DAY, 'LUNCH', 583, 478, 270.22, 51.84),
 (3, @d0 + INTERVAL 12 DAY, 'SNACKS', 327, 274, 40.42, 6.99),
 (3, @d0 + INTERVAL 12 DAY, 'DINNER', 595, 505, 257.40, 45.79),
 (4, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 220, 191, 56.65, 9.71),
 (4, @d0 + INTERVAL 12 DAY, 'LUNCH', 270, 233, 125.15, 19.95),
 (4, @d0 + INTERVAL 12 DAY, 'DINNER', 257, 203, 111.18, 24.23),
 (5, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 346, 301, 89.09, 14.38),
 (5, @d0 + INTERVAL 12 DAY, 'LUNCH', 470, 389, 217.84, 38.75),
 (5, @d0 + INTERVAL 12 DAY, 'SNACKS', 246, 198, 30.41, 6.26),
 (5, @d0 + INTERVAL 12 DAY, 'DINNER', 448, 390, 193.80, 28.05),
 (6, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 301, 258, 77.51, 14.52),
 (6, @d0 + INTERVAL 12 DAY, 'LUNCH', 362, 313, 167.79, 31.08),
 (6, @d0 + INTERVAL 12 DAY, 'SNACKS', 200, 176, 24.72, 2.85),
 (6, @d0 + INTERVAL 12 DAY, 'DINNER', 356, 303, 154.01, 28.32),
 (1, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 584, 503, 150.38, 25.72);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (1, @d0 + INTERVAL 13 DAY, 'LUNCH', 706, 601, 327.23, 61.61),
 (1, @d0 + INTERVAL 13 DAY, 'SNACKS', 393, 326, 48.57, 9.00),
 (1, @d0 + INTERVAL 13 DAY, 'DINNER', 695, 562, 300.66, 64.12),
 (2, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 414, 342, 106.61, 22.56),
 (2, @d0 + INTERVAL 13 DAY, 'LUNCH', 540, 455, 250.29, 48.16),
 (2, @d0 + INTERVAL 13 DAY, 'SNACKS', 278, 240, 34.36, 4.59),
 (2, @d0 + INTERVAL 13 DAY, 'DINNER', 527, 465, 227.98, 31.71),
 (3, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 474, 408, 122.06, 19.75),
 (3, @d0 + INTERVAL 13 DAY, 'LUNCH', 619, 534, 286.91, 50.56),
 (3, @d0 + INTERVAL 13 DAY, 'SNACKS', 306, 249, 37.82, 6.29),
 (3, @d0 + INTERVAL 13 DAY, 'DINNER', 608, 499, 263.02, 53.19),
 (4, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 217, 185, 55.88, 9.28),
 (4, @d0 + INTERVAL 13 DAY, 'LUNCH', 262, 220, 121.44, 24.15),
 (4, @d0 + INTERVAL 13 DAY, 'DINNER', 272, 244, 117.67, 13.45),
 (5, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 360, 296, 92.70, 19.24),
 (5, @d0 + INTERVAL 13 DAY, 'LUNCH', 463, 351, 214.60, 49.68),
 (5, @d0 + INTERVAL 13 DAY, 'SNACKS', 228, 190, 28.18, 6.10),
 (5, @d0 + INTERVAL 13 DAY, 'DINNER', 453, 414, 195.97, 30.45),
 (6, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 286, 241, 73.64, 13.28),
 (6, @d0 + INTERVAL 13 DAY, 'LUNCH', 368, 312, 170.57, 23.45),
 (6, @d0 + INTERVAL 13 DAY, 'SNACKS', 195, 169, 24.10, 3.74),
 (6, @d0 + INTERVAL 13 DAY, 'DINNER', 362, 293, 156.60, 33.82),
 (1, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 577, 532, 148.58, 17.18),
 (1, @d0 + INTERVAL 14 DAY, 'LUNCH', 697, 635, 323.06, 35.19),
 (1, @d0 + INTERVAL 14 DAY, 'SNACKS', 395, 392, 48.82, 1.81),
 (1, @d0 + INTERVAL 14 DAY, 'DINNER', 726, 674, 314.07, 41.95),
 (2, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 428, 396, 110.21, 15.81),
 (2, @d0 + INTERVAL 14 DAY, 'LUNCH', 553, 543, 256.32, 7.64),
 (2, @d0 + INTERVAL 14 DAY, 'SNACKS', 275, 269, 33.99, 1.28),
 (2, @d0 + INTERVAL 14 DAY, 'DINNER', 533, 509, 230.58, 22.77),
 (3, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 497, 472, 127.98, 12.16),
 (3, @d0 + INTERVAL 14 DAY, 'LUNCH', 578, 553, 267.90, 19.09),
 (3, @d0 + INTERVAL 14 DAY, 'SNACKS', 322, 310, 39.80, 2.14),
 (3, @d0 + INTERVAL 14 DAY, 'DINNER', 625, 584, 270.38, 26.16),
 (4, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 210, 203, 54.08, 2.94),
 (4, @d0 + INTERVAL 14 DAY, 'LUNCH', 270, 249, 125.15, 12.78),
 (4, @d0 + INTERVAL 14 DAY, 'DINNER', 267, 265, 115.50, 4.87),
 (5, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 371, 352, 95.53, 7.31),
 (5, @d0 + INTERVAL 14 DAY, 'LUNCH', 446, 444, 206.72, 4.15),
 (5, @d0 + INTERVAL 14 DAY, 'SNACKS', 247, 238, 30.53, 1.78),
 (5, @d0 + INTERVAL 14 DAY, 'DINNER', 443, 434, 191.64, 7.71),
 (6, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 300, 285, 77.25, 8.44),
 (6, @d0 + INTERVAL 14 DAY, 'LUNCH', 375, 347, 173.81, 15.56),
 (6, @d0 + INTERVAL 14 DAY, 'SNACKS', 194, 184, 23.98, 1.73),
 (6, @d0 + INTERVAL 14 DAY, 'DINNER', 350, 343, 151.41, 10.06),
 (1, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 562, 549, 144.72, 6.85),
 (1, @d0 + INTERVAL 15 DAY, 'LUNCH', 710, 666, 329.09, 22.35),
 (1, @d0 + INTERVAL 15 DAY, 'SNACKS', 402, 367, 49.69, 5.23),
 (1, @d0 + INTERVAL 15 DAY, 'DINNER', 703, 693, 304.12, 15.71),
 (2, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 441, 412, 113.56, 9.70),
 (2, @d0 + INTERVAL 15 DAY, 'LUNCH', 513, 477, 237.78, 16.11),
 (2, @d0 + INTERVAL 15 DAY, 'SNACKS', 287, 264, 35.47, 5.57),
 (2, @d0 + INTERVAL 15 DAY, 'DINNER', 536, 530, 231.87, 9.68),
 (3, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 480, 458, 123.60, 10.24),
 (3, @d0 + INTERVAL 15 DAY, 'LUNCH', 576, 550, 266.98, 25.68),
 (3, @d0 + INTERVAL 15 DAY, 'SNACKS', 325, 303, 40.17, 4.86),
 (3, @d0 + INTERVAL 15 DAY, 'DINNER', 606, 556, 262.16, 31.34),
 (4, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 211, 196, 54.33, 6.08),
 (4, @d0 + INTERVAL 15 DAY, 'LUNCH', 273, 268, 126.54, 7.30),
 (4, @d0 + INTERVAL 15 DAY, 'DINNER', 278, 266, 120.26, 6.67);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (5, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 373, 371, 96.05, 5.55),
 (5, @d0 + INTERVAL 15 DAY, 'LUNCH', 438, 402, 203.01, 23.50),
 (5, @d0 + INTERVAL 15 DAY, 'SNACKS', 238, 233, 29.42, 1.88),
 (5, @d0 + INTERVAL 15 DAY, 'DINNER', 464, 442, 200.73, 16.74),
 (6, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 278, 249, 71.59, 9.43),
 (6, @d0 + INTERVAL 15 DAY, 'LUNCH', 377, 351, 174.74, 14.45),
 (6, @d0 + INTERVAL 15 DAY, 'SNACKS', 192, 189, 23.73, 1.72),
 (6, @d0 + INTERVAL 15 DAY, 'DINNER', 347, 347, 150.11, 6.38),
 (1, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 589, 559, 151.67, 10.63),
 (1, @d0 + INTERVAL 16 DAY, 'LUNCH', 718, 694, 332.79, 17.71),
 (1, @d0 + INTERVAL 16 DAY, 'SNACKS', 401, 363, 49.56, 6.59),
 (1, @d0 + INTERVAL 16 DAY, 'DINNER', 749, 749, 324.02, 8.48),
 (2, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 442, 433, 113.81, 5.59),
 (2, @d0 + INTERVAL 16 DAY, 'LUNCH', 554, 538, 256.78, 12.03),
 (2, @d0 + INTERVAL 16 DAY, 'SNACKS', 302, 290, 37.33, 3.50),
 (2, @d0 + INTERVAL 16 DAY, 'DINNER', 531, 486, 229.71, 24.71),
 (3, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 489, 485, 125.92, 5.43),
 (3, @d0 + INTERVAL 16 DAY, 'LUNCH', 609, 585, 282.27, 5.83),
 (3, @d0 + INTERVAL 16 DAY, 'SNACKS', 305, 304, 37.70, 1.23),
 (3, @d0 + INTERVAL 16 DAY, 'DINNER', 590, 565, 255.23, 5.76),
 (4, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 220, 219, 56.65, 3.66),
 (4, @d0 + INTERVAL 16 DAY, 'LUNCH', 272, 257, 126.07, 12.35),
 (4, @d0 + INTERVAL 16 DAY, 'DINNER', 266, 244, 115.07, 11.34),
 (5, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 361, 341, 92.96, 6.41),
 (5, @d0 + INTERVAL 16 DAY, 'LUNCH', 431, 418, 199.77, 14.73),
 (5, @d0 + INTERVAL 16 DAY, 'SNACKS', 230, 217, 28.43, 3.41),
 (5, @d0 + INTERVAL 16 DAY, 'DINNER', 430, 403, 186.02, 16.02),
 (6, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 280, 276, 72.10, 1.09),
 (6, @d0 + INTERVAL 16 DAY, 'LUNCH', 366, 342, 169.64, 17.22),
 (6, @d0 + INTERVAL 16 DAY, 'SNACKS', 198, 183, 24.47, 2.29),
 (6, @d0 + INTERVAL 16 DAY, 'DINNER', 367, 334, 158.76, 10.89),
 (1, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 579, 542, 149.09, 14.63),
 (1, @d0 + INTERVAL 17 DAY, 'LUNCH', 755, 723, 349.94, 16.83),
 (1, @d0 + INTERVAL 17 DAY, 'SNACKS', 389, 389, 48.08, 0.62),
 (1, @d0 + INTERVAL 17 DAY, 'DINNER', 705, 672, 304.98, 31.17),
 (2, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 436, 416, 112.27, 4.02),
 (2, @d0 + INTERVAL 17 DAY, 'LUNCH', 514, 504, 238.24, 14.54),
 (2, @d0 + INTERVAL 17 DAY, 'SNACKS', 294, 282, 36.34, 2.47),
 (2, @d0 + INTERVAL 17 DAY, 'DINNER', 527, 497, 227.98, 18.30),
 (3, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 459, 433, 118.19, 10.69),
 (3, @d0 + INTERVAL 17 DAY, 'LUNCH', 587, 523, 272.07, 42.08),
 (3, @d0 + INTERVAL 17 DAY, 'SNACKS', 312, 285, 38.56, 4.11),
 (3, @d0 + INTERVAL 17 DAY, 'DINNER', 613, 588, 265.18, 21.20),
 (4, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 221, 199, 56.91, 6.31),
 (4, @d0 + INTERVAL 17 DAY, 'LUNCH', 275, 268, 127.46, 4.53),
 (4, @d0 + INTERVAL 17 DAY, 'DINNER', 257, 239, 111.18, 9.90),
 (5, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 349, 328, 89.87, 7.16),
 (5, @d0 + INTERVAL 17 DAY, 'LUNCH', 443, 405, 205.33, 19.92),
 (5, @d0 + INTERVAL 17 DAY, 'SNACKS', 239, 223, 29.54, 2.96),
 (5, @d0 + INTERVAL 17 DAY, 'DINNER', 463, 410, 200.29, 33.18),
 (6, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 294, 280, 75.70, 3.86),
 (6, @d0 + INTERVAL 17 DAY, 'LUNCH', 357, 349, 165.47, 12.65),
 (6, @d0 + INTERVAL 17 DAY, 'SNACKS', 196, 183, 24.23, 2.05),
 (6, @d0 + INTERVAL 17 DAY, 'DINNER', 357, 321, 154.44, 25.76),
 (1, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 555, 389, 142.91, 43.02),
 (1, @d0 + INTERVAL 18 DAY, 'LUNCH', 722, 541, 334.65, 87.70),
 (1, @d0 + INTERVAL 18 DAY, 'SNACKS', 364, 248, 44.99, 15.61),
 (1, @d0 + INTERVAL 18 DAY, 'DINNER', 755, 551, 326.61, 102.12),
 (2, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 449, 318, 115.62, 38.24),
 (2, @d0 + INTERVAL 18 DAY, 'LUNCH', 523, 390, 242.41, 61.57);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (2, @d0 + INTERVAL 18 DAY, 'SNACKS', 287, 208, 35.47, 10.21),
 (2, @d0 + INTERVAL 18 DAY, 'DINNER', 516, 411, 223.22, 48.41),
 (3, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 472, 331, 121.54, 41.72),
 (3, @d0 + INTERVAL 18 DAY, 'LUNCH', 574, 433, 266.05, 80.09),
 (3, @d0 + INTERVAL 18 DAY, 'SNACKS', 312, 220, 38.56, 12.97),
 (3, @d0 + INTERVAL 18 DAY, 'DINNER', 597, 441, 258.26, 73.76),
 (4, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 208, 164, 53.56, 11.76),
 (4, @d0 + INTERVAL 18 DAY, 'LUNCH', 277, 183, 128.39, 48.09),
 (4, @d0 + INTERVAL 18 DAY, 'DINNER', 257, 178, 111.18, 34.59),
 (5, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 371, 287, 95.53, 23.47),
 (5, @d0 + INTERVAL 18 DAY, 'LUNCH', 452, 323, 209.50, 63.54),
 (5, @d0 + INTERVAL 18 DAY, 'SNACKS', 244, 185, 30.16, 8.84),
 (5, @d0 + INTERVAL 18 DAY, 'DINNER', 437, 326, 189.05, 55.02),
 (6, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 287, 203, 73.90, 22.67),
 (6, @d0 + INTERVAL 18 DAY, 'LUNCH', 363, 278, 168.25, 37.50),
 (6, @d0 + INTERVAL 18 DAY, 'SNACKS', 186, 135, 22.99, 6.64),
 (6, @d0 + INTERVAL 18 DAY, 'DINNER', 346, 271, 149.68, 37.63),
 (1, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 575, 386, 148.06, 53.69),
 (1, @d0 + INTERVAL 19 DAY, 'LUNCH', 736, 470, 341.14, 126.93),
 (1, @d0 + INTERVAL 19 DAY, 'SNACKS', 387, 242, 47.83, 19.08),
 (1, @d0 + INTERVAL 19 DAY, 'DINNER', 752, 477, 325.32, 122.20),
 (2, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 430, 250, 110.73, 49.31),
 (2, @d0 + INTERVAL 19 DAY, 'LUNCH', 566, 369, 262.34, 102.65),
 (2, @d0 + INTERVAL 19 DAY, 'SNACKS', 300, 192, 37.08, 13.82),
 (2, @d0 + INTERVAL 19 DAY, 'DINNER', 566, 356, 244.85, 93.40),
 (3, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 465, 287, 119.74, 49.55),
 (3, @d0 + INTERVAL 19 DAY, 'LUNCH', 587, 371, 272.07, 104.75),
 (3, @d0 + INTERVAL 19 DAY, 'SNACKS', 333, 208, 41.16, 16.25),
 (3, @d0 + INTERVAL 19 DAY, 'DINNER', 607, 353, 262.59, 114.95),
 (4, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 219, 142, 56.39, 21.36),
 (4, @d0 + INTERVAL 19 DAY, 'LUNCH', 281, 194, 130.24, 44.92),
 (4, @d0 + INTERVAL 19 DAY, 'DINNER', 277, 170, 119.83, 46.27),
 (5, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 359, 236, 92.44, 34.41),
 (5, @d0 + INTERVAL 19 DAY, 'LUNCH', 453, 294, 209.97, 78.74),
 (5, @d0 + INTERVAL 19 DAY, 'SNACKS', 236, 145, 29.17, 10.88),
 (5, @d0 + INTERVAL 19 DAY, 'DINNER', 462, 283, 199.86, 77.62),
 (6, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 275, 160, 70.81, 30.81),
 (6, @d0 + INTERVAL 19 DAY, 'LUNCH', 360, 234, 166.86, 62.03),
 (6, @d0 + INTERVAL 19 DAY, 'SNACKS', 191, 122, 23.61, 9.04),
 (6, @d0 + INTERVAL 19 DAY, 'DINNER', 377, 246, 163.09, 64.03),
 (1, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 596, 379, 153.47, 59.99),
 (1, @d0 + INTERVAL 20 DAY, 'LUNCH', 752, 480, 348.55, 134.68),
 (1, @d0 + INTERVAL 20 DAY, 'SNACKS', 385, 242, 47.59, 19.08),
 (1, @d0 + INTERVAL 20 DAY, 'DINNER', 693, 462, 299.79, 111.96),
 (2, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 413, 264, 106.35, 38.55),
 (2, @d0 + INTERVAL 20 DAY, 'LUNCH', 535, 330, 247.97, 91.46),
 (2, @d0 + INTERVAL 20 DAY, 'SNACKS', 279, 173, 34.48, 13.51),
 (2, @d0 + INTERVAL 20 DAY, 'DINNER', 566, 359, 244.85, 96.69),
 (3, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 500, 319, 128.75, 50.81),
 (3, @d0 + INTERVAL 20 DAY, 'LUNCH', 591, 394, 273.93, 92.32),
 (3, @d0 + INTERVAL 20 DAY, 'SNACKS', 312, 197, 38.56, 15.08),
 (3, @d0 + INTERVAL 20 DAY, 'DINNER', 577, 330, 249.61, 109.94),
 (4, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 216, 141, 55.62, 20.66),
 (4, @d0 + INTERVAL 20 DAY, 'LUNCH', 281, 181, 130.24, 50.90),
 (4, @d0 + INTERVAL 20 DAY, 'DINNER', 256, 170, 110.75, 41.85),
 (5, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 348, 213, 89.61, 35.68),
 (5, @d0 + INTERVAL 20 DAY, 'LUNCH', 430, 268, 199.31, 75.87),
 (5, @d0 + INTERVAL 20 DAY, 'SNACKS', 248, 154, 30.65, 12.45),
 (5, @d0 + INTERVAL 20 DAY, 'DINNER', 470, 268, 203.32, 90.03),
 (6, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 286, 173, 73.64, 31.37);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (6, @d0 + INTERVAL 20 DAY, 'LUNCH', 346, 201, 160.37, 68.38),
 (6, @d0 + INTERVAL 20 DAY, 'SNACKS', 191, 117, 23.61, 9.08),
 (6, @d0 + INTERVAL 20 DAY, 'DINNER', 367, 222, 158.76, 65.94),
 (1, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 582, 522, 149.87, 22.43),
 (1, @d0 + INTERVAL 21 DAY, 'LUNCH', 748, 689, 346.70, 34.80),
 (1, @d0 + INTERVAL 21 DAY, 'SNACKS', 398, 388, 49.19, 2.12),
 (1, @d0 + INTERVAL 21 DAY, 'DINNER', 744, 726, 321.85, 17.61),
 (2, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 422, 407, 108.67, 6.90),
 (2, @d0 + INTERVAL 21 DAY, 'LUNCH', 549, 513, 254.46, 19.57),
 (2, @d0 + INTERVAL 21 DAY, 'SNACKS', 301, 281, 37.20, 2.76),
 (2, @d0 + INTERVAL 21 DAY, 'DINNER', 523, 487, 226.25, 20.86),
 (3, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 464, 427, 119.48, 12.69),
 (3, @d0 + INTERVAL 21 DAY, 'LUNCH', 619, 602, 286.91, 7.93),
 (3, @d0 + INTERVAL 21 DAY, 'SNACKS', 304, 304, 37.57, 0.85),
 (3, @d0 + INTERVAL 21 DAY, 'DINNER', 599, 550, 259.13, 31.45),
 (4, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 221, 214, 56.91, 2.90),
 (4, @d0 + INTERVAL 21 DAY, 'LUNCH', 271, 252, 125.61, 13.16),
 (4, @d0 + INTERVAL 21 DAY, 'DINNER', 277, 277, 119.83, 3.40),
 (5, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 344, 343, 88.58, 0.00),
 (5, @d0 + INTERVAL 21 DAY, 'LUNCH', 441, 439, 204.40, 12.79),
 (5, @d0 + INTERVAL 21 DAY, 'SNACKS', 233, 229, 28.80, 1.22),
 (5, @d0 + INTERVAL 21 DAY, 'DINNER', 456, 415, 197.27, 16.68),
 (6, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 281, 267, 72.36, 7.17),
 (6, @d0 + INTERVAL 21 DAY, 'LUNCH', 368, 356, 170.57, 8.66),
 (6, @d0 + INTERVAL 21 DAY, 'SNACKS', 190, 183, 23.48, 1.82),
 (6, @d0 + INTERVAL 21 DAY, 'DINNER', 360, 332, 155.74, 16.18),
 (1, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 561, 446, 144.46, 35.17),
 (1, @d0 + INTERVAL 22 DAY, 'LUNCH', 745, 715, 345.31, 17.95),
 (1, @d0 + INTERVAL 22 DAY, 'SNACKS', 376, 331, 46.47, 6.22),
 (1, @d0 + INTERVAL 22 DAY, 'DINNER', 753, 703, 325.75, 17.00),
 (2, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 448, 367, 115.36, 24.40),
 (2, @d0 + INTERVAL 22 DAY, 'LUNCH', 529, 466, 245.19, 31.41),
 (2, @d0 + INTERVAL 22 DAY, 'SNACKS', 279, 259, 34.48, 3.79),
 (2, @d0 + INTERVAL 22 DAY, 'DINNER', 523, 483, 226.25, 20.35),
 (3, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 481, 386, 123.86, 27.97),
 (3, @d0 + INTERVAL 22 DAY, 'LUNCH', 591, 543, 273.93, 32.05),
 (3, @d0 + INTERVAL 22 DAY, 'SNACKS', 325, 301, 40.17, 3.29),
 (3, @d0 + INTERVAL 22 DAY, 'DINNER', 580, 560, 250.91, 15.62),
 (4, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 213, 179, 54.85, 10.27),
 (4, @d0 + INTERVAL 22 DAY, 'LUNCH', 258, 242, 119.58, 8.54),
 (4, @d0 + INTERVAL 22 DAY, 'DINNER', 278, 261, 120.26, 7.96),
 (5, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 348, 280, 89.61, 20.51),
 (5, @d0 + INTERVAL 22 DAY, 'LUNCH', 430, 386, 199.31, 31.32),
 (5, @d0 + INTERVAL 22 DAY, 'SNACKS', 232, 216, 28.68, 2.89),
 (5, @d0 + INTERVAL 22 DAY, 'DINNER', 440, 440, 190.34, 11.01),
 (6, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 277, 213, 71.33, 18.44),
 (6, @d0 + INTERVAL 22 DAY, 'LUNCH', 353, 322, 163.62, 21.06),
 (6, @d0 + INTERVAL 22 DAY, 'SNACKS', 198, 185, 24.47, 2.77),
 (6, @d0 + INTERVAL 22 DAY, 'DINNER', 364, 338, 157.47, 15.74),
 (1, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 559, 485, 143.94, 24.81),
 (1, @d0 + INTERVAL 23 DAY, 'LUNCH', 752, 718, 348.55, 35.86),
 (1, @d0 + INTERVAL 23 DAY, 'SNACKS', 400, 378, 49.44, 5.18),
 (1, @d0 + INTERVAL 23 DAY, 'DINNER', 722, 681, 312.34, 25.29),
 (2, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 422, 372, 108.67, 13.51),
 (2, @d0 + INTERVAL 23 DAY, 'LUNCH', 533, 506, 247.05, 20.38),
 (2, @d0 + INTERVAL 23 DAY, 'SNACKS', 286, 265, 35.35, 2.60),
 (2, @d0 + INTERVAL 23 DAY, 'DINNER', 537, 495, 232.31, 24.71),
 (3, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 480, 391, 123.60, 20.27),
 (3, @d0 + INTERVAL 23 DAY, 'LUNCH', 590, 580, 273.47, 23.24),
 (3, @d0 + INTERVAL 23 DAY, 'SNACKS', 331, 329, 40.91, 2.16);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (3, @d0 + INTERVAL 23 DAY, 'DINNER', 614, 573, 265.62, 22.23),
 (4, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 226, 203, 58.20, 6.01),
 (4, @d0 + INTERVAL 23 DAY, 'LUNCH', 265, 262, 122.83, 3.63),
 (4, @d0 + INTERVAL 23 DAY, 'DINNER', 262, 262, 113.34, 0.00),
 (5, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 349, 301, 89.87, 14.46),
 (5, @d0 + INTERVAL 23 DAY, 'LUNCH', 466, 437, 215.99, 27.11),
 (5, @d0 + INTERVAL 23 DAY, 'SNACKS', 237, 214, 29.29, 4.02),
 (5, @d0 + INTERVAL 23 DAY, 'DINNER', 471, 441, 203.75, 12.66),
 (6, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 295, 258, 75.96, 10.89),
 (6, @d0 + INTERVAL 23 DAY, 'LUNCH', 343, 331, 158.98, 9.14),
 (6, @d0 + INTERVAL 23 DAY, 'SNACKS', 191, 179, 23.61, 1.75),
 (6, @d0 + INTERVAL 23 DAY, 'DINNER', 347, 344, 150.11, 7.20),
 (1, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 593, 496, 152.70, 25.70),
 (1, @d0 + INTERVAL 24 DAY, 'LUNCH', 740, 692, 342.99, 33.38),
 (1, @d0 + INTERVAL 24 DAY, 'SNACKS', 368, 358, 45.48, 4.36),
 (1, @d0 + INTERVAL 24 DAY, 'DINNER', 748, 699, 323.58, 24.78),
 (2, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 431, 357, 110.98, 21.65),
 (2, @d0 + INTERVAL 24 DAY, 'LUNCH', 522, 489, 241.95, 24.87),
 (2, @d0 + INTERVAL 24 DAY, 'SNACKS', 278, 260, 34.36, 3.49),
 (2, @d0 + INTERVAL 24 DAY, 'DINNER', 548, 525, 237.06, 17.46),
 (3, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 467, 401, 120.25, 19.02),
 (3, @d0 + INTERVAL 24 DAY, 'LUNCH', 615, 569, 285.05, 28.02),
 (3, @d0 + INTERVAL 24 DAY, 'SNACKS', 313, 286, 38.69, 3.15),
 (3, @d0 + INTERVAL 24 DAY, 'DINNER', 573, 512, 247.88, 43.22),
 (4, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 214, 188, 55.11, 8.55),
 (4, @d0 + INTERVAL 24 DAY, 'LUNCH', 270, 269, 125.15, 10.06),
 (4, @d0 + INTERVAL 24 DAY, 'DINNER', 279, 265, 120.70, 11.36),
 (5, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 360, 296, 92.70, 19.37),
 (5, @d0 + INTERVAL 24 DAY, 'LUNCH', 440, 417, 203.94, 15.22),
 (5, @d0 + INTERVAL 24 DAY, 'SNACKS', 250, 250, 30.90, 0.72),
 (5, @d0 + INTERVAL 24 DAY, 'DINNER', 459, 448, 198.56, 14.04),
 (6, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 296, 255, 76.22, 12.97),
 (6, @d0 + INTERVAL 24 DAY, 'LUNCH', 355, 325, 164.54, 20.95),
 (6, @d0 + INTERVAL 24 DAY, 'SNACKS', 191, 179, 23.61, 3.54),
 (6, @d0 + INTERVAL 24 DAY, 'DINNER', 357, 335, 154.44, 13.69),
 (1, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 577, 468, 148.58, 34.95),
 (1, @d0 + INTERVAL 25 DAY, 'LUNCH', 748, 739, 346.70, 11.08),
 (1, @d0 + INTERVAL 25 DAY, 'SNACKS', 397, 379, 49.07, 3.85),
 (1, @d0 + INTERVAL 25 DAY, 'DINNER', 710, 710, 307.15, 6.82),
 (2, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 452, 376, 116.39, 20.96),
 (2, @d0 + INTERVAL 25 DAY, 'LUNCH', 540, 500, 250.29, 21.86),
 (2, @d0 + INTERVAL 25 DAY, 'SNACKS', 297, 276, 36.71, 3.47),
 (2, @d0 + INTERVAL 25 DAY, 'DINNER', 521, 479, 225.38, 30.68),
 (3, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 491, 398, 126.43, 26.20),
 (3, @d0 + INTERVAL 25 DAY, 'LUNCH', 591, 580, 273.93, 7.13),
 (3, @d0 + INTERVAL 25 DAY, 'SNACKS', 320, 315, 39.55, 1.30),
 (3, @d0 + INTERVAL 25 DAY, 'DINNER', 588, 558, 254.37, 25.01),
 (4, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 223, 182, 57.42, 10.51),
 (4, @d0 + INTERVAL 25 DAY, 'LUNCH', 263, 243, 121.90, 14.49),
 (4, @d0 + INTERVAL 25 DAY, 'DINNER', 272, 258, 117.67, 8.64),
 (5, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 354, 299, 91.16, 16.88),
 (5, @d0 + INTERVAL 25 DAY, 'LUNCH', 447, 428, 207.18, 20.05),
 (5, @d0 + INTERVAL 25 DAY, 'SNACKS', 236, 220, 29.17, 3.25),
 (5, @d0 + INTERVAL 25 DAY, 'DINNER', 431, 418, 186.45, 10.74),
 (6, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 292, 248, 75.19, 12.45),
 (6, @d0 + INTERVAL 25 DAY, 'LUNCH', 370, 345, 171.50, 7.77),
 (6, @d0 + INTERVAL 25 DAY, 'SNACKS', 192, 187, 23.73, 0.02),
 (6, @d0 + INTERVAL 25 DAY, 'DINNER', 368, 340, 159.20, 17.65),
 (1, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 547, 419, 140.85, 38.14),
 (1, @d0 + INTERVAL 26 DAY, 'LUNCH', 738, 590, 342.06, 87.51);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (1, @d0 + INTERVAL 26 DAY, 'SNACKS', 400, 328, 49.44, 10.03),
 (1, @d0 + INTERVAL 26 DAY, 'DINNER', 739, 623, 319.69, 57.35),
 (2, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 421, 301, 108.41, 34.27),
 (2, @d0 + INTERVAL 26 DAY, 'LUNCH', 563, 487, 260.95, 42.85),
 (2, @d0 + INTERVAL 26 DAY, 'SNACKS', 286, 230, 35.35, 7.65),
 (2, @d0 + INTERVAL 26 DAY, 'DINNER', 527, 453, 227.98, 44.53),
 (3, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 495, 378, 127.46, 32.03),
 (3, @d0 + INTERVAL 26 DAY, 'LUNCH', 617, 482, 285.98, 66.27),
 (3, @d0 + INTERVAL 26 DAY, 'SNACKS', 332, 280, 41.04, 7.91),
 (3, @d0 + INTERVAL 26 DAY, 'DINNER', 613, 533, 265.18, 36.34),
 (4, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 205, 145, 52.79, 17.55),
 (4, @d0 + INTERVAL 26 DAY, 'LUNCH', 277, 233, 128.39, 18.59),
 (4, @d0 + INTERVAL 26 DAY, 'DINNER', 264, 231, 114.21, 16.44),
 (5, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 359, 264, 92.44, 25.19),
 (5, @d0 + INTERVAL 26 DAY, 'LUNCH', 448, 363, 207.65, 46.07),
 (5, @d0 + INTERVAL 26 DAY, 'SNACKS', 231, 189, 28.55, 6.10),
 (5, @d0 + INTERVAL 26 DAY, 'DINNER', 428, 365, 185.15, 36.01),
 (6, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 294, 223, 75.70, 22.48),
 (6, @d0 + INTERVAL 26 DAY, 'LUNCH', 363, 321, 168.25, 25.07),
 (6, @d0 + INTERVAL 26 DAY, 'SNACKS', 196, 168, 24.23, 3.45),
 (6, @d0 + INTERVAL 26 DAY, 'DINNER', 354, 302, 153.14, 27.93),
 (1, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 558, 463, 143.69, 30.18),
 (1, @d0 + INTERVAL 27 DAY, 'LUNCH', 696, 543, 322.60, 83.50),
 (1, @d0 + INTERVAL 27 DAY, 'SNACKS', 371, 313, 45.86, 8.30),
 (1, @d0 + INTERVAL 27 DAY, 'DINNER', 695, 580, 300.66, 55.22),
 (2, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 419, 367, 107.89, 15.70),
 (2, @d0 + INTERVAL 27 DAY, 'LUNCH', 563, 497, 260.95, 31.17),
 (2, @d0 + INTERVAL 27 DAY, 'SNACKS', 282, 235, 34.86, 6.30),
 (2, @d0 + INTERVAL 27 DAY, 'DINNER', 516, 446, 223.22, 36.48),
 (3, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 498, 433, 128.24, 20.39),
 (3, @d0 + INTERVAL 27 DAY, 'LUNCH', 570, 491, 264.19, 39.20),
 (3, @d0 + INTERVAL 27 DAY, 'SNACKS', 317, 263, 39.18, 7.12),
 (3, @d0 + INTERVAL 27 DAY, 'DINNER', 578, 467, 250.04, 56.21),
 (4, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 208, 177, 53.56, 11.83),
 (4, @d0 + INTERVAL 27 DAY, 'LUNCH', 282, 234, 130.71, 26.55),
 (4, @d0 + INTERVAL 27 DAY, 'DINNER', 259, 239, 112.04, 12.17),
 (5, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 361, 315, 92.96, 13.60),
 (5, @d0 + INTERVAL 27 DAY, 'LUNCH', 441, 374, 204.40, 36.59),
 (5, @d0 + INTERVAL 27 DAY, 'SNACKS', 234, 201, 28.92, 4.93),
 (5, @d0 + INTERVAL 27 DAY, 'DINNER', 457, 406, 197.70, 33.43),
 (6, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 300, 238, 77.25, 17.89),
 (6, @d0 + INTERVAL 27 DAY, 'LUNCH', 377, 315, 174.74, 32.56),
 (6, @d0 + INTERVAL 27 DAY, 'SNACKS', 183, 150, 22.62, 4.25),
 (6, @d0 + INTERVAL 27 DAY, 'DINNER', 349, 316, 150.98, 20.57),
 (1, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 550, 535, 141.62, 9.31),
 (1, @d0 + INTERVAL 28 DAY, 'LUNCH', 699, 672, 323.99, 22.26),
 (1, @d0 + INTERVAL 28 DAY, 'SNACKS', 392, 376, 48.45, 4.46),
 (1, @d0 + INTERVAL 28 DAY, 'DINNER', 715, 700, 309.31, 8.19),
 (2, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 418, 410, 107.64, 2.44),
 (2, @d0 + INTERVAL 28 DAY, 'LUNCH', 556, 556, 257.71, 12.67),
 (2, @d0 + INTERVAL 28 DAY, 'SNACKS', 281, 259, 34.73, 2.88),
 (2, @d0 + INTERVAL 28 DAY, 'DINNER', 530, 487, 229.28, 22.62),
 (3, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 486, 453, 125.15, 13.48),
 (3, @d0 + INTERVAL 28 DAY, 'LUNCH', 587, 564, 272.07, 13.46),
 (3, @d0 + INTERVAL 28 DAY, 'SNACKS', 329, 305, 40.66, 3.88),
 (3, @d0 + INTERVAL 28 DAY, 'DINNER', 588, 564, 254.37, 16.51),
 (4, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 222, 219, 57.16, 0.09),
 (4, @d0 + INTERVAL 28 DAY, 'LUNCH', 266, 248, 123.29, 10.84),
 (4, @d0 + INTERVAL 28 DAY, 'DINNER', 263, 263, 113.77, 7.18),
 (5, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 343, 327, 88.32, 3.87);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (5, @d0 + INTERVAL 28 DAY, 'LUNCH', 464, 457, 215.06, 7.88),
 (5, @d0 + INTERVAL 28 DAY, 'SNACKS', 236, 223, 29.17, 3.32),
 (5, @d0 + INTERVAL 28 DAY, 'DINNER', 465, 456, 201.16, 10.74),
 (6, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 275, 261, 70.81, 4.24),
 (6, @d0 + INTERVAL 28 DAY, 'LUNCH', 345, 321, 159.91, 14.71),
 (6, @d0 + INTERVAL 28 DAY, 'SNACKS', 183, 157, 22.62, 4.62),
 (6, @d0 + INTERVAL 28 DAY, 'DINNER', 349, 302, 150.98, 23.56),
 (1, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 564, 544, 145.23, 11.76),
 (1, @d0 + INTERVAL 29 DAY, 'LUNCH', 686, 642, 317.96, 23.67),
 (1, @d0 + INTERVAL 29 DAY, 'SNACKS', 394, 394, 48.70, 3.68),
 (1, @d0 + INTERVAL 29 DAY, 'DINNER', 754, 727, 326.18, 32.84),
 (2, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 430, 415, 110.73, 11.41),
 (2, @d0 + INTERVAL 29 DAY, 'LUNCH', 545, 501, 252.61, 33.48),
 (2, @d0 + INTERVAL 29 DAY, 'SNACKS', 278, 257, 34.36, 3.21),
 (2, @d0 + INTERVAL 29 DAY, 'DINNER', 521, 510, 225.38, 4.46),
 (3, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 488, 454, 125.66, 13.21),
 (3, @d0 + INTERVAL 29 DAY, 'LUNCH', 605, 570, 280.42, 23.10),
 (3, @d0 + INTERVAL 29 DAY, 'SNACKS', 313, 313, 38.69, 0.00),
 (3, @d0 + INTERVAL 29 DAY, 'DINNER', 595, 548, 257.40, 30.20),
 (4, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 225, 212, 57.94, 4.13),
 (4, @d0 + INTERVAL 29 DAY, 'LUNCH', 278, 265, 128.85, 8.03),
 (4, @d0 + INTERVAL 29 DAY, 'DINNER', 272, 258, 117.67, 13.82),
 (5, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 358, 342, 92.19, 2.58),
 (5, @d0 + INTERVAL 29 DAY, 'LUNCH', 464, 443, 215.06, 19.78),
 (5, @d0 + INTERVAL 29 DAY, 'SNACKS', 244, 221, 30.16, 4.60),
 (5, @d0 + INTERVAL 29 DAY, 'DINNER', 460, 432, 199.00, 18.09),
 (6, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 291, 275, 74.93, 6.17),
 (6, @d0 + INTERVAL 29 DAY, 'LUNCH', 345, 317, 159.91, 18.14),
 (6, @d0 + INTERVAL 29 DAY, 'SNACKS', 182, 164, 22.50, 2.40),
 (6, @d0 + INTERVAL 29 DAY, 'DINNER', 371, 354, 160.49, 13.31),
 (1, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 566, 552, 145.75, 7.04),
 (1, @d0 + INTERVAL 30 DAY, 'LUNCH', 712, 654, 330.01, 48.42),
 (1, @d0 + INTERVAL 30 DAY, 'SNACKS', 398, 375, 49.19, 5.92),
 (1, @d0 + INTERVAL 30 DAY, 'DINNER', 740, 729, 320.12, 23.83),
 (2, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 445, 445, 114.59, 0.00),
 (2, @d0 + INTERVAL 30 DAY, 'LUNCH', 515, 485, 238.70, 16.30),
 (2, @d0 + INTERVAL 30 DAY, 'SNACKS', 281, 253, 34.73, 3.73),
 (2, @d0 + INTERVAL 30 DAY, 'DINNER', 532, 491, 230.14, 17.51),
 (3, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 456, 440, 117.42, 3.88),
 (3, @d0 + INTERVAL 30 DAY, 'LUNCH', 613, 581, 284.13, 24.10),
 (3, @d0 + INTERVAL 30 DAY, 'SNACKS', 335, 320, 41.41, 3.52),
 (3, @d0 + INTERVAL 30 DAY, 'DINNER', 600, 577, 259.56, 11.38),
 (4, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 213, 209, 54.85, 2.97),
 (4, @d0 + INTERVAL 30 DAY, 'LUNCH', 277, 265, 128.39, 7.79),
 (4, @d0 + INTERVAL 30 DAY, 'DINNER', 276, 273, 119.40, 7.55),
 (5, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 367, 340, 94.50, 7.47),
 (5, @d0 + INTERVAL 30 DAY, 'LUNCH', 447, 411, 207.18, 23.08),
 (5, @d0 + INTERVAL 30 DAY, 'SNACKS', 236, 228, 29.17, 2.59),
 (5, @d0 + INTERVAL 30 DAY, 'DINNER', 463, 446, 200.29, 11.47),
 (6, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 296, 281, 76.22, 5.72),
 (6, @d0 + INTERVAL 30 DAY, 'LUNCH', 377, 356, 174.74, 14.77),
 (6, @d0 + INTERVAL 30 DAY, 'SNACKS', 192, 192, 23.73, 0.06),
 (6, @d0 + INTERVAL 30 DAY, 'DINNER', 350, 344, 151.41, 10.52),
 (1, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 594, 565, 152.96, 8.00),
 (1, @d0 + INTERVAL 31 DAY, 'LUNCH', 745, 722, 345.31, 13.43),
 (1, @d0 + INTERVAL 31 DAY, 'SNACKS', 400, 394, 49.44, 1.72),
 (1, @d0 + INTERVAL 31 DAY, 'DINNER', 724, 724, 313.20, 22.23),
 (2, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 415, 391, 106.86, 5.64),
 (2, @d0 + INTERVAL 31 DAY, 'LUNCH', 532, 510, 246.58, 10.95),
 (2, @d0 + INTERVAL 31 DAY, 'SNACKS', 282, 267, 34.86, 3.37);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (2, @d0 + INTERVAL 31 DAY, 'DINNER', 549, 517, 237.50, 25.38),
 (3, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 482, 470, 124.12, 9.08),
 (3, @d0 + INTERVAL 31 DAY, 'LUNCH', 574, 538, 266.05, 22.50),
 (3, @d0 + INTERVAL 31 DAY, 'SNACKS', 325, 302, 40.17, 4.20),
 (3, @d0 + INTERVAL 31 DAY, 'DINNER', 577, 551, 249.61, 12.35),
 (4, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 220, 203, 56.65, 6.27),
 (4, @d0 + INTERVAL 31 DAY, 'LUNCH', 272, 262, 126.07, 4.97),
 (4, @d0 + INTERVAL 31 DAY, 'DINNER', 266, 253, 115.07, 6.94),
 (5, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 348, 348, 89.61, 1.83),
 (5, @d0 + INTERVAL 31 DAY, 'LUNCH', 432, 391, 200.23, 26.44),
 (5, @d0 + INTERVAL 31 DAY, 'SNACKS', 250, 239, 30.90, 2.22),
 (5, @d0 + INTERVAL 31 DAY, 'DINNER', 465, 447, 201.16, 12.85),
 (6, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 274, 269, 70.56, 4.74),
 (6, @d0 + INTERVAL 31 DAY, 'LUNCH', 364, 364, 168.71, 3.75),
 (6, @d0 + INTERVAL 31 DAY, 'SNACKS', 194, 189, 23.98, 1.12),
 (6, @d0 + INTERVAL 31 DAY, 'DINNER', 362, 351, 156.60, 10.84),
 (1, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 560, 519, 144.20, 16.42),
 (1, @d0 + INTERVAL 32 DAY, 'LUNCH', 742, 742, 343.92, 26.69),
 (1, @d0 + INTERVAL 32 DAY, 'SNACKS', 396, 383, 48.95, 2.58),
 (1, @d0 + INTERVAL 32 DAY, 'DINNER', 702, 660, 303.69, 20.03),
 (2, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 415, 399, 106.86, 7.81),
 (2, @d0 + INTERVAL 32 DAY, 'LUNCH', 560, 514, 259.56, 20.32),
 (2, @d0 + INTERVAL 32 DAY, 'SNACKS', 294, 289, 36.34, 1.76),
 (2, @d0 + INTERVAL 32 DAY, 'DINNER', 522, 480, 225.82, 17.81),
 (3, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 494, 473, 127.20, 13.67),
 (3, @d0 + INTERVAL 32 DAY, 'LUNCH', 585, 580, 271.15, 4.87),
 (3, @d0 + INTERVAL 32 DAY, 'SNACKS', 310, 295, 38.32, 3.12),
 (3, @d0 + INTERVAL 32 DAY, 'DINNER', 627, 572, 271.24, 39.13),
 (4, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 211, 199, 54.33, 5.09),
 (4, @d0 + INTERVAL 32 DAY, 'LUNCH', 265, 250, 122.83, 12.60),
 (4, @d0 + INTERVAL 32 DAY, 'DINNER', 263, 232, 113.77, 18.71),
 (5, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 345, 323, 88.84, 9.95),
 (5, @d0 + INTERVAL 32 DAY, 'LUNCH', 472, 432, 218.77, 23.67),
 (5, @d0 + INTERVAL 32 DAY, 'SNACKS', 234, 227, 28.92, 1.54),
 (5, @d0 + INTERVAL 32 DAY, 'DINNER', 430, 406, 186.02, 12.34),
 (6, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 284, 261, 73.13, 7.43),
 (6, @d0 + INTERVAL 32 DAY, 'LUNCH', 347, 346, 160.83, 0.96),
 (6, @d0 + INTERVAL 32 DAY, 'SNACKS', 200, 191, 24.72, 1.35),
 (6, @d0 + INTERVAL 32 DAY, 'DINNER', 360, 341, 155.74, 4.21),
 (1, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 586, 516, 150.90, 23.14),
 (1, @d0 + INTERVAL 33 DAY, 'LUNCH', 719, 576, 333.26, 68.64),
 (1, @d0 + INTERVAL 33 DAY, 'SNACKS', 383, 312, 47.34, 11.63),
 (1, @d0 + INTERVAL 33 DAY, 'DINNER', 733, 575, 317.10, 73.63),
 (2, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 451, 380, 116.13, 18.17),
 (2, @d0 + INTERVAL 33 DAY, 'LUNCH', 527, 439, 244.26, 45.56),
 (2, @d0 + INTERVAL 33 DAY, 'SNACKS', 288, 248, 35.60, 6.20),
 (2, @d0 + INTERVAL 33 DAY, 'DINNER', 566, 501, 244.85, 29.72),
 (3, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 469, 383, 120.77, 24.79),
 (3, @d0 + INTERVAL 33 DAY, 'LUNCH', 575, 492, 266.51, 48.93),
 (3, @d0 + INTERVAL 33 DAY, 'SNACKS', 327, 285, 40.42, 5.08),
 (3, @d0 + INTERVAL 33 DAY, 'DINNER', 588, 501, 254.37, 41.50),
 (4, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 207, 182, 53.30, 7.70),
 (4, @d0 + INTERVAL 33 DAY, 'LUNCH', 273, 229, 126.54, 21.61),
 (4, @d0 + INTERVAL 33 DAY, 'DINNER', 258, 217, 111.61, 19.12),
 (5, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 356, 300, 91.67, 19.05),
 (5, @d0 + INTERVAL 33 DAY, 'LUNCH', 449, 395, 208.11, 31.25),
 (5, @d0 + INTERVAL 33 DAY, 'SNACKS', 231, 202, 28.55, 4.83),
 (5, @d0 + INTERVAL 33 DAY, 'DINNER', 460, 372, 199.00, 41.16),
 (6, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 295, 267, 75.96, 10.44),
 (6, @d0 + INTERVAL 33 DAY, 'LUNCH', 373, 324, 172.89, 28.77);
INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES
 (6, @d0 + INTERVAL 33 DAY, 'SNACKS', 183, 154, 22.62, 4.50),
 (6, @d0 + INTERVAL 33 DAY, 'DINNER', 363, 325, 157.03, 18.03),
 (1, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 597, 496, 153.73, 25.98),
 (1, @d0 + INTERVAL 34 DAY, 'LUNCH', 697, 571, 323.06, 62.18),
 (1, @d0 + INTERVAL 34 DAY, 'SNACKS', 379, 316, 46.84, 9.92),
 (1, @d0 + INTERVAL 34 DAY, 'DINNER', 687, 559, 297.20, 64.14),
 (2, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 417, 340, 107.38, 24.77),
 (2, @d0 + INTERVAL 34 DAY, 'LUNCH', 527, 461, 244.26, 40.39),
 (2, @d0 + INTERVAL 34 DAY, 'SNACKS', 288, 245, 35.60, 5.85),
 (2, @d0 + INTERVAL 34 DAY, 'DINNER', 549, 449, 237.50, 50.79),
 (3, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 476, 405, 122.57, 19.86),
 (3, @d0 + INTERVAL 34 DAY, 'LUNCH', 595, 524, 275.78, 44.22),
 (3, @d0 + INTERVAL 34 DAY, 'SNACKS', 318, 258, 39.30, 8.44),
 (3, @d0 + INTERVAL 34 DAY, 'DINNER', 621, 525, 268.64, 50.20),
 (4, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 219, 186, 56.39, 7.43),
 (4, @d0 + INTERVAL 34 DAY, 'LUNCH', 283, 240, 131.17, 22.03),
 (4, @d0 + INTERVAL 34 DAY, 'DINNER', 281, 249, 121.56, 17.63),
 (5, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 356, 288, 91.67, 21.43),
 (5, @d0 + INTERVAL 34 DAY, 'LUNCH', 431, 360, 199.77, 35.19),
 (5, @d0 + INTERVAL 34 DAY, 'SNACKS', 241, 202, 29.79, 5.49),
 (5, @d0 + INTERVAL 34 DAY, 'DINNER', 439, 382, 189.91, 31.02),
 (6, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 274, 230, 70.56, 13.18),
 (6, @d0 + INTERVAL 34 DAY, 'LUNCH', 366, 331, 169.64, 18.23),
 (6, @d0 + INTERVAL 34 DAY, 'SNACKS', 195, 171, 24.10, 3.75),
 (6, @d0 + INTERVAL 34 DAY, 'DINNER', 353, 281, 152.71, 31.63),
 (1, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 558, 558, 143.69, 1.76),
 (1, @d0 + INTERVAL 35 DAY, 'LUNCH', 694, 676, 321.67, 16.45),
 (1, @d0 + INTERVAL 35 DAY, 'SNACKS', 380, 360, 46.97, 3.13),
 (1, @d0 + INTERVAL 35 DAY, 'DINNER', 733, 664, 317.10, 39.64),
 (2, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 423, 403, 108.92, 8.52),
 (2, @d0 + INTERVAL 35 DAY, 'LUNCH', 522, 497, 241.95, 16.25),
 (2, @d0 + INTERVAL 35 DAY, 'SNACKS', 291, 283, 35.97, 1.16),
 (2, @d0 + INTERVAL 35 DAY, 'DINNER', 550, 519, 237.93, 28.31),
 (3, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 501, 447, 129.01, 14.03),
 (3, @d0 + INTERVAL 35 DAY, 'LUNCH', 585, 585, 271.15, 0.00),
 (3, @d0 + INTERVAL 35 DAY, 'SNACKS', 320, 316, 39.55, 3.78),
 (3, @d0 + INTERVAL 35 DAY, 'DINNER', 620, 617, 268.21, 2.74),
 (4, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 205, 192, 52.79, 4.27),
 (4, @d0 + INTERVAL 35 DAY, 'LUNCH', 279, 263, 129.32, 12.98),
 (4, @d0 + INTERVAL 35 DAY, 'DINNER', 271, 257, 117.23, 5.27),
 (5, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 371, 350, 95.53, 6.75),
 (5, @d0 + INTERVAL 35 DAY, 'LUNCH', 468, 444, 216.92, 22.54),
 (5, @d0 + INTERVAL 35 DAY, 'SNACKS', 246, 221, 30.41, 4.12),
 (5, @d0 + INTERVAL 35 DAY, 'DINNER', 460, 423, 199.00, 19.63),
 (6, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 279, 252, 71.84, 9.36),
 (6, @d0 + INTERVAL 35 DAY, 'LUNCH', 356, 321, 165.01, 20.00),
 (6, @d0 + INTERVAL 35 DAY, 'SNACKS', 198, 182, 24.47, 3.00),
 (6, @d0 + INTERVAL 35 DAY, 'DINNER', 374, 364, 161.79, 0.59);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (1, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 0 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 0 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 0 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 0 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 0 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 0 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 0 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 0 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 0 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 0 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 0 DAY, 'LUNCH', 21),
 (2, @d0 + INTERVAL 0 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 0 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 0 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 0 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 0 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 0 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 0 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 0 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 0 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 0 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 0 DAY, 'DINNER', 22),
 (3, @d0 + INTERVAL 0 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 0 DAY, 'DINNER', 16),
 (4, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 0 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 0 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 0 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 0 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 0 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 0 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 0 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 0 DAY, 'LUNCH', 7),
 (5, @d0 + INTERVAL 0 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 0 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 0 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 0 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 0 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 0 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 0 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 0 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 0 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 0 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 0 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 0 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 0 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 0 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 0 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 1 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 1 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 1 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 1 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 1 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 1 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 1 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 1 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 1 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 1 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 1 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 1 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 1 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 1 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 1 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 1 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 1);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (3, @d0 + INTERVAL 1 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 1 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 1 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 1 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 1 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 1 DAY, 'DINNER', 16),
 (3, @d0 + INTERVAL 1 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 1 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 1 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 1 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 1 DAY, 'LUNCH', 7),
 (4, @d0 + INTERVAL 1 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 1 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 1 DAY, 'DINNER', 11),
 (5, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 1 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 1 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 1 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 1 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 1 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 1 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 1 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 1 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 1 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 1 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 1 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 1 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 1 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 1 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 1 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 1 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 1 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 2 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 2 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 2 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 2 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 2 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 2 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 2 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 2 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 2 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 2 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 2 DAY, 'LUNCH', 7),
 (2, @d0 + INTERVAL 2 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 2 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 2 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 2 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 2 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 2 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 2 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 2 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 2 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 2 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 2 DAY, 'DINNER', 17),
 (3, @d0 + INTERVAL 2 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 2 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 2 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 2 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 2 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 2 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 2 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 2 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 2 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 2 DAY, 'LUNCH', 24),
 (5, @d0 + INTERVAL 2 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 2 DAY, 'SNACKS', 18);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (5, @d0 + INTERVAL 2 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 2 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 2 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 2 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 2 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 2 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 2 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 2 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 2 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 2 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 2 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 2 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 2 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 3 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 3 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 3 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 3 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 3 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 3 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 3 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 3 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 3 DAY, 'LUNCH', 7),
 (2, @d0 + INTERVAL 3 DAY, 'LUNCH', 10),
 (2, @d0 + INTERVAL 3 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 3 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 3 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 3 DAY, 'DINNER', 13),
 (2, @d0 + INTERVAL 3 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 3 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 3 DAY, 'LUNCH', 15),
 (3, @d0 + INTERVAL 3 DAY, 'LUNCH', 16),
 (3, @d0 + INTERVAL 3 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 3 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 3 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 3 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 3 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 3 DAY, 'DINNER', 10),
 (4, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 3 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 3 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 3 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 3 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 3 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 3 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 3 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 3 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 3 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 3 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 3 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 3 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 3 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 3 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 3 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 3 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 3 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 3 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 3 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 3 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 3 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 3 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 3 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 4 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 4 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 4 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 4 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 4 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 4 DAY, 'DINNER', 6);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (1, @d0 + INTERVAL 4 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 4 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 4 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 4 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 4 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 4 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 4 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 4 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 4 DAY, 'DINNER', 13),
 (2, @d0 + INTERVAL 4 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 4 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 4 DAY, 'LUNCH', 10),
 (3, @d0 + INTERVAL 4 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 4 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 4 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 4 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 4 DAY, 'DINNER', 24),
 (3, @d0 + INTERVAL 4 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 4 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 4 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 4 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 4 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 4 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 4 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 4 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 4 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 4 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 4 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 4 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 4 DAY, 'DINNER', 11),
 (5, @d0 + INTERVAL 4 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 4 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 4 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 4 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 4 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 4 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 4 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 4 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 4 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 4 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 4 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 5 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 5 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 5 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 5 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 5 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 5 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 5 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 5 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 5 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 5 DAY, 'LUNCH', 10),
 (2, @d0 + INTERVAL 5 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 5 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 5 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 5 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 5 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 5 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 5 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 5 DAY, 'LUNCH', 10),
 (3, @d0 + INTERVAL 5 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 5 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 5 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 5 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 5 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 5 DAY, 'DINNER', 11);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (4, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 5 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 5 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 5 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 5 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 5 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 5 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 5 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 5 DAY, 'LUNCH', 15),
 (5, @d0 + INTERVAL 5 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 5 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 5 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 5 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 5 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 5 DAY, 'DINNER', 13),
 (6, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 5 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 5 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 5 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 5 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 5 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 5 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 5 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 5 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 5 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 6 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 6 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 6 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 6 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 6 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 6 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 6 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 6 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 6 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 6 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 6 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 6 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 6 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 6 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 6 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 6 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 6 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 6 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 6 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 6 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 6 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 6 DAY, 'DINNER', 16),
 (3, @d0 + INTERVAL 6 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 6 DAY, 'DINNER', 22),
 (4, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 6 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 6 DAY, 'LUNCH', 7),
 (4, @d0 + INTERVAL 6 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 6 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 6 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 6 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 6 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 6 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 6 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 6 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 6 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 6 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 6 DAY, 'DINNER', 11),
 (5, @d0 + INTERVAL 6 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 6 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 6 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 6 DAY, 'LUNCH', 10);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (6, @d0 + INTERVAL 6 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 6 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 6 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 6 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 6 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 6 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 7 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 7 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 7 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 7 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 7 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 7 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 7 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 7 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 7 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 7 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 7 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 7 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 7 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 7 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 7 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 7 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 7 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 7 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 7 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 7 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 7 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 7 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 7 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 7 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 7 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 7 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 7 DAY, 'LUNCH', 7),
 (4, @d0 + INTERVAL 7 DAY, 'DINNER', 7),
 (4, @d0 + INTERVAL 7 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 7 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 7 DAY, 'LUNCH', 13),
 (5, @d0 + INTERVAL 7 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 7 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 7 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 7 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 7 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 7 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 7 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 7 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 7 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 7 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 7 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 7 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 7 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 7 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 7 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 7 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 8 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 8 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 8 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 8 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 8 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 8 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 8 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 8 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 8 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 8 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 8 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 8 DAY, 'SNACKS', 18);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (2, @d0 + INTERVAL 8 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 8 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 8 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 8 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 8 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 8 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 8 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 8 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 8 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 8 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 8 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 8 DAY, 'DINNER', 22),
 (4, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 8 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 8 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 8 DAY, 'LUNCH', 6),
 (4, @d0 + INTERVAL 8 DAY, 'DINNER', 7),
 (4, @d0 + INTERVAL 8 DAY, 'DINNER', 22),
 (4, @d0 + INTERVAL 8 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 8 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 8 DAY, 'LUNCH', 7),
 (5, @d0 + INTERVAL 8 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 8 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 8 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 8 DAY, 'DINNER', 14),
 (5, @d0 + INTERVAL 8 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 8 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 8 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 8 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 8 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 8 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 8 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 8 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 8 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 8 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 8 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 9 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 9 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 9 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 9 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 9 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 9 DAY, 'DINNER', 6),
 (1, @d0 + INTERVAL 9 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 9 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 9 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 9 DAY, 'LUNCH', 11),
 (2, @d0 + INTERVAL 9 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 9 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 9 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 9 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 9 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 9 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 9 DAY, 'LUNCH', 10),
 (3, @d0 + INTERVAL 9 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 9 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 9 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 9 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 9 DAY, 'DINNER', 17),
 (3, @d0 + INTERVAL 9 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 9 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 9 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 9 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 9 DAY, 'LUNCH', 16),
 (4, @d0 + INTERVAL 9 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 9 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 9 DAY, 'DINNER', 7);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (5, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 9 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 9 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 9 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 9 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 9 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 9 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 9 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 9 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 9 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 9 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 9 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 9 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 9 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 9 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 9 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 9 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 9 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 10 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 10 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 10 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 10 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 10 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 10 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 10 DAY, 'DINNER', 6),
 (1, @d0 + INTERVAL 10 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 10 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 10 DAY, 'LUNCH', 23),
 (2, @d0 + INTERVAL 10 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 10 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 10 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 10 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 10 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 10 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 10 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 10 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 10 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 10 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 10 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 10 DAY, 'DINNER', 17),
 (3, @d0 + INTERVAL 10 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 10 DAY, 'DINNER', 7),
 (4, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 10 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 10 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 10 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 10 DAY, 'DINNER', 10),
 (4, @d0 + INTERVAL 10 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 10 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 10 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 10 DAY, 'LUNCH', 24),
 (5, @d0 + INTERVAL 10 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 10 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 10 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 10 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 10 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 10 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 10 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 10 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 10 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 10 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 10 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 10 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 10 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 10 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 10 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 1);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (1, @d0 + INTERVAL 11 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 11 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 11 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 11 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 11 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 11 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 11 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 11 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 11 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 11 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 11 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 11 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 11 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 11 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 11 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 11 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 11 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 11 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 11 DAY, 'LUNCH', 15),
 (3, @d0 + INTERVAL 11 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 11 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 11 DAY, 'DINNER', 22),
 (3, @d0 + INTERVAL 11 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 11 DAY, 'DINNER', 10),
 (4, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 11 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 11 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 11 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 11 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 11 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 11 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 11 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 11 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 11 DAY, 'LUNCH', 15),
 (5, @d0 + INTERVAL 11 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 11 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 11 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 11 DAY, 'DINNER', 14),
 (5, @d0 + INTERVAL 11 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 11 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 11 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 11 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 11 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 11 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 11 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 11 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 11 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 11 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 12 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 12 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 12 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 12 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 12 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 12 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 12 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 12 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 12 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 12 DAY, 'LUNCH', 21),
 (2, @d0 + INTERVAL 12 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 12 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 12 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 12 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 12 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 12 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 12 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 12 DAY, 'LUNCH', 15);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (3, @d0 + INTERVAL 12 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 12 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 12 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 12 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 12 DAY, 'DINNER', 22),
 (3, @d0 + INTERVAL 12 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 12 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 12 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 12 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 12 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 12 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 12 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 12 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 12 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 12 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 12 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 12 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 12 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 12 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 12 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 12 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 12 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 12 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 12 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 12 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 12 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 12 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 12 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 12 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 13 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 13 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 13 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 13 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 13 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 13 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 13 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 13 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 13 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 13 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 13 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 13 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 13 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 13 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 13 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 13 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 13 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 13 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 13 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 13 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 13 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 13 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 13 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 13 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 13 DAY, 'LUNCH', 7),
 (4, @d0 + INTERVAL 13 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 13 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 13 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 13 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 13 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 13 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 13 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 13 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 13 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 13 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 13 DAY, 'DINNER', 14);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (5, @d0 + INTERVAL 13 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 13 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 13 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 13 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 13 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 13 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 13 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 13 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 13 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 13 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 13 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 14 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 14 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 14 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 14 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 14 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 14 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 14 DAY, 'DINNER', 6),
 (1, @d0 + INTERVAL 14 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 14 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 14 DAY, 'LUNCH', 21),
 (2, @d0 + INTERVAL 14 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 14 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 14 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 14 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 14 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 14 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 14 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 14 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 14 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 14 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 14 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 14 DAY, 'DINNER', 16),
 (3, @d0 + INTERVAL 14 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 14 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 14 DAY, 'LUNCH', 16),
 (4, @d0 + INTERVAL 14 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 14 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 14 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 14 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 14 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 14 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 14 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 14 DAY, 'LUNCH', 15),
 (5, @d0 + INTERVAL 14 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 14 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 14 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 14 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 14 DAY, 'DINNER', 14),
 (6, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 14 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 14 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 14 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 14 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 14 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 14 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 14 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 14 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 14 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 15 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 15 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 15 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 15 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 15 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 15 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 15 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 15 DAY, 'DINNER', 8);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (2, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 15 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 15 DAY, 'LUNCH', 11),
 (2, @d0 + INTERVAL 15 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 15 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 15 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 15 DAY, 'DINNER', 13),
 (2, @d0 + INTERVAL 15 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 15 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 15 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 15 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 15 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 15 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 15 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 15 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 15 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 15 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 15 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 15 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 15 DAY, 'LUNCH', 16),
 (4, @d0 + INTERVAL 15 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 15 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 15 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 15 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 15 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 15 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 15 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 15 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 15 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 15 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 15 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 15 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 15 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 15 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 15 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 15 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 15 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 15 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 15 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 15 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 16 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 16 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 16 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 16 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 16 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 16 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 16 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 16 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 16 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 16 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 16 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 16 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 16 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 16 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 16 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 16 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 16 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 16 DAY, 'LUNCH', 16),
 (3, @d0 + INTERVAL 16 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 16 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 16 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 16 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 16 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 16 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 3);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (4, @d0 + INTERVAL 16 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 16 DAY, 'LUNCH', 6),
 (4, @d0 + INTERVAL 16 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 16 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 16 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 16 DAY, 'DINNER', 14),
 (5, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 16 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 16 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 16 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 16 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 16 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 16 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 16 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 16 DAY, 'DINNER', 13),
 (6, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 16 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 16 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 16 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 16 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 16 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 16 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 16 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 16 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 16 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 17 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 17 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 17 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 17 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 17 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 17 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 17 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 17 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 17 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 17 DAY, 'LUNCH', 23),
 (2, @d0 + INTERVAL 17 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 17 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 17 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 17 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 17 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 17 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 17 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 17 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 17 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 17 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 17 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 17 DAY, 'DINNER', 24),
 (3, @d0 + INTERVAL 17 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 17 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 17 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 17 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 17 DAY, 'LUNCH', 6),
 (4, @d0 + INTERVAL 17 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 17 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 17 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 17 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 17 DAY, 'LUNCH', 13),
 (5, @d0 + INTERVAL 17 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 17 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 17 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 17 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 17 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 17 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 17 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 17 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 17 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 17 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 17 DAY, 'SNACKS', 18);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (6, @d0 + INTERVAL 17 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 17 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 17 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 17 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 18 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 18 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 18 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 18 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 18 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 18 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 18 DAY, 'DINNER', 6),
 (1, @d0 + INTERVAL 18 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 18 DAY, 'LUNCH', 21),
 (2, @d0 + INTERVAL 18 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 18 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 18 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 18 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 18 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 18 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 18 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 18 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 18 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 18 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 18 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 18 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 18 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 18 DAY, 'DINNER', 24),
 (3, @d0 + INTERVAL 18 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 18 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 18 DAY, 'LUNCH', 7),
 (4, @d0 + INTERVAL 18 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 18 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 18 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 18 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 18 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 18 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 18 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 18 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 18 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 18 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 18 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 18 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 18 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 18 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 18 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 18 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 18 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 18 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 18 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 18 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 18 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 19 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 19 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 19 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 19 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 19 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 19 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 19 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 19 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 19 DAY, 'LUNCH', 16),
 (2, @d0 + INTERVAL 19 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 19 DAY, 'LUNCH', 23),
 (2, @d0 + INTERVAL 19 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 19 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 19 DAY, 'DINNER', 7);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (2, @d0 + INTERVAL 19 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 19 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 19 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 19 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 19 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 19 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 19 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 19 DAY, 'DINNER', 17),
 (3, @d0 + INTERVAL 19 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 19 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 19 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 19 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 19 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 19 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 19 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 19 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 19 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 19 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 19 DAY, 'LUNCH', 13),
 (5, @d0 + INTERVAL 19 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 19 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 19 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 19 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 19 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 19 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 19 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 19 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 19 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 19 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 19 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 19 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 19 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 19 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 20 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 20 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 20 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 20 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 20 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 20 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 20 DAY, 'DINNER', 6),
 (1, @d0 + INTERVAL 20 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 20 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 20 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 20 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 20 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 20 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 20 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 20 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 20 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 20 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 20 DAY, 'LUNCH', 16),
 (3, @d0 + INTERVAL 20 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 20 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 20 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 20 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 20 DAY, 'DINNER', 12),
 (3, @d0 + INTERVAL 20 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 20 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 20 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 20 DAY, 'LUNCH', 7),
 (4, @d0 + INTERVAL 20 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 20 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 20 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 4);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (5, @d0 + INTERVAL 20 DAY, 'LUNCH', 15),
 (5, @d0 + INTERVAL 20 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 20 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 20 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 20 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 20 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 20 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 20 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 20 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 20 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 20 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 20 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 20 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 20 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 20 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 20 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 20 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 21 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 21 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 21 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 21 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 21 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 21 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 21 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 21 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 21 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 21 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 21 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 21 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 21 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 21 DAY, 'DINNER', 17),
 (2, @d0 + INTERVAL 21 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 21 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 21 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 21 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 21 DAY, 'LUNCH', 16),
 (3, @d0 + INTERVAL 21 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 21 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 21 DAY, 'DINNER', 21),
 (3, @d0 + INTERVAL 21 DAY, 'DINNER', 24),
 (3, @d0 + INTERVAL 21 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 21 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 21 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 21 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 21 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 21 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 21 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 21 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 21 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 21 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 21 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 21 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 21 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 21 DAY, 'DINNER', 14),
 (5, @d0 + INTERVAL 21 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 21 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 21 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 21 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 21 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 21 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 21 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 21 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 21 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 21 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 22 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 22 DAY, 'LUNCH', 10);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (1, @d0 + INTERVAL 22 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 22 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 22 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 22 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 22 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 22 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 22 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 22 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 22 DAY, 'LUNCH', 24),
 (2, @d0 + INTERVAL 22 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 22 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 22 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 22 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 22 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 22 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 22 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 22 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 22 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 22 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 22 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 22 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 22 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 22 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 22 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 22 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 22 DAY, 'DINNER', 10),
 (4, @d0 + INTERVAL 22 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 22 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 22 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 22 DAY, 'LUNCH', 13),
 (5, @d0 + INTERVAL 22 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 22 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 22 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 22 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 22 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 22 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 22 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 22 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 22 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 22 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 22 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 22 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 22 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 22 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 22 DAY, 'DINNER', 6),
 (1, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 23 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 23 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 23 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 23 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 23 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 23 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 23 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 23 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 23 DAY, 'LUNCH', 16),
 (2, @d0 + INTERVAL 23 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 23 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 23 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 23 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 23 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 23 DAY, 'DINNER', 13),
 (2, @d0 + INTERVAL 23 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 23 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 23 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 23 DAY, 'LUNCH', 15),
 (3, @d0 + INTERVAL 23 DAY, 'SNACKS', 23);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (3, @d0 + INTERVAL 23 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 23 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 23 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 23 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 23 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 23 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 23 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 23 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 23 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 23 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 23 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 23 DAY, 'LUNCH', 7),
 (5, @d0 + INTERVAL 23 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 23 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 23 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 23 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 23 DAY, 'DINNER', 11),
 (5, @d0 + INTERVAL 23 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 23 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 23 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 23 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 23 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 23 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 23 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 23 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 23 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 23 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 24 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 24 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 24 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 24 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 24 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 24 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 24 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 24 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 24 DAY, 'LUNCH', 10),
 (2, @d0 + INTERVAL 24 DAY, 'LUNCH', 7),
 (2, @d0 + INTERVAL 24 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 24 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 24 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 24 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 24 DAY, 'DINNER', 13),
 (2, @d0 + INTERVAL 24 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 24 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 24 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 24 DAY, 'LUNCH', 15),
 (3, @d0 + INTERVAL 24 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 24 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 24 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 24 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 24 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 24 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 24 DAY, 'LUNCH', 6),
 (4, @d0 + INTERVAL 24 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 24 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 24 DAY, 'DINNER', 12),
 (4, @d0 + INTERVAL 24 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 24 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 24 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 24 DAY, 'LUNCH', 24),
 (5, @d0 + INTERVAL 24 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 24 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 24 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 24 DAY, 'DINNER', 6),
 (5, @d0 + INTERVAL 24 DAY, 'DINNER', 24);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (6, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 24 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 24 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 24 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 24 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 24 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 24 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 24 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 24 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 24 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 25 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 25 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 25 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 25 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 25 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 25 DAY, 'DINNER', 12),
 (1, @d0 + INTERVAL 25 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 25 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 25 DAY, 'LUNCH', 16),
 (2, @d0 + INTERVAL 25 DAY, 'LUNCH', 23),
 (2, @d0 + INTERVAL 25 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 25 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 25 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 25 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 25 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 25 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 25 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 25 DAY, 'LUNCH', 10),
 (3, @d0 + INTERVAL 25 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 25 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 25 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 25 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 25 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 25 DAY, 'DINNER', 10),
 (4, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 25 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 25 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 25 DAY, 'LUNCH', 6),
 (4, @d0 + INTERVAL 25 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 25 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 25 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 25 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 25 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 25 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 25 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 25 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 25 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 25 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 25 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 25 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 25 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 25 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 25 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 25 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 25 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 25 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 25 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 25 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 26 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 26 DAY, 'LUNCH', 6),
 (1, @d0 + INTERVAL 26 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 26 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 26 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 26 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 26 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 26 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 4);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (2, @d0 + INTERVAL 26 DAY, 'LUNCH', 21),
 (2, @d0 + INTERVAL 26 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 26 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 26 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 26 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 26 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 26 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 26 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 26 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 26 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 26 DAY, 'LUNCH', 10),
 (3, @d0 + INTERVAL 26 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 26 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 26 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 26 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 26 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 26 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 26 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 26 DAY, 'LUNCH', 11),
 (4, @d0 + INTERVAL 26 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 26 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 26 DAY, 'DINNER', 14),
 (5, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 26 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 26 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 26 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 26 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 26 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 26 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 26 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 26 DAY, 'DINNER', 14),
 (6, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 26 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 26 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 26 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 26 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 26 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 26 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 26 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 26 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 26 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 27 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 27 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 27 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 27 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 27 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 27 DAY, 'DINNER', 22),
 (1, @d0 + INTERVAL 27 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 27 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 27 DAY, 'LUNCH', 7),
 (2, @d0 + INTERVAL 27 DAY, 'LUNCH', 6),
 (2, @d0 + INTERVAL 27 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 27 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 27 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 27 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 27 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 27 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 27 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 27 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 27 DAY, 'LUNCH', 16),
 (3, @d0 + INTERVAL 27 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 27 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 27 DAY, 'DINNER', 24),
 (3, @d0 + INTERVAL 27 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 27 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 5),
 (4, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 27 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 27 DAY, 'LUNCH', 16);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (4, @d0 + INTERVAL 27 DAY, 'LUNCH', 6),
 (4, @d0 + INTERVAL 27 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 27 DAY, 'DINNER', 16),
 (4, @d0 + INTERVAL 27 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 27 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 27 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 27 DAY, 'LUNCH', 13),
 (5, @d0 + INTERVAL 27 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 27 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 27 DAY, 'DINNER', 8),
 (5, @d0 + INTERVAL 27 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 27 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 27 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 27 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 27 DAY, 'LUNCH', 6),
 (6, @d0 + INTERVAL 27 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 27 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 27 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 27 DAY, 'DINNER', 24),
 (6, @d0 + INTERVAL 27 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 27 DAY, 'DINNER', 21),
 (1, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 28 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 28 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 28 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 28 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 28 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 28 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 28 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 28 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 28 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 28 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 28 DAY, 'LUNCH', 10),
 (2, @d0 + INTERVAL 28 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 28 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 28 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 28 DAY, 'DINNER', 13),
 (2, @d0 + INTERVAL 28 DAY, 'DINNER', 12),
 (3, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 28 DAY, 'LUNCH', 15),
 (3, @d0 + INTERVAL 28 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 28 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 28 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 28 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 28 DAY, 'DINNER', 11),
 (3, @d0 + INTERVAL 28 DAY, 'DINNER', 16),
 (3, @d0 + INTERVAL 28 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 28 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 28 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 28 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 28 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 28 DAY, 'DINNER', 10),
 (4, @d0 + INTERVAL 28 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 28 DAY, 'LUNCH', 11),
 (5, @d0 + INTERVAL 28 DAY, 'LUNCH', 7),
 (5, @d0 + INTERVAL 28 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 28 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 28 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 28 DAY, 'DINNER', 22),
 (5, @d0 + INTERVAL 28 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 28 DAY, 'DINNER', 17),
 (6, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 28 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 28 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 28 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 28 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 28 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 28 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 28 DAY, 'DINNER', 22);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (6, @d0 + INTERVAL 28 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 28 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 2),
 (1, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 29 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 29 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 29 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 29 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 29 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 29 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 29 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 29 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 29 DAY, 'LUNCH', 7),
 (2, @d0 + INTERVAL 29 DAY, 'LUNCH', 16),
 (2, @d0 + INTERVAL 29 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 29 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 29 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 29 DAY, 'DINNER', 11),
 (2, @d0 + INTERVAL 29 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 29 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 29 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 29 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 29 DAY, 'LUNCH', 14),
 (3, @d0 + INTERVAL 29 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 29 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 29 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 29 DAY, 'DINNER', 8),
 (3, @d0 + INTERVAL 29 DAY, 'DINNER', 22),
 (4, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 29 DAY, 'LUNCH', 24),
 (4, @d0 + INTERVAL 29 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 29 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 29 DAY, 'DINNER', 22),
 (4, @d0 + INTERVAL 29 DAY, 'DINNER', 21),
 (4, @d0 + INTERVAL 29 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 29 DAY, 'LUNCH', 24),
 (5, @d0 + INTERVAL 29 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 29 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 29 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 29 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 29 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 29 DAY, 'DINNER', 24),
 (5, @d0 + INTERVAL 29 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 29 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 29 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 29 DAY, 'LUNCH', 24),
 (6, @d0 + INTERVAL 29 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 29 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 29 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 29 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 29 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 29 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 30 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 30 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 30 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 30 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 30 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 30 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 30 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 30 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 30 DAY, 'LUNCH', 16),
 (2, @d0 + INTERVAL 30 DAY, 'LUNCH', 8),
 (2, @d0 + INTERVAL 30 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 30 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 30 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 30 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 30 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 30 DAY, 'DINNER', 13);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (3, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 30 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 30 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 30 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 30 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 30 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 30 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 30 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 30 DAY, 'DINNER', 13),
 (4, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 30 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 30 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 30 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 30 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 30 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 30 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 30 DAY, 'LUNCH', 7),
 (5, @d0 + INTERVAL 30 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 30 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 30 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 30 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 30 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 30 DAY, 'DINNER', 11),
 (5, @d0 + INTERVAL 30 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 30 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 30 DAY, 'LUNCH', 11),
 (6, @d0 + INTERVAL 30 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 30 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 30 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 30 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 30 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 30 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 30 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 31 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 31 DAY, 'LUNCH', 7),
 (1, @d0 + INTERVAL 31 DAY, 'LUNCH', 11),
 (1, @d0 + INTERVAL 31 DAY, 'SNACKS', 18),
 (1, @d0 + INTERVAL 31 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 31 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 31 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 31 DAY, 'DINNER', 24),
 (2, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 31 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 31 DAY, 'LUNCH', 11),
 (2, @d0 + INTERVAL 31 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 31 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 31 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 31 DAY, 'DINNER', 10),
 (2, @d0 + INTERVAL 31 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 31 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 4),
 (3, @d0 + INTERVAL 31 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 31 DAY, 'LUNCH', 23),
 (3, @d0 + INTERVAL 31 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 31 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 31 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 31 DAY, 'DINNER', 16),
 (3, @d0 + INTERVAL 31 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 31 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 31 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 31 DAY, 'LUNCH', 9),
 (4, @d0 + INTERVAL 31 DAY, 'LUNCH', 13),
 (4, @d0 + INTERVAL 31 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 31 DAY, 'DINNER', 16),
 (4, @d0 + INTERVAL 31 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 31 DAY, 'LUNCH', 6),
 (5, @d0 + INTERVAL 31 DAY, 'LUNCH', 7);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (5, @d0 + INTERVAL 31 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 31 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 31 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 31 DAY, 'DINNER', 14),
 (5, @d0 + INTERVAL 31 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 31 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 31 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 31 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 31 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 31 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 31 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 31 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 31 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 31 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 31 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 32 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 32 DAY, 'LUNCH', 9),
 (1, @d0 + INTERVAL 32 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 32 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 32 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 32 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 32 DAY, 'DINNER', 7),
 (1, @d0 + INTERVAL 32 DAY, 'DINNER', 21),
 (2, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 4),
 (2, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 32 DAY, 'LUNCH', 15),
 (2, @d0 + INTERVAL 32 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 32 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 32 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 32 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 32 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 32 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 32 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 3),
 (3, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 32 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 32 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 32 DAY, 'LUNCH', 8),
 (3, @d0 + INTERVAL 32 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 32 DAY, 'SNACKS', 18),
 (3, @d0 + INTERVAL 32 DAY, 'DINNER', 7),
 (3, @d0 + INTERVAL 32 DAY, 'DINNER', 21),
 (3, @d0 + INTERVAL 32 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 32 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 32 DAY, 'LUNCH', 23),
 (4, @d0 + INTERVAL 32 DAY, 'LUNCH', 16),
 (4, @d0 + INTERVAL 32 DAY, 'DINNER', 22),
 (4, @d0 + INTERVAL 32 DAY, 'DINNER', 16),
 (4, @d0 + INTERVAL 32 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 32 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 32 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 32 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 32 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 32 DAY, 'SNACKS', 19),
 (5, @d0 + INTERVAL 32 DAY, 'DINNER', 16),
 (5, @d0 + INTERVAL 32 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 32 DAY, 'DINNER', 12),
 (6, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 4),
 (6, @d0 + INTERVAL 32 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 32 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 32 DAY, 'LUNCH', 21),
 (6, @d0 + INTERVAL 32 DAY, 'LUNCH', 10),
 (6, @d0 + INTERVAL 32 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 32 DAY, 'SNACKS', 18),
 (6, @d0 + INTERVAL 32 DAY, 'DINNER', 22),
 (6, @d0 + INTERVAL 32 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 32 DAY, 'DINNER', 11),
 (1, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 33 DAY, 'LUNCH', 10),
 (1, @d0 + INTERVAL 33 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 33 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 33 DAY, 'SNACKS', 18);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (1, @d0 + INTERVAL 33 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 33 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 33 DAY, 'DINNER', 8),
 (1, @d0 + INTERVAL 33 DAY, 'DINNER', 22),
 (2, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 5),
 (2, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 33 DAY, 'LUNCH', 14),
 (2, @d0 + INTERVAL 33 DAY, 'LUNCH', 10),
 (2, @d0 + INTERVAL 33 DAY, 'LUNCH', 16),
 (2, @d0 + INTERVAL 33 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 33 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 33 DAY, 'DINNER', 6),
 (2, @d0 + INTERVAL 33 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 33 DAY, 'DINNER', 13),
 (3, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 33 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 33 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 33 DAY, 'LUNCH', 6),
 (3, @d0 + INTERVAL 33 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 33 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 33 DAY, 'DINNER', 21),
 (3, @d0 + INTERVAL 33 DAY, 'DINNER', 6),
 (3, @d0 + INTERVAL 33 DAY, 'DINNER', 8),
 (4, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 33 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 33 DAY, 'LUNCH', 21),
 (4, @d0 + INTERVAL 33 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 33 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 33 DAY, 'DINNER', 16),
 (4, @d0 + INTERVAL 33 DAY, 'DINNER', 17),
 (5, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 2),
 (5, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 33 DAY, 'LUNCH', 21),
 (5, @d0 + INTERVAL 33 DAY, 'LUNCH', 9),
 (5, @d0 + INTERVAL 33 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 33 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 33 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 33 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 33 DAY, 'DINNER', 11),
 (5, @d0 + INTERVAL 33 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 2),
 (6, @d0 + INTERVAL 33 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 33 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 33 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 33 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 33 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 33 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 33 DAY, 'DINNER', 21),
 (6, @d0 + INTERVAL 33 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 33 DAY, 'DINNER', 16),
 (1, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 4),
 (1, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 34 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 34 DAY, 'LUNCH', 23),
 (1, @d0 + INTERVAL 34 DAY, 'LUNCH', 8),
 (1, @d0 + INTERVAL 34 DAY, 'SNACKS', 19),
 (1, @d0 + INTERVAL 34 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 34 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 34 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 34 DAY, 'DINNER', 16),
 (2, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 1),
 (2, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 34 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 34 DAY, 'LUNCH', 21),
 (2, @d0 + INTERVAL 34 DAY, 'LUNCH', 11),
 (2, @d0 + INTERVAL 34 DAY, 'SNACKS', 18),
 (2, @d0 + INTERVAL 34 DAY, 'SNACKS', 20),
 (2, @d0 + INTERVAL 34 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 34 DAY, 'DINNER', 14),
 (2, @d0 + INTERVAL 34 DAY, 'DINNER', 24),
 (3, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 1),
 (3, @d0 + INTERVAL 34 DAY, 'LUNCH', 24),
 (3, @d0 + INTERVAL 34 DAY, 'LUNCH', 7),
 (3, @d0 + INTERVAL 34 DAY, 'LUNCH', 11),
 (3, @d0 + INTERVAL 34 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 34 DAY, 'SNACKS', 23),
 (3, @d0 + INTERVAL 34 DAY, 'DINNER', 13);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (3, @d0 + INTERVAL 34 DAY, 'DINNER', 21),
 (3, @d0 + INTERVAL 34 DAY, 'DINNER', 17),
 (4, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 3),
 (4, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 4),
 (4, @d0 + INTERVAL 34 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 34 DAY, 'LUNCH', 8),
 (4, @d0 + INTERVAL 34 DAY, 'LUNCH', 14),
 (4, @d0 + INTERVAL 34 DAY, 'DINNER', 24),
 (4, @d0 + INTERVAL 34 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 34 DAY, 'DINNER', 10),
 (5, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 3),
 (5, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 1),
 (5, @d0 + INTERVAL 34 DAY, 'LUNCH', 14),
 (5, @d0 + INTERVAL 34 DAY, 'LUNCH', 8),
 (5, @d0 + INTERVAL 34 DAY, 'LUNCH', 16),
 (5, @d0 + INTERVAL 34 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 34 DAY, 'SNACKS', 23),
 (5, @d0 + INTERVAL 34 DAY, 'DINNER', 21),
 (5, @d0 + INTERVAL 34 DAY, 'DINNER', 13),
 (5, @d0 + INTERVAL 34 DAY, 'DINNER', 7),
 (6, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 34 DAY, 'BREAKFAST', 3),
 (6, @d0 + INTERVAL 34 DAY, 'LUNCH', 23),
 (6, @d0 + INTERVAL 34 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 34 DAY, 'LUNCH', 9),
 (6, @d0 + INTERVAL 34 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 34 DAY, 'SNACKS', 19),
 (6, @d0 + INTERVAL 34 DAY, 'DINNER', 8),
 (6, @d0 + INTERVAL 34 DAY, 'DINNER', 16),
 (6, @d0 + INTERVAL 34 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 3),
 (1, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 1),
 (1, @d0 + INTERVAL 35 DAY, 'LUNCH', 16),
 (1, @d0 + INTERVAL 35 DAY, 'LUNCH', 24),
 (1, @d0 + INTERVAL 35 DAY, 'LUNCH', 21),
 (1, @d0 + INTERVAL 35 DAY, 'SNACKS', 20),
 (1, @d0 + INTERVAL 35 DAY, 'SNACKS', 23),
 (1, @d0 + INTERVAL 35 DAY, 'DINNER', 24),
 (1, @d0 + INTERVAL 35 DAY, 'DINNER', 10),
 (1, @d0 + INTERVAL 35 DAY, 'DINNER', 8),
 (2, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 2),
 (2, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 3),
 (2, @d0 + INTERVAL 35 DAY, 'LUNCH', 23),
 (2, @d0 + INTERVAL 35 DAY, 'LUNCH', 9),
 (2, @d0 + INTERVAL 35 DAY, 'LUNCH', 13),
 (2, @d0 + INTERVAL 35 DAY, 'SNACKS', 19),
 (2, @d0 + INTERVAL 35 DAY, 'SNACKS', 23),
 (2, @d0 + INTERVAL 35 DAY, 'DINNER', 7),
 (2, @d0 + INTERVAL 35 DAY, 'DINNER', 12),
 (2, @d0 + INTERVAL 35 DAY, 'DINNER', 14),
 (3, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 2),
 (3, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 5),
 (3, @d0 + INTERVAL 35 DAY, 'LUNCH', 13),
 (3, @d0 + INTERVAL 35 DAY, 'LUNCH', 21),
 (3, @d0 + INTERVAL 35 DAY, 'LUNCH', 9),
 (3, @d0 + INTERVAL 35 DAY, 'SNACKS', 20),
 (3, @d0 + INTERVAL 35 DAY, 'SNACKS', 19),
 (3, @d0 + INTERVAL 35 DAY, 'DINNER', 10),
 (3, @d0 + INTERVAL 35 DAY, 'DINNER', 16),
 (3, @d0 + INTERVAL 35 DAY, 'DINNER', 6),
 (4, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 1),
 (4, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 2),
 (4, @d0 + INTERVAL 35 DAY, 'LUNCH', 15),
 (4, @d0 + INTERVAL 35 DAY, 'LUNCH', 10),
 (4, @d0 + INTERVAL 35 DAY, 'LUNCH', 16),
 (4, @d0 + INTERVAL 35 DAY, 'DINNER', 14),
 (4, @d0 + INTERVAL 35 DAY, 'DINNER', 11),
 (4, @d0 + INTERVAL 35 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 5),
 (5, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 4),
 (5, @d0 + INTERVAL 35 DAY, 'LUNCH', 10),
 (5, @d0 + INTERVAL 35 DAY, 'LUNCH', 23),
 (5, @d0 + INTERVAL 35 DAY, 'LUNCH', 24),
 (5, @d0 + INTERVAL 35 DAY, 'SNACKS', 20),
 (5, @d0 + INTERVAL 35 DAY, 'SNACKS', 18),
 (5, @d0 + INTERVAL 35 DAY, 'DINNER', 12),
 (5, @d0 + INTERVAL 35 DAY, 'DINNER', 7),
 (5, @d0 + INTERVAL 35 DAY, 'DINNER', 10),
 (6, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 1),
 (6, @d0 + INTERVAL 35 DAY, 'BREAKFAST', 4);
INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES
 (6, @d0 + INTERVAL 35 DAY, 'LUNCH', 8),
 (6, @d0 + INTERVAL 35 DAY, 'LUNCH', 7),
 (6, @d0 + INTERVAL 35 DAY, 'LUNCH', 16),
 (6, @d0 + INTERVAL 35 DAY, 'SNACKS', 23),
 (6, @d0 + INTERVAL 35 DAY, 'SNACKS', 20),
 (6, @d0 + INTERVAL 35 DAY, 'DINNER', 11),
 (6, @d0 + INTERVAL 35 DAY, 'DINNER', 6),
 (6, @d0 + INTERVAL 35 DAY, 'DINNER', 12);

-- ---------- seed-only helper procedures (dropped at the end) ----------
-- They replay history at a GIVEN time. The live procedures always use
-- NOW(), which is why these separate helpers exist.
DELIMITER $$
-- A shelter responds at p_at: picks the p_pick-th best ELIGIBLE shelter
-- by fn_match_score (shelters that already claimed and cancelled this
-- batch are skipped). Does nothing if no shelter is eligible.
CREATE PROCEDURE seed_claim(p_batch INT UNSIGNED, p_at DATETIME, p_pick INT)
proc: BEGIN
  DECLARE v_shelter INT UNSIGNED; DECLARE v_score DECIMAL(5,2); DECLARE v_km DECIMAL(8,3);
  IF p_at >= NOW() OR NOT EXISTS (SELECT 1 FROM surplus_batch WHERE batch_id = p_batch) THEN
    LEAVE proc;     -- history stops before the load time
  END IF;
  IF (SELECT status FROM surplus_batch WHERE batch_id = p_batch) <> 'AVAILABLE'
     OR (SELECT safe_until FROM surplus_batch WHERE batch_id = p_batch) <= p_at THEN
    LEAVE proc;
  END IF;
  SELECT shelter_id, score INTO v_shelter, v_score FROM (
    SELECT s.site_id AS shelter_id, fn_match_score(p_batch, s.site_id, p_at) AS score
      FROM shelter s
     WHERE NOT EXISTS (SELECT 1 FROM claim c WHERE c.batch_id = p_batch AND c.shelter_site_id = s.site_id)) r
   WHERE score IS NOT NULL
   ORDER BY score DESC, shelter_id
   LIMIT 1 OFFSET 0;
  IF p_pick > 1 THEN   -- second-best shelter answered first, if there is one
    SELECT shelter_id, score INTO v_shelter, v_score FROM (
      SELECT s.site_id AS shelter_id, fn_match_score(p_batch, s.site_id, p_at) AS score
        FROM shelter s
       WHERE NOT EXISTS (SELECT 1 FROM claim c WHERE c.batch_id = p_batch AND c.shelter_site_id = s.site_id)) r
     WHERE score IS NOT NULL
     ORDER BY score DESC, shelter_id
     LIMIT 1 OFFSET 1;
  END IF;
  IF v_shelter IS NULL THEN LEAVE proc; END IF;
  SELECT fn_distance_km(ms.location, ss.location) INTO v_km
    FROM surplus_batch b JOIN site ms ON ms.site_id = b.mess_site_id JOIN site ss ON ss.site_id = v_shelter
   WHERE b.batch_id = p_batch;
  INSERT INTO claim (batch_id, shelter_site_id, claimed_by, claimed_at, match_score, distance_km)
  SELECT p_batch, v_shelter, u.user_id, p_at, v_score, v_km
    FROM app_user u WHERE u.site_id = v_shelter AND u.role = 'SHELTER' LIMIT 1;
END$$

-- The shelter cancels its live claim at p_at.
CREATE PROCEDURE seed_cancel(p_batch INT UNSIGNED, p_at DATETIME, p_reason VARCHAR(255))
BEGIN
  IF p_at < NOW() THEN
  UPDATE claim SET status = 'CANCELLED', closed_at = p_at, close_reason = p_reason
   WHERE batch_id = p_batch AND status = 'ACTIVE';
  END IF;
END$$

-- Back-fill forecasts (no alerts) for the last 14 days before the load date
CREATE PROCEDURE seed_forecast(p_date DATE)
BEGIN
  IF p_date < CURRENT_DATE AND p_date >= CURRENT_DATE - INTERVAL 14 DAY THEN
    CALL sp_generate_forecast(p_date, FALSE);
  END IF;
END$$

-- A volunteer trip starting at p_start for the live claims of the given
-- batches. Uses the real sp_create_trip for stop order and ETAs, then
-- fills in the historical arrival times, custody events and outcome.
-- Volunteer = verified, available, can carry the load, fewest trips so
-- far (spreads the work). Food arriving after safe_until, or the batch
-- listed in p_fail_batch, fails the hygiene check.
CREATE PROCEDURE seed_trip(p_batches JSON, p_start DATETIME, p_fail_batch INT UNSIGNED, p_temp_drop DECIMAL(4,1))
proc: BEGIN
  DECLARE v_claims JSON; DECLARE v_load DECIMAL(9,2); DECLARE v_vol INT UNSIGNED;
  DECLARE v_trip INT UNSIGNED; DECLARE v_done BOOLEAN DEFAULT FALSE;
  DECLARE v_seq TINYINT UNSIGNED; DECLARE v_type VARCHAR(6); DECLARE v_eta DATETIME;
  DECLARE v_arr DATETIME; DECLARE v_lag INT DEFAULT 0;
  DECLARE v_failed BOOLEAN DEFAULT FALSE; DECLARE v_i INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT stop_seq, stop_type, planned_eta FROM trip_stop
                          WHERE trip_id = v_trip ORDER BY stop_seq;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
  IF p_start >= NOW() THEN LEAVE proc; END IF;   -- history only

  SELECT JSON_ARRAYAGG(c.claim_id), SUM(b.quantity_kg) INTO v_claims, v_load
    FROM JSON_TABLE(p_batches, '$[*]' COLUMNS (id INT UNSIGNED PATH '$')) j
    JOIN claim c ON c.batch_id = j.id AND c.status = 'ACTIVE'
    JOIN surplus_batch b ON b.batch_id = c.batch_id AND b.safe_until > p_start;
  IF v_claims IS NULL THEN LEAVE proc; END IF;

  SELECT v.user_id INTO v_vol
    FROM volunteer v
   WHERE v.verified_at IS NOT NULL AND v.is_available AND v.max_load_kg >= v_load
   ORDER BY (SELECT COUNT(*) FROM pickup_trip t WHERE t.volunteer_id = v.user_id), v.max_load_kg, v.user_id
   LIMIT 1;
  IF v_vol IS NULL THEN LEAVE proc; END IF;

  BEGIN
    -- sp_create_trip refuses a route that would deliver food late
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_failed = TRUE;
    CALL sp_create_trip(v_vol, v_claims, p_start, v_trip);
  END;
  IF v_failed THEN
    -- fall back to one trip per batch (recursion depth 1)
    IF JSON_LENGTH(p_batches) > 1 THEN
      WHILE v_i < JSON_LENGTH(p_batches) DO
        CALL seed_trip(JSON_ARRAY(JSON_EXTRACT(p_batches, CONCAT('$[', v_i, ']'))), p_start, p_fail_batch, p_temp_drop);
        SET v_i = v_i + 1;
      END WHILE;
    END IF;
    LEAVE proc;     -- a single batch that cannot arrive in time is left to expire
  END IF;
  UPDATE pickup_trip SET status = 'IN_PROGRESS', started_at = p_start WHERE trip_id = v_trip;

  OPEN cur;
  stops: LOOP
    FETCH cur INTO v_seq, v_type, v_eta;
    IF v_done THEN LEAVE stops; END IF;
    SET v_lag = v_lag + FLOOR(RAND(v_trip * 31 + v_seq) * 6);       -- a few minutes of delay
    SET v_arr = v_eta + INTERVAL v_lag MINUTE;
    UPDATE trip_stop SET arrived_at = v_arr, departed_at = v_arr + INTERVAL 5 MINUTE
     WHERE trip_id = v_trip AND stop_seq = v_seq;
    IF v_type = 'PICKUP' THEN
      INSERT INTO custody_event (batch_id, claim_id, trip_id, event_type, event_time, actor_user_id, temperature_c)
      SELECT c.batch_id, c.claim_id, v_trip, 'PICKED_UP', v_arr + INTERVAL 5 MINUTE, v_vol,
             CASE b.storage WHEN 'HOT_HELD' THEN 68.0 WHEN 'CHILLED' THEN 4.0 ELSE 29.0 END
        FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id JOIN surplus_batch b ON b.batch_id = c.batch_id
       WHERE ti.trip_id = v_trip AND ti.pickup_seq = v_seq;
      UPDATE surplus_batch b JOIN claim c ON c.batch_id = b.batch_id AND c.status = 'ACTIVE'
        JOIN trip_item ti ON ti.claim_id = c.claim_id
         SET b.status = 'IN_TRANSIT' WHERE ti.trip_id = v_trip AND ti.pickup_seq = v_seq;
    ELSE
      -- hygiene check at the door: on time and (for the chosen batch) temperature
      INSERT INTO custody_event (batch_id, claim_id, trip_id, event_type, event_time, actor_user_id, temperature_c, hygiene_ok, notes)
      SELECT c.batch_id, c.claim_id, v_trip, 'HYGIENE_CHECK', v_arr + INTERVAL 2 MINUTE,
             (SELECT user_id FROM app_user WHERE site_id = c.shelter_site_id AND role = 'SHELTER' LIMIT 1),
             CASE WHEN b.batch_id = p_fail_batch THEN p_temp_drop
                  WHEN b.storage = 'HOT_HELD' THEN 62.0 WHEN b.storage = 'CHILLED' THEN 6.0 ELSE 30.0 END,
             (v_arr < b.safe_until AND b.batch_id <> COALESCE(p_fail_batch, 0)),
             CASE WHEN v_arr >= b.safe_until THEN 'arrived after safe-until time'
                  WHEN b.batch_id = p_fail_batch THEN 'hot food below 60 C on arrival' END
        FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id JOIN surplus_batch b ON b.batch_id = c.batch_id
       WHERE ti.trip_id = v_trip AND ti.drop_seq = v_seq;
      INSERT INTO custody_event (batch_id, claim_id, trip_id, event_type, event_time, actor_user_id)
      SELECT c.batch_id, c.claim_id, v_trip, 'DELIVERED', v_arr + INTERVAL 4 MINUTE, v_vol
        FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id JOIN surplus_batch b ON b.batch_id = c.batch_id
       WHERE ti.trip_id = v_trip AND ti.drop_seq = v_seq
         AND v_arr < b.safe_until AND b.batch_id <> COALESCE(p_fail_batch, 0);
      -- outcome is decided first into a temp table: the claim trigger
      -- updates surplus_batch, so the UPDATE itself must not read it (error 1442)
      DROP TEMPORARY TABLE IF EXISTS tmp_outcome;
      CREATE TEMPORARY TABLE tmp_outcome
      SELECT c.claim_id,
             IF(v_arr < b.safe_until AND b.batch_id <> COALESCE(p_fail_batch, 0), 'FULFILLED', 'REJECTED') AS new_status,
             IF(v_arr >= b.safe_until, 'arrived after safe-until time',
                IF(b.batch_id = p_fail_batch, 'failed hygiene check: temperature', NULL)) AS reason
        FROM trip_item ti JOIN claim c ON c.claim_id = ti.claim_id JOIN surplus_batch b ON b.batch_id = c.batch_id
       WHERE ti.trip_id = v_trip AND ti.drop_seq = v_seq;
      UPDATE claim c JOIN tmp_outcome o ON o.claim_id = c.claim_id
         SET c.status = o.new_status, c.closed_at = v_arr + INTERVAL 4 MINUTE, c.close_reason = o.reason;
      DROP TEMPORARY TABLE tmp_outcome;
    END IF;
  END LOOP;
  CLOSE cur;
  UPDATE pickup_trip SET status = 'COMPLETED',
         completed_at = (SELECT MAX(departed_at) FROM trip_stop WHERE trip_id = v_trip)
   WHERE trip_id = v_trip;
END$$
DELIMITER ;

-- ---------- history replayed in time order (490 batches generated; those on/after today are skipped) ----------
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 1, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 10.89, 'HOT_HELD', (@d0 + INTERVAL 47203 SECOND), (@d0 + INTERVAL 50792 SECOND), (@d0 + INTERVAL 47203 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 51203 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 51203 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 1;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 3, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 7.85, 'CHILLED', (@d0 + INTERVAL 46453 SECOND), (@d0 + INTERVAL 50921 SECOND), (@d0 + INTERVAL 46453 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 51344 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 51344 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 3;
CALL seed_claim(3, (@d0 + INTERVAL 51806 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 5, 3, 3, 5, 'LUNCH', 'Egg curry (lunch leftover)', 7.19, 'HOT_HELD', (@d0 + INTERVAL 46530 SECOND), (@d0 + INTERVAL 51735 SECOND), (@d0 + INTERVAL 46530 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 51991 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 51991 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 5;
CALL seed_claim(1, (@d0 + INTERVAL 52229 SECOND), 1);
CALL seed_claim(5, (@d0 + INTERVAL 52594 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 2, 1, 2, 3, 'LUNCH', 'Aloo gobi (lunch leftover)', 14.31, 'HOT_HELD', (@d0 + INTERVAL 46257 SECOND), (@d0 + INTERVAL 52303 SECOND), (@d0 + INTERVAL 46257 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 52658 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 52658 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 2;
CALL seed_trip('[3, 1, 5]', (@d0 + INTERVAL 53541 SECOND), NULL, 54.0);
CALL seed_claim(2, (@d0 + INTERVAL 53579 SECOND), 1);
CALL seed_trip('[2]', (@d0 + INTERVAL 54972 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 6, 5, 1, 7, 'DINNER', 'Veg biryani (dinner leftover)', 6.02, 'HOT_HELD', (@d0 + INTERVAL 73486 SECOND), (@d0 + INTERVAL 77924 SECOND), (@d0 + INTERVAL 73486 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 78285 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 78285 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 6;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 4, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 8.28, 'CHILLED', (@d0 + INTERVAL 73266 SECOND), (@d0 + INTERVAL 78727 SECOND), (@d0 + INTERVAL 73266 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 79263 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 79263 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 4;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 7, 5, 1, 7, 'DINNER', 'Steamed rice (dinner leftover)', 7.15, 'CHILLED', (@d0 + INTERVAL 74167 SECOND), (@d0 + INTERVAL 79373 SECOND), (@d0 + INTERVAL 74167 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 79746 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 79746 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 7;
CALL seed_claim(6, (@d0 + INTERVAL 80484 SECOND), 1);
CALL seed_claim(4, (@d0 + INTERVAL 80609 SECOND), 1);
CALL seed_trip('[6, 4]', (@d0 + INTERVAL 81567 SECOND), NULL, 54.0);
CALL seed_claim(7, (@d0 + INTERVAL 116291 SECOND), 1);
CALL seed_trip('[7]', (@d0 + INTERVAL 117749 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 9, 2, 1, 4, 'LUNCH', 'Steamed rice (lunch leftover)', 9.05, 'HOT_HELD', (@d0 + INTERVAL 134006 SECOND), (@d0 + INTERVAL 137077 SECOND), (@d0 + INTERVAL 134006 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 137632 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 137632 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 9;
CALL seed_claim(9, (@d0 + INTERVAL 138275 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 8, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 6.50, 'HOT_HELD', (@d0 + INTERVAL 133101 SECOND), (@d0 + INTERVAL 138358 SECOND), (@d0 + INTERVAL 133101 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 138865 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 138865 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 8;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 10, 3, 3, 5, 'LUNCH', 'Chicken curry (lunch leftover)', 6.08, 'CHILLED', (@d0 + INTERVAL 133738 SECOND), (@d0 + INTERVAL 138968 SECOND), (@d0 + INTERVAL 133738 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 139293 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 139293 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 10;
CALL seed_claim(8, (@d0 + INTERVAL 139598 SECOND), 1);
CALL seed_trip('[9, 8]', (@d0 + INTERVAL 140452 SECOND), NULL, 54.0);
CALL seed_claim(10, (@d0 + INTERVAL 141120 SECOND), 2);
CALL seed_trip('[10]', (@d0 + INTERVAL 142369 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 11, 5, 1, 7, 'DINNER', 'Steamed rice (dinner leftover)', 7.27, 'HOT_HELD', (@d0 + INTERVAL 159601 SECOND), (@d0 + INTERVAL 164024 SECOND), (@d0 + INTERVAL 159601 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 164383 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 164383 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 11;
CALL seed_claim(11, (@d0 + INTERVAL 166880 SECOND), 1);
CALL seed_trip('[11]', (@d0 + INTERVAL 167896 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 12, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.15, 'HOT_HELD', (@d0 + INTERVAL 203237 SECOND), (@d0 + INTERVAL 207111 SECOND), (@d0 + INTERVAL 203237 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 207640 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 207640 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 12;
CALL seed_claim(12, (@d0 + INTERVAL 207917 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 13, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 7.13, 'HOT_HELD', (@d0 + INTERVAL 202601 SECOND), (@d0 + INTERVAL 208484 SECOND), (@d0 + INTERVAL 202601 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 208844 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 208844 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 13;
CALL seed_claim(13, (@d0 + INTERVAL 209454 SECOND), 1);
CALL seed_trip('[12, 13]', (@d0 + INTERVAL 210212 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 17, 3, 1, 5, 'LUNCH', 'Curd rice (lunch leftover)', 6.08, 'HOT_HELD', (@d0 + INTERVAL 218822 SECOND), (@d0 + INTERVAL 224994 SECOND), (@d0 + INTERVAL 218822 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 225565 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 225565 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 17;
CALL seed_claim(17, (@d0 + INTERVAL 226793 SECOND), 1);
CALL seed_trip('[17]', (@d0 + INTERVAL 228032 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 14, 1, 2, 3, 'DINNER', 'Aloo gobi (dinner leftover)', 9.54, 'HOT_HELD', (@d0 + INTERVAL 245844 SECOND), (@d0 + INTERVAL 250166 SECOND), (@d0 + INTERVAL 245844 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 250805 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 250805 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 14;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 18, 3, 1, 5, 'DINNER', 'Veg biryani (dinner leftover)', 8.93, 'CHILLED', (@d0 + INTERVAL 246886 SECOND), (@d0 + INTERVAL 250701 SECOND), (@d0 + INTERVAL 246886 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 251330 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 251330 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 18;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 16, 2, 1, 4, 'DINNER', 'Dal tadka (dinner leftover)', 7.01, 'HOT_HELD', (@d0 + INTERVAL 245489 SECOND), (@d0 + INTERVAL 251077 SECOND), (@d0 + INTERVAL 245489 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 251729 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 251729 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 16;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 15, 2, 1, 4, 'DINNER', 'Steamed rice (dinner leftover)', 6.50, 'HOT_HELD', (@d0 + INTERVAL 246962 SECOND), (@d0 + INTERVAL 251610 SECOND), (@d0 + INTERVAL 246962 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 251866 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 251866 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 15;
CALL seed_claim(14, (@d0 + INTERVAL 252038 SECOND), 1);
CALL seed_trip('[14]', (@d0 + INTERVAL 252808 SECOND), 14, 54.0);
CALL seed_claim(18, (@d0 + INTERVAL 289043 SECOND), 1);
CALL seed_trip('[18]', (@d0 + INTERVAL 290236 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 24, 5, 1, 7, 'LUNCH', 'Dal tadka (lunch leftover)', 11.53, 'HOT_HELD', (@d0 + INTERVAL 305197 SECOND), (@d0 + INTERVAL 309768 SECOND), (@d0 + INTERVAL 305197 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 310440 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 310440 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 24;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 22, 3, 1, 5, 'LUNCH', 'Steamed rice (lunch leftover)', 9.18, 'HOT_HELD', (@d0 + INTERVAL 304855 SECOND), (@d0 + INTERVAL 309922 SECOND), (@d0 + INTERVAL 304855 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 310638 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 310638 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 22;
CALL seed_claim(24, (@d0 + INTERVAL 311927 SECOND), 1);
CALL seed_claim(22, (@d0 + INTERVAL 311967 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 21, 3, 3, 5, 'LUNCH', 'Fish fry (lunch leftover)', 7.59, 'HOT_HELD', (@d0 + INTERVAL 305692 SECOND), (@d0 + INTERVAL 311901 SECOND), (@d0 + INTERVAL 305692 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 312288 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 312288 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 21;
CALL seed_trip('[24]', (@d0 + INTERVAL 312765 SECOND), NULL, 54.0);
CALL seed_claim(21, (@d0 + INTERVAL 313681 SECOND), 2);
CALL seed_cancel(22, (@d0 + INTERVAL 313943 SECOND), 'no transport available');
CALL seed_claim(22, (@d0 + INTERVAL 314516 SECOND), 1);
CALL seed_trip('[21, 22]', (@d0 + INTERVAL 315451 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 20, 2, 1, 4, 'DINNER', 'Dal tadka (dinner leftover)', 10.29, 'HOT_HELD', (@d0 + INTERVAL 333456 SECOND), (@d0 + INTERVAL 336513 SECOND), (@d0 + INTERVAL 333456 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 337146 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 337146 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 20;
CALL seed_claim(20, (@d0 + INTERVAL 338477 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 23, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 7.69, 'CHILLED', (@d0 + INTERVAL 332869 SECOND), (@d0 + INTERVAL 338813 SECOND), (@d0 + INTERVAL 332869 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 339248 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 339248 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 23;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 19, 2, 1, 4, 'DINNER', 'Veg biryani (dinner leftover)', 11.00, 'HOT_HELD', (@d0 + INTERVAL 332290 SECOND), (@d0 + INTERVAL 338828 SECOND), (@d0 + INTERVAL 332290 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 339248 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 339248 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 19;
CALL seed_trip('[20]', (@d0 + INTERVAL 339541 SECOND), NULL, 54.0);
CALL seed_claim(23, (@d0 + INTERVAL 340585 SECOND), 1);
CALL seed_claim(19, (@d0 + INTERVAL 340949 SECOND), 1);
CALL seed_trip('[23, 19]', (@d0 + INTERVAL 342224 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 25, 2, 5, 4, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.20, 'HOT_HELD', (@d0 + INTERVAL 375165 SECOND), (@d0 + INTERVAL 379890 SECOND), (@d0 + INTERVAL 375165 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 380462 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 380462 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 25;
CALL seed_claim(25, (@d0 + INTERVAL 381048 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 27, 3, 5, 5, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.14, 'CHILLED', (@d0 + INTERVAL 375716 SECOND), (@d0 + INTERVAL 380490 SECOND), (@d0 + INTERVAL 375716 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 381089 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 381089 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 27;
CALL seed_claim(27, (@d0 + INTERVAL 381909 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 26, 3, 5, 5, 'BREAKFAST', 'Upma (breakfast leftover)', 8.22, 'HOT_HELD', (@d0 + INTERVAL 376128 SECOND), (@d0 + INTERVAL 381758 SECOND), (@d0 + INTERVAL 376128 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 382200 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 382200 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 26;
CALL seed_claim(26, (@d0 + INTERVAL 383045 SECOND), 1);
CALL seed_trip('[25, 27]', (@d0 + INTERVAL 383100 SECOND), NULL, 54.0);
CALL seed_trip('[26]', (@d0 + INTERVAL 383871 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 28, 3, 2, 5, 'LUNCH', 'Vegetable kurma (lunch leftover)', 6.32, 'CHILLED', (@d0 + INTERVAL 392639 SECOND), (@d0 + INTERVAL 396651 SECOND), (@d0 + INTERVAL 392639 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 396949 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 396949 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 28;
CALL seed_claim(28, (@d0 + INTERVAL 397807 SECOND), 2);
CALL seed_trip('[28]', (@d0 + INTERVAL 399037 SECOND), 28, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 29, 3, 1, 5, 'DINNER', 'Veg biryani (dinner leftover)', 8.28, 'HOT_HELD', (@d0 + INTERVAL 419045 SECOND), (@d0 + INTERVAL 424906 SECOND), (@d0 + INTERVAL 419045 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 425565 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 425565 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 29;
CALL seed_claim(29, (@d0 + INTERVAL 428266 SECOND), 1);
CALL seed_trip('[29]', (@d0 + INTERVAL 429707 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 30, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 6.47, 'CHILLED', (@d0 + INTERVAL 462736 SECOND), (@d0 + INTERVAL 466633 SECOND), (@d0 + INTERVAL 462736 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 466939 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 466939 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 30;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 41, 3, 5, 5, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 6.28, 'CHILLED', (@d0 + INTERVAL 462742 SECOND), (@d0 + INTERVAL 466309 SECOND), (@d0 + INTERVAL 462742 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 467012 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 467012 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 41;
CALL seed_claim(41, (@d0 + INTERVAL 467584 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 42, 3, 5, 5, 'BREAKFAST', 'Pongal (breakfast leftover)', 8.53, 'HOT_HELD', (@d0 + INTERVAL 462476 SECOND), (@d0 + INTERVAL 467090 SECOND), (@d0 + INTERVAL 462476 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 467796 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 467796 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 42;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 36, 2, 5, 4, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 9.46, 'HOT_HELD', (@d0 + INTERVAL 462884 SECOND), (@d0 + INTERVAL 467686 SECOND), (@d0 + INTERVAL 462884 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 468167 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 468167 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 36;
CALL seed_claim(30, (@d0 + INTERVAL 468306 SECOND), 1);
CALL seed_claim(42, (@d0 + INTERVAL 468445 SECOND), 2);
CALL seed_claim(36, (@d0 + INTERVAL 468776 SECOND), 2);
CALL seed_trip('[41, 30, 42]', (@d0 + INTERVAL 469300 SECOND), NULL, 54.0);
CALL seed_trip('[36]', (@d0 + INTERVAL 469787 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 32, 1, 8, 3, 'LUNCH', 'Fruit salad (lunch leftover)', 11.15, 'CHILLED', (@d0 + INTERVAL 479519 SECOND), (@d0 + INTERVAL 482787 SECOND), (@d0 + INTERVAL 479519 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 483057 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 483057 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 32;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 48, 5, 4, 7, 'LUNCH', 'Chapati (lunch leftover)', 9.28, 'AMBIENT', (@d0 + INTERVAL 478148 SECOND), (@d0 + INTERVAL 482664 SECOND), (@d0 + INTERVAL 478148 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 483278 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 483278 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 48;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 37, 2, 2, 4, 'LUNCH', 'Vegetable kurma (lunch leftover)', 6.42, 'AMBIENT', (@d0 + INTERVAL 479076 SECOND), (@d0 + INTERVAL 482613 SECOND), (@d0 + INTERVAL 479076 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 483297 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 483297 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 37;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 43, 3, 1, 5, 'LUNCH', 'Dal tadka (lunch leftover)', 16.41, 'CHILLED', (@d0 + INTERVAL 478607 SECOND), (@d0 + INTERVAL 482832 SECOND), (@d0 + INTERVAL 478607 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 483326 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 483326 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 43;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 31, 1, 1, 3, 'LUNCH', 'Sambar rice (lunch leftover)', 17.36, 'AMBIENT', (@d0 + INTERVAL 479324 SECOND), (@d0 + INTERVAL 483199 SECOND), (@d0 + INTERVAL 479324 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 483518 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 483518 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 31;
CALL seed_claim(32, (@d0 + INTERVAL 483561 SECOND), 1);
CALL seed_claim(37, (@d0 + INTERVAL 483770 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 33, 1, 2, 3, 'LUNCH', 'Aloo gobi (lunch leftover)', 9.78, 'HOT_HELD', (@d0 + INTERVAL 478002 SECOND), (@d0 + INTERVAL 483227 SECOND), (@d0 + INTERVAL 478002 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 483778 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 483778 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 33;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 38, 2, 1, 4, 'LUNCH', 'Curd rice (lunch leftover)', 9.84, 'HOT_HELD', (@d0 + INTERVAL 478160 SECOND), (@d0 + INTERVAL 483382 SECOND), (@d0 + INTERVAL 478160 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 484059 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 484059 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 38;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 50, 6, 1, 8, 'LUNCH', 'Veg biryani (lunch leftover)', 9.39, 'HOT_HELD', (@d0 + INTERVAL 478138 SECOND), (@d0 + INTERVAL 483746 SECOND), (@d0 + INTERVAL 478138 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 484095 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 484095 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 50;
CALL seed_claim(31, (@d0 + INTERVAL 484144 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 44, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 9.47, 'CHILLED', (@d0 + INTERVAL 479652 SECOND), (@d0 + INTERVAL 483596 SECOND), (@d0 + INTERVAL 479652 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 484151 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 484151 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 44;
CALL seed_claim(43, (@d0 + INTERVAL 484194 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 47, 5, 3, 7, 'LUNCH', 'Egg curry (lunch leftover)', 7.80, 'CHILLED', (@d0 + INTERVAL 477952 SECOND), (@d0 + INTERVAL 484000 SECOND), (@d0 + INTERVAL 477952 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 484242 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 484242 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 47;
CALL seed_claim(48, (@d0 + INTERVAL 484338 SECOND), 2);
CALL seed_claim(33, (@d0 + INTERVAL 484376 SECOND), 1);
CALL seed_claim(47, (@d0 + INTERVAL 484622 SECOND), 2);
CALL seed_claim(38, (@d0 + INTERVAL 484815 SECOND), 1);
CALL seed_claim(50, (@d0 + INTERVAL 484855 SECOND), 1);
CALL seed_trip('[32, 37, 31]', (@d0 + INTERVAL 484934 SECOND), NULL, 54.0);
CALL seed_claim(44, (@d0 + INTERVAL 485418 SECOND), 1);
CALL seed_trip('[33, 47, 43]', (@d0 + INTERVAL 485456 SECOND), NULL, 54.0);
CALL seed_trip('[48, 38, 50]', (@d0 + INTERVAL 486301 SECOND), NULL, 54.0);
CALL seed_trip('[44]', (@d0 + INTERVAL 486606 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 35, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 12.02, 'CHILLED', (@d0 + INTERVAL 506405 SECOND), (@d0 + INTERVAL 509980 SECOND), (@d0 + INTERVAL 506405 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 510305 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 510305 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 35;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 34, 1, 7, 3, 'DINNER', 'Semiya payasam (dinner leftover)', 10.05, 'CHILLED', (@d0 + INTERVAL 504952 SECOND), (@d0 + INTERVAL 510107 SECOND), (@d0 + INTERVAL 504952 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 510476 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 510476 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 34;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 45, 3, 1, 5, 'DINNER', 'Sambar rice (dinner leftover)', 14.07, 'CHILLED', (@d0 + INTERVAL 505090 SECOND), (@d0 + INTERVAL 510809 SECOND), (@d0 + INTERVAL 505090 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 511109 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 511109 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 45;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 46, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 8.01, 'CHILLED', (@d0 + INTERVAL 504959 SECOND), (@d0 + INTERVAL 510632 SECOND), (@d0 + INTERVAL 504959 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 511291 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 511291 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 46;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 40, 2, 2, 4, 'DINNER', 'Vegetable kurma (dinner leftover)', 7.70, 'HOT_HELD', (@d0 + INTERVAL 506040 SECOND), (@d0 + INTERVAL 511060 SECOND), (@d0 + INTERVAL 506040 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 511716 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 511716 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 40;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 49, 5, 3, 7, 'DINNER', 'Chicken curry (dinner leftover)', 7.81, 'CHILLED', (@d0 + INTERVAL 505267 SECOND), (@d0 + INTERVAL 511232 SECOND), (@d0 + INTERVAL 505267 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 511722 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 511722 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 49;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 39, 2, 1, 4, 'DINNER', 'Steamed rice (dinner leftover)', 8.27, 'HOT_HELD', (@d0 + INTERVAL 505740 SECOND), (@d0 + INTERVAL 511139 SECOND), (@d0 + INTERVAL 505740 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 511852 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 511852 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 39;
CALL seed_claim(34, (@d0 + INTERVAL 512101 SECOND), 1);
CALL seed_claim(46, (@d0 + INTERVAL 512963 SECOND), 1);
CALL seed_claim(39, (@d0 + INTERVAL 513283 SECOND), 1);
CALL seed_trip('[34, 46, 39]', (@d0 + INTERVAL 514634 SECOND), NULL, 54.0);
CALL seed_claim(40, (@d0 + INTERVAL 515713 SECOND), 1);
CALL seed_trip('[40]', (@d0 + INTERVAL 517108 SECOND), NULL, 54.0);
CALL seed_claim(35, (@d0 + INTERVAL 546035 SECOND), 1);
CALL seed_trip('[35]', (@d0 + INTERVAL 546754 SECOND), NULL, 54.0);
CALL seed_claim(49, (@d0 + INTERVAL 547330 SECOND), 1);
CALL seed_claim(45, (@d0 + INTERVAL 547844 SECOND), 1);
CALL seed_trip('[45]', (@d0 + INTERVAL 548681 SECOND), NULL, 54.0);
CALL seed_trip('[49]', (@d0 + INTERVAL 548718 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 61, 3, 5, 5, 'BREAKFAST', 'Pongal (breakfast leftover)', 6.30, 'HOT_HELD', (@d0 + INTERVAL 549277 SECOND), (@d0 + INTERVAL 553277 SECOND), (@d0 + INTERVAL 549277 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 553644 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 553644 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 61;
CALL seed_claim(61, (@d0 + INTERVAL 554814 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 73, 6, 5, 8, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.53, 'HOT_HELD', (@d0 + INTERVAL 549864 SECOND), (@d0 + INTERVAL 554534 SECOND), (@d0 + INTERVAL 549864 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 555059 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 555059 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 73;
CALL seed_claim(73, (@d0 + INTERVAL 555694 SECOND), 1);
CALL seed_trip('[61, 73]', (@d0 + INTERVAL 556976 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 58, 2, 3, 4, 'LUNCH', 'Fish fry (lunch leftover)', 7.94, 'AMBIENT', (@d0 + INTERVAL 566080 SECOND), (@d0 + INTERVAL 569294 SECOND), (@d0 + INTERVAL 566080 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 569554 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 569554 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 58;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 68, 5, 2, 7, 'LUNCH', 'Vegetable kurma (lunch leftover)', 8.25, 'HOT_HELD', (@d0 + INTERVAL 564481 SECOND), (@d0 + INTERVAL 568980 SECOND), (@d0 + INTERVAL 564481 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 569686 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 569686 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 68;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 52, 1, 1, 3, 'LUNCH', 'Dal tadka (lunch leftover)', 15.85, 'HOT_HELD', (@d0 + INTERVAL 565672 SECOND), (@d0 + INTERVAL 569212 SECOND), (@d0 + INTERVAL 565672 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 569701 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 569701 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 52;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 53, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 6.40, 'CHILLED', (@d0 + INTERVAL 565101 SECOND), (@d0 + INTERVAL 569138 SECOND), (@d0 + INTERVAL 565101 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 569757 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 569757 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 53;
CALL seed_claim(68, (@d0 + INTERVAL 570182 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 70, 5, 2, 7, 'LUNCH', 'Aloo gobi (lunch leftover)', 8.88, 'CHILLED', (@d0 + INTERVAL 566069 SECOND), (@d0 + INTERVAL 569938 SECOND), (@d0 + INTERVAL 566069 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 570366 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 570366 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 70;
CALL seed_claim(52, (@d0 + INTERVAL 570403 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 74, 6, 2, 8, 'LUNCH', 'Vegetable kurma (lunch leftover)', 6.68, 'AMBIENT', (@d0 + INTERVAL 565492 SECOND), (@d0 + INTERVAL 570228 SECOND), (@d0 + INTERVAL 565492 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 570566 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 570566 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 74;
CALL seed_claim(58, (@d0 + INTERVAL 570610 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 63, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 9.53, 'CHILLED', (@d0 + INTERVAL 564231 SECOND), (@d0 + INTERVAL 570369 SECOND), (@d0 + INTERVAL 564231 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 570686 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 570686 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 63;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 75, 6, 1, 8, 'LUNCH', 'Sambar rice (lunch leftover)', 8.63, 'HOT_HELD', (@d0 + INTERVAL 564864 SECOND), (@d0 + INTERVAL 570203 SECOND), (@d0 + INTERVAL 564864 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 570756 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 570756 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 75;
CALL seed_claim(70, (@d0 + INTERVAL 570957 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 69, 5, 8, 7, 'LUNCH', 'Fruit salad (lunch leftover)', 7.93, 'CHILLED', (@d0 + INTERVAL 565740 SECOND), (@d0 + INTERVAL 570676 SECOND), (@d0 + INTERVAL 565740 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 571005 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 571005 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 69;
CALL seed_claim(69, (@d0 + INTERVAL 571249 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 62, 3, 1, 5, 'LUNCH', 'Steamed rice (lunch leftover)', 10.24, 'HOT_HELD', (@d0 + INTERVAL 565852 SECOND), (@d0 + INTERVAL 570817 SECOND), (@d0 + INTERVAL 565852 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 571274 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 571274 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 62;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 57, 2, 1, 4, 'LUNCH', 'Veg biryani (lunch leftover)', 16.46, 'HOT_HELD', (@d0 + INTERVAL 564244 SECOND), (@d0 + INTERVAL 570988 SECOND), (@d0 + INTERVAL 564244 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 571282 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 571282 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 57;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 51, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 15.03, 'CHILLED', (@d0 + INTERVAL 565148 SECOND), (@d0 + INTERVAL 570961 SECOND), (@d0 + INTERVAL 565148 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 571302 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 571302 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 51;
CALL seed_claim(75, (@d0 + INTERVAL 571413 SECOND), 1);
CALL seed_trip('[68, 52, 70]', (@d0 + INTERVAL 571862 SECOND), NULL, 54.0);
CALL seed_claim(74, (@d0 + INTERVAL 572038 SECOND), 1);
CALL seed_claim(57, (@d0 + INTERVAL 572205 SECOND), 1);
CALL seed_claim(51, (@d0 + INTERVAL 572306 SECOND), 1);
CALL seed_trip('[69, 58, 75]', (@d0 + INTERVAL 572412 SECOND), NULL, 54.0);
CALL seed_claim(63, (@d0 + INTERVAL 572455 SECOND), 2);
CALL seed_claim(62, (@d0 + INTERVAL 572478 SECOND), 1);
CALL seed_trip('[74, 51]', (@d0 + INTERVAL 573378 SECOND), NULL, 54.0);
CALL seed_trip('[57, 62, 63]', (@d0 + INTERVAL 573912 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 66, 3, 7, 5, 'DINNER', 'Gulab jamun (dinner leftover)', 9.97, 'CHILLED', (@d0 + INTERVAL 592585 SECOND), (@d0 + INTERVAL 595779 SECOND), (@d0 + INTERVAL 592585 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 596442 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 596442 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 66;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 76, 6, 1, 8, 'DINNER', 'Dal tadka (dinner leftover)', 7.26, 'HOT_HELD', (@d0 + INTERVAL 591822 SECOND), (@d0 + INTERVAL 596063 SECOND), (@d0 + INTERVAL 591822 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 596456 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 596456 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 76;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 67, 4, 1, 6, 'DINNER', 'Sambar rice (dinner leftover)', 7.90, 'HOT_HELD', (@d0 + INTERVAL 592017 SECOND), (@d0 + INTERVAL 596188 SECOND), (@d0 + INTERVAL 592017 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 596476 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 596476 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 67;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 56, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 9.64, 'CHILLED', (@d0 + INTERVAL 592482 SECOND), (@d0 + INTERVAL 595982 SECOND), (@d0 + INTERVAL 592482 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 596615 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 596615 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 56;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 59, 2, 7, 4, 'DINNER', 'Semiya payasam (dinner leftover)', 9.71, 'AMBIENT', (@d0 + INTERVAL 592821 SECOND), (@d0 + INTERVAL 596354 SECOND), (@d0 + INTERVAL 592821 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 596675 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 596675 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 59;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 71, 5, 2, 7, 'DINNER', 'Aloo gobi (dinner leftover)', 7.71, 'HOT_HELD', (@d0 + INTERVAL 592017 SECOND), (@d0 + INTERVAL 596486 SECOND), (@d0 + INTERVAL 592017 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 596867 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 596867 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 71;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 60, 2, 3, 4, 'DINNER', 'Chicken curry (dinner leftover)', 6.04, 'HOT_HELD', (@d0 + INTERVAL 592454 SECOND), (@d0 + INTERVAL 596747 SECOND), (@d0 + INTERVAL 592454 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 597081 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 597081 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 60;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 54, 1, 2, 3, 'DINNER', 'Aloo gobi (dinner leftover)', 17.17, 'HOT_HELD', (@d0 + INTERVAL 592390 SECOND), (@d0 + INTERVAL 597090 SECOND), (@d0 + INTERVAL 592390 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 597732 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 597732 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 54;
CALL seed_claim(56, (@d0 + INTERVAL 597827 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 72, 5, 7, 7, 'DINNER', 'Gulab jamun (dinner leftover)', 6.35, 'CHILLED', (@d0 + INTERVAL 592802 SECOND), (@d0 + INTERVAL 597531 SECOND), (@d0 + INTERVAL 592802 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 597831 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 597831 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 72;
CALL seed_claim(59, (@d0 + INTERVAL 598194 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 65, 3, 2, 5, 'DINNER', 'Aloo gobi (dinner leftover)', 9.56, 'HOT_HELD', (@d0 + INTERVAL 592351 SECOND), (@d0 + INTERVAL 597982 SECOND), (@d0 + INTERVAL 592351 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 598360 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 598360 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 65;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 55, 1, 4, 3, 'DINNER', 'Chapati (dinner leftover)', 10.35, 'AMBIENT', (@d0 + INTERVAL 591744 SECOND), (@d0 + INTERVAL 597734 SECOND), (@d0 + INTERVAL 591744 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 598364 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 598364 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 55;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 64, 3, 4, 5, 'DINNER', 'Chapati (dinner leftover)', 9.81, 'AMBIENT', (@d0 + INTERVAL 592105 SECOND), (@d0 + INTERVAL 598123 SECOND), (@d0 + INTERVAL 592105 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 598449 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 598449 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 64;
CALL seed_trip('[56, 59]', (@d0 + INTERVAL 598933 SECOND), 56, 54.0);
CALL seed_claim(65, (@d0 + INTERVAL 599278 SECOND), 1);
CALL seed_claim(67, (@d0 + INTERVAL 599515 SECOND), 2);
CALL seed_claim(71, (@d0 + INTERVAL 599537 SECOND), 2);
CALL seed_claim(55, (@d0 + INTERVAL 600283 SECOND), 1);
CALL seed_claim(64, (@d0 + INTERVAL 600742 SECOND), 2);
CALL seed_trip('[65, 67, 71]', (@d0 + INTERVAL 600775 SECOND), NULL, 54.0);
CALL seed_claim(54, (@d0 + INTERVAL 601462 SECOND), 1);
CALL seed_trip('[64, 55, 54]', (@d0 + INTERVAL 602729 SECOND), NULL, 54.0);
CALL seed_claim(72, (@d0 + INTERVAL 631971 SECOND), 2);
CALL seed_claim(66, (@d0 + INTERVAL 633629 SECOND), 1);
CALL seed_claim(53, (@d0 + INTERVAL 634192 SECOND), 1);
CALL seed_trip('[72, 66]', (@d0 + INTERVAL 634467 SECOND), NULL, 54.0);
CALL seed_trip('[53]', (@d0 + INTERVAL 635458 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 78, 2, 1, 4, 'LUNCH', 'Steamed rice (lunch leftover)', 6.77, 'HOT_HELD', (@d0 + INTERVAL 651758 SECOND), (@d0 + INTERVAL 656055 SECOND), (@d0 + INTERVAL 651758 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 656590 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 656590 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 78;
CALL seed_claim(78, (@d0 + INTERVAL 657613 SECOND), 2);
CALL seed_trip('[78]', (@d0 + INTERVAL 658629 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 79, 2, 1, 4, 'DINNER', 'Veg biryani (dinner leftover)', 6.81, 'HOT_HELD', (@d0 + INTERVAL 678033 SECOND), (@d0 + INTERVAL 682837 SECOND), (@d0 + INTERVAL 678033 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 683267 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 683267 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 79;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 77, 1, 1, 3, 'DINNER', 'Sambar rice (dinner leftover)', 9.54, 'CHILLED', (@d0 + INTERVAL 678441 SECOND), (@d0 + INTERVAL 682735 SECOND), (@d0 + INTERVAL 678441 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 683351 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 683351 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 77;
CALL seed_claim(79, (@d0 + INTERVAL 684617 SECOND), 1);
CALL seed_claim(77, (@d0 + INTERVAL 685083 SECOND), 1);
CALL seed_trip('[79, 77]', (@d0 + INTERVAL 685978 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 81, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 7.35, 'CHILLED', (@d0 + INTERVAL 721549 SECOND), (@d0 + INTERVAL 725623 SECOND), (@d0 + INTERVAL 721549 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 726245 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 726245 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 81;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 80, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.88, 'HOT_HELD', (@d0 + INTERVAL 721325 SECOND), (@d0 + INTERVAL 726122 SECOND), (@d0 + INTERVAL 721325 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 726448 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 726448 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 80;
CALL seed_claim(81, (@d0 + INTERVAL 726713 SECOND), 1);
CALL seed_claim(80, (@d0 + INTERVAL 726839 SECOND), 1);
CALL seed_trip('[81]', (@d0 + INTERVAL 727614 SECOND), NULL, 54.0);
CALL seed_cancel(80, (@d0 + INTERVAL 728660 SECOND), 'no transport available');
CALL seed_claim(80, (@d0 + INTERVAL 729484 SECOND), 1);
CALL seed_trip('[80]', (@d0 + INTERVAL 730164 SECOND), 80, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 82, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 8.37, 'HOT_HELD', (@d0 + INTERVAL 737742 SECOND), (@d0 + INTERVAL 742804 SECOND), (@d0 + INTERVAL 737742 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 743416 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 743416 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 82;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 83, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 7.83, 'HOT_HELD', (@d0 + INTERVAL 738360 SECOND), (@d0 + INTERVAL 743459 SECOND), (@d0 + INTERVAL 738360 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 744162 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 744162 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 83;
CALL seed_claim(83, (@d0 + INTERVAL 744549 SECOND), 1);
CALL seed_trip('[83]', (@d0 + INTERVAL 745348 SECOND), NULL, 54.0);
CALL seed_claim(82, (@d0 + INTERVAL 746333 SECOND), 2);
CALL seed_trip('[82]', (@d0 + INTERVAL 747819 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 84, 2, 1, 4, 'DINNER', 'Steamed rice (dinner leftover)', 7.12, 'HOT_HELD', (@d0 + INTERVAL 765824 SECOND), (@d0 + INTERVAL 768853 SECOND), (@d0 + INTERVAL 765824 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 769191 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 769191 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 84;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 86, 3, 7, 5, 'DINNER', 'Gulab jamun (dinner leftover)', 7.89, 'CHILLED', (@d0 + INTERVAL 764162 SECOND), (@d0 + INTERVAL 769254 SECOND), (@d0 + INTERVAL 764162 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 769765 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 769765 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 86;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 85, 3, 2, 5, 'DINNER', 'Vegetable kurma (dinner leftover)', 7.46, 'HOT_HELD', (@d0 + INTERVAL 764547 SECOND), (@d0 + INTERVAL 769605 SECOND), (@d0 + INTERVAL 764547 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 769980 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 769980 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 85;
CALL seed_claim(85, (@d0 + INTERVAL 770700 SECOND), 1);
CALL seed_trip('[85]', (@d0 + INTERVAL 771454 SECOND), NULL, 54.0);
CALL seed_claim(86, (@d0 + INTERVAL 807889 SECOND), 1);
CALL seed_trip('[86]', (@d0 + INTERVAL 808556 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 90, 3, 3, 5, 'LUNCH', 'Egg curry (lunch leftover)', 6.55, 'HOT_HELD', (@d0 + INTERVAL 824219 SECOND), (@d0 + INTERVAL 828013 SECOND), (@d0 + INTERVAL 824219 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 828658 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 828658 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 90;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 87, 1, 4, 3, 'LUNCH', 'Chapati (lunch leftover)', 6.10, 'AMBIENT', (@d0 + INTERVAL 824352 SECOND), (@d0 + INTERVAL 828491 SECOND), (@d0 + INTERVAL 824352 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 828990 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 828990 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 87;
CALL seed_claim(90, (@d0 + INTERVAL 829495 SECOND), 1);
CALL seed_claim(87, (@d0 + INTERVAL 829704 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 88, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 9.47, 'CHILLED', (@d0 + INTERVAL 823213 SECOND), (@d0 + INTERVAL 829770 SECOND), (@d0 + INTERVAL 823213 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 830147 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 830147 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 88;
CALL seed_trip('[90, 87]', (@d0 + INTERVAL 830669 SECOND), NULL, 54.0);
CALL seed_claim(88, (@d0 + INTERVAL 832315 SECOND), 2);
CALL seed_trip('[88]', (@d0 + INTERVAL 833502 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 92, 3, 1, 5, 'DINNER', 'Sambar rice (dinner leftover)', 9.68, 'HOT_HELD', (@d0 + INTERVAL 850393 SECOND), (@d0 + INTERVAL 855414 SECOND), (@d0 + INTERVAL 850393 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 856046 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 856046 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 92;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 91, 3, 4, 5, 'DINNER', 'Parotta (dinner leftover)', 6.23, 'AMBIENT', (@d0 + INTERVAL 851128 SECOND), (@d0 + INTERVAL 856750 SECOND), (@d0 + INTERVAL 851128 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 857340 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 857340 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_EGG' AS tag) t WHERE batch_id = 91;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 89, 1, 1, 3, 'DINNER', 'Steamed rice (dinner leftover)', 7.35, 'CHILLED', (@d0 + INTERVAL 850214 SECOND), (@d0 + INTERVAL 857051 SECOND), (@d0 + INTERVAL 850214 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 857615 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 857615 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 89;
CALL seed_claim(91, (@d0 + INTERVAL 858935 SECOND), 1);
CALL seed_claim(89, (@d0 + INTERVAL 859301 SECOND), 1);
CALL seed_trip('[91]', (@d0 + INTERVAL 859611 SECOND), NULL, 54.0);
CALL seed_cancel(89, (@d0 + INTERVAL 861254 SECOND), 'no transport available');
CALL seed_claim(89, (@d0 + INTERVAL 861655 SECOND), 1);
CALL seed_trip('[89]', (@d0 + INTERVAL 862672 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 93, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 6.25, 'CHILLED', (@d0 + INTERVAL 910326 SECOND), (@d0 + INTERVAL 915420 SECOND), (@d0 + INTERVAL 910326 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 915881 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 915881 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 93;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 94, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 7.35, 'CHILLED', (@d0 + INTERVAL 909708 SECOND), (@d0 + INTERVAL 915205 SECOND), (@d0 + INTERVAL 909708 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 915900 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 915900 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 94;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 97, 2, 1, 4, 'LUNCH', 'Curd rice (lunch leftover)', 6.63, 'HOT_HELD', (@d0 + INTERVAL 911175 SECOND), (@d0 + INTERVAL 915627 SECOND), (@d0 + INTERVAL 911175 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 916131 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 916131 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 97;
CALL seed_claim(97, (@d0 + INTERVAL 916823 SECOND), 2);
CALL seed_claim(93, (@d0 + INTERVAL 917107 SECOND), 1);
CALL seed_claim(94, (@d0 + INTERVAL 917434 SECOND), 1);
CALL seed_trip('[93, 97, 94]', (@d0 + INTERVAL 918316 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 99, 3, 1, 5, 'DINNER', 'Sambar rice (dinner leftover)', 10.08, 'CHILLED', (@d0 + INTERVAL 937735 SECOND), (@d0 + INTERVAL 941533 SECOND), (@d0 + INTERVAL 937735 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 942003 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 942003 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 99;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 98, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 9.89, 'CHILLED', (@d0 + INTERVAL 938554 SECOND), (@d0 + INTERVAL 942615 SECOND), (@d0 + INTERVAL 938554 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 943104 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 943104 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 98;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 95, 1, 1, 3, 'DINNER', 'Steamed rice (dinner leftover)', 7.09, 'HOT_HELD', (@d0 + INTERVAL 937969 SECOND), (@d0 + INTERVAL 942692 SECOND), (@d0 + INTERVAL 937969 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 943311 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 943311 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 95;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 96, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 6.04, 'HOT_HELD', (@d0 + INTERVAL 938529 SECOND), (@d0 + INTERVAL 943418 SECOND), (@d0 + INTERVAL 938529 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 943709 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 943709 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 96;
CALL seed_claim(98, (@d0 + INTERVAL 944140 SECOND), 2);
CALL seed_claim(95, (@d0 + INTERVAL 944467 SECOND), 1);
CALL seed_trip('[98, 95]', (@d0 + INTERVAL 945870 SECOND), NULL, 54.0);
CALL seed_claim(99, (@d0 + INTERVAL 980333 SECOND), 2);
CALL seed_trip('[99]', (@d0 + INTERVAL 981096 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 108, 5, 1, 7, 'LUNCH', 'Steamed rice (lunch leftover)', 15.79, 'HOT_HELD', (@d0 + INTERVAL 997630 SECOND), (@d0 + INTERVAL 1001437 SECOND), (@d0 + INTERVAL 997630 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1002010 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1002010 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 108;
CALL seed_claim(108, (@d0 + INTERVAL 1002441 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 107, 5, 4, 7, 'LUNCH', 'Chapati (lunch leftover)', 6.00, 'AMBIENT', (@d0 + INTERVAL 997654 SECOND), (@d0 + INTERVAL 1002743 SECOND), (@d0 + INTERVAL 997654 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1003268 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1003268 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 107;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 100, 1, 1, 3, 'LUNCH', 'Sambar rice (lunch leftover)', 12.60, 'CHILLED', (@d0 + INTERVAL 997971 SECOND), (@d0 + INTERVAL 1002932 SECOND), (@d0 + INTERVAL 997971 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1003410 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1003410 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 100;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 101, 1, 8, 3, 'LUNCH', 'Fruit salad (lunch leftover)', 7.79, 'CHILLED', (@d0 + INTERVAL 997451 SECOND), (@d0 + INTERVAL 1003142 SECOND), (@d0 + INTERVAL 997451 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1003468 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1003468 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 101;
CALL seed_claim(100, (@d0 + INTERVAL 1004402 SECOND), 1);
CALL seed_claim(101, (@d0 + INTERVAL 1004445 SECOND), 2);
CALL seed_trip('[108, 100]', (@d0 + INTERVAL 1005044 SECOND), NULL, 54.0);
CALL seed_trip('[101]', (@d0 + INTERVAL 1005526 SECOND), 101, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 102, 1, 2, 3, 'DINNER', 'Vegetable kurma (dinner leftover)', 16.21, 'CHILLED', (@d0 + INTERVAL 1024512 SECOND), (@d0 + INTERVAL 1027800 SECOND), (@d0 + INTERVAL 1024512 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1028431 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1028431 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 102;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 106, 2, 1, 4, 'DINNER', 'Dal tadka (dinner leftover)', 7.32, 'HOT_HELD', (@d0 + INTERVAL 1023591 SECOND), (@d0 + INTERVAL 1028137 SECOND), (@d0 + INTERVAL 1023591 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1028670 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1028670 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 106;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 104, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 18.93, 'CHILLED', (@d0 + INTERVAL 1024114 SECOND), (@d0 + INTERVAL 1028637 SECOND), (@d0 + INTERVAL 1024114 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1029187 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1029187 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 104;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 105, 2, 1, 4, 'DINNER', 'Sambar rice (dinner leftover)', 7.00, 'AMBIENT', (@d0 + INTERVAL 1024427 SECOND), (@d0 + INTERVAL 1028964 SECOND), (@d0 + INTERVAL 1024427 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1029531 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1029531 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 105;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 103, 1, 7, 3, 'DINNER', 'Semiya payasam (dinner leftover)', 23.42, 'CHILLED', (@d0 + INTERVAL 1023841 SECOND), (@d0 + INTERVAL 1029111 SECOND), (@d0 + INTERVAL 1023841 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1029594 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1029594 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 103;
CALL seed_claim(102, (@d0 + INTERVAL 1031014 SECOND), 1);
CALL seed_claim(105, (@d0 + INTERVAL 1031056 SECOND), 2);
CALL seed_cancel(102, (@d0 + INTERVAL 1032116 SECOND), 'no transport available');
CALL seed_trip('[105]', (@d0 + INTERVAL 1032314 SECOND), NULL, 54.0);
CALL seed_claim(102, (@d0 + INTERVAL 1032875 SECOND), 1);
CALL seed_trip('[102]', (@d0 + INTERVAL 1033897 SECOND), NULL, 54.0);
CALL seed_claim(103, (@d0 + INTERVAL 1063975 SECOND), 1);
CALL seed_trip('[103]', (@d0 + INTERVAL 1064732 SECOND), NULL, 54.0);
CALL seed_claim(104, (@d0 + INTERVAL 1067222 SECOND), 1);
CALL seed_trip('[104]', (@d0 + INTERVAL 1068543 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 118, 3, 5, 5, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.80, 'HOT_HELD', (@d0 + INTERVAL 1068026 SECOND), (@d0 + INTERVAL 1071540 SECOND), (@d0 + INTERVAL 1068026 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1071910 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1071910 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 118;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 109, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 6.47, 'HOT_HELD', (@d0 + INTERVAL 1067928 SECOND), (@d0 + INTERVAL 1071660 SECOND), (@d0 + INTERVAL 1067928 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1071999 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1071999 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 109;
CALL seed_claim(118, (@d0 + INTERVAL 1072629 SECOND), 2);
CALL seed_trip('[118]', (@d0 + INTERVAL 1073829 SECOND), NULL, 54.0);
CALL seed_claim(109, (@d0 + INTERVAL 1074020 SECOND), 1);
CALL seed_trip('[109]', (@d0 + INTERVAL 1075207 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 117, 2, 3, 4, 'LUNCH', 'Fish fry (lunch leftover)', 7.10, 'HOT_HELD', (@d0 + INTERVAL 1084038 SECOND), (@d0 + INTERVAL 1087138 SECOND), (@d0 + INTERVAL 1084038 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1087698 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1087698 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 117;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 119, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 8.44, 'HOT_HELD', (@d0 + INTERVAL 1082677 SECOND), (@d0 + INTERVAL 1087154 SECOND), (@d0 + INTERVAL 1082677 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1087743 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1087743 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 119;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 120, 3, 3, 5, 'LUNCH', 'Fish fry (lunch leftover)', 6.34, 'CHILLED', (@d0 + INTERVAL 1082761 SECOND), (@d0 + INTERVAL 1087886 SECOND), (@d0 + INTERVAL 1082761 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1088196 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1088196 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 120;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 116, 2, 1, 4, 'LUNCH', 'Steamed rice (lunch leftover)', 11.52, 'HOT_HELD', (@d0 + INTERVAL 1082883 SECOND), (@d0 + INTERVAL 1087640 SECOND), (@d0 + INTERVAL 1082883 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1088357 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1088357 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 116;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 112, 1, 1, 3, 'LUNCH', 'Dal tadka (lunch leftover)', 18.69, 'HOT_HELD', (@d0 + INTERVAL 1084249 SECOND), (@d0 + INTERVAL 1087833 SECOND), (@d0 + INTERVAL 1084249 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1088439 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1088439 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 112;
CALL seed_claim(117, (@d0 + INTERVAL 1088443 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 127, 6, 1, 8, 'LUNCH', 'Veg biryani (lunch leftover)', 6.61, 'HOT_HELD', (@d0 + INTERVAL 1082486 SECOND), (@d0 + INTERVAL 1088019 SECOND), (@d0 + INTERVAL 1082486 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1088725 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1088725 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 127;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 121, 3, 1, 5, 'LUNCH', 'Curd rice (lunch leftover)', 16.33, 'HOT_HELD', (@d0 + INTERVAL 1082415 SECOND), (@d0 + INTERVAL 1088367 SECOND), (@d0 + INTERVAL 1082415 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1088737 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1088737 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 121;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 128, 6, 1, 8, 'LUNCH', 'Dal tadka (lunch leftover)', 6.68, 'HOT_HELD', (@d0 + INTERVAL 1083643 SECOND), (@d0 + INTERVAL 1088761 SECOND), (@d0 + INTERVAL 1083643 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1089022 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1089022 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 128;
CALL seed_claim(120, (@d0 + INTERVAL 1089111 SECOND), 1);
CALL seed_claim(119, (@d0 + INTERVAL 1089188 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 125, 5, 4, 7, 'LUNCH', 'Chapati (lunch leftover)', 7.22, 'AMBIENT', (@d0 + INTERVAL 1082773 SECOND), (@d0 + INTERVAL 1088845 SECOND), (@d0 + INTERVAL 1082773 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1089208 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1089208 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 125;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 111, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 8.38, 'CHILLED', (@d0 + INTERVAL 1083492 SECOND), (@d0 + INTERVAL 1088986 SECOND), (@d0 + INTERVAL 1083492 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1089245 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1089245 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 111;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 124, 5, 1, 7, 'LUNCH', 'Dal tadka (lunch leftover)', 11.13, 'HOT_HELD', (@d0 + INTERVAL 1083536 SECOND), (@d0 + INTERVAL 1088971 SECOND), (@d0 + INTERVAL 1083536 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1089324 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1089324 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 124;
CALL seed_claim(116, (@d0 + INTERVAL 1089526 SECOND), 1);
CALL seed_claim(111, (@d0 + INTERVAL 1089722 SECOND), 1);
CALL seed_trip('[117, 119]', (@d0 + INTERVAL 1089788 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 110, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 11.49, 'CHILLED', (@d0 + INTERVAL 1084338 SECOND), (@d0 + INTERVAL 1089511 SECOND), (@d0 + INTERVAL 1084338 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1089832 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1089832 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 110;
CALL seed_claim(127, (@d0 + INTERVAL 1089928 SECOND), 1);
CALL seed_claim(121, (@d0 + INTERVAL 1089972 SECOND), 2);
CALL seed_claim(124, (@d0 + INTERVAL 1090119 SECOND), 1);
CALL seed_claim(110, (@d0 + INTERVAL 1090229 SECOND), 1);
CALL seed_claim(128, (@d0 + INTERVAL 1090241 SECOND), 1);
CALL seed_claim(112, (@d0 + INTERVAL 1090413 SECOND), 1);
CALL seed_trip('[120, 111, 116]', (@d0 + INTERVAL 1090805 SECOND), NULL, 54.0);
CALL seed_trip('[128, 112, 121]', (@d0 + INTERVAL 1091168 SECOND), NULL, 54.0);
CALL seed_trip('[127, 124, 110]', (@d0 + INTERVAL 1091659 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 115, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 6.82, 'CHILLED', (@d0 + INTERVAL 1109867 SECOND), (@d0 + INTERVAL 1114518 SECOND), (@d0 + INTERVAL 1109867 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1114902 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1114902 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 115;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 123, 3, 7, 5, 'DINNER', 'Gulab jamun (dinner leftover)', 6.46, 'CHILLED', (@d0 + INTERVAL 1109712 SECOND), (@d0 + INTERVAL 1114232 SECOND), (@d0 + INTERVAL 1109712 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1114928 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1114928 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 123;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 129, 6, 1, 8, 'DINNER', 'Sambar rice (dinner leftover)', 7.60, 'HOT_HELD', (@d0 + INTERVAL 1109535 SECOND), (@d0 + INTERVAL 1114912 SECOND), (@d0 + INTERVAL 1109535 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1115193 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1115193 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 129;
CALL seed_claim(129, (@d0 + INTERVAL 1115739 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 122, 3, 1, 5, 'DINNER', 'Sambar rice (dinner leftover)', 15.98, 'HOT_HELD', (@d0 + INTERVAL 1110634 SECOND), (@d0 + INTERVAL 1115944 SECOND), (@d0 + INTERVAL 1110634 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1116187 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1116187 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 122;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 126, 5, 1, 7, 'DINNER', 'Veg biryani (dinner leftover)', 6.62, 'CHILLED', (@d0 + INTERVAL 1109633 SECOND), (@d0 + INTERVAL 1116043 SECOND), (@d0 + INTERVAL 1109633 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1116447 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1116447 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 126;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 114, 1, 1, 3, 'DINNER', 'Sambar rice (dinner leftover)', 20.69, 'HOT_HELD', (@d0 + INTERVAL 1110038 SECOND), (@d0 + INTERVAL 1116170 SECOND), (@d0 + INTERVAL 1110038 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1116773 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1116773 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 114;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 113, 1, 2, 3, 'DINNER', 'Paneer butter masala (dinner leftover)', 13.80, 'CHILLED', (@d0 + INTERVAL 1109576 SECOND), (@d0 + INTERVAL 1116638 SECOND), (@d0 + INTERVAL 1109576 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1116892 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1116892 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 113;
CALL seed_claim(123, (@d0 + INTERVAL 1116950 SECOND), 2);
CALL seed_claim(122, (@d0 + INTERVAL 1117377 SECOND), 1);
CALL seed_trip('[129, 123, 122]', (@d0 + INTERVAL 1118022 SECOND), NULL, 54.0);
CALL seed_claim(113, (@d0 + INTERVAL 1150548 SECOND), 1);
CALL seed_trip('[113]', (@d0 + INTERVAL 1151991 SECOND), NULL, 54.0);
CALL seed_claim(126, (@d0 + INTERVAL 1152308 SECOND), 1);
CALL seed_claim(115, (@d0 + INTERVAL 1152644 SECOND), 1);
CALL seed_trip('[115, 126]', (@d0 + INTERVAL 1153514 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 139, 2, 5, 4, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 7.10, 'HOT_HELD', (@d0 + INTERVAL 1154296 SECOND), (@d0 + INTERVAL 1157794 SECOND), (@d0 + INTERVAL 1154296 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1158384 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1158384 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 139;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 138, 2, 5, 4, 'BREAKFAST', 'Pongal (breakfast leftover)', 6.44, 'HOT_HELD', (@d0 + INTERVAL 1153016 SECOND), (@d0 + INTERVAL 1157935 SECOND), (@d0 + INTERVAL 1153016 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1158500 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1158500 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 138;
CALL seed_claim(139, (@d0 + INTERVAL 1159062 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 151, 5, 5, 7, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 7.31, 'HOT_HELD', (@d0 + INTERVAL 1153004 SECOND), (@d0 + INTERVAL 1158508 SECOND), (@d0 + INTERVAL 1153004 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1159178 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1159178 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 151;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 145, 3, 5, 5, 'BREAKFAST', 'Upma (breakfast leftover)', 7.38, 'CHILLED', (@d0 + INTERVAL 1154614 SECOND), (@d0 + INTERVAL 1158826 SECOND), (@d0 + INTERVAL 1154614 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1159250 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1159250 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 145;
CALL seed_claim(151, (@d0 + INTERVAL 1159388 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 131, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 7.74, 'HOT_HELD', (@d0 + INTERVAL 1153717 SECOND), (@d0 + INTERVAL 1158883 SECOND), (@d0 + INTERVAL 1153717 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1159446 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1159446 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 131;
CALL seed_claim(131, (@d0 + INTERVAL 1159652 SECOND), 1);
CALL seed_claim(145, (@d0 + INTERVAL 1160029 SECOND), 1);
CALL seed_claim(138, (@d0 + INTERVAL 1160057 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 130, 1, 5, 3, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.69, 'HOT_HELD', (@d0 + INTERVAL 1154089 SECOND), (@d0 + INTERVAL 1159631 SECOND), (@d0 + INTERVAL 1154089 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1160069 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1160069 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 130;
CALL seed_cancel(139, (@d0 + INTERVAL 1160159 SECOND), 'no transport available');
CALL seed_trip('[131]', (@d0 + INTERVAL 1160572 SECOND), NULL, 54.0);
CALL seed_trip('[138]', (@d0 + INTERVAL 1160685 SECOND), NULL, 54.0);
CALL seed_trip('[151, 145]', (@d0 + INTERVAL 1160861 SECOND), NULL, 54.0);
CALL seed_claim(139, (@d0 + INTERVAL 1160874 SECOND), 1);
CALL seed_claim(130, (@d0 + INTERVAL 1161449 SECOND), 1);
CALL seed_trip('[139]', (@d0 + INTERVAL 1161937 SECOND), NULL, 54.0);
CALL seed_trip('[130]', (@d0 + INTERVAL 1162440 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 148, 3, 1, 5, 'LUNCH', 'Veg biryani (lunch leftover)', 15.92, 'HOT_HELD', (@d0 + INTERVAL 1169163 SECOND), (@d0 + INTERVAL 1173684 SECOND), (@d0 + INTERVAL 1169163 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1174372 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1174372 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 148;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 134, 1, 1, 3, 'LUNCH', 'Steamed rice (lunch leftover)', 14.74, 'HOT_HELD', (@d0 + INTERVAL 1169569 SECOND), (@d0 + INTERVAL 1174329 SECOND), (@d0 + INTERVAL 1169569 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1174697 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1174697 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 134;
CALL seed_claim(148, (@d0 + INTERVAL 1174928 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 153, 5, 2, 7, 'LUNCH', 'Vegetable kurma (lunch leftover)', 11.11, 'HOT_HELD', (@d0 + INTERVAL 1168914 SECOND), (@d0 + INTERVAL 1174782 SECOND), (@d0 + INTERVAL 1168914 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175095 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175095 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 153;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 146, 3, 7, 5, 'LUNCH', 'Semiya payasam (lunch leftover)', 7.89, 'CHILLED', (@d0 + INTERVAL 1170698 SECOND), (@d0 + INTERVAL 1174623 SECOND), (@d0 + INTERVAL 1170698 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175211 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175211 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 146;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 154, 5, 4, 7, 'LUNCH', 'Chapati (lunch leftover)', 10.37, 'AMBIENT', (@d0 + INTERVAL 1169983 SECOND), (@d0 + INTERVAL 1174653 SECOND), (@d0 + INTERVAL 1169983 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175215 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175215 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 154;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 141, 2, 3, 4, 'LUNCH', 'Egg curry (lunch leftover)', 8.52, 'HOT_HELD', (@d0 + INTERVAL 1170717 SECOND), (@d0 + INTERVAL 1175005 SECOND), (@d0 + INTERVAL 1170717 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175310 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175310 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 141;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 140, 2, 3, 4, 'LUNCH', 'Chicken curry (lunch leftover)', 9.84, 'HOT_HELD', (@d0 + INTERVAL 1170756 SECOND), (@d0 + INTERVAL 1175067 SECOND), (@d0 + INTERVAL 1170756 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175537 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175537 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 140;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 152, 5, 3, 7, 'LUNCH', 'Egg curry (lunch leftover)', 8.32, 'HOT_HELD', (@d0 + INTERVAL 1170329 SECOND), (@d0 + INTERVAL 1175392 SECOND), (@d0 + INTERVAL 1170329 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175689 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175689 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 152;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 132, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 10.16, 'HOT_HELD', (@d0 + INTERVAL 1169334 SECOND), (@d0 + INTERVAL 1175252 SECOND), (@d0 + INTERVAL 1169334 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175778 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175778 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 132;
CALL seed_claim(154, (@d0 + INTERVAL 1175805 SECOND), 1);
CALL seed_claim(153, (@d0 + INTERVAL 1175835 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 133, 1, 1, 3, 'LUNCH', 'Sambar rice (lunch leftover)', 12.06, 'HOT_HELD', (@d0 + INTERVAL 1170495 SECOND), (@d0 + INTERVAL 1175451 SECOND), (@d0 + INTERVAL 1170495 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1175880 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1175880 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 133;
CALL seed_claim(134, (@d0 + INTERVAL 1175926 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 142, 2, 1, 4, 'LUNCH', 'Curd rice (lunch leftover)', 10.54, 'HOT_HELD', (@d0 + INTERVAL 1169976 SECOND), (@d0 + INTERVAL 1175322 SECOND), (@d0 + INTERVAL 1169976 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1176010 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1176010 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 142;
CALL seed_claim(146, (@d0 + INTERVAL 1176155 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 147, 3, 8, 5, 'LUNCH', 'Fruit salad (lunch leftover)', 6.53, 'CHILLED', (@d0 + INTERVAL 1170801 SECOND), (@d0 + INTERVAL 1175828 SECOND), (@d0 + INTERVAL 1170801 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1176273 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1176273 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 147;
CALL seed_claim(142, (@d0 + INTERVAL 1176315 SECOND), 1);
CALL seed_claim(140, (@d0 + INTERVAL 1176329 SECOND), 1);
CALL seed_claim(132, (@d0 + INTERVAL 1176464 SECOND), 2);
CALL seed_claim(141, (@d0 + INTERVAL 1176508 SECOND), 2);
CALL seed_claim(152, (@d0 + INTERVAL 1176600 SECOND), 1);
CALL seed_claim(147, (@d0 + INTERVAL 1176827 SECOND), 1);
CALL seed_trip('[148, 134]', (@d0 + INTERVAL 1177055 SECOND), NULL, 54.0);
CALL seed_trip('[146, 154, 153]', (@d0 + INTERVAL 1177263 SECOND), NULL, 54.0);
CALL seed_trip('[140]', (@d0 + INTERVAL 1177314 SECOND), NULL, 54.0);
CALL seed_claim(133, (@d0 + INTERVAL 1177485 SECOND), 2);
CALL seed_trip('[142, 152]', (@d0 + INTERVAL 1177580 SECOND), NULL, 54.0);
CALL seed_trip('[141, 132]', (@d0 + INTERVAL 1177851 SECOND), NULL, 54.0);
CALL seed_trip('[147, 133]', (@d0 + INTERVAL 1178436 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 156, 6, 7, 8, 'DINNER', 'Semiya payasam (dinner leftover)', 7.57, 'AMBIENT', (@d0 + INTERVAL 1196578 SECOND), (@d0 + INTERVAL 1200725 SECOND), (@d0 + INTERVAL 1196578 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1201084 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1201084 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 156;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 150, 3, 3, 5, 'DINNER', 'Egg curry (dinner leftover)', 12.40, 'HOT_HELD', (@d0 + INTERVAL 1195864 SECOND), (@d0 + INTERVAL 1201475 SECOND), (@d0 + INTERVAL 1195864 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1201926 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1201926 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 150;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 155, 5, 1, 7, 'DINNER', 'Steamed rice (dinner leftover)', 8.74, 'HOT_HELD', (@d0 + INTERVAL 1197667 SECOND), (@d0 + INTERVAL 1201468 SECOND), (@d0 + INTERVAL 1197667 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202031 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202031 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 155;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 149, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 13.53, 'HOT_HELD', (@d0 + INTERVAL 1197137 SECOND), (@d0 + INTERVAL 1201571 SECOND), (@d0 + INTERVAL 1197137 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202135 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202135 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 149;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 157, 6, 1, 8, 'DINNER', 'Dal tadka (dinner leftover)', 8.56, 'HOT_HELD', (@d0 + INTERVAL 1196162 SECOND), (@d0 + INTERVAL 1201583 SECOND), (@d0 + INTERVAL 1196162 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202293 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202293 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 157;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 135, 1, 1, 3, 'DINNER', 'Sambar rice (dinner leftover)', 19.44, 'CHILLED', (@d0 + INTERVAL 1197382 SECOND), (@d0 + INTERVAL 1202219 SECOND), (@d0 + INTERVAL 1197382 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202561 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202561 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 135;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 144, 2, 3, 4, 'DINNER', 'Egg curry (dinner leftover)', 6.91, 'AMBIENT', (@d0 + INTERVAL 1197394 SECOND), (@d0 + INTERVAL 1202265 SECOND), (@d0 + INTERVAL 1197394 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202564 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202564 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 144;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 137, 1, 7, 3, 'DINNER', 'Semiya payasam (dinner leftover)', 9.61, 'CHILLED', (@d0 + INTERVAL 1197755 SECOND), (@d0 + INTERVAL 1202133 SECOND), (@d0 + INTERVAL 1197755 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202699 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202699 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 137;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 136, 1, 4, 3, 'DINNER', 'Chapati (dinner leftover)', 9.42, 'AMBIENT', (@d0 + INTERVAL 1197448 SECOND), (@d0 + INTERVAL 1202092 SECOND), (@d0 + INTERVAL 1197448 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202719 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202719 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 136;
CALL seed_claim(156, (@d0 + INTERVAL 1202924 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 143, 2, 1, 4, 'DINNER', 'Dal tadka (dinner leftover)', 7.45, 'HOT_HELD', (@d0 + INTERVAL 1197354 SECOND), (@d0 + INTERVAL 1202291 SECOND), (@d0 + INTERVAL 1197354 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1202956 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1202956 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 143;
CALL seed_trip('[156]', (@d0 + INTERVAL 1203526 SECOND), NULL, 54.0);
CALL seed_claim(157, (@d0 + INTERVAL 1203734 SECOND), 1);
CALL seed_claim(155, (@d0 + INTERVAL 1204312 SECOND), 2);
CALL seed_claim(135, (@d0 + INTERVAL 1204315 SECOND), 1);
CALL seed_claim(143, (@d0 + INTERVAL 1204637 SECOND), 1);
CALL seed_claim(149, (@d0 + INTERVAL 1204667 SECOND), 1);
CALL seed_trip('[157, 135]', (@d0 + INTERVAL 1205470 SECOND), NULL, 54.0);
CALL seed_claim(144, (@d0 + INTERVAL 1205664 SECOND), 1);
CALL seed_trip('[149, 155]', (@d0 + INTERVAL 1205680 SECOND), NULL, 54.0);
CALL seed_trip('[143, 144]', (@d0 + INTERVAL 1206785 SECOND), NULL, 54.0);
CALL seed_claim(137, (@d0 + INTERVAL 1207574 SECOND), 2);
CALL seed_trip('[137]', (@d0 + INTERVAL 1208679 SECOND), 137, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 158, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 6.68, 'CHILLED', (@d0 + INTERVAL 1239972 SECOND), (@d0 + INTERVAL 1243930 SECOND), (@d0 + INTERVAL 1239972 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1244322 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1244322 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 158;
CALL seed_claim(158, (@d0 + INTERVAL 1244956 SECOND), 2);
CALL seed_trip('[158]', (@d0 + INTERVAL 1246272 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 159, 1, 1, 3, 'LUNCH', 'Dal tadka (lunch leftover)', 9.89, 'HOT_HELD', (@d0 + INTERVAL 1256937 SECOND), (@d0 + INTERVAL 1261499 SECOND), (@d0 + INTERVAL 1256937 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1262158 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1262158 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 159;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 160, 1, 4, 3, 'LUNCH', 'Chapati (lunch leftover)', 6.14, 'AMBIENT', (@d0 + INTERVAL 1255932 SECOND), (@d0 + INTERVAL 1261707 SECOND), (@d0 + INTERVAL 1255932 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1262176 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1262176 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 160;
CALL seed_claim(159, (@d0 + INTERVAL 1263238 SECOND), 1);
CALL seed_claim(160, (@d0 + INTERVAL 1263608 SECOND), 1);
CALL seed_trip('[159, 160]', (@d0 + INTERVAL 1264862 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 163, 3, 3, 5, 'DINNER', 'Egg curry (dinner leftover)', 6.56, 'CHILLED', (@d0 + INTERVAL 1282212 SECOND), (@d0 + INTERVAL 1287241 SECOND), (@d0 + INTERVAL 1282212 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1287837 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1287837 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 163;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 162, 1, 1, 3, 'DINNER', 'Dal tadka (dinner leftover)', 11.14, 'HOT_HELD', (@d0 + INTERVAL 1284211 SECOND), (@d0 + INTERVAL 1288762 SECOND), (@d0 + INTERVAL 1284211 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1289193 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1289193 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 162;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 161, 1, 1, 3, 'DINNER', 'Steamed rice (dinner leftover)', 8.97, 'HOT_HELD', (@d0 + INTERVAL 1283155 SECOND), (@d0 + INTERVAL 1288866 SECOND), (@d0 + INTERVAL 1283155 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1289422 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1289422 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 161;
CALL seed_claim(161, (@d0 + INTERVAL 1290970 SECOND), 2);
CALL seed_claim(162, (@d0 + INTERVAL 1291172 SECOND), 2);
CALL seed_trip('[161, 162]', (@d0 + INTERVAL 1292302 SECOND), NULL, 54.0);
CALL seed_claim(163, (@d0 + INTERVAL 1326464 SECOND), 1);
CALL seed_trip('[163]', (@d0 + INTERVAL 1327517 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 164, 3, 1, 5, 'LUNCH', 'Veg biryani (lunch leftover)', 6.15, 'CHILLED', (@d0 + INTERVAL 1342551 SECOND), (@d0 + INTERVAL 1348480 SECOND), (@d0 + INTERVAL 1342551 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1348911 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1348911 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 164;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 166, 5, 1, 7, 'LUNCH', 'Curd rice (lunch leftover)', 8.05, 'CHILLED', (@d0 + INTERVAL 1342667 SECOND), (@d0 + INTERVAL 1348743 SECOND), (@d0 + INTERVAL 1342667 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1349053 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1349053 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 166;
CALL seed_claim(164, (@d0 + INTERVAL 1351351 SECOND), 2);
CALL seed_trip('[164]', (@d0 + INTERVAL 1352102 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 165, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 9.02, 'AMBIENT', (@d0 + INTERVAL 1370138 SECOND), (@d0 + INTERVAL 1374817 SECOND), (@d0 + INTERVAL 1370138 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1375250 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1375250 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 165;
CALL seed_claim(165, (@d0 + INTERVAL 1376531 SECOND), 1);
CALL seed_trip('[165]', (@d0 + INTERVAL 1377872 SECOND), NULL, 54.0);
CALL seed_claim(166, (@d0 + INTERVAL 1410357 SECOND), 2);
CALL seed_trip('[166]', (@d0 + INTERVAL 1410996 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 167, 2, 3, 4, 'DINNER', 'Chicken curry (dinner leftover)', 6.38, 'HOT_HELD', (@d0 + INTERVAL 1456572 SECOND), (@d0 + INTERVAL 1460433 SECOND), (@d0 + INTERVAL 1456572 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1461011 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1461011 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 167;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 170, 3, 1, 5, 'LUNCH', 'Curd rice (lunch leftover)', 11.77, 'CHILLED', (@d0 + INTERVAL 1514896 SECOND), (@d0 + INTERVAL 1519445 SECOND), (@d0 + INTERVAL 1514896 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1519803 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1519803 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 170;
CALL seed_claim(170, (@d0 + INTERVAL 1520554 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 172, 5, 1, 7, 'LUNCH', 'Dal tadka (lunch leftover)', 6.28, 'HOT_HELD', (@d0 + INTERVAL 1515556 SECOND), (@d0 + INTERVAL 1521333 SECOND), (@d0 + INTERVAL 1515556 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1521624 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1521624 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 172;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 171, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 9.39, 'HOT_HELD', (@d0 + INTERVAL 1515593 SECOND), (@d0 + INTERVAL 1521034 SECOND), (@d0 + INTERVAL 1515593 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1521699 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1521699 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 171;
CALL seed_claim(171, (@d0 + INTERVAL 1522095 SECOND), 1);
CALL seed_cancel(170, (@d0 + INTERVAL 1522139 SECOND), 'no transport available');
CALL seed_claim(170, (@d0 + INTERVAL 1522511 SECOND), 1);
CALL seed_trip('[171]', (@d0 + INTERVAL 1523386 SECOND), NULL, 54.0);
CALL seed_trip('[170]', (@d0 + INTERVAL 1523556 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 169, 1, 2, 3, 'DINNER', 'Paneer butter masala (dinner leftover)', 7.38, 'HOT_HELD', (@d0 + INTERVAL 1542286 SECOND), (@d0 + INTERVAL 1546201 SECOND), (@d0 + INTERVAL 1542286 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1546698 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1546698 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 169;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 175, 6, 1, 8, 'DINNER', 'Dal tadka (dinner leftover)', 7.93, 'AMBIENT', (@d0 + INTERVAL 1542812 SECOND), (@d0 + INTERVAL 1546359 SECOND), (@d0 + INTERVAL 1542812 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1546887 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1546887 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 175;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 168, 1, 1, 3, 'DINNER', 'Sambar rice (dinner leftover)', 6.97, 'HOT_HELD', (@d0 + INTERVAL 1542867 SECOND), (@d0 + INTERVAL 1546825 SECOND), (@d0 + INTERVAL 1542867 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1547331 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1547331 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 168;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 173, 5, 1, 7, 'DINNER', 'Dal tadka (dinner leftover)', 8.83, 'CHILLED', (@d0 + INTERVAL 1543120 SECOND), (@d0 + INTERVAL 1547291 SECOND), (@d0 + INTERVAL 1543120 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1547854 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1547854 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 173;
CALL seed_claim(169, (@d0 + INTERVAL 1548576 SECOND), 1);
CALL seed_claim(173, (@d0 + INTERVAL 1548857 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 174, 5, 7, 7, 'DINNER', 'Semiya payasam (dinner leftover)', 6.28, 'CHILLED', (@d0 + INTERVAL 1541811 SECOND), (@d0 + INTERVAL 1548598 SECOND), (@d0 + INTERVAL 1541811 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1548861 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1548861 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 174;
CALL seed_claim(175, (@d0 + INTERVAL 1548970 SECOND), 1);
CALL seed_cancel(175, (@d0 + INTERVAL 1550002 SECOND), 'no transport available');
CALL seed_trip('[173, 169]', (@d0 + INTERVAL 1550068 SECOND), NULL, 54.0);
CALL seed_claim(175, (@d0 + INTERVAL 1550831 SECOND), 1);
CALL seed_claim(174, (@d0 + INTERVAL 1552590 SECOND), 1);
CALL seed_trip('[175, 174]', (@d0 + INTERVAL 1553314 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 185, 2, 5, 4, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 10.56, 'HOT_HELD', (@d0 + INTERVAL 1584616 SECOND), (@d0 + INTERVAL 1589749 SECOND), (@d0 + INTERVAL 1584616 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1590169 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1590169 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 185;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 205, 5, 5, 7, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.94, 'HOT_HELD', (@d0 + INTERVAL 1585636 SECOND), (@d0 + INTERVAL 1590075 SECOND), (@d0 + INTERVAL 1585636 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1590431 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1590431 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 205;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 176, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 14.37, 'CHILLED', (@d0 + INTERVAL 1584966 SECOND), (@d0 + INTERVAL 1589990 SECOND), (@d0 + INTERVAL 1584966 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1590438 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1590438 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 176;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 204, 5, 5, 7, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.14, 'CHILLED', (@d0 + INTERVAL 1585289 SECOND), (@d0 + INTERVAL 1590128 SECOND), (@d0 + INTERVAL 1585289 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1590461 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1590461 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 204;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 212, 6, 5, 8, 'BREAKFAST', 'Pongal (breakfast leftover)', 6.62, 'HOT_HELD', (@d0 + INTERVAL 1586337 SECOND), (@d0 + INTERVAL 1589941 SECOND), (@d0 + INTERVAL 1586337 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1590532 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1590532 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 212;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 192, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 10.70, 'AMBIENT', (@d0 + INTERVAL 1585285 SECOND), (@d0 + INTERVAL 1590317 SECOND), (@d0 + INTERVAL 1585285 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1590577 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1590577 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 192;
CALL seed_claim(204, (@d0 + INTERVAL 1590830 SECOND), 1);
CALL seed_claim(205, (@d0 + INTERVAL 1590896 SECOND), 1);
CALL seed_claim(176, (@d0 + INTERVAL 1590954 SECOND), 1);
CALL seed_claim(185, (@d0 + INTERVAL 1590993 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 177, 1, 5, 3, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 11.44, 'HOT_HELD', (@d0 + INTERVAL 1585720 SECOND), (@d0 + INTERVAL 1590409 SECOND), (@d0 + INTERVAL 1585720 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1591007 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1591007 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 177;
CALL seed_claim(212, (@d0 + INTERVAL 1591122 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 193, 3, 5, 5, 'BREAKFAST', 'Pongal (breakfast leftover)', 14.33, 'AMBIENT', (@d0 + INTERVAL 1586409 SECOND), (@d0 + INTERVAL 1590553 SECOND), (@d0 + INTERVAL 1586409 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1591190 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1591190 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 193;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 184, 2, 5, 4, 'BREAKFAST', 'Upma (breakfast leftover)', 12.38, 'HOT_HELD', (@d0 + INTERVAL 1586075 SECOND), (@d0 + INTERVAL 1591021 SECOND), (@d0 + INTERVAL 1586075 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1591373 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1591373 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 184;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 211, 6, 5, 8, 'BREAKFAST', 'Upma (breakfast leftover)', 6.98, 'HOT_HELD', (@d0 + INTERVAL 1585062 SECOND), (@d0 + INTERVAL 1590954 SECOND), (@d0 + INTERVAL 1585062 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1591430 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1591430 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 211;
CALL seed_trip('[204, 176]', (@d0 + INTERVAL 1591618 SECOND), NULL, 54.0);
CALL seed_claim(177, (@d0 + INTERVAL 1591980 SECOND), 1);
CALL seed_claim(192, (@d0 + INTERVAL 1592017 SECOND), 2);
CALL seed_claim(184, (@d0 + INTERVAL 1592204 SECOND), 1);
CALL seed_trip('[185, 212, 205]', (@d0 + INTERVAL 1592216 SECOND), NULL, 54.0);
CALL seed_claim(193, (@d0 + INTERVAL 1592508 SECOND), 1);
CALL seed_claim(211, (@d0 + INTERVAL 1592886 SECOND), 1);
CALL seed_trip('[177, 184, 192]', (@d0 + INTERVAL 1593403 SECOND), NULL, 54.0);
CALL seed_trip('[211]', (@d0 + INTERVAL 1593930 SECOND), NULL, 54.0);
CALL seed_trip('[193]', (@d0 + INTERVAL 1594008 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 179, 1, 1, 3, 'LUNCH', 'Steamed rice (lunch leftover)', 25.72, 'HOT_HELD', (@d0 + INTERVAL 1601527 SECOND), (@d0 + INTERVAL 1605571 SECOND), (@d0 + INTERVAL 1601527 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1606082 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1606082 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 179;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 178, 1, 1, 3, 'LUNCH', 'Sambar rice (lunch leftover)', 13.46, 'HOT_HELD', (@d0 + INTERVAL 1601624 SECOND), (@d0 + INTERVAL 1605782 SECOND), (@d0 + INTERVAL 1601624 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1606095 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1606095 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 178;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 208, 5, 4, 7, 'LUNCH', 'Chapati (lunch leftover)', 15.23, 'AMBIENT', (@d0 + INTERVAL 1602884 SECOND), (@d0 + INTERVAL 1605479 SECOND), (@d0 + INTERVAL 1602884 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1606162 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1606162 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 208;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 207, 5, 1, 7, 'LUNCH', 'Curd rice (lunch leftover)', 13.48, 'HOT_HELD', (@d0 + INTERVAL 1602378 SECOND), (@d0 + INTERVAL 1606223 SECOND), (@d0 + INTERVAL 1602378 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1606507 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1606507 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 207;
CALL seed_claim(179, (@d0 + INTERVAL 1606872 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 213, 6, 1, 8, 'LUNCH', 'Sambar rice (lunch leftover)', 6.83, 'HOT_HELD', (@d0 + INTERVAL 1601896 SECOND), (@d0 + INTERVAL 1606501 SECOND), (@d0 + INTERVAL 1601896 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1606915 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1606915 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 213;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 200, 4, 1, 6, 'LUNCH', 'Veg biryani (lunch leftover)', 14.69, 'AMBIENT', (@d0 + INTERVAL 1601777 SECOND), (@d0 + INTERVAL 1606547 SECOND), (@d0 + INTERVAL 1601777 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607007 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607007 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 200;
CALL seed_claim(178, (@d0 + INTERVAL 1607103 SECOND), 1);
CALL seed_claim(208, (@d0 + INTERVAL 1607186 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 188, 2, 3, 4, 'LUNCH', 'Egg curry (lunch leftover)', 14.34, 'HOT_HELD', (@d0 + INTERVAL 1602317 SECOND), (@d0 + INTERVAL 1606587 SECOND), (@d0 + INTERVAL 1602317 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607283 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607283 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 188;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 194, 3, 1, 5, 'LUNCH', 'Dal tadka (lunch leftover)', 23.48, 'AMBIENT', (@d0 + INTERVAL 1601690 SECOND), (@d0 + INTERVAL 1606710 SECOND), (@d0 + INTERVAL 1601690 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607329 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607329 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 194;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 186, 2, 7, 4, 'LUNCH', 'Semiya payasam (lunch leftover)', 13.24, 'AMBIENT', (@d0 + INTERVAL 1602543 SECOND), (@d0 + INTERVAL 1606745 SECOND), (@d0 + INTERVAL 1602543 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607377 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607377 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 186;
CALL seed_claim(213, (@d0 + INTERVAL 1607444 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 214, 6, 1, 8, 'LUNCH', 'Dal tadka (lunch leftover)', 11.39, 'HOT_HELD', (@d0 + INTERVAL 1601911 SECOND), (@d0 + INTERVAL 1607053 SECOND), (@d0 + INTERVAL 1601911 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607487 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607487 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 214;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 180, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 13.44, 'CHILLED', (@d0 + INTERVAL 1602405 SECOND), (@d0 + INTERVAL 1606871 SECOND), (@d0 + INTERVAL 1602405 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607495 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607495 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 180;
CALL seed_claim(200, (@d0 + INTERVAL 1607644 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 201, 4, 1, 6, 'LUNCH', 'Sambar rice (lunch leftover)', 7.29, 'HOT_HELD', (@d0 + INTERVAL 1602477 SECOND), (@d0 + INTERVAL 1607364 SECOND), (@d0 + INTERVAL 1602477 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607707 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607707 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 201;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 187, 2, 3, 4, 'LUNCH', 'Fish fry (lunch leftover)', 9.36, 'HOT_HELD', (@d0 + INTERVAL 1602664 SECOND), (@d0 + INTERVAL 1607169 SECOND), (@d0 + INTERVAL 1602664 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607755 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607755 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 187;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 196, 3, 7, 5, 'LUNCH', 'Semiya payasam (lunch leftover)', 9.54, 'CHILLED', (@d0 + INTERVAL 1600844 SECOND), (@d0 + INTERVAL 1607376 SECOND), (@d0 + INTERVAL 1600844 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607870 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607870 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 196;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 202, 4, 2, 6, 'LUNCH', 'Aloo gobi (lunch leftover)', 6.88, 'HOT_HELD', (@d0 + INTERVAL 1601765 SECOND), (@d0 + INTERVAL 1607285 SECOND), (@d0 + INTERVAL 1601765 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607962 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607962 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 202;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 206, 5, 2, 7, 'LUNCH', 'Vegetable kurma (lunch leftover)', 9.42, 'AMBIENT', (@d0 + INTERVAL 1601293 SECOND), (@d0 + INTERVAL 1607337 SECOND), (@d0 + INTERVAL 1601293 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607967 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607967 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 206;
CALL seed_claim(194, (@d0 + INTERVAL 1607973 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 195, 3, 3, 5, 'LUNCH', 'Chicken curry (lunch leftover)', 15.04, 'HOT_HELD', (@d0 + INTERVAL 1602190 SECOND), (@d0 + INTERVAL 1607727 SECOND), (@d0 + INTERVAL 1602190 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1607973 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1607973 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 195;
CALL seed_claim(188, (@d0 + INTERVAL 1608210 SECOND), 1);
CALL seed_claim(196, (@d0 + INTERVAL 1608213 SECOND), 2);
CALL seed_claim(201, (@d0 + INTERVAL 1608300 SECOND), 1);
CALL seed_trip('[179, 178, 208]', (@d0 + INTERVAL 1608343 SECOND), NULL, 54.0);
CALL seed_claim(180, (@d0 + INTERVAL 1608375 SECOND), 2);
CALL seed_claim(214, (@d0 + INTERVAL 1608540 SECOND), 1);
CALL seed_trip('[200, 213]', (@d0 + INTERVAL 1608674 SECOND), NULL, 54.0);
CALL seed_claim(206, (@d0 + INTERVAL 1608942 SECOND), 1);
CALL seed_claim(195, (@d0 + INTERVAL 1609002 SECOND), 1);
CALL seed_claim(187, (@d0 + INTERVAL 1609081 SECOND), 1);
CALL seed_claim(202, (@d0 + INTERVAL 1609180 SECOND), 1);
CALL seed_trip('[214, 196]', (@d0 + INTERVAL 1609225 SECOND), NULL, 54.0);
CALL seed_trip('[180]', (@d0 + INTERVAL 1609342 SECOND), NULL, 54.0);
CALL seed_cancel(201, (@d0 + INTERVAL 1609545 SECOND), 'no transport available');
CALL seed_trip('[194, 187, 206]', (@d0 + INTERVAL 1609985 SECOND), NULL, 54.0);
CALL seed_cancel(188, (@d0 + INTERVAL 1610019 SECOND), 'no transport available');
CALL seed_claim(201, (@d0 + INTERVAL 1610070 SECOND), 1);
CALL seed_cancel(195, (@d0 + INTERVAL 1610113 SECOND), 'no transport available');
CALL seed_claim(188, (@d0 + INTERVAL 1610393 SECOND), 1);
CALL seed_claim(195, (@d0 + INTERVAL 1610780 SECOND), 1);
CALL seed_cancel(202, (@d0 + INTERVAL 1610935 SECOND), 'no transport available');
CALL seed_claim(202, (@d0 + INTERVAL 1611394 SECOND), 1);
CALL seed_trip('[201]', (@d0 + INTERVAL 1611459 SECOND), NULL, 54.0);
CALL seed_trip('[195]', (@d0 + INTERVAL 1611504 SECOND), NULL, 54.0);
CALL seed_trip('[188, 202]', (@d0 + INTERVAL 1612158 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 183, 1, 4, 3, 'DINNER', 'Chapati (dinner leftover)', 23.89, 'AMBIENT', (@d0 + INTERVAL 1629414 SECOND), (@d0 + INTERVAL 1633244 SECOND), (@d0 + INTERVAL 1629414 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1633602 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1633602 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 183;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 215, 6, 1, 8, 'DINNER', 'Dal tadka (dinner leftover)', 8.00, 'HOT_HELD', (@d0 + INTERVAL 1628587 SECOND), (@d0 + INTERVAL 1632993 SECOND), (@d0 + INTERVAL 1628587 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1633690 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1633690 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 215;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 191, 2, 3, 4, 'DINNER', 'Egg curry (dinner leftover)', 8.07, 'HOT_HELD', (@d0 + INTERVAL 1629307 SECOND), (@d0 + INTERVAL 1633389 SECOND), (@d0 + INTERVAL 1629307 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1633771 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1633771 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 191;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 181, 1, 1, 3, 'DINNER', 'Dal tadka (dinner leftover)', 17.04, 'CHILLED', (@d0 + INTERVAL 1629561 SECOND), (@d0 + INTERVAL 1633776 SECOND), (@d0 + INTERVAL 1629561 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634283 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634283 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 181;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 203, 4, 4, 6, 'DINNER', 'Chapati (dinner leftover)', 6.95, 'AMBIENT', (@d0 + INTERVAL 1629540 SECOND), (@d0 + INTERVAL 1633766 SECOND), (@d0 + INTERVAL 1629540 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634295 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634295 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 203;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 190, 2, 2, 4, 'DINNER', 'Paneer butter masala (dinner leftover)', 11.63, 'HOT_HELD', (@d0 + INTERVAL 1628676 SECOND), (@d0 + INTERVAL 1633930 SECOND), (@d0 + INTERVAL 1628676 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634367 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634367 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 190;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 189, 2, 2, 4, 'DINNER', 'Aloo gobi (dinner leftover)', 9.35, 'HOT_HELD', (@d0 + INTERVAL 1627830 SECOND), (@d0 + INTERVAL 1634143 SECOND), (@d0 + INTERVAL 1627830 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634410 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634410 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 189;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 182, 1, 1, 3, 'DINNER', 'Steamed rice (dinner leftover)', 20.34, 'HOT_HELD', (@d0 + INTERVAL 1628559 SECOND), (@d0 + INTERVAL 1634137 SECOND), (@d0 + INTERVAL 1628559 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634422 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634422 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 182;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 199, 3, 2, 5, 'DINNER', 'Paneer butter masala (dinner leftover)', 11.22, 'HOT_HELD', (@d0 + INTERVAL 1629798 SECOND), (@d0 + INTERVAL 1634375 SECOND), (@d0 + INTERVAL 1629798 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634691 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634691 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 199;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 210, 5, 1, 7, 'DINNER', 'Veg biryani (dinner leftover)', 13.98, 'HOT_HELD', (@d0 + INTERVAL 1628595 SECOND), (@d0 + INTERVAL 1634202 SECOND), (@d0 + INTERVAL 1628595 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634698 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634698 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 210;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 197, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 16.81, 'HOT_HELD', (@d0 + INTERVAL 1628608 SECOND), (@d0 + INTERVAL 1634433 SECOND), (@d0 + INTERVAL 1628608 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634781 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634781 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 197;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 216, 6, 1, 8, 'DINNER', 'Sambar rice (dinner leftover)', 8.65, 'HOT_HELD', (@d0 + INTERVAL 1629558 SECOND), (@d0 + INTERVAL 1634305 SECOND), (@d0 + INTERVAL 1629558 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634866 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634866 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 216;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 209, 5, 1, 7, 'DINNER', 'Sambar rice (dinner leftover)', 13.46, 'CHILLED', (@d0 + INTERVAL 1627804 SECOND), (@d0 + INTERVAL 1634259 SECOND), (@d0 + INTERVAL 1627804 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1634916 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1634916 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 209;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 198, 3, 1, 5, 'DINNER', 'Veg biryani (dinner leftover)', 16.22, 'HOT_HELD', (@d0 + INTERVAL 1629824 SECOND), (@d0 + INTERVAL 1634592 SECOND), (@d0 + INTERVAL 1629824 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1635188 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1635188 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 198;
CALL seed_claim(190, (@d0 + INTERVAL 1635261 SECOND), 2);
CALL seed_claim(182, (@d0 + INTERVAL 1635853 SECOND), 1);
CALL seed_claim(181, (@d0 + INTERVAL 1635959 SECOND), 1);
CALL seed_claim(215, (@d0 + INTERVAL 1636114 SECOND), 1);
CALL seed_claim(210, (@d0 + INTERVAL 1636794 SECOND), 1);
CALL seed_claim(189, (@d0 + INTERVAL 1637191 SECOND), 1);
CALL seed_trip('[190, 181, 210]', (@d0 + INTERVAL 1637443 SECOND), NULL, 54.0);
CALL seed_claim(216, (@d0 + INTERVAL 1637541 SECOND), 1);
CALL seed_claim(198, (@d0 + INTERVAL 1637684 SECOND), 1);
CALL seed_cancel(182, (@d0 + INTERVAL 1637854 SECOND), 'no transport available');
CALL seed_claim(182, (@d0 + INTERVAL 1638270 SECOND), 1);
CALL seed_trip('[215, 189]', (@d0 + INTERVAL 1638344 SECOND), NULL, 54.0);
CALL seed_cancel(216, (@d0 + INTERVAL 1639252 SECOND), 'no transport available');
CALL seed_claim(199, (@d0 + INTERVAL 1639447 SECOND), 1);
CALL seed_trip('[198, 182, 199]', (@d0 + INTERVAL 1640055 SECOND), NULL, 54.0);
CALL seed_claim(216, (@d0 + INTERVAL 1640070 SECOND), 1);
CALL seed_trip('[216]', (@d0 + INTERVAL 1640742 SECOND), NULL, 54.0);
CALL seed_claim(209, (@d0 + INTERVAL 1669264 SECOND), 1);
CALL seed_trip('[209]', (@d0 + INTERVAL 1670057 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 217, 1, 5, 3, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 12.39, 'HOT_HELD', (@d0 + INTERVAL 1672898 SECOND), (@d0 + INTERVAL 1676263 SECOND), (@d0 + INTERVAL 1672898 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1676598 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1676598 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 217;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 218, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 19.82, 'CHILLED', (@d0 + INTERVAL 1671419 SECOND), (@d0 + INTERVAL 1676305 SECOND), (@d0 + INTERVAL 1671419 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1676752 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1676752 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 218;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 255, 6, 5, 8, 'BREAKFAST', 'Pongal (breakfast leftover)', 9.30, 'HOT_HELD', (@d0 + INTERVAL 1672564 SECOND), (@d0 + INTERVAL 1676159 SECOND), (@d0 + INTERVAL 1672564 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1676788 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1676788 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 255;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 226, 2, 5, 4, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 13.75, 'HOT_HELD', (@d0 + INTERVAL 1672496 SECOND), (@d0 + INTERVAL 1676531 SECOND), (@d0 + INTERVAL 1672496 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1677153 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1677153 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 226;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 242, 4, 4, 6, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 6.01, 'AMBIENT', (@d0 + INTERVAL 1671972 SECOND), (@d0 + INTERVAL 1676787 SECOND), (@d0 + INTERVAL 1671972 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1677280 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1677280 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 242;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 247, 5, 5, 7, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 8.96, 'CHILLED', (@d0 + INTERVAL 1671239 SECOND), (@d0 + INTERVAL 1676982 SECOND), (@d0 + INTERVAL 1671239 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1677355 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1677355 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 247;
CALL seed_claim(255, (@d0 + INTERVAL 1677398 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 248, 5, 5, 7, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 11.68, 'HOT_HELD', (@d0 + INTERVAL 1673009 SECOND), (@d0 + INTERVAL 1677160 SECOND), (@d0 + INTERVAL 1673009 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1677617 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1677617 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 248;
CALL seed_claim(247, (@d0 + INTERVAL 1677722 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 241, 4, 5, 6, 'BREAKFAST', 'Upma (breakfast leftover)', 6.81, 'HOT_HELD', (@d0 + INTERVAL 1672000 SECOND), (@d0 + INTERVAL 1677470 SECOND), (@d0 + INTERVAL 1672000 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1678094 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1678094 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 241;
CALL seed_claim(226, (@d0 + INTERVAL 1678278 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 234, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 15.39, 'AMBIENT', (@d0 + INTERVAL 1672074 SECOND), (@d0 + INTERVAL 1677698 SECOND), (@d0 + INTERVAL 1672074 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1678378 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1678378 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 234;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 233, 3, 5, 5, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 14.34, 'AMBIENT', (@d0 + INTERVAL 1671518 SECOND), (@d0 + INTERVAL 1677892 SECOND), (@d0 + INTERVAL 1671518 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1678419 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1678419 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 233;
CALL seed_claim(218, (@d0 + INTERVAL 1678423 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 227, 2, 5, 4, 'BREAKFAST', 'Upma (breakfast leftover)', 15.83, 'HOT_HELD', (@d0 + INTERVAL 1671373 SECOND), (@d0 + INTERVAL 1677802 SECOND), (@d0 + INTERVAL 1671373 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1678425 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1678425 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 227;
CALL seed_claim(242, (@d0 + INTERVAL 1678427 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 256, 6, 5, 8, 'BREAKFAST', 'Upma (breakfast leftover)', 9.18, 'HOT_HELD', (@d0 + INTERVAL 1671714 SECOND), (@d0 + INTERVAL 1678161 SECOND), (@d0 + INTERVAL 1671714 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1678491 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1678491 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 256;
CALL seed_trip('[255]', (@d0 + INTERVAL 1678587 SECOND), NULL, 54.0);
CALL seed_trip('[247, 226, 218]', (@d0 + INTERVAL 1679161 SECOND), NULL, 54.0);
CALL seed_claim(227, (@d0 + INTERVAL 1679281 SECOND), 1);
CALL seed_claim(234, (@d0 + INTERVAL 1679330 SECOND), 1);
CALL seed_claim(233, (@d0 + INTERVAL 1679443 SECOND), 2);
CALL seed_claim(256, (@d0 + INTERVAL 1679573 SECOND), 1);
CALL seed_claim(241, (@d0 + INTERVAL 1679749 SECOND), 2);
CALL seed_trip('[242, 227, 234]', (@d0 + INTERVAL 1680339 SECOND), NULL, 54.0);
CALL seed_trip('[233]', (@d0 + INTERVAL 1680927 SECOND), NULL, 54.0);
CALL seed_trip('[256, 241]', (@d0 + INTERVAL 1681173 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 236, 3, 3, 5, 'LUNCH', 'Egg curry (lunch leftover)', 12.12, 'AMBIENT', (@d0 + INTERVAL 1687543 SECOND), (@d0 + INTERVAL 1691805 SECOND), (@d0 + INTERVAL 1687543 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1692481 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1692481 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 236;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 250, 5, 1, 7, 'LUNCH', 'Steamed rice (lunch leftover)', 20.24, 'AMBIENT', (@d0 + INTERVAL 1687898 SECOND), (@d0 + INTERVAL 1692492 SECOND), (@d0 + INTERVAL 1687898 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1692901 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1692901 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 250;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 221, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 16.78, 'CHILLED', (@d0 + INTERVAL 1689200 SECOND), (@d0 + INTERVAL 1692303 SECOND), (@d0 + INTERVAL 1689200 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1692914 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1692914 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 221;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 220, 1, 8, 3, 'LUNCH', 'Fruit salad (lunch leftover)', 24.41, 'CHILLED', (@d0 + INTERVAL 1689282 SECOND), (@d0 + INTERVAL 1692949 SECOND), (@d0 + INTERVAL 1689282 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693266 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693266 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 220;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 258, 6, 1, 8, 'LUNCH', 'Steamed rice (lunch leftover)', 13.48, 'AMBIENT', (@d0 + INTERVAL 1689288 SECOND), (@d0 + INTERVAL 1692649 SECOND), (@d0 + INTERVAL 1689288 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693312 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693312 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 258;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 237, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 27.82, 'CHILLED', (@d0 + INTERVAL 1689245 SECOND), (@d0 + INTERVAL 1692802 SECOND), (@d0 + INTERVAL 1689245 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693396 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693396 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 237;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 235, 3, 1, 5, 'LUNCH', 'Steamed rice (lunch leftover)', 22.91, 'HOT_HELD', (@d0 + INTERVAL 1688616 SECOND), (@d0 + INTERVAL 1693159 SECOND), (@d0 + INTERVAL 1688616 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693547 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693547 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 235;
CALL seed_claim(221, (@d0 + INTERVAL 1693575 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 249, 5, 8, 7, 'LUNCH', 'Fruit salad (lunch leftover)', 13.38, 'CHILLED', (@d0 + INTERVAL 1688732 SECOND), (@d0 + INTERVAL 1692942 SECOND), (@d0 + INTERVAL 1688732 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693606 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693606 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 249;
CALL seed_claim(220, (@d0 + INTERVAL 1693622 SECOND), 1);
CALL seed_claim(250, (@d0 + INTERVAL 1693624 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 259, 6, 1, 8, 'LUNCH', 'Dal tadka (lunch leftover)', 16.88, 'HOT_HELD', (@d0 + INTERVAL 1688515 SECOND), (@d0 + INTERVAL 1693205 SECOND), (@d0 + INTERVAL 1688515 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693629 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693629 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 259;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 228, 2, 4, 4, 'LUNCH', 'Chapati (lunch leftover)', 21.63, 'AMBIENT', (@d0 + INTERVAL 1687824 SECOND), (@d0 + INTERVAL 1693336 SECOND), (@d0 + INTERVAL 1687824 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693768 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693768 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 228;
CALL seed_claim(258, (@d0 + INTERVAL 1693868 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 244, 4, 1, 6, 'LUNCH', 'Curd rice (lunch leftover)', 14.22, 'HOT_HELD', (@d0 + INTERVAL 1688857 SECOND), (@d0 + INTERVAL 1693647 SECOND), (@d0 + INTERVAL 1688857 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693954 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693954 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 244;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 257, 6, 7, 8, 'LUNCH', 'Semiya payasam (lunch leftover)', 6.85, 'AMBIENT', (@d0 + INTERVAL 1688916 SECOND), (@d0 + INTERVAL 1693290 SECOND), (@d0 + INTERVAL 1688916 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1693961 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1693961 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 257;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 219, 1, 1, 3, 'LUNCH', 'Steamed rice (lunch leftover)', 34.97, 'HOT_HELD', (@d0 + INTERVAL 1687618 SECOND), (@d0 + INTERVAL 1693675 SECOND), (@d0 + INTERVAL 1687618 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1694057 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1694057 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 219;
CALL seed_claim(237, (@d0 + INTERVAL 1694127 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 243, 4, 3, 6, 'LUNCH', 'Chicken curry (lunch leftover)', 6.49, 'HOT_HELD', (@d0 + INTERVAL 1688642 SECOND), (@d0 + INTERVAL 1693434 SECOND), (@d0 + INTERVAL 1688642 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1694152 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1694152 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 243;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 251, 5, 3, 7, 'LUNCH', 'Chicken curry (lunch leftover)', 13.63, 'CHILLED', (@d0 + INTERVAL 1688624 SECOND), (@d0 + INTERVAL 1693929 SECOND), (@d0 + INTERVAL 1688624 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1694206 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1694206 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 251;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 229, 2, 8, 4, 'LUNCH', 'Fruit salad (lunch leftover)', 15.58, 'AMBIENT', (@d0 + INTERVAL 1688201 SECOND), (@d0 + INTERVAL 1693836 SECOND), (@d0 + INTERVAL 1688201 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1694242 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1694242 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 229;
CALL seed_claim(235, (@d0 + INTERVAL 1694326 SECOND), 1);
CALL seed_claim(259, (@d0 + INTERVAL 1694407 SECOND), 1);
CALL seed_claim(236, (@d0 + INTERVAL 1694519 SECOND), 2);
CALL seed_claim(228, (@d0 + INTERVAL 1694559 SECOND), 1);
CALL seed_claim(243, (@d0 + INTERVAL 1694591 SECOND), 1);
CALL seed_claim(249, (@d0 + INTERVAL 1694799 SECOND), 1);
CALL seed_claim(257, (@d0 + INTERVAL 1694864 SECOND), 1);
CALL seed_trip('[258, 250, 221]', (@d0 + INTERVAL 1694942 SECOND), NULL, 54.0);
CALL seed_claim(219, (@d0 + INTERVAL 1695160 SECOND), 1);
CALL seed_claim(244, (@d0 + INTERVAL 1695164 SECOND), 2);
CALL seed_trip('[220, 237, 243]', (@d0 + INTERVAL 1695235 SECOND), NULL, 54.0);
CALL seed_claim(229, (@d0 + INTERVAL 1695359 SECOND), 1);
CALL seed_trip('[249, 235, 228]', (@d0 + INTERVAL 1695703 SECOND), NULL, 54.0);
CALL seed_trip('[259]', (@d0 + INTERVAL 1695772 SECOND), NULL, 54.0);
CALL seed_claim(251, (@d0 + INTERVAL 1695994 SECOND), 1);
CALL seed_trip('[236, 257, 229]', (@d0 + INTERVAL 1696387 SECOND), NULL, 54.0);
CALL seed_trip('[219, 244, 251]', (@d0 + INTERVAL 1697367 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 222, 1, 6, 3, 'SNACKS', 'Samosa (snacks leftover)', 7.41, 'AMBIENT', (@d0 + INTERVAL 1700217 SECOND), (@d0 + INTERVAL 1706039 SECOND), (@d0 + INTERVAL 1700217 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1706480 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1706480 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 222;
CALL seed_claim(222, (@d0 + INTERVAL 1707588 SECOND), 1);
CALL seed_trip('[222]', (@d0 + INTERVAL 1708388 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 246, 4, 7, 6, 'DINNER', 'Semiya payasam (dinner leftover)', 7.01, 'AMBIENT', (@d0 + INTERVAL 1715895 SECOND), (@d0 + INTERVAL 1719075 SECOND), (@d0 + INTERVAL 1715895 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1719496 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1719496 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 246;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 232, 2, 3, 4, 'DINNER', 'Chicken curry (dinner leftover)', 9.12, 'AMBIENT', (@d0 + INTERVAL 1715824 SECOND), (@d0 + INTERVAL 1718845 SECOND), (@d0 + INTERVAL 1715824 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1719547 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1719547 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 232;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 245, 4, 1, 6, 'DINNER', 'Veg biryani (dinner leftover)', 15.33, 'HOT_HELD', (@d0 + INTERVAL 1716016 SECOND), (@d0 + INTERVAL 1719045 SECOND), (@d0 + INTERVAL 1716016 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1719557 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1719557 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 245;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 260, 6, 1, 8, 'DINNER', 'Sambar rice (dinner leftover)', 21.59, 'HOT_HELD', (@d0 + INTERVAL 1714929 SECOND), (@d0 + INTERVAL 1719773 SECOND), (@d0 + INTERVAL 1714929 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720071 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720071 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 260;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 254, 5, 2, 7, 'DINNER', 'Aloo gobi (dinner leftover)', 9.95, 'HOT_HELD', (@d0 + INTERVAL 1715479 SECOND), (@d0 + INTERVAL 1719823 SECOND), (@d0 + INTERVAL 1715479 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720178 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720178 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 254;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 239, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 24.60, 'HOT_HELD', (@d0 + INTERVAL 1715720 SECOND), (@d0 + INTERVAL 1719523 SECOND), (@d0 + INTERVAL 1715720 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720236 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720236 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 239;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 261, 6, 7, 8, 'DINNER', 'Gulab jamun (dinner leftover)', 6.77, 'AMBIENT', (@d0 + INTERVAL 1715986 SECOND), (@d0 + INTERVAL 1720159 SECOND), (@d0 + INTERVAL 1715986 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720406 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720406 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 261;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 223, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 19.49, 'CHILLED', (@d0 + INTERVAL 1714497 SECOND), (@d0 + INTERVAL 1719842 SECOND), (@d0 + INTERVAL 1714497 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720424 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720424 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 223;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 230, 2, 1, 4, 'DINNER', 'Sambar rice (dinner leftover)', 22.66, 'HOT_HELD', (@d0 + INTERVAL 1716038 SECOND), (@d0 + INTERVAL 1720131 SECOND), (@d0 + INTERVAL 1716038 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720609 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720609 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 230;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 238, 3, 4, 5, 'DINNER', 'Parotta (dinner leftover)', 26.14, 'AMBIENT', (@d0 + INTERVAL 1715872 SECOND), (@d0 + INTERVAL 1719954 SECOND), (@d0 + INTERVAL 1715872 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720652 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720652 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_EGG' AS tag) t WHERE batch_id = 238;
CALL seed_claim(246, (@d0 + INTERVAL 1720665 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 231, 2, 1, 4, 'DINNER', 'Steamed rice (dinner leftover)', 24.26, 'HOT_HELD', (@d0 + INTERVAL 1716020 SECOND), (@d0 + INTERVAL 1720525 SECOND), (@d0 + INTERVAL 1716020 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720890 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720890 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 231;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 240, 3, 2, 5, 'DINNER', 'Paneer butter masala (dinner leftover)', 18.23, 'HOT_HELD', (@d0 + INTERVAL 1715833 SECOND), (@d0 + INTERVAL 1720262 SECOND), (@d0 + INTERVAL 1715833 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720912 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720912 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 240;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 253, 5, 2, 7, 'DINNER', 'Paneer butter masala (dinner leftover)', 14.29, 'HOT_HELD', (@d0 + INTERVAL 1714374 SECOND), (@d0 + INTERVAL 1720566 SECOND), (@d0 + INTERVAL 1714374 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1720929 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1720929 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 253;
CALL seed_claim(239, (@d0 + INTERVAL 1721046 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 252, 5, 1, 7, 'DINNER', 'Sambar rice (dinner leftover)', 22.32, 'CHILLED', (@d0 + INTERVAL 1714673 SECOND), (@d0 + INTERVAL 1720708 SECOND), (@d0 + INTERVAL 1714673 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1721148 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1721148 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 252;
CALL seed_claim(245, (@d0 + INTERVAL 1721239 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 225, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 27.34, 'HOT_HELD', (@d0 + INTERVAL 1715553 SECOND), (@d0 + INTERVAL 1720982 SECOND), (@d0 + INTERVAL 1715553 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1721320 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1721320 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 225;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 224, 1, 1, 3, 'DINNER', 'Sambar rice (dinner leftover)', 26.49, 'HOT_HELD', (@d0 + INTERVAL 1715096 SECOND), (@d0 + INTERVAL 1721050 SECOND), (@d0 + INTERVAL 1715096 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1721587 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1721587 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 224;
CALL seed_claim(254, (@d0 + INTERVAL 1721617 SECOND), 1);
CALL seed_claim(232, (@d0 + INTERVAL 1721639 SECOND), 1);
CALL seed_claim(253, (@d0 + INTERVAL 1722130 SECOND), 1);
CALL seed_trip('[246, 239, 245]', (@d0 + INTERVAL 1722287 SECOND), NULL, 54.0);
CALL seed_claim(240, (@d0 + INTERVAL 1722525 SECOND), 1);
CALL seed_trip('[254]', (@d0 + INTERVAL 1722660 SECOND), NULL, 54.0);
CALL seed_trip('[232]', (@d0 + INTERVAL 1722839 SECOND), NULL, 54.0);
CALL seed_claim(225, (@d0 + INTERVAL 1723085 SECOND), 1);
CALL seed_claim(252, (@d0 + INTERVAL 1723309 SECOND), 1);
CALL seed_trip('[253, 240, 225]', (@d0 + INTERVAL 1724340 SECOND), NULL, 54.0);
CALL seed_claim(238, (@d0 + INTERVAL 1724784 SECOND), 1);
CALL seed_trip('[252, 238]', (@d0 + INTERVAL 1725681 SECOND), 252, 54.0);
CALL seed_claim(223, (@d0 + INTERVAL 1755255 SECOND), 1);
CALL seed_trip('[223]', (@d0 + INTERVAL 1756249 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 292, 5, 5, 7, 'BREAKFAST', 'Upma (breakfast leftover)', 13.11, 'HOT_HELD', (@d0 + INTERVAL 1759270 SECOND), (@d0 + INTERVAL 1762107 SECOND), (@d0 + INTERVAL 1759270 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1762793 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1762793 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 292;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 279, 3, 5, 5, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 17.50, 'HOT_HELD', (@d0 + INTERVAL 1758759 SECOND), (@d0 + INTERVAL 1762352 SECOND), (@d0 + INTERVAL 1758759 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763044 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763044 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 279;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 278, 3, 5, 5, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 12.98, 'HOT_HELD', (@d0 + INTERVAL 1759215 SECOND), (@d0 + INTERVAL 1762481 SECOND), (@d0 + INTERVAL 1759215 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763104 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763104 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 278;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 263, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 24.75, 'HOT_HELD', (@d0 + INTERVAL 1759110 SECOND), (@d0 + INTERVAL 1762763 SECOND), (@d0 + INTERVAL 1759110 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763291 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763291 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 263;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 286, 4, 5, 6, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.80, 'HOT_HELD', (@d0 + INTERVAL 1758261 SECOND), (@d0 + INTERVAL 1762835 SECOND), (@d0 + INTERVAL 1758261 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763296 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763296 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 286;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 271, 2, 5, 4, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 10.25, 'HOT_HELD', (@d0 + INTERVAL 1757904 SECOND), (@d0 + INTERVAL 1762938 SECOND), (@d0 + INTERVAL 1757904 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763317 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763317 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 271;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 262, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 11.25, 'HOT_HELD', (@d0 + INTERVAL 1757549 SECOND), (@d0 + INTERVAL 1762646 SECOND), (@d0 + INTERVAL 1757549 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763350 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763350 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 262;
CALL seed_claim(279, (@d0 + INTERVAL 1763633 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 272, 2, 5, 4, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 12.88, 'HOT_HELD', (@d0 + INTERVAL 1757485 SECOND), (@d0 + INTERVAL 1763297 SECOND), (@d0 + INTERVAL 1757485 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1763674 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1763674 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 272;
CALL seed_claim(263, (@d0 + INTERVAL 1763749 SECOND), 1);
CALL seed_claim(286, (@d0 + INTERVAL 1763757 SECOND), 1);
CALL seed_claim(292, (@d0 + INTERVAL 1763993 SECOND), 2);
CALL seed_claim(271, (@d0 + INTERVAL 1764067 SECOND), 2);
CALL seed_claim(262, (@d0 + INTERVAL 1764086 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 300, 6, 5, 8, 'BREAKFAST', 'Upma (breakfast leftover)', 9.95, 'HOT_HELD', (@d0 + INTERVAL 1758067 SECOND), (@d0 + INTERVAL 1763395 SECOND), (@d0 + INTERVAL 1758067 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1764090 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1764090 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 300;
CALL seed_claim(278, (@d0 + INTERVAL 1764234 SECOND), 1);
CALL seed_claim(272, (@d0 + INTERVAL 1764596 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 301, 6, 5, 8, 'BREAKFAST', 'Pongal (breakfast leftover)', 8.87, 'HOT_HELD', (@d0 + INTERVAL 1758297 SECOND), (@d0 + INTERVAL 1764229 SECOND), (@d0 + INTERVAL 1758297 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1764705 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1764705 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 301;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 293, 5, 5, 7, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 8.29, 'CHILLED', (@d0 + INTERVAL 1758428 SECOND), (@d0 + INTERVAL 1764457 SECOND), (@d0 + INTERVAL 1758428 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1764879 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1764879 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 293;
CALL seed_trip('[279, 286, 278]', (@d0 + INTERVAL 1765179 SECOND), NULL, 54.0);
CALL seed_cancel(292, (@d0 + INTERVAL 1765343 SECOND), 'no transport available');
CALL seed_trip('[263, 271, 262]', (@d0 + INTERVAL 1765365 SECOND), NULL, 54.0);
CALL seed_claim(300, (@d0 + INTERVAL 1765758 SECOND), 2);
CALL seed_claim(301, (@d0 + INTERVAL 1766190 SECOND), 1);
CALL seed_claim(292, (@d0 + INTERVAL 1766228 SECOND), 1);
CALL seed_claim(293, (@d0 + INTERVAL 1766304 SECOND), 1);
CALL seed_trip('[272, 301, 300]', (@d0 + INTERVAL 1767214 SECOND), NULL, 54.0);
CALL seed_trip('[293]', (@d0 + INTERVAL 1767235 SECOND), NULL, 54.0);
CALL seed_trip('[292]', (@d0 + INTERVAL 1767473 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 288, 4, 2, 6, 'LUNCH', 'Vegetable kurma (lunch leftover)', 9.67, 'HOT_HELD', (@d0 + INTERVAL 1774158 SECOND), (@d0 + INTERVAL 1778290 SECOND), (@d0 + INTERVAL 1774158 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1778972 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1778972 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 288;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 287, 4, 3, 6, 'LUNCH', 'Egg curry (lunch leftover)', 9.77, 'HOT_HELD', (@d0 + INTERVAL 1774935 SECOND), (@d0 + INTERVAL 1778951 SECOND), (@d0 + INTERVAL 1774935 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779204 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779204 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 287;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 281, 3, 4, 5, 'LUNCH', 'Chapati (lunch leftover)', 14.92, 'AMBIENT', (@d0 + INTERVAL 1774321 SECOND), (@d0 + INTERVAL 1778703 SECOND), (@d0 + INTERVAL 1774321 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779259 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779259 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 281;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 294, 5, 3, 7, 'LUNCH', 'Fish fry (lunch leftover)', 11.51, 'CHILLED', (@d0 + INTERVAL 1774085 SECOND), (@d0 + INTERVAL 1778887 SECOND), (@d0 + INTERVAL 1774085 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779322 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779322 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 294;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 304, 6, 1, 8, 'LUNCH', 'Sambar rice (lunch leftover)', 16.19, 'HOT_HELD', (@d0 + INTERVAL 1775197 SECOND), (@d0 + INTERVAL 1778985 SECOND), (@d0 + INTERVAL 1775197 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779517 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779517 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 304;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 265, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 30.42, 'CHILLED', (@d0 + INTERVAL 1775077 SECOND), (@d0 + INTERVAL 1779178 SECOND), (@d0 + INTERVAL 1775077 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779555 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779555 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 265;
CALL seed_claim(288, (@d0 + INTERVAL 1779575 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 266, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 20.05, 'HOT_HELD', (@d0 + INTERVAL 1775273 SECOND), (@d0 + INTERVAL 1779319 SECOND), (@d0 + INTERVAL 1775273 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779602 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779602 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 266;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 303, 6, 4, 8, 'LUNCH', 'Chapati (lunch leftover)', 15.92, 'AMBIENT', (@d0 + INTERVAL 1775338 SECOND), (@d0 + INTERVAL 1778928 SECOND), (@d0 + INTERVAL 1775338 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779630 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779630 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 303;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 264, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 30.34, 'CHILLED', (@d0 + INTERVAL 1774171 SECOND), (@d0 + INTERVAL 1779375 SECOND), (@d0 + INTERVAL 1774171 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779644 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779644 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 264;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 275, 2, 1, 4, 'LUNCH', 'Dal tadka (lunch leftover)', 21.97, 'HOT_HELD', (@d0 + INTERVAL 1774164 SECOND), (@d0 + INTERVAL 1779411 SECOND), (@d0 + INTERVAL 1774164 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779781 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779781 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 275;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 282, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 19.05, 'CHILLED', (@d0 + INTERVAL 1775379 SECOND), (@d0 + INTERVAL 1779707 SECOND), (@d0 + INTERVAL 1775379 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1779968 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1779968 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 282;
CALL seed_claim(294, (@d0 + INTERVAL 1780007 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 302, 6, 2, 8, 'LUNCH', 'Vegetable kurma (lunch leftover)', 8.92, 'HOT_HELD', (@d0 + INTERVAL 1774715 SECOND), (@d0 + INTERVAL 1779757 SECOND), (@d0 + INTERVAL 1774715 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1780010 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1780010 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 302;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 295, 5, 2, 7, 'LUNCH', 'Aloo gobi (lunch leftover)', 16.10, 'HOT_HELD', (@d0 + INTERVAL 1775625 SECOND), (@d0 + INTERVAL 1779699 SECOND), (@d0 + INTERVAL 1775625 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1780088 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1780088 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 295;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 289, 4, 1, 6, 'LUNCH', 'Sambar rice (lunch leftover)', 11.10, 'HOT_HELD', (@d0 + INTERVAL 1773966 SECOND), (@d0 + INTERVAL 1779563 SECOND), (@d0 + INTERVAL 1773966 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1780120 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1780120 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 289;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 280, 3, 1, 5, 'LUNCH', 'Veg biryani (lunch leftover)', 21.42, 'HOT_HELD', (@d0 + INTERVAL 1775234 SECOND), (@d0 + INTERVAL 1779779 SECOND), (@d0 + INTERVAL 1775234 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1780185 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1780185 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 280;
CALL seed_claim(281, (@d0 + INTERVAL 1780294 SECOND), 1);
CALL seed_claim(304, (@d0 + INTERVAL 1780298 SECOND), 1);
CALL seed_claim(303, (@d0 + INTERVAL 1780299 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 273, 2, 3, 4, 'LUNCH', 'Fish fry (lunch leftover)', 11.23, 'HOT_HELD', (@d0 + INTERVAL 1774867 SECOND), (@d0 + INTERVAL 1779805 SECOND), (@d0 + INTERVAL 1774867 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1780349 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1780349 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 273;
CALL seed_claim(282, (@d0 + INTERVAL 1780481 SECOND), 1);
CALL seed_claim(302, (@d0 + INTERVAL 1780608 SECOND), 1);
CALL seed_claim(265, (@d0 + INTERVAL 1780613 SECOND), 1);
CALL seed_claim(295, (@d0 + INTERVAL 1780643 SECOND), 2);
CALL seed_claim(275, (@d0 + INTERVAL 1780647 SECOND), 1);
CALL seed_claim(264, (@d0 + INTERVAL 1780704 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 296, 5, 3, 7, 'LUNCH', 'Egg curry (lunch leftover)', 17.92, 'HOT_HELD', (@d0 + INTERVAL 1775008 SECOND), (@d0 + INTERVAL 1780617 SECOND), (@d0 + INTERVAL 1775008 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1780929 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1780929 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 296;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 274, 2, 1, 4, 'LUNCH', 'Curd rice (lunch leftover)', 21.68, 'HOT_HELD', (@d0 + INTERVAL 1775053 SECOND), (@d0 + INTERVAL 1780714 SECOND), (@d0 + INTERVAL 1775053 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1781020 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1781020 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 274;
CALL seed_trip('[288, 281, 303]', (@d0 + INTERVAL 1781057 SECOND), NULL, 54.0);
CALL seed_claim(273, (@d0 + INTERVAL 1781100 SECOND), 1);
CALL seed_claim(266, (@d0 + INTERVAL 1781303 SECOND), 1);
CALL seed_claim(274, (@d0 + INTERVAL 1781612 SECOND), 1);
CALL seed_cancel(294, (@d0 + INTERVAL 1781648 SECOND), 'no transport available');
CALL seed_trip('[302, 304, 265]', (@d0 + INTERVAL 1781682 SECOND), NULL, 54.0);
CALL seed_trip('[275]', (@d0 + INTERVAL 1781776 SECOND), NULL, 54.0);
CALL seed_claim(289, (@d0 + INTERVAL 1781779 SECOND), 2);
CALL seed_claim(296, (@d0 + INTERVAL 1781836 SECOND), 1);
CALL seed_claim(287, (@d0 + INTERVAL 1782075 SECOND), 1);
CALL seed_trip('[282, 295, 273]', (@d0 + INTERVAL 1782171 SECOND), NULL, 54.0);
CALL seed_claim(294, (@d0 + INTERVAL 1782251 SECOND), 1);
CALL seed_claim(280, (@d0 + INTERVAL 1782489 SECOND), 1);
CALL seed_trip('[266, 274, 296]', (@d0 + INTERVAL 1782662 SECOND), NULL, 54.0);
CALL seed_cancel(264, (@d0 + INTERVAL 1782669 SECOND), 'no transport available');
CALL seed_trip('[294, 280, 289]', (@d0 + INTERVAL 1783185 SECOND), NULL, 54.0);
CALL seed_claim(264, (@d0 + INTERVAL 1783441 SECOND), 1);
CALL seed_trip('[287]', (@d0 + INTERVAL 1783530 SECOND), NULL, 54.0);
CALL seed_trip('[264]', (@d0 + INTERVAL 1784475 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 267, 1, 6, 3, 'SNACKS', 'Onion bajji (snacks leftover)', 6.37, 'AMBIENT', (@d0 + INTERVAL 1786554 SECOND), (@d0 + INTERVAL 1791429 SECOND), (@d0 + INTERVAL 1786554 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1791790 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1791790 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 267;
CALL seed_claim(267, (@d0 + INTERVAL 1792436 SECOND), 1);
CALL seed_trip('[267]', (@d0 + INTERVAL 1793209 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 276, 2, 2, 4, 'DINNER', 'Paneer butter masala (dinner leftover)', 22.51, 'HOT_HELD', (@d0 + INTERVAL 1801225 SECOND), (@d0 + INTERVAL 1805489 SECOND), (@d0 + INTERVAL 1801225 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1805938 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1805938 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 276;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 290, 4, 2, 6, 'DINNER', 'Paneer butter masala (dinner leftover)', 8.33, 'HOT_HELD', (@d0 + INTERVAL 1802227 SECOND), (@d0 + INTERVAL 1805537 SECOND), (@d0 + INTERVAL 1802227 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1805989 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1805989 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 290;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 305, 6, 4, 8, 'DINNER', 'Chapati (dinner leftover)', 12.90, 'AMBIENT', (@d0 + INTERVAL 1801938 SECOND), (@d0 + INTERVAL 1805756 SECOND), (@d0 + INTERVAL 1801938 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806094 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806094 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 305;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 299, 5, 1, 7, 'DINNER', 'Steamed rice (dinner leftover)', 29.38, 'HOT_HELD', (@d0 + INTERVAL 1802102 SECOND), (@d0 + INTERVAL 1805626 SECOND), (@d0 + INTERVAL 1802102 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806131 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806131 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 299;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 270, 1, 4, 3, 'DINNER', 'Chapati (dinner leftover)', 17.19, 'AMBIENT', (@d0 + INTERVAL 1801689 SECOND), (@d0 + INTERVAL 1805649 SECOND), (@d0 + INTERVAL 1801689 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806349 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806349 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 270;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 298, 5, 7, 7, 'DINNER', 'Semiya payasam (dinner leftover)', 10.54, 'CHILLED', (@d0 + INTERVAL 1801521 SECOND), (@d0 + INTERVAL 1805987 SECOND), (@d0 + INTERVAL 1801521 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806369 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806369 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 298;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 307, 6, 7, 8, 'DINNER', 'Semiya payasam (dinner leftover)', 13.04, 'AMBIENT', (@d0 + INTERVAL 1801462 SECOND), (@d0 + INTERVAL 1805954 SECOND), (@d0 + INTERVAL 1801462 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806522 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806522 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 307;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 297, 5, 4, 7, 'DINNER', 'Chapati (dinner leftover)', 14.09, 'AMBIENT', (@d0 + INTERVAL 1802037 SECOND), (@d0 + INTERVAL 1806209 SECOND), (@d0 + INTERVAL 1802037 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806648 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806648 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 297;
CALL seed_claim(299, (@d0 + INTERVAL 1806717 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 269, 1, 1, 3, 'DINNER', 'Steamed rice (dinner leftover)', 32.88, 'CHILLED', (@d0 + INTERVAL 1802051 SECOND), (@d0 + INTERVAL 1806225 SECOND), (@d0 + INTERVAL 1802051 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806724 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806724 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 269;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 291, 4, 1, 6, 'DINNER', 'Sambar rice (dinner leftover)', 12.84, 'HOT_HELD', (@d0 + INTERVAL 1802132 SECOND), (@d0 + INTERVAL 1806119 SECOND), (@d0 + INTERVAL 1802132 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1806809 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1806809 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 291;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 277, 2, 3, 4, 'DINNER', 'Chicken curry (dinner leftover)', 19.52, 'HOT_HELD', (@d0 + INTERVAL 1800762 SECOND), (@d0 + INTERVAL 1806740 SECOND), (@d0 + INTERVAL 1800762 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1807052 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1807052 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 277;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 283, 3, 1, 5, 'DINNER', 'Sambar rice (dinner leftover)', 21.05, 'AMBIENT', (@d0 + INTERVAL 1801622 SECOND), (@d0 + INTERVAL 1806356 SECOND), (@d0 + INTERVAL 1801622 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1807059 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1807059 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 283;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 306, 6, 2, 8, 'DINNER', 'Aloo gobi (dinner leftover)', 13.62, 'HOT_HELD', (@d0 + INTERVAL 1800715 SECOND), (@d0 + INTERVAL 1806457 SECOND), (@d0 + INTERVAL 1800715 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1807159 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1807159 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 306;
CALL seed_claim(276, (@d0 + INTERVAL 1807168 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 285, 3, 3, 5, 'DINNER', 'Egg curry (dinner leftover)', 23.02, 'CHILLED', (@d0 + INTERVAL 1802231 SECOND), (@d0 + INTERVAL 1807115 SECOND), (@d0 + INTERVAL 1802231 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1807762 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1807762 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 285;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 284, 3, 2, 5, 'DINNER', 'Paneer butter masala (dinner leftover)', 21.89, 'CHILLED', (@d0 + INTERVAL 1801729 SECOND), (@d0 + INTERVAL 1807096 SECOND), (@d0 + INTERVAL 1801729 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1807815 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1807815 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 284;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 268, 1, 7, 3, 'DINNER', 'Semiya payasam (dinner leftover)', 17.11, 'CHILLED', (@d0 + INTERVAL 1802017 SECOND), (@d0 + INTERVAL 1807410 SECOND), (@d0 + INTERVAL 1802017 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1807871 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1807871 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 268;
CALL seed_claim(291, (@d0 + INTERVAL 1808009 SECOND), 2);
CALL seed_claim(305, (@d0 + INTERVAL 1808165 SECOND), 1);
CALL seed_claim(297, (@d0 + INTERVAL 1808375 SECOND), 2);
CALL seed_claim(298, (@d0 + INTERVAL 1808710 SECOND), 2);
CALL seed_claim(277, (@d0 + INTERVAL 1808805 SECOND), 2);
CALL seed_claim(269, (@d0 + INTERVAL 1808910 SECOND), 1);
CALL seed_trip('[299, 276, 291]', (@d0 + INTERVAL 1809030 SECOND), NULL, 54.0);
CALL seed_claim(306, (@d0 + INTERVAL 1809389 SECOND), 2);
CALL seed_trip('[277]', (@d0 + INTERVAL 1809430 SECOND), NULL, 54.0);
CALL seed_trip('[298]', (@d0 + INTERVAL 1809532 SECOND), NULL, 54.0);
CALL seed_claim(307, (@d0 + INTERVAL 1809627 SECOND), 1);
CALL seed_claim(285, (@d0 + INTERVAL 1809677 SECOND), 1);
CALL seed_trip('[305, 269, 297]', (@d0 + INTERVAL 1809842 SECOND), NULL, 54.0);
CALL seed_claim(283, (@d0 + INTERVAL 1810254 SECOND), 1);
CALL seed_trip('[306, 307, 285]', (@d0 + INTERVAL 1810476 SECOND), NULL, 54.0);
CALL seed_claim(284, (@d0 + INTERVAL 1810742 SECOND), 1);
CALL seed_trip('[283, 284]', (@d0 + INTERVAL 1811730 SECOND), NULL, 54.0);
CALL seed_claim(268, (@d0 + INTERVAL 1813038 SECOND), 1);
CALL seed_trip('[268]', (@d0 + INTERVAL 1813641 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 309, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.49, 'HOT_HELD', (@d0 + INTERVAL 1844784 SECOND), (@d0 + INTERVAL 1848579 SECOND), (@d0 + INTERVAL 1844784 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1849218 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1849218 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 309;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 308, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 6.97, 'CHILLED', (@d0 + INTERVAL 1845022 SECOND), (@d0 + INTERVAL 1850588 SECOND), (@d0 + INTERVAL 1845022 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1850976 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1850976 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 308;
CALL seed_claim(308, (@d0 + INTERVAL 1852484 SECOND), 2);
CALL seed_trip('[308]', (@d0 + INTERVAL 1853917 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 310, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 10.37, 'HOT_HELD', (@d0 + INTERVAL 1860951 SECOND), (@d0 + INTERVAL 1866852 SECOND), (@d0 + INTERVAL 1860951 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1867343 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1867343 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 310;
CALL seed_claim(310, (@d0 + INTERVAL 1867944 SECOND), 2);
CALL seed_trip('[310]', (@d0 + INTERVAL 1868608 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 311, 3, 1, 5, 'DINNER', 'Veg biryani (dinner leftover)', 7.05, 'CHILLED', (@d0 + INTERVAL 1887711 SECOND), (@d0 + INTERVAL 1891666 SECOND), (@d0 + INTERVAL 1887711 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1892294 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1892294 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 311;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 312, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 8.78, 'CHILLED', (@d0 + INTERVAL 1887634 SECOND), (@d0 + INTERVAL 1892870 SECOND), (@d0 + INTERVAL 1887634 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1893430 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1893430 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 312;
CALL seed_claim(311, (@d0 + INTERVAL 1894123 SECOND), 1);
CALL seed_claim(312, (@d0 + INTERVAL 1894965 SECOND), 2);
CALL seed_trip('[311]', (@d0 + INTERVAL 1895459 SECOND), NULL, 54.0);
CALL seed_trip('[312]', (@d0 + INTERVAL 1896263 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 323, 5, 5, 7, 'BREAKFAST', 'Upma (breakfast leftover)', 7.71, 'HOT_HELD', (@d0 + INTERVAL 1931172 SECOND), (@d0 + INTERVAL 1934964 SECOND), (@d0 + INTERVAL 1931172 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1935575 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1935575 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 323;
CALL seed_claim(323, (@d0 + INTERVAL 1936147 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 316, 2, 4, 4, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 6.85, 'AMBIENT', (@d0 + INTERVAL 1930886 SECOND), (@d0 + INTERVAL 1936099 SECOND), (@d0 + INTERVAL 1930886 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1936451 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1936451 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 316;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 319, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 8.25, 'AMBIENT', (@d0 + INTERVAL 1931144 SECOND), (@d0 + INTERVAL 1936494 SECOND), (@d0 + INTERVAL 1931144 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1936735 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1936735 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 319;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 320, 3, 5, 5, 'BREAKFAST', 'Upma (breakfast leftover)', 8.53, 'HOT_HELD', (@d0 + INTERVAL 1930855 SECOND), (@d0 + INTERVAL 1936771 SECOND), (@d0 + INTERVAL 1930855 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1937054 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1937054 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 320;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 315, 2, 5, 4, 'BREAKFAST', 'Upma (breakfast leftover)', 7.79, 'HOT_HELD', (@d0 + INTERVAL 1930758 SECOND), (@d0 + INTERVAL 1936952 SECOND), (@d0 + INTERVAL 1930758 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1937197 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1937197 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 315;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 314, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 11.61, 'HOT_HELD', (@d0 + INTERVAL 1930966 SECOND), (@d0 + INTERVAL 1936756 SECOND), (@d0 + INTERVAL 1930966 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1937221 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1937221 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 314;
CALL seed_claim(320, (@d0 + INTERVAL 1937499 SECOND), 1);
CALL seed_trip('[323]', (@d0 + INTERVAL 1937566 SECOND), NULL, 54.0);
CALL seed_claim(319, (@d0 + INTERVAL 1937588 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 313, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 9.49, 'CHILLED', (@d0 + INTERVAL 1930535 SECOND), (@d0 + INTERVAL 1937407 SECOND), (@d0 + INTERVAL 1930535 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1937657 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1937657 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 313;
CALL seed_claim(313, (@d0 + INTERVAL 1938047 SECOND), 2);
CALL seed_claim(316, (@d0 + INTERVAL 1938458 SECOND), 1);
CALL seed_trip('[320, 313, 319]', (@d0 + INTERVAL 1939077 SECOND), NULL, 54.0);
CALL seed_claim(315, (@d0 + INTERVAL 1939384 SECOND), 2);
CALL seed_trip('[316, 315]', (@d0 + INTERVAL 1940386 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 324, 5, 3, 7, 'LUNCH', 'Chicken curry (lunch leftover)', 7.86, 'HOT_HELD', (@d0 + INTERVAL 1947244 SECOND), (@d0 + INTERVAL 1951361 SECOND), (@d0 + INTERVAL 1947244 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1951822 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1951822 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 324;
CALL seed_claim(324, (@d0 + INTERVAL 1952469 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 322, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 9.15, 'HOT_HELD', (@d0 + INTERVAL 1947263 SECOND), (@d0 + INTERVAL 1952933 SECOND), (@d0 + INTERVAL 1947263 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1953440 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1953440 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 322;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 317, 2, 1, 4, 'LUNCH', 'Dal tadka (lunch leftover)', 6.51, 'HOT_HELD', (@d0 + INTERVAL 1947435 SECOND), (@d0 + INTERVAL 1953142 SECOND), (@d0 + INTERVAL 1947435 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1953729 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1953729 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 317;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 318, 2, 1, 4, 'LUNCH', 'Veg biryani (lunch leftover)', 7.26, 'HOT_HELD', (@d0 + INTERVAL 1948497 SECOND), (@d0 + INTERVAL 1953500 SECOND), (@d0 + INTERVAL 1948497 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1953859 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1953859 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 318;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 321, 3, 1, 5, 'LUNCH', 'Dal tadka (lunch leftover)', 6.98, 'HOT_HELD', (@d0 + INTERVAL 1947363 SECOND), (@d0 + INTERVAL 1953632 SECOND), (@d0 + INTERVAL 1947363 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 1953895 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 1953895 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 321;
CALL seed_claim(322, (@d0 + INTERVAL 1953909 SECOND), 2);
CALL seed_cancel(324, (@d0 + INTERVAL 1954433 SECOND), 'no transport available');
CALL seed_claim(317, (@d0 + INTERVAL 1954955 SECOND), 1);
CALL seed_claim(324, (@d0 + INTERVAL 1955128 SECOND), 1);
CALL seed_claim(318, (@d0 + INTERVAL 1955257 SECOND), 1);
CALL seed_trip('[322, 324]', (@d0 + INTERVAL 1955965 SECOND), NULL, 54.0);
CALL seed_cancel(317, (@d0 + INTERVAL 1956317 SECOND), 'no transport available');
CALL seed_claim(317, (@d0 + INTERVAL 1956936 SECOND), 1);
CALL seed_trip('[318, 317]', (@d0 + INTERVAL 1957570 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 325, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 9.07, 'CHILLED', (@d0 + INTERVAL 2017609 SECOND), (@d0 + INTERVAL 2022094 SECOND), (@d0 + INTERVAL 2017609 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2022800 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2022800 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 325;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 330, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 7.90, 'AMBIENT', (@d0 + INTERVAL 2018285 SECOND), (@d0 + INTERVAL 2023099 SECOND), (@d0 + INTERVAL 2018285 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2023415 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2023415 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 330;
CALL seed_claim(325, (@d0 + INTERVAL 2023726 SECOND), 1);
CALL seed_claim(330, (@d0 + INTERVAL 2024623 SECOND), 1);
CALL seed_trip('[325]', (@d0 + INTERVAL 2025223 SECOND), NULL, 54.0);
CALL seed_trip('[330]', (@d0 + INTERVAL 2025608 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 327, 1, 1, 3, 'LUNCH', 'Steamed rice (lunch leftover)', 8.77, 'HOT_HELD', (@d0 + INTERVAL 2033221 SECOND), (@d0 + INTERVAL 2037660 SECOND), (@d0 + INTERVAL 2033221 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2038230 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2038230 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 327;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 326, 1, 8, 3, 'LUNCH', 'Fruit salad (lunch leftover)', 7.06, 'CHILLED', (@d0 + INTERVAL 2033590 SECOND), (@d0 + INTERVAL 2038852 SECOND), (@d0 + INTERVAL 2033590 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2039190 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2039190 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 326;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 331, 5, 1, 7, 'LUNCH', 'Sambar rice (lunch leftover)', 7.71, 'AMBIENT', (@d0 + INTERVAL 2033808 SECOND), (@d0 + INTERVAL 2038734 SECOND), (@d0 + INTERVAL 2033808 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2039225 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2039225 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 331;
CALL seed_claim(331, (@d0 + INTERVAL 2039654 SECOND), 1);
CALL seed_claim(327, (@d0 + INTERVAL 2039836 SECOND), 1);
CALL seed_claim(326, (@d0 + INTERVAL 2040572 SECOND), 1);
CALL seed_trip('[327, 331, 326]', (@d0 + INTERVAL 2041686 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 328, 1, 1, 3, 'DINNER', 'Steamed rice (dinner leftover)', 7.61, 'HOT_HELD', (@d0 + INTERVAL 2060891 SECOND), (@d0 + INTERVAL 2064467 SECOND), (@d0 + INTERVAL 2060891 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2065086 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2065086 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 328;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 329, 2, 1, 4, 'DINNER', 'Dal tadka (dinner leftover)', 7.89, 'HOT_HELD', (@d0 + INTERVAL 2061551 SECOND), (@d0 + INTERVAL 2065795 SECOND), (@d0 + INTERVAL 2061551 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2066067 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2066067 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 329;
CALL seed_claim(329, (@d0 + INTERVAL 2067724 SECOND), 1);
CALL seed_trip('[329]', (@d0 + INTERVAL 2068422 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 335, 2, 5, 4, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.92, 'AMBIENT', (@d0 + INTERVAL 2104495 SECOND), (@d0 + INTERVAL 2108677 SECOND), (@d0 + INTERVAL 2104495 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2109169 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2109169 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 335;
CALL seed_claim(335, (@d0 + INTERVAL 2109801 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 333, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 6.07, 'CHILLED', (@d0 + INTERVAL 2103313 SECOND), (@d0 + INTERVAL 2109346 SECOND), (@d0 + INTERVAL 2103313 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2110046 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2110046 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 333;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 343, 5, 5, 7, 'BREAKFAST', 'Pongal (breakfast leftover)', 6.54, 'AMBIENT', (@d0 + INTERVAL 2104593 SECOND), (@d0 + INTERVAL 2109557 SECOND), (@d0 + INTERVAL 2104593 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2110175 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2110175 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 343;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 337, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 6.03, 'AMBIENT', (@d0 + INTERVAL 2103215 SECOND), (@d0 + INTERVAL 2110188 SECOND), (@d0 + INTERVAL 2103215 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2110434 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2110434 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 337;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 332, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 9.35, 'CHILLED', (@d0 + INTERVAL 2104073 SECOND), (@d0 + INTERVAL 2110036 SECOND), (@d0 + INTERVAL 2104073 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2110473 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2110473 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 332;
CALL seed_claim(343, (@d0 + INTERVAL 2110753 SECOND), 1);
CALL seed_claim(333, (@d0 + INTERVAL 2110847 SECOND), 2);
CALL seed_claim(337, (@d0 + INTERVAL 2110922 SECOND), 1);
CALL seed_claim(332, (@d0 + INTERVAL 2111436 SECOND), 1);
CALL seed_trip('[335, 333]', (@d0 + INTERVAL 2111466 SECOND), NULL, 54.0);
CALL seed_trip('[343, 337]', (@d0 + INTERVAL 2112151 SECOND), NULL, 54.0);
CALL seed_cancel(332, (@d0 + INTERVAL 2113329 SECOND), 'no transport available');
CALL seed_claim(332, (@d0 + INTERVAL 2114090 SECOND), 1);
CALL seed_trip('[332]', (@d0 + INTERVAL 2115209 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 339, 3, 3, 5, 'LUNCH', 'Fish fry (lunch leftover)', 6.11, 'AMBIENT', (@d0 + INTERVAL 2120308 SECOND), (@d0 + INTERVAL 2123984 SECOND), (@d0 + INTERVAL 2120308 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2124655 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2124655 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 339;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 338, 3, 7, 5, 'LUNCH', 'Semiya payasam (lunch leftover)', 6.14, 'CHILLED', (@d0 + INTERVAL 2119538 SECOND), (@d0 + INTERVAL 2124153 SECOND), (@d0 + INTERVAL 2119538 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2124658 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2124658 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 338;
CALL seed_claim(338, (@d0 + INTERVAL 2125264 SECOND), 1);
CALL seed_claim(339, (@d0 + INTERVAL 2125480 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 336, 2, 3, 4, 'LUNCH', 'Chicken curry (lunch leftover)', 6.37, 'HOT_HELD', (@d0 + INTERVAL 2120499 SECOND), (@d0 + INTERVAL 2125425 SECOND), (@d0 + INTERVAL 2120499 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2125869 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2125869 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 336;
CALL seed_trip('[338]', (@d0 + INTERVAL 2126014 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 334, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 10.25, 'HOT_HELD', (@d0 + INTERVAL 2120149 SECOND), (@d0 + INTERVAL 2126134 SECOND), (@d0 + INTERVAL 2120149 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2126435 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2126435 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 334;
CALL seed_trip('[339]', (@d0 + INTERVAL 2126828 SECOND), NULL, 54.0);
CALL seed_claim(334, (@d0 + INTERVAL 2127227 SECOND), 1);
CALL seed_trip('[334]', (@d0 + INTERVAL 2128649 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 342, 3, 7, 5, 'DINNER', 'Semiya payasam (dinner leftover)', 7.18, 'CHILLED', (@d0 + INTERVAL 2146836 SECOND), (@d0 + INTERVAL 2152270 SECOND), (@d0 + INTERVAL 2146836 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2152727 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2152727 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 342;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 340, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 12.66, 'HOT_HELD', (@d0 + INTERVAL 2146596 SECOND), (@d0 + INTERVAL 2152393 SECOND), (@d0 + INTERVAL 2146596 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2152788 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2152788 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 340;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 341, 3, 2, 5, 'DINNER', 'Aloo gobi (dinner leftover)', 6.09, 'HOT_HELD', (@d0 + INTERVAL 2147273 SECOND), (@d0 + INTERVAL 2153324 SECOND), (@d0 + INTERVAL 2147273 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2153659 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2153659 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 341;
CALL seed_claim(341, (@d0 + INTERVAL 2154715 SECOND), 1);
CALL seed_trip('[341]', (@d0 + INTERVAL 2156153 SECOND), NULL, 54.0);
CALL seed_claim(342, (@d0 + INTERVAL 2156948 SECOND), 1);
CALL seed_claim(340, (@d0 + INTERVAL 2157167 SECOND), 1);
CALL seed_trip('[342, 340]', (@d0 + INTERVAL 2158493 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 348, 3, 5, 5, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.55, 'HOT_HELD', (@d0 + INTERVAL 2190120 SECOND), (@d0 + INTERVAL 2195098 SECOND), (@d0 + INTERVAL 2190120 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2195785 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2195785 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 348;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 344, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 14.55, 'HOT_HELD', (@d0 + INTERVAL 2191144 SECOND), (@d0 + INTERVAL 2195693 SECOND), (@d0 + INTERVAL 2191144 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2196206 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2196206 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 344;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 345, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.42, 'AMBIENT', (@d0 + INTERVAL 2191187 SECOND), (@d0 + INTERVAL 2195893 SECOND), (@d0 + INTERVAL 2191187 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2196308 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2196308 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 345;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 346, 2, 5, 4, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.51, 'HOT_HELD', (@d0 + INTERVAL 2190815 SECOND), (@d0 + INTERVAL 2196250 SECOND), (@d0 + INTERVAL 2190815 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2196579 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2196579 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 346;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 349, 3, 5, 5, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 8.17, 'HOT_HELD', (@d0 + INTERVAL 2190731 SECOND), (@d0 + INTERVAL 2196178 SECOND), (@d0 + INTERVAL 2190731 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2196628 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2196628 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 349;
CALL seed_claim(344, (@d0 + INTERVAL 2196844 SECOND), 1);
CALL seed_claim(346, (@d0 + INTERVAL 2197004 SECOND), 1);
CALL seed_claim(345, (@d0 + INTERVAL 2197220 SECOND), 2);
CALL seed_claim(349, (@d0 + INTERVAL 2197835 SECOND), 2);
CALL seed_trip('[345, 344, 346]', (@d0 + INTERVAL 2198385 SECOND), 345, 54.0);
CALL seed_trip('[349]', (@d0 + INTERVAL 2198557 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 347, 2, 1, 4, 'DINNER', 'Steamed rice (dinner leftover)', 9.04, 'HOT_HELD', (@d0 + INTERVAL 2233826 SECOND), (@d0 + INTERVAL 2237306 SECOND), (@d0 + INTERVAL 2233826 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2237962 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2237962 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 347;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 350, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 7.45, 'HOT_HELD', (@d0 + INTERVAL 2232943 SECOND), (@d0 + INTERVAL 2237794 SECOND), (@d0 + INTERVAL 2232943 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2238162 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2238162 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 350;
CALL seed_claim(350, (@d0 + INTERVAL 2240661 SECOND), 1);
CALL seed_trip('[350]', (@d0 + INTERVAL 2241559 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 374, 5, 4, 7, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 8.05, 'AMBIENT', (@d0 + INTERVAL 2275805 SECOND), (@d0 + INTERVAL 2280631 SECOND), (@d0 + INTERVAL 2275805 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2281153 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2281153 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 374;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 352, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 8.83, 'CHILLED', (@d0 + INTERVAL 2276207 SECOND), (@d0 + INTERVAL 2281285 SECOND), (@d0 + INTERVAL 2276207 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2281683 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2281683 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 352;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 367, 3, 5, 5, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 7.96, 'CHILLED', (@d0 + INTERVAL 2276094 SECOND), (@d0 + INTERVAL 2281444 SECOND), (@d0 + INTERVAL 2276094 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2281733 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2281733 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 367;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 360, 2, 5, 4, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 8.94, 'HOT_HELD', (@d0 + INTERVAL 2277657 SECOND), (@d0 + INTERVAL 2281470 SECOND), (@d0 + INTERVAL 2277657 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2281748 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2281748 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 360;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 373, 4, 5, 6, 'BREAKFAST', 'Upma (breakfast leftover)', 6.31, 'HOT_HELD', (@d0 + INTERVAL 2277751 SECOND), (@d0 + INTERVAL 2281525 SECOND), (@d0 + INTERVAL 2277751 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2281824 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2281824 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 373;
CALL seed_claim(374, (@d0 + INTERVAL 2281872 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 382, 6, 5, 8, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.43, 'HOT_HELD', (@d0 + INTERVAL 2276704 SECOND), (@d0 + INTERVAL 2281487 SECOND), (@d0 + INTERVAL 2276704 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2281989 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2281989 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 382;
CALL seed_claim(373, (@d0 + INTERVAL 2282239 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 381, 6, 5, 8, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.06, 'AMBIENT', (@d0 + INTERVAL 2277652 SECOND), (@d0 + INTERVAL 2281931 SECOND), (@d0 + INTERVAL 2277652 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2282265 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2282265 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 381;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 375, 5, 5, 7, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.06, 'HOT_HELD', (@d0 + INTERVAL 2276162 SECOND), (@d0 + INTERVAL 2281689 SECOND), (@d0 + INTERVAL 2276162 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2282398 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2282398 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 375;
CALL seed_claim(367, (@d0 + INTERVAL 2282411 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 359, 2, 4, 4, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 11.62, 'AMBIENT', (@d0 + INTERVAL 2276309 SECOND), (@d0 + INTERVAL 2282077 SECOND), (@d0 + INTERVAL 2276309 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2282460 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2282460 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 359;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 366, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 11.26, 'AMBIENT', (@d0 + INTERVAL 2277022 SECOND), (@d0 + INTERVAL 2282128 SECOND), (@d0 + INTERVAL 2277022 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2282815 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2282815 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 366;
CALL seed_claim(359, (@d0 + INTERVAL 2283047 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 351, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 14.06, 'CHILLED', (@d0 + INTERVAL 2276140 SECOND), (@d0 + INTERVAL 2282641 SECOND), (@d0 + INTERVAL 2276140 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2283238 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2283238 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 351;
CALL seed_claim(382, (@d0 + INTERVAL 2283342 SECOND), 1);
CALL seed_claim(381, (@d0 + INTERVAL 2283391 SECOND), 1);
CALL seed_claim(375, (@d0 + INTERVAL 2283418 SECOND), 1);
CALL seed_claim(366, (@d0 + INTERVAL 2283587 SECOND), 1);
CALL seed_trip('[374, 373, 359]', (@d0 + INTERVAL 2283682 SECOND), NULL, 54.0);
CALL seed_trip('[367, 382]', (@d0 + INTERVAL 2284040 SECOND), NULL, 54.0);
CALL seed_claim(351, (@d0 + INTERVAL 2284047 SECOND), 1);
CALL seed_claim(360, (@d0 + INTERVAL 2284069 SECOND), 1);
CALL seed_cancel(375, (@d0 + INTERVAL 2285140 SECOND), 'no transport available');
CALL seed_cancel(366, (@d0 + INTERVAL 2285251 SECOND), 'no transport available');
CALL seed_claim(375, (@d0 + INTERVAL 2285481 SECOND), 1);
CALL seed_trip('[381, 360, 351]', (@d0 + INTERVAL 2285492 SECOND), NULL, 54.0);
CALL seed_claim(366, (@d0 + INTERVAL 2285798 SECOND), 1);
CALL seed_trip('[366, 375]', (@d0 + INTERVAL 2286708 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 378, 5, 2, 7, 'LUNCH', 'Aloo gobi (lunch leftover)', 10.46, 'HOT_HELD', (@d0 + INTERVAL 2293156 SECOND), (@d0 + INTERVAL 2297254 SECOND), (@d0 + INTERVAL 2293156 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2297823 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2297823 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 378;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 354, 1, 1, 3, 'LUNCH', 'Steamed rice (lunch leftover)', 14.99, 'HOT_HELD', (@d0 + INTERVAL 2292710 SECOND), (@d0 + INTERVAL 2297475 SECOND), (@d0 + INTERVAL 2292710 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2297915 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2297915 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 354;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 363, 2, 3, 4, 'LUNCH', 'Fish fry (lunch leftover)', 8.69, 'HOT_HELD', (@d0 + INTERVAL 2292069 SECOND), (@d0 + INTERVAL 2297530 SECOND), (@d0 + INTERVAL 2292069 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2297944 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2297944 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 363;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 368, 3, 1, 5, 'LUNCH', 'Dal tadka (lunch leftover)', 19.86, 'CHILLED', (@d0 + INTERVAL 2293551 SECOND), (@d0 + INTERVAL 2297984 SECOND), (@d0 + INTERVAL 2293551 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2298255 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2298255 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 368;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 370, 3, 2, 5, 'LUNCH', 'Vegetable kurma (lunch leftover)', 9.45, 'HOT_HELD', (@d0 + INTERVAL 2293933 SECOND), (@d0 + INTERVAL 2297762 SECOND), (@d0 + INTERVAL 2293933 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2298351 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2298351 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 370;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 361, 2, 7, 4, 'LUNCH', 'Semiya payasam (lunch leftover)', 10.22, 'AMBIENT', (@d0 + INTERVAL 2294061 SECOND), (@d0 + INTERVAL 2297874 SECOND), (@d0 + INTERVAL 2294061 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2298480 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2298480 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 361;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 362, 2, 3, 4, 'LUNCH', 'Chicken curry (lunch leftover)', 6.80, 'HOT_HELD', (@d0 + INTERVAL 2292066 SECOND), (@d0 + INTERVAL 2298120 SECOND), (@d0 + INTERVAL 2292066 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2298529 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2298529 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 362;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 369, 3, 3, 5, 'LUNCH', 'Egg curry (lunch leftover)', 10.46, 'HOT_HELD', (@d0 + INTERVAL 2293257 SECOND), (@d0 + INTERVAL 2298322 SECOND), (@d0 + INTERVAL 2293257 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2298665 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2298665 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 369;
CALL seed_claim(354, (@d0 + INTERVAL 2298673 SECOND), 2);
CALL seed_claim(368, (@d0 + INTERVAL 2298748 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 376, 5, 7, 7, 'LUNCH', 'Semiya payasam (lunch leftover)', 7.20, 'CHILLED', (@d0 + INTERVAL 2292762 SECOND), (@d0 + INTERVAL 2298494 SECOND), (@d0 + INTERVAL 2292762 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2298813 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2298813 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 376;
CALL seed_claim(363, (@d0 + INTERVAL 2298828 SECOND), 2);
CALL seed_claim(369, (@d0 + INTERVAL 2299109 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 353, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 19.43, 'AMBIENT', (@d0 + INTERVAL 2292171 SECOND), (@d0 + INTERVAL 2298818 SECOND), (@d0 + INTERVAL 2292171 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2299116 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2299116 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 353;
CALL seed_claim(370, (@d0 + INTERVAL 2299199 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 355, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 18.08, 'HOT_HELD', (@d0 + INTERVAL 2294035 SECOND), (@d0 + INTERVAL 2298729 SECOND), (@d0 + INTERVAL 2294035 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2299314 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2299314 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 355;
CALL seed_claim(378, (@d0 + INTERVAL 2299327 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 377, 5, 1, 7, 'LUNCH', 'Dal tadka (lunch leftover)', 9.99, 'HOT_HELD', (@d0 + INTERVAL 2293816 SECOND), (@d0 + INTERVAL 2298937 SECOND), (@d0 + INTERVAL 2293816 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2299446 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2299446 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 377;
CALL seed_claim(361, (@d0 + INTERVAL 2299463 SECOND), 1);
CALL seed_claim(376, (@d0 + INTERVAL 2299464 SECOND), 2);
CALL seed_claim(362, (@d0 + INTERVAL 2299505 SECOND), 1);
CALL seed_claim(353, (@d0 + INTERVAL 2299675 SECOND), 1);
CALL seed_trip('[368, 354, 363]', (@d0 + INTERVAL 2299787 SECOND), NULL, 54.0);
CALL seed_claim(355, (@d0 + INTERVAL 2300087 SECOND), 1);
CALL seed_claim(377, (@d0 + INTERVAL 2300376 SECOND), 1);
CALL seed_trip('[370, 378, 369]', (@d0 + INTERVAL 2300427 SECOND), NULL, 54.0);
CALL seed_trip('[376]', (@d0 + INTERVAL 2300532 SECOND), NULL, 54.0);
CALL seed_trip('[361, 353, 362]', (@d0 + INTERVAL 2300870 SECOND), NULL, 54.0);
CALL seed_trip('[355]', (@d0 + INTERVAL 2301043 SECOND), NULL, 54.0);
CALL seed_trip('[377]', (@d0 + INTERVAL 2301234 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 365, 2, 1, 4, 'DINNER', 'Veg biryani (dinner leftover)', 9.85, 'HOT_HELD', (@d0 + INTERVAL 2321006 SECOND), (@d0 + INTERVAL 2324085 SECOND), (@d0 + INTERVAL 2321006 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2324331 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2324331 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 365;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 356, 1, 2, 3, 'DINNER', 'Vegetable kurma (dinner leftover)', 9.50, 'HOT_HELD', (@d0 + INTERVAL 2319038 SECOND), (@d0 + INTERVAL 2324303 SECOND), (@d0 + INTERVAL 2319038 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2324547 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2324547 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 356;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 357, 1, 1, 3, 'DINNER', 'Sambar rice (dinner leftover)', 16.81, 'HOT_HELD', (@d0 + INTERVAL 2321059 SECOND), (@d0 + INTERVAL 2324037 SECOND), (@d0 + INTERVAL 2321059 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2324612 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2324612 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 357;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 371, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 11.82, 'CHILLED', (@d0 + INTERVAL 2320824 SECOND), (@d0 + INTERVAL 2324810 SECOND), (@d0 + INTERVAL 2320824 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2325191 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2325191 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 371;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 379, 5, 1, 7, 'DINNER', 'Sambar rice (dinner leftover)', 9.57, 'HOT_HELD', (@d0 + INTERVAL 2319760 SECOND), (@d0 + INTERVAL 2324771 SECOND), (@d0 + INTERVAL 2319760 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2325214 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2325214 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 379;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 383, 6, 1, 8, 'DINNER', 'Dal tadka (dinner leftover)', 8.43, 'AMBIENT', (@d0 + INTERVAL 2319443 SECOND), (@d0 + INTERVAL 2324940 SECOND), (@d0 + INTERVAL 2319443 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2325333 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2325333 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 383;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 364, 2, 1, 4, 'DINNER', 'Sambar rice (dinner leftover)', 11.24, 'HOT_HELD', (@d0 + INTERVAL 2319274 SECOND), (@d0 + INTERVAL 2325123 SECOND), (@d0 + INTERVAL 2319274 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2325555 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2325555 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 364;
CALL seed_claim(357, (@d0 + INTERVAL 2325848 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 358, 1, 2, 3, 'DINNER', 'Aloo gobi (dinner leftover)', 8.10, 'HOT_HELD', (@d0 + INTERVAL 2320755 SECOND), (@d0 + INTERVAL 2325462 SECOND), (@d0 + INTERVAL 2320755 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2325947 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2325947 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 358;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 372, 3, 4, 5, 'DINNER', 'Parotta (dinner leftover)', 6.45, 'AMBIENT', (@d0 + INTERVAL 2320936 SECOND), (@d0 + INTERVAL 2325806 SECOND), (@d0 + INTERVAL 2320936 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2326206 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2326206 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_EGG' AS tag) t WHERE batch_id = 372;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 380, 5, 1, 7, 'DINNER', 'Dal tadka (dinner leftover)', 6.63, 'CHILLED', (@d0 + INTERVAL 2319262 SECOND), (@d0 + INTERVAL 2325520 SECOND), (@d0 + INTERVAL 2319262 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2326209 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2326209 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 380;
CALL seed_claim(365, (@d0 + INTERVAL 2326237 SECOND), 2);
CALL seed_claim(371, (@d0 + INTERVAL 2326540 SECOND), 1);
CALL seed_trip('[357]', (@d0 + INTERVAL 2326793 SECOND), NULL, 54.0);
CALL seed_trip('[365]', (@d0 + INTERVAL 2326920 SECOND), NULL, 54.0);
CALL seed_claim(379, (@d0 + INTERVAL 2327940 SECOND), 1);
CALL seed_claim(364, (@d0 + INTERVAL 2328143 SECOND), 2);
CALL seed_claim(383, (@d0 + INTERVAL 2328615 SECOND), 1);
CALL seed_trip('[371, 379]', (@d0 + INTERVAL 2328653 SECOND), NULL, 54.0);
CALL seed_claim(372, (@d0 + INTERVAL 2329043 SECOND), 1);
CALL seed_claim(358, (@d0 + INTERVAL 2329590 SECOND), 1);
CALL seed_trip('[364, 383, 372]', (@d0 + INTERVAL 2330537 SECOND), NULL, 54.0);
CALL seed_trip('[358]', (@d0 + INTERVAL 2330742 SECOND), NULL, 54.0);
CALL seed_claim(380, (@d0 + INTERVAL 2363374 SECOND), 1);
CALL seed_trip('[380]', (@d0 + INTERVAL 2364511 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 398, 3, 5, 5, 'BREAKFAST', 'Upma (breakfast leftover)', 6.03, 'HOT_HELD', (@d0 + INTERVAL 2363065 SECOND), (@d0 + INTERVAL 2367251 SECOND), (@d0 + INTERVAL 2363065 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2367525 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2367525 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 398;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 385, 1, 5, 3, 'BREAKFAST', 'Pongal (breakfast leftover)', 11.06, 'HOT_HELD', (@d0 + INTERVAL 2364155 SECOND), (@d0 + INTERVAL 2367364 SECOND), (@d0 + INTERVAL 2364155 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2367621 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2367621 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 385;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 397, 3, 5, 5, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.20, 'CHILLED', (@d0 + INTERVAL 2362892 SECOND), (@d0 + INTERVAL 2367931 SECOND), (@d0 + INTERVAL 2362892 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2368235 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2368235 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 397;
CALL seed_claim(398, (@d0 + INTERVAL 2368365 SECOND), 1);
CALL seed_claim(385, (@d0 + INTERVAL 2368394 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 384, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 7.04, 'CHILLED', (@d0 + INTERVAL 2362654 SECOND), (@d0 + INTERVAL 2367799 SECOND), (@d0 + INTERVAL 2362654 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2368415 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2368415 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 384;
CALL seed_claim(397, (@d0 + INTERVAL 2368621 SECOND), 1);
CALL seed_trip('[385, 398, 397]', (@d0 + INTERVAL 2369808 SECOND), NULL, 54.0);
CALL seed_claim(384, (@d0 + INTERVAL 2371634 SECOND), 1);
CALL seed_trip('[384]', (@d0 + INTERVAL 2373100 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 388, 1, 1, 3, 'LUNCH', 'Sambar rice (lunch leftover)', 20.29, 'HOT_HELD', (@d0 + INTERVAL 2380293 SECOND), (@d0 + INTERVAL 2383355 SECOND), (@d0 + INTERVAL 2380293 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2383726 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2383726 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 388;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 408, 5, 1, 7, 'LUNCH', 'Steamed rice (lunch leftover)', 8.06, 'CHILLED', (@d0 + INTERVAL 2379138 SECOND), (@d0 + INTERVAL 2383021 SECOND), (@d0 + INTERVAL 2379138 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2383737 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2383737 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 408;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 411, 6, 1, 8, 'LUNCH', 'Curd rice (lunch leftover)', 9.68, 'HOT_HELD', (@d0 + INTERVAL 2379035 SECOND), (@d0 + INTERVAL 2383620 SECOND), (@d0 + INTERVAL 2379035 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2383930 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2383930 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 411;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 386, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 19.21, 'CHILLED', (@d0 + INTERVAL 2378596 SECOND), (@d0 + INTERVAL 2383289 SECOND), (@d0 + INTERVAL 2378596 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2383942 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2383942 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 386;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 406, 4, 1, 6, 'LUNCH', 'Steamed rice (lunch leftover)', 6.41, 'HOT_HELD', (@d0 + INTERVAL 2378625 SECOND), (@d0 + INTERVAL 2383330 SECOND), (@d0 + INTERVAL 2378625 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2383960 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2383960 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 406;
CALL seed_claim(388, (@d0 + INTERVAL 2384042 SECOND), 1);
CALL seed_claim(411, (@d0 + INTERVAL 2384363 SECOND), 1);
CALL seed_claim(406, (@d0 + INTERVAL 2384739 SECOND), 1);
CALL seed_claim(408, (@d0 + INTERVAL 2384772 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 399, 3, 2, 5, 'LUNCH', 'Aloo gobi (lunch leftover)', 7.21, 'AMBIENT', (@d0 + INTERVAL 2379462 SECOND), (@d0 + INTERVAL 2384615 SECOND), (@d0 + INTERVAL 2379462 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385046 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385046 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 399;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 393, 2, 1, 4, 'LUNCH', 'Steamed rice (lunch leftover)', 7.41, 'HOT_HELD', (@d0 + INTERVAL 2379924 SECOND), (@d0 + INTERVAL 2384385 SECOND), (@d0 + INTERVAL 2379924 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385060 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385060 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 393;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 392, 2, 1, 4, 'LUNCH', 'Sambar rice (lunch leftover)', 7.47, 'HOT_HELD', (@d0 + INTERVAL 2378855 SECOND), (@d0 + INTERVAL 2384668 SECOND), (@d0 + INTERVAL 2378855 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385144 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385144 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 392;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 387, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 10.60, 'CHILLED', (@d0 + INTERVAL 2378403 SECOND), (@d0 + INTERVAL 2384651 SECOND), (@d0 + INTERVAL 2378403 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385283 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385283 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 387;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 409, 5, 3, 7, 'LUNCH', 'Chicken curry (lunch leftover)', 6.83, 'HOT_HELD', (@d0 + INTERVAL 2379279 SECOND), (@d0 + INTERVAL 2384647 SECOND), (@d0 + INTERVAL 2379279 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385311 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385311 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 409;
CALL seed_trip('[388, 411, 406]', (@d0 + INTERVAL 2385564 SECOND), NULL, 54.0);
CALL seed_claim(399, (@d0 + INTERVAL 2385632 SECOND), 1);
CALL seed_claim(393, (@d0 + INTERVAL 2385673 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 405, 4, 3, 6, 'LUNCH', 'Egg curry (lunch leftover)', 6.09, 'HOT_HELD', (@d0 + INTERVAL 2378898 SECOND), (@d0 + INTERVAL 2385188 SECOND), (@d0 + INTERVAL 2378898 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385680 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385680 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 405;
CALL seed_claim(387, (@d0 + INTERVAL 2385708 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 400, 3, 3, 5, 'LUNCH', 'Egg curry (lunch leftover)', 8.06, 'HOT_HELD', (@d0 + INTERVAL 2379290 SECOND), (@d0 + INTERVAL 2385066 SECOND), (@d0 + INTERVAL 2379290 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385715 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385715 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 400;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 401, 3, 4, 5, 'LUNCH', 'Chapati (lunch leftover)', 8.25, 'AMBIENT', (@d0 + INTERVAL 2380321 SECOND), (@d0 + INTERVAL 2385195 SECOND), (@d0 + INTERVAL 2380321 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385726 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385726 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 401;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 407, 5, 7, 7, 'LUNCH', 'Semiya payasam (lunch leftover)', 7.07, 'CHILLED', (@d0 + INTERVAL 2380128 SECOND), (@d0 + INTERVAL 2385340 SECOND), (@d0 + INTERVAL 2380128 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2385811 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2385811 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 407;
CALL seed_claim(409, (@d0 + INTERVAL 2385869 SECOND), 1);
CALL seed_claim(392, (@d0 + INTERVAL 2386003 SECOND), 1);
CALL seed_claim(401, (@d0 + INTERVAL 2386326 SECOND), 1);
CALL seed_claim(407, (@d0 + INTERVAL 2386339 SECOND), 1);
CALL seed_claim(400, (@d0 + INTERVAL 2386439 SECOND), 1);
CALL seed_trip('[408, 393, 387]', (@d0 + INTERVAL 2386601 SECOND), NULL, 54.0);
CALL seed_claim(405, (@d0 + INTERVAL 2386833 SECOND), 1);
CALL seed_trip('[409, 399]', (@d0 + INTERVAL 2386906 SECOND), 409, 54.0);
CALL seed_trip('[392, 401, 400]', (@d0 + INTERVAL 2387169 SECOND), NULL, 54.0);
CALL seed_trip('[407, 405]', (@d0 + INTERVAL 2387479 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 402, 3, 1, 5, 'DINNER', 'Veg biryani (dinner leftover)', 13.26, 'CHILLED', (@d0 + INTERVAL 2405686 SECOND), (@d0 + INTERVAL 2410706 SECOND), (@d0 + INTERVAL 2405686 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2411140 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2411140 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 402;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 394, 2, 4, 4, 'DINNER', 'Chapati (dinner leftover)', 6.61, 'AMBIENT', (@d0 + INTERVAL 2405958 SECOND), (@d0 + INTERVAL 2410820 SECOND), (@d0 + INTERVAL 2405958 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2411279 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2411279 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 394;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 410, 5, 1, 7, 'DINNER', 'Dal tadka (dinner leftover)', 10.58, 'HOT_HELD', (@d0 + INTERVAL 2405496 SECOND), (@d0 + INTERVAL 2410997 SECOND), (@d0 + INTERVAL 2405496 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2411305 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2411305 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 410;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 396, 2, 3, 4, 'DINNER', 'Chicken curry (dinner leftover)', 6.96, 'HOT_HELD', (@d0 + INTERVAL 2406783 SECOND), (@d0 + INTERVAL 2411070 SECOND), (@d0 + INTERVAL 2406783 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2411719 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2411719 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 396;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 403, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 13.46, 'HOT_HELD', (@d0 + INTERVAL 2406258 SECOND), (@d0 + INTERVAL 2411377 SECOND), (@d0 + INTERVAL 2406258 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2411961 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2411961 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 403;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 389, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 8.98, 'CHILLED', (@d0 + INTERVAL 2407362 SECOND), (@d0 + INTERVAL 2411434 SECOND), (@d0 + INTERVAL 2407362 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2412076 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2412076 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 389;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 391, 1, 1, 3, 'DINNER', 'Dal tadka (dinner leftover)', 16.74, 'HOT_HELD', (@d0 + INTERVAL 2405822 SECOND), (@d0 + INTERVAL 2411853 SECOND), (@d0 + INTERVAL 2405822 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2412145 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2412145 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 391;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 404, 3, 2, 5, 'DINNER', 'Aloo gobi (dinner leftover)', 7.01, 'HOT_HELD', (@d0 + INTERVAL 2407120 SECOND), (@d0 + INTERVAL 2411935 SECOND), (@d0 + INTERVAL 2407120 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2412653 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2412653 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 404;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 395, 2, 1, 4, 'DINNER', 'Sambar rice (dinner leftover)', 8.32, 'HOT_HELD', (@d0 + INTERVAL 2407398 SECOND), (@d0 + INTERVAL 2412033 SECOND), (@d0 + INTERVAL 2407398 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2412705 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2412705 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 395;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 390, 1, 7, 3, 'DINNER', 'Semiya payasam (dinner leftover)', 7.41, 'CHILLED', (@d0 + INTERVAL 2407319 SECOND), (@d0 + INTERVAL 2412230 SECOND), (@d0 + INTERVAL 2407319 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2412744 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2412744 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 390;
CALL seed_claim(403, (@d0 + INTERVAL 2413311 SECOND), 2);
CALL seed_claim(404, (@d0 + INTERVAL 2414016 SECOND), 1);
CALL seed_claim(391, (@d0 + INTERVAL 2414439 SECOND), 2);
CALL seed_claim(395, (@d0 + INTERVAL 2414537 SECOND), 1);
CALL seed_claim(390, (@d0 + INTERVAL 2414569 SECOND), 1);
CALL seed_claim(396, (@d0 + INTERVAL 2414753 SECOND), 1);
CALL seed_trip('[403, 404]', (@d0 + INTERVAL 2415339 SECOND), NULL, 54.0);
CALL seed_trip('[395, 396, 391]', (@d0 + INTERVAL 2415733 SECOND), NULL, 54.0);
CALL seed_trip('[390]', (@d0 + INTERVAL 2415752 SECOND), NULL, 54.0);
CALL seed_claim(402, (@d0 + INTERVAL 2446593 SECOND), 1);
CALL seed_claim(389, (@d0 + INTERVAL 2447864 SECOND), 2);
CALL seed_claim(386, (@d0 + INTERVAL 2448099 SECOND), 2);
CALL seed_trip('[402, 389]', (@d0 + INTERVAL 2448652 SECOND), NULL, 54.0);
CALL seed_trip('[386]', (@d0 + INTERVAL 2449557 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 412, 6, 1, 8, 'DINNER', 'Veg biryani (dinner leftover)', 6.99, 'HOT_HELD', (@d0 + INTERVAL 2492744 SECOND), (@d0 + INTERVAL 2498188 SECOND), (@d0 + INTERVAL 2492744 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2498814 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2498814 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 412;
CALL seed_claim(412, (@d0 + INTERVAL 2499520 SECOND), 1);
CALL seed_trip('[412]', (@d0 + INTERVAL 2500799 SECOND), 412, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 415, 2, 1, 4, 'LUNCH', 'Sambar rice (lunch leftover)', 7.52, 'HOT_HELD', (@d0 + INTERVAL 2551963 SECOND), (@d0 + INTERVAL 2557206 SECOND), (@d0 + INTERVAL 2551963 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2557783 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2557783 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 415;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 416, 2, 4, 4, 'LUNCH', 'Chapati (lunch leftover)', 7.36, 'AMBIENT', (@d0 + INTERVAL 2552616 SECOND), (@d0 + INTERVAL 2557765 SECOND), (@d0 + INTERVAL 2552616 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2558236 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2558236 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 416;
CALL seed_claim(415, (@d0 + INTERVAL 2558304 SECOND), 1);
CALL seed_claim(416, (@d0 + INTERVAL 2558655 SECOND), 1);
CALL seed_trip('[415, 416]', (@d0 + INTERVAL 2559930 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 414, 1, 1, 3, 'DINNER', 'Dal tadka (dinner leftover)', 8.27, 'CHILLED', (@d0 + INTERVAL 2578411 SECOND), (@d0 + INTERVAL 2583194 SECOND), (@d0 + INTERVAL 2578411 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2583601 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2583601 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 414;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 417, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 7.24, 'CHILLED', (@d0 + INTERVAL 2580293 SECOND), (@d0 + INTERVAL 2583743 SECOND), (@d0 + INTERVAL 2580293 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2584430 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2584430 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 417;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 413, 1, 2, 3, 'DINNER', 'Aloo gobi (dinner leftover)', 6.55, 'HOT_HELD', (@d0 + INTERVAL 2578390 SECOND), (@d0 + INTERVAL 2583923 SECOND), (@d0 + INTERVAL 2578390 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2584492 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2584492 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 413;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 418, 5, 1, 7, 'DINNER', 'Veg biryani (dinner leftover)', 6.03, 'HOT_HELD', (@d0 + INTERVAL 2578623 SECOND), (@d0 + INTERVAL 2584532 SECOND), (@d0 + INTERVAL 2578623 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2584861 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2584861 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 418;
CALL seed_claim(417, (@d0 + INTERVAL 2585503 SECOND), 2);
CALL seed_claim(418, (@d0 + INTERVAL 2585890 SECOND), 2);
CALL seed_claim(414, (@d0 + INTERVAL 2586777 SECOND), 2);
CALL seed_claim(413, (@d0 + INTERVAL 2587281 SECOND), 2);
CALL seed_trip('[418, 417, 414]', (@d0 + INTERVAL 2587428 SECOND), NULL, 54.0);
CALL seed_trip('[413]', (@d0 + INTERVAL 2588730 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 421, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 6.92, 'HOT_HELD', (@d0 + INTERVAL 2639600 SECOND), (@d0 + INTERVAL 2642991 SECOND), (@d0 + INTERVAL 2639600 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2643623 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2643623 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 421;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 420, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 8.43, 'AMBIENT', (@d0 + INTERVAL 2639352 SECOND), (@d0 + INTERVAL 2643538 SECOND), (@d0 + INTERVAL 2639352 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2644022 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2644022 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 420;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 424, 3, 1, 5, 'LUNCH', 'Steamed rice (lunch leftover)', 6.02, 'CHILLED', (@d0 + INTERVAL 2638430 SECOND), (@d0 + INTERVAL 2644184 SECOND), (@d0 + INTERVAL 2638430 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2644533 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2644533 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 424;
CALL seed_claim(421, (@d0 + INTERVAL 2644581 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 419, 1, 1, 3, 'LUNCH', 'Dal tadka (lunch leftover)', 13.70, 'HOT_HELD', (@d0 + INTERVAL 2638065 SECOND), (@d0 + INTERVAL 2644498 SECOND), (@d0 + INTERVAL 2638065 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2644906 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2644906 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 419;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 423, 3, 1, 5, 'LUNCH', 'Veg biryani (lunch leftover)', 6.13, 'HOT_HELD', (@d0 + INTERVAL 2638144 SECOND), (@d0 + INTERVAL 2644569 SECOND), (@d0 + INTERVAL 2638144 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2644942 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2644942 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 423;
CALL seed_claim(424, (@d0 + INTERVAL 2645323 SECOND), 1);
CALL seed_claim(420, (@d0 + INTERVAL 2645389 SECOND), 1);
CALL seed_claim(419, (@d0 + INTERVAL 2645524 SECOND), 1);
CALL seed_trip('[421, 424, 419]', (@d0 + INTERVAL 2646512 SECOND), NULL, 54.0);
CALL seed_trip('[420]', (@d0 + INTERVAL 2646827 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 422, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 6.39, 'HOT_HELD', (@d0 + INTERVAL 2665404 SECOND), (@d0 + INTERVAL 2670107 SECOND), (@d0 + INTERVAL 2665404 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2670596 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2670596 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 422;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 427, 3, 1, 5, 'LUNCH', 'Steamed rice (lunch leftover)', 6.46, 'HOT_HELD', (@d0 + INTERVAL 2725068 SECOND), (@d0 + INTERVAL 2730044 SECOND), (@d0 + INTERVAL 2725068 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2730487 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2730487 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 427;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 428, 5, 1, 7, 'LUNCH', 'Sambar rice (lunch leftover)', 6.05, 'HOT_HELD', (@d0 + INTERVAL 2725985 SECOND), (@d0 + INTERVAL 2730599 SECOND), (@d0 + INTERVAL 2725985 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2731009 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2731009 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 428;
CALL seed_claim(427, (@d0 + INTERVAL 2731341 SECOND), 1);
CALL seed_claim(428, (@d0 + INTERVAL 2732071 SECOND), 1);
CALL seed_trip('[427, 428]', (@d0 + INTERVAL 2733464 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 425, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 7.02, 'HOT_HELD', (@d0 + INTERVAL 2751131 SECOND), (@d0 + INTERVAL 2756820 SECOND), (@d0 + INTERVAL 2751131 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2757341 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2757341 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 425;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 426, 2, 1, 4, 'DINNER', 'Sambar rice (dinner leftover)', 6.04, 'HOT_HELD', (@d0 + INTERVAL 2752661 SECOND), (@d0 + INTERVAL 2757320 SECOND), (@d0 + INTERVAL 2752661 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2757839 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2757839 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 426;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 429, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.49, 'AMBIENT', (@d0 + INTERVAL 2796027 SECOND), (@d0 + INTERVAL 2800667 SECOND), (@d0 + INTERVAL 2796027 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2801015 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2801015 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 429;
CALL seed_claim(429, (@d0 + INTERVAL 2802511 SECOND), 1);
CALL seed_trip('[429]', (@d0 + INTERVAL 2803198 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 432, 5, 1, 7, 'LUNCH', 'Dal tadka (lunch leftover)', 6.10, 'CHILLED', (@d0 + INTERVAL 2810883 SECOND), (@d0 + INTERVAL 2815770 SECOND), (@d0 + INTERVAL 2810883 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2816412 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2816412 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 432;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 430, 1, 1, 3, 'LUNCH', 'Curd rice (lunch leftover)', 7.00, 'CHILLED', (@d0 + INTERVAL 2811861 SECOND), (@d0 + INTERVAL 2816532 SECOND), (@d0 + INTERVAL 2811861 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2817226 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2817226 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 430;
CALL seed_claim(430, (@d0 + INTERVAL 2817860 SECOND), 2);
CALL seed_claim(432, (@d0 + INTERVAL 2818407 SECOND), 1);
CALL seed_trip('[430, 432]', (@d0 + INTERVAL 2819147 SECOND), 430, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 431, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 11.68, 'HOT_HELD', (@d0 + INTERVAL 2838831 SECOND), (@d0 + INTERVAL 2843759 SECOND), (@d0 + INTERVAL 2838831 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2844400 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2844400 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 431;
CALL seed_claim(431, (@d0 + INTERVAL 2845451 SECOND), 1);
CALL seed_trip('[431]', (@d0 + INTERVAL 2846700 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 447, 3, 5, 5, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.05, 'HOT_HELD', (@d0 + INTERVAL 2882189 SECOND), (@d0 + INTERVAL 2886399 SECOND), (@d0 + INTERVAL 2882189 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2887077 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2887077 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 447;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 434, 1, 5, 3, 'BREAKFAST', 'Upma (breakfast leftover)', 6.22, 'HOT_HELD', (@d0 + INTERVAL 2882124 SECOND), (@d0 + INTERVAL 2886501 SECOND), (@d0 + INTERVAL 2882124 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2887152 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2887152 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 434;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 433, 1, 5, 3, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.66, 'CHILLED', (@d0 + INTERVAL 2881335 SECOND), (@d0 + INTERVAL 2886718 SECOND), (@d0 + INTERVAL 2881335 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2887226 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2887226 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 433;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 454, 5, 5, 7, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 6.92, 'HOT_HELD', (@d0 + INTERVAL 2882140 SECOND), (@d0 + INTERVAL 2886784 SECOND), (@d0 + INTERVAL 2882140 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2887329 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2887329 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 454;
CALL seed_claim(434, (@d0 + INTERVAL 2887613 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 446, 3, 5, 5, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.82, 'HOT_HELD', (@d0 + INTERVAL 2881611 SECOND), (@d0 + INTERVAL 2887707 SECOND), (@d0 + INTERVAL 2881611 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2887966 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2887966 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 446;
CALL seed_claim(447, (@d0 + INTERVAL 2888319 SECOND), 1);
CALL seed_claim(454, (@d0 + INTERVAL 2888346 SECOND), 1);
CALL seed_claim(446, (@d0 + INTERVAL 2888548 SECOND), 1);
CALL seed_trip('[434, 454]', (@d0 + INTERVAL 2889483 SECOND), 434, 54.0);
CALL seed_claim(433, (@d0 + INTERVAL 2889559 SECOND), 1);
CALL seed_trip('[447, 446, 433]', (@d0 + INTERVAL 2890899 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 443, 2, 4, 4, 'LUNCH', 'Chapati (lunch leftover)', 9.55, 'AMBIENT', (@d0 + INTERVAL 2897100 SECOND), (@d0 + INTERVAL 2901843 SECOND), (@d0 + INTERVAL 2897100 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2902138 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2902138 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 443;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 441, 2, 3, 4, 'LUNCH', 'Egg curry (lunch leftover)', 8.86, 'HOT_HELD', (@d0 + INTERVAL 2898070 SECOND), (@d0 + INTERVAL 2902070 SECOND), (@d0 + INTERVAL 2898070 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2902415 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2902415 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 441;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 449, 3, 1, 5, 'LUNCH', 'Curd rice (lunch leftover)', 9.86, 'HOT_HELD', (@d0 + INTERVAL 2898133 SECOND), (@d0 + INTERVAL 2902461 SECOND), (@d0 + INTERVAL 2898133 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903131 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903131 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 449;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 455, 5, 1, 7, 'LUNCH', 'Curd rice (lunch leftover)', 8.71, 'AMBIENT', (@d0 + INTERVAL 2897351 SECOND), (@d0 + INTERVAL 2902796 SECOND), (@d0 + INTERVAL 2897351 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903224 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903224 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 455;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 459, 6, 1, 8, 'LUNCH', 'Sambar rice (lunch leftover)', 7.38, 'HOT_HELD', (@d0 + INTERVAL 2898633 SECOND), (@d0 + INTERVAL 2903238 SECOND), (@d0 + INTERVAL 2898633 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903491 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903491 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 459;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 448, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 12.98, 'CHILLED', (@d0 + INTERVAL 2898894 SECOND), (@d0 + INTERVAL 2903102 SECOND), (@d0 + INTERVAL 2898894 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903608 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903608 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 448;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 435, 1, 2, 3, 'LUNCH', 'Vegetable kurma (lunch leftover)', 12.96, 'AMBIENT', (@d0 + INTERVAL 2898585 SECOND), (@d0 + INTERVAL 2903261 SECOND), (@d0 + INTERVAL 2898585 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903688 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903688 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 435;
CALL seed_claim(443, (@d0 + INTERVAL 2903826 SECOND), 2);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 437, 1, 1, 3, 'LUNCH', 'Veg biryani (lunch leftover)', 21.12, 'CHILLED', (@d0 + INTERVAL 2897230 SECOND), (@d0 + INTERVAL 2903335 SECOND), (@d0 + INTERVAL 2897230 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903982 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903982 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 437;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 450, 3, 1, 5, 'LUNCH', 'Steamed rice (lunch leftover)', 6.52, 'CHILLED', (@d0 + INTERVAL 2897426 SECOND), (@d0 + INTERVAL 2903281 SECOND), (@d0 + INTERVAL 2897426 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2903997 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2903997 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 450;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 442, 2, 2, 4, 'LUNCH', 'Vegetable kurma (lunch leftover)', 8.93, 'HOT_HELD', (@d0 + INTERVAL 2898522 SECOND), (@d0 + INTERVAL 2903496 SECOND), (@d0 + INTERVAL 2898522 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2904133 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2904133 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 442;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 436, 1, 4, 3, 'LUNCH', 'Chapati (lunch leftover)', 7.10, 'AMBIENT', (@d0 + INTERVAL 2898882 SECOND), (@d0 + INTERVAL 2903565 SECOND), (@d0 + INTERVAL 2898882 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2904135 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2904135 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 436;
CALL seed_claim(455, (@d0 + INTERVAL 2904172 SECOND), 1);
CALL seed_claim(449, (@d0 + INTERVAL 2904257 SECOND), 1);
CALL seed_claim(435, (@d0 + INTERVAL 2904331 SECOND), 1);
CALL seed_claim(437, (@d0 + INTERVAL 2904589 SECOND), 2);
CALL seed_claim(459, (@d0 + INTERVAL 2904806 SECOND), 1);
CALL seed_claim(450, (@d0 + INTERVAL 2904806 SECOND), 1);
CALL seed_claim(448, (@d0 + INTERVAL 2904818 SECOND), 1);
CALL seed_claim(441, (@d0 + INTERVAL 2904925 SECOND), 1);
CALL seed_claim(436, (@d0 + INTERVAL 2905019 SECOND), 1);
CALL seed_claim(442, (@d0 + INTERVAL 2905048 SECOND), 2);
CALL seed_trip('[449, 435, 443]', (@d0 + INTERVAL 2905279 SECOND), NULL, 54.0);
CALL seed_trip('[455, 448, 437]', (@d0 + INTERVAL 2905639 SECOND), NULL, 54.0);
CALL seed_trip('[450, 459, 442]', (@d0 + INTERVAL 2906095 SECOND), NULL, 54.0);
CALL seed_trip('[436]', (@d0 + INTERVAL 2906124 SECOND), NULL, 54.0);
CALL seed_cancel(441, (@d0 + INTERVAL 2906884 SECOND), 'no transport available');
CALL seed_claim(441, (@d0 + INTERVAL 2907616 SECOND), 1);
CALL seed_trip('[441]', (@d0 + INTERVAL 2908307 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 453, 3, 1, 5, 'DINNER', 'Dal tadka (dinner leftover)', 7.34, 'AMBIENT', (@d0 + INTERVAL 2924215 SECOND), (@d0 + INTERVAL 2928839 SECOND), (@d0 + INTERVAL 2924215 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2929103 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2929103 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 453;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 456, 5, 3, 7, 'DINNER', 'Chicken curry (dinner leftover)', 6.79, 'HOT_HELD', (@d0 + INTERVAL 2924026 SECOND), (@d0 + INTERVAL 2929583 SECOND), (@d0 + INTERVAL 2924026 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2929851 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2929851 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 456;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 438, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 19.19, 'CHILLED', (@d0 + INTERVAL 2924313 SECOND), (@d0 + INTERVAL 2929439 SECOND), (@d0 + INTERVAL 2924313 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930080 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930080 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 438;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 451, 3, 7, 5, 'DINNER', 'Semiya payasam (dinner leftover)', 6.90, 'CHILLED', (@d0 + INTERVAL 2924446 SECOND), (@d0 + INTERVAL 2929545 SECOND), (@d0 + INTERVAL 2924446 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930123 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930123 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 451;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 444, 2, 1, 4, 'DINNER', 'Steamed rice (dinner leftover)', 6.62, 'HOT_HELD', (@d0 + INTERVAL 2925647 SECOND), (@d0 + INTERVAL 2929895 SECOND), (@d0 + INTERVAL 2925647 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930231 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930231 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 444;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 452, 3, 1, 5, 'DINNER', 'Steamed rice (dinner leftover)', 10.66, 'HOT_HELD', (@d0 + INTERVAL 2924363 SECOND), (@d0 + INTERVAL 2929680 SECOND), (@d0 + INTERVAL 2924363 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930242 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930242 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 452;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 440, 1, 7, 3, 'DINNER', 'Gulab jamun (dinner leftover)', 6.01, 'CHILLED', (@d0 + INTERVAL 2925723 SECOND), (@d0 + INTERVAL 2929738 SECOND), (@d0 + INTERVAL 2925723 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930342 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930342 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag) t WHERE batch_id = 440;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 445, 2, 1, 4, 'DINNER', 'Sambar rice (dinner leftover)', 6.74, 'AMBIENT', (@d0 + INTERVAL 2924355 SECOND), (@d0 + INTERVAL 2930230 SECOND), (@d0 + INTERVAL 2924355 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930620 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930620 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 445;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 439, 1, 1, 3, 'DINNER', 'Dal tadka (dinner leftover)', 18.98, 'HOT_HELD', (@d0 + INTERVAL 2924986 SECOND), (@d0 + INTERVAL 2930377 SECOND), (@d0 + INTERVAL 2924986 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2930810 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2930810 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 439;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 458, 5, 2, 7, 'DINNER', 'Vegetable kurma (dinner leftover)', 7.80, 'CHILLED', (@d0 + INTERVAL 2924146 SECOND), (@d0 + INTERVAL 2930514 SECOND), (@d0 + INTERVAL 2924146 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2931106 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2931106 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 458;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 457, 5, 2, 7, 'DINNER', 'Aloo gobi (dinner leftover)', 10.11, 'CHILLED', (@d0 + INTERVAL 2925760 SECOND), (@d0 + INTERVAL 2930708 SECOND), (@d0 + INTERVAL 2925760 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2931247 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2931247 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 457;
CALL seed_claim(438, (@d0 + INTERVAL 2931525 SECOND), 1);
CALL seed_claim(453, (@d0 + INTERVAL 2931956 SECOND), 1);
CALL seed_trip('[438]', (@d0 + INTERVAL 2932810 SECOND), NULL, 54.0);
CALL seed_cancel(453, (@d0 + INTERVAL 2933673 SECOND), 'no transport available');
CALL seed_claim(453, (@d0 + INTERVAL 2934272 SECOND), 1);
CALL seed_claim(445, (@d0 + INTERVAL 2934434 SECOND), 2);
CALL seed_trip('[445, 453]', (@d0 + INTERVAL 2935506 SECOND), NULL, 54.0);
CALL seed_claim(451, (@d0 + INTERVAL 2964755 SECOND), 1);
CALL seed_trip('[451]', (@d0 + INTERVAL 2965493 SECOND), NULL, 54.0);
CALL seed_claim(458, (@d0 + INTERVAL 2966357 SECOND), 2);
CALL seed_claim(440, (@d0 + INTERVAL 2966570 SECOND), 1);
CALL seed_trip('[458]', (@d0 + INTERVAL 2967489 SECOND), NULL, 54.0);
CALL seed_trip('[440]', (@d0 + INTERVAL 2968037 SECOND), NULL, 54.0);
CALL seed_claim(457, (@d0 + INTERVAL 2968102 SECOND), 1);
CALL seed_trip('[457]', (@d0 + INTERVAL 2969601 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 468, 2, 5, 4, 'BREAKFAST', 'Pongal (breakfast leftover)', 7.83, 'HOT_HELD', (@d0 + INTERVAL 2967495 SECOND), (@d0 + INTERVAL 2971663 SECOND), (@d0 + INTERVAL 2967495 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2972362 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2972362 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 468;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 473, 3, 4, 5, 'BREAKFAST', 'Bread omelette (breakfast leftover)', 6.11, 'AMBIENT', (@d0 + INTERVAL 2968743 SECOND), (@d0 + INTERVAL 2972506 SECOND), (@d0 + INTERVAL 2968743 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2972970 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2972970 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 473;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 467, 2, 5, 4, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 7.03, 'HOT_HELD', (@d0 + INTERVAL 2967308 SECOND), (@d0 + INTERVAL 2973302 SECOND), (@d0 + INTERVAL 2967308 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2973571 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2973571 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 467;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 460, 1, 5, 3, 'BREAKFAST', 'Masala dosa (breakfast leftover)', 9.63, 'HOT_HELD', (@d0 + INTERVAL 2967244 SECOND), (@d0 + INTERVAL 2973033 SECOND), (@d0 + INTERVAL 2967244 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2973616 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2973616 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 460;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 480, 5, 5, 7, 'BREAKFAST', 'Idli with sambar (breakfast leftover)', 6.99, 'CHILLED', (@d0 + INTERVAL 2967195 SECOND), (@d0 + INTERVAL 2973316 SECOND), (@d0 + INTERVAL 2967195 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2973666 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2973666 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 480;
CALL seed_claim(468, (@d0 + INTERVAL 2973750 SECOND), 1);
CALL seed_claim(473, (@d0 + INTERVAL 2973853 SECOND), 1);
CALL seed_claim(480, (@d0 + INTERVAL 2974200 SECOND), 1);
CALL seed_claim(467, (@d0 + INTERVAL 2974305 SECOND), 1);
CALL seed_trip('[468]', (@d0 + INTERVAL 2974388 SECOND), NULL, 54.0);
CALL seed_claim(460, (@d0 + INTERVAL 2975114 SECOND), 1);
CALL seed_trip('[480, 473, 467]', (@d0 + INTERVAL 2975142 SECOND), 480, 54.0);
CALL seed_trip('[460]', (@d0 + INTERVAL 2976503 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 475, 3, 1, 5, 'LUNCH', 'Sambar rice (lunch leftover)', 12.35, 'CHILLED', (@d0 + INTERVAL 2983718 SECOND), (@d0 + INTERVAL 2987960 SECOND), (@d0 + INTERVAL 2983718 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2988575 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2988575 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 475;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 474, 3, 1, 5, 'LUNCH', 'Veg biryani (lunch leftover)', 9.79, 'AMBIENT', (@d0 + INTERVAL 2984751 SECOND), (@d0 + INTERVAL 2988515 SECOND), (@d0 + INTERVAL 2984751 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2988801 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2988801 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 474;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 481, 5, 3, 7, 'LUNCH', 'Egg curry (lunch leftover)', 6.15, 'HOT_HELD', (@d0 + INTERVAL 2983441 SECOND), (@d0 + INTERVAL 2988425 SECOND), (@d0 + INTERVAL 2983441 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2989096 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2989096 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 481;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 461, 1, 7, 3, 'LUNCH', 'Semiya payasam (lunch leftover)', 12.92, 'CHILLED', (@d0 + INTERVAL 2984507 SECOND), (@d0 + INTERVAL 2988477 SECOND), (@d0 + INTERVAL 2984507 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2989169 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2989169 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 461;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 462, 1, 8, 3, 'LUNCH', 'Fruit salad (lunch leftover)', 8.51, 'CHILLED', (@d0 + INTERVAL 2983325 SECOND), (@d0 + INTERVAL 2989009 SECOND), (@d0 + INTERVAL 2983325 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2989404 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2989404 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 462;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 469, 2, 3, 4, 'LUNCH', 'Chicken curry (lunch leftover)', 8.57, 'HOT_HELD', (@d0 + INTERVAL 2984711 SECOND), (@d0 + INTERVAL 2988905 SECOND), (@d0 + INTERVAL 2984711 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2989609 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2989609 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 469;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 463, 1, 1, 3, 'LUNCH', 'Dal tadka (lunch leftover)', 15.88, 'CHILLED', (@d0 + INTERVAL 2983603 SECOND), (@d0 + INTERVAL 2989100 SECOND), (@d0 + INTERVAL 2983603 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2989764 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2989764 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 463;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 482, 5, 1, 7, 'LUNCH', 'Dal tadka (lunch leftover)', 10.11, 'HOT_HELD', (@d0 + INTERVAL 2983880 SECOND), (@d0 + INTERVAL 2989575 SECOND), (@d0 + INTERVAL 2983880 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2989865 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2989865 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 482;
CALL seed_claim(475, (@d0 + INTERVAL 2989899 SECOND), 1);
CALL seed_claim(481, (@d0 + INTERVAL 2989942 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 470, 2, 2, 4, 'LUNCH', 'Aloo gobi (lunch leftover)', 7.03, 'HOT_HELD', (@d0 + INTERVAL 2984740 SECOND), (@d0 + INTERVAL 2989356 SECOND), (@d0 + INTERVAL 2984740 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2990003 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2990003 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 470;
CALL seed_claim(461, (@d0 + INTERVAL 2990110 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 479, 4, 1, 6, 'LUNCH', 'Dal tadka (lunch leftover)', 7.44, 'HOT_HELD', (@d0 + INTERVAL 2985146 SECOND), (@d0 + INTERVAL 2989852 SECOND), (@d0 + INTERVAL 2985146 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 2990217 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 2990217 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 479;
CALL seed_claim(463, (@d0 + INTERVAL 2990276 SECOND), 2);
CALL seed_claim(469, (@d0 + INTERVAL 2990555 SECOND), 1);
CALL seed_claim(482, (@d0 + INTERVAL 2990708 SECOND), 2);
CALL seed_claim(462, (@d0 + INTERVAL 2990727 SECOND), 2);
CALL seed_claim(470, (@d0 + INTERVAL 2990897 SECOND), 1);
CALL seed_trip('[475, 481, 463]', (@d0 + INTERVAL 2991105 SECOND), NULL, 54.0);
CALL seed_claim(479, (@d0 + INTERVAL 2991230 SECOND), 1);
CALL seed_cancel(461, (@d0 + INTERVAL 2991315 SECOND), 'no transport available');
CALL seed_trip('[470]', (@d0 + INTERVAL 2991657 SECOND), NULL, 54.0);
CALL seed_claim(461, (@d0 + INTERVAL 2992019 SECOND), 1);
CALL seed_trip('[469, 479]', (@d0 + INTERVAL 2992037 SECOND), NULL, 54.0);
CALL seed_cancel(462, (@d0 + INTERVAL 2992258 SECOND), 'no transport available');
CALL seed_cancel(482, (@d0 + INTERVAL 2992635 SECOND), 'no transport available');
CALL seed_claim(462, (@d0 + INTERVAL 2992980 SECOND), 1);
CALL seed_claim(482, (@d0 + INTERVAL 2993241 SECOND), 1);
CALL seed_trip('[461, 462]', (@d0 + INTERVAL 2993730 SECOND), NULL, 54.0);
CALL seed_trip('[482]', (@d0 + INTERVAL 2994094 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 472, 2, 1, 4, 'DINNER', 'Veg biryani (dinner leftover)', 12.87, 'HOT_HELD', (@d0 + INTERVAL 3011689 SECOND), (@d0 + INTERVAL 3015356 SECOND), (@d0 + INTERVAL 3011689 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3015603 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3015603 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 472;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 477, 3, 7, 5, 'DINNER', 'Semiya payasam (dinner leftover)', 8.06, 'CHILLED', (@d0 + INTERVAL 3010897 SECOND), (@d0 + INTERVAL 3015653 SECOND), (@d0 + INTERVAL 3010897 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3015923 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3015923 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 477;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 483, 5, 7, 7, 'DINNER', 'Semiya payasam (dinner leftover)', 6.54, 'CHILLED', (@d0 + INTERVAL 3010221 SECOND), (@d0 + INTERVAL 3015540 SECOND), (@d0 + INTERVAL 3010221 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016140 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016140 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 483;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 464, 1, 2, 3, 'DINNER', 'Vegetable kurma (dinner leftover)', 11.18, 'AMBIENT', (@d0 + INTERVAL 3011188 SECOND), (@d0 + INTERVAL 3016073 SECOND), (@d0 + INTERVAL 3011188 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016431 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016431 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 464;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 466, 1, 4, 3, 'DINNER', 'Chapati (dinner leftover)', 8.07, 'AMBIENT', (@d0 + INTERVAL 3012173 SECOND), (@d0 + INTERVAL 3016014 SECOND), (@d0 + INTERVAL 3012173 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016550 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016550 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag) t WHERE batch_id = 466;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 485, 6, 1, 8, 'DINNER', 'Dal tadka (dinner leftover)', 8.26, 'HOT_HELD', (@d0 + INTERVAL 3010870 SECOND), (@d0 + INTERVAL 3016309 SECOND), (@d0 + INTERVAL 3010870 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016647 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016647 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 485;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 478, 3, 4, 5, 'DINNER', 'Parotta (dinner leftover)', 13.00, 'AMBIENT', (@d0 + INTERVAL 3011470 SECOND), (@d0 + INTERVAL 3016444 SECOND), (@d0 + INTERVAL 3011470 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016798 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016798 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_EGG' AS tag) t WHERE batch_id = 478;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 476, 3, 3, 5, 'DINNER', 'Chicken curry (dinner leftover)', 9.07, 'HOT_HELD', (@d0 + INTERVAL 3010628 SECOND), (@d0 + INTERVAL 3016179 SECOND), (@d0 + INTERVAL 3010628 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016846 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016846 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'NON_VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 476;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 471, 2, 3, 4, 'DINNER', 'Egg curry (dinner leftover)', 11.91, 'HOT_HELD', (@d0 + INTERVAL 3010302 SECOND), (@d0 + INTERVAL 3016491 SECOND), (@d0 + INTERVAL 3010302 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016888 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016888 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'CONTAINS_EGG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 471;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 484, 5, 1, 7, 'DINNER', 'Sambar rice (dinner leftover)', 6.87, 'HOT_HELD', (@d0 + INTERVAL 3012056 SECOND), (@d0 + INTERVAL 3016498 SECOND), (@d0 + INTERVAL 3012056 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3016934 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3016934 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 484;
CALL seed_claim(483, (@d0 + INTERVAL 3017429 SECOND), 1);
CALL seed_claim(472, (@d0 + INTERVAL 3017468 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 465, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 19.24, 'CHILLED', (@d0 + INTERVAL 3010700 SECOND), (@d0 + INTERVAL 3017140 SECOND), (@d0 + INTERVAL 3010700 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3017513 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3017513 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 465;
CALL seed_trip('[483, 472]', (@d0 + INTERVAL 3018380 SECOND), NULL, 54.0);
CALL seed_claim(478, (@d0 + INTERVAL 3018825 SECOND), 1);
CALL seed_claim(477, (@d0 + INTERVAL 3018890 SECOND), 2);
CALL seed_claim(471, (@d0 + INTERVAL 3019252 SECOND), 1);
CALL seed_claim(484, (@d0 + INTERVAL 3019292 SECOND), 1);
CALL seed_trip('[471]', (@d0 + INTERVAL 3020018 SECOND), NULL, 54.0);
CALL seed_claim(464, (@d0 + INTERVAL 3020198 SECOND), 2);
CALL seed_claim(465, (@d0 + INTERVAL 3020214 SECOND), 1);
CALL seed_trip('[477, 478, 484]', (@d0 + INTERVAL 3020259 SECOND), NULL, 54.0);
CALL seed_trip('[464, 465]', (@d0 + INTERVAL 3020998 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 490, 5, 1, 7, 'LUNCH', 'Veg biryani (lunch leftover)', 7.32, 'CHILLED', (@d0 + INTERVAL 3069689 SECOND), (@d0 + INTERVAL 3075924 SECOND), (@d0 + INTERVAL 3069689 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3076466 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3076466 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 490;
CALL seed_claim(490, (@d0 + INTERVAL 3076745 SECOND), 1);
CALL seed_trip('[490]', (@d0 + INTERVAL 3077822 SECOND), NULL, 54.0);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 489, 2, 2, 4, 'DINNER', 'Paneer butter masala (dinner leftover)', 6.17, 'HOT_HELD', (@d0 + INTERVAL 3097869 SECOND), (@d0 + INTERVAL 3101832 SECOND), (@d0 + INTERVAL 3097869 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3102542 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3102542 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_DAIRY' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 489;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 486, 1, 1, 3, 'DINNER', 'Veg biryani (dinner leftover)', 8.74, 'CHILLED', (@d0 + INTERVAL 3096759 SECOND), (@d0 + INTERVAL 3102234 SECOND), (@d0 + INTERVAL 3096759 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3102907 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3102907 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'SPICY' AS tag) t WHERE batch_id = 486;
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 488, 1, 1, 3, 'DINNER', 'Dal tadka (dinner leftover)', 8.90, 'HOT_HELD', (@d0 + INTERVAL 3098387 SECOND), (@d0 + INTERVAL 3102431 SECOND), (@d0 + INTERVAL 3098387 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3102983 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3102983 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag) t WHERE batch_id = 488;
CALL seed_claim(489, (@d0 + INTERVAL 3103777 SECOND), 1);
INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) SELECT 487, 1, 2, 3, 'DINNER', 'Vegetable kurma (dinner leftover)', 6.15, 'HOT_HELD', (@d0 + INTERVAL 3098266 SECOND), (@d0 + INTERVAL 3103456 SECOND), (@d0 + INTERVAL 3098266 SECOND) + INTERVAL 1 SECOND, (@d0 + INTERVAL 3103786 SECOND) FROM DUAL WHERE (@d0 + INTERVAL 3103786 SECOND) < CURRENT_DATE;
INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (SELECT 'VEG' AS tag UNION ALL SELECT 'CONTAINS_ONION_GARLIC' AS tag UNION ALL SELECT 'CONTAINS_NUTS' AS tag) t WHERE batch_id = 487;
CALL seed_claim(488, (@d0 + INTERVAL 3104834 SECOND), 1);
CALL seed_claim(486, (@d0 + INTERVAL 3105526 SECOND), 1);
CALL seed_trip('[489, 488]', (@d0 + INTERVAL 3106041 SECOND), NULL, 54.0);
CALL seed_claim(487, (@d0 + INTERVAL 3106207 SECOND), 1);
CALL seed_trip('[487, 486]', (@d0 + INTERVAL 3107009 SECOND), NULL, 54.0);

-- history must end before today: drop meal logs for today or later (menus cascade)
DELETE FROM mess_meal_log WHERE service_date >= CURRENT_DATE;

-- forecasts for the 14 days before today (no alerts), used to measure forecast accuracy
CALL seed_forecast(@d0 + INTERVAL 22 DAY);
CALL seed_forecast(@d0 + INTERVAL 23 DAY);
CALL seed_forecast(@d0 + INTERVAL 24 DAY);
CALL seed_forecast(@d0 + INTERVAL 25 DAY);
CALL seed_forecast(@d0 + INTERVAL 26 DAY);
CALL seed_forecast(@d0 + INTERVAL 27 DAY);
CALL seed_forecast(@d0 + INTERVAL 28 DAY);
CALL seed_forecast(@d0 + INTERVAL 29 DAY);
CALL seed_forecast(@d0 + INTERVAL 30 DAY);
CALL seed_forecast(@d0 + INTERVAL 31 DAY);
CALL seed_forecast(@d0 + INTERVAL 32 DAY);
CALL seed_forecast(@d0 + INTERVAL 33 DAY);
CALL seed_forecast(@d0 + INTERVAL 34 DAY);
CALL seed_forecast(@d0 + INTERVAL 35 DAY);

-- history is over: everything nobody could take in time expires now
CALL sp_expire_batches();

DROP PROCEDURE seed_claim;
DROP PROCEDURE seed_forecast;
DROP PROCEDURE seed_cancel;
DROP PROCEDURE seed_trip;

-- ---------- LIVE 'TODAY': created through the real application procedures ----------
-- Four fresh batches (posted minutes ago) for the live feed and the race demo.
CALL sp_post_batch(3, 1, 'LUNCH', 'SYN Sambar rice (live demo)', 24.00, 'HOT_HELD',
                   NOW() - INTERVAL 70 MINUTE, NOW() - INTERVAL 10 MINUTE, '["VEG","CONTAINS_ONION_GARLIC"]', @live1);
CALL sp_post_batch(4, 2, 'LUNCH', 'SYN Vegetable kurma (live demo)', 12.50, 'HOT_HELD',
                   NOW() - INTERVAL 60 MINUTE, NOW() - INTERVAL 8 MINUTE, '["VEG","CONTAINS_ONION_GARLIC","CONTAINS_NUTS"]', @live2);
CALL sp_post_batch(5, 3, 'LUNCH', 'SYN Chicken curry (live demo)', 9.00, 'CHILLED',
                   NOW() - INTERVAL 90 MINUTE, NOW() - INTERVAL 20 MINUTE, '["NON_VEG","CONTAINS_ONION_GARLIC","SPICY"]', @live3);
CALL sp_post_batch(7, 4, 'LUNCH', 'SYN Chapati (live demo)', 6.00, 'AMBIENT',
                   NOW() - INTERVAL 45 MINUTE, NOW() - INTERVAL 5 MINUTE, '["VEG"]', @live4);
-- Two more that are already claimed, one of them already on the road.
CALL sp_post_batch(6, 1, 'LUNCH', 'SYN Curd rice (live demo)', 15.00, 'CHILLED',
                   NOW() - INTERVAL 80 MINUTE, NOW() - INTERVAL 30 MINUTE, '["VEG","CONTAINS_DAIRY"]', @live5);
CALL sp_post_batch(8, 1, 'LUNCH', 'SYN Veg biryani (live demo)', 18.00, 'HOT_HELD',
                   NOW() - INTERVAL 75 MINUTE, NOW() - INTERVAL 25 MINUTE, '["VEG","CONTAINS_ONION_GARLIC","SPICY"]', @live6);
CALL sp_claim_batch(15, @live5, @c5, @r5);     -- user 15 = staff of shelter 13
CALL sp_claim_batch(9,  @live6, @c6, @r6);     -- user 9  = staff of shelter 7
SELECT @r5 AS live_claim_5, @r6 AS live_claim_6;
CALL sp_create_trip(20, JSON_ARRAY(@c6), NOW(), @live_trip);   -- user 20 = SYN Volunteer Bhavya
CALL sp_record_pickup(20, @live_trip, 1, 67.5);
-- Pre-alerts for tomorrow
CALL sp_generate_forecast(CURRENT_DATE + INTERVAL 1 DAY, TRUE);

