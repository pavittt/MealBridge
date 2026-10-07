-- =====================================================================
-- MealBridge : ROLE-BASED ACCESS CONTROL (MySQL 8 roles)  Stage 5 deliverable
-- Run after the schema, procedures and views exist.
--
-- Reading guide for the viva:
--   * A ROLE is a named bundle of privileges. A USER (login) is granted
--     a role, and SET DEFAULT ROLE makes it active when the user logs in.
--     Changing what "a shelter" may do is then one GRANT/REVOKE on the
--     role, not one per login.
--   * Principle of least privilege:
--       - end-user roles get SELECT only on what their screens show;
--       - every WRITE goes through a SQL SECURITY DEFINER procedure
--         (EXECUTE privilege), never a direct INSERT/UPDATE, so business
--         rules, locking and ownership checks cannot be skipped;
--       - where a direct write is allowed it is COLUMN-level
--         (e.g. a shelter may update meals_needed but not reserved_kg).
--   * Nobody, not even the platform admin role, can UPDATE or DELETE
--     custody_event or audit_log. (The custody triggers also refuse
--     root, so this is two independent layers.)
--   * Limitation to state honestly: MySQL has no row-level security.
--     "A shelter sees and changes only ITS OWN rows" is enforced inside
--     the procedures, which check p_user_id's role and site. The web API
--     connects with one login per role and passes the authenticated
--     user's id; end users never get database logins.
--
-- The four demo logins below use DEMO passwords. Change them before any
-- real deployment (ALTER USER ... IDENTIFIED BY ...).
-- =====================================================================
USE mealbridge;
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;  -- also when run on its own; see 01_schema.sql

DROP USER IF EXISTS 'mb_mess_admin'@'localhost', 'mb_shelter'@'localhost',
                    'mb_volunteer'@'localhost', 'mb_platform_admin'@'localhost',
                    'mb_auth'@'localhost', 'mb_public'@'localhost';
DROP ROLE IF EXISTS 'r_mess_admin', 'r_shelter', 'r_volunteer', 'r_platform_admin',
                    'r_auth', 'r_public';

CREATE ROLE 'r_mess_admin', 'r_shelter', 'r_volunteer', 'r_platform_admin';
-- Stage 6 (web app): two tiny service roles, see the end of this file
CREATE ROLE 'r_auth', 'r_public';

-- ---------------------------------------------------------------------
-- MESS ADMIN : posts surplus, logs meals, follows its batches.
-- Blocked from: claiming, shelter capacity data, volunteer data,
-- audit log, scoring policy, password hashes.
-- ---------------------------------------------------------------------
GRANT SELECT ON mealbridge.campus          TO 'r_mess_admin';
GRANT SELECT ON mealbridge.site            TO 'r_mess_admin';
GRANT SELECT ON mealbridge.mess            TO 'r_mess_admin';
GRANT SELECT ON mealbridge.food_category   TO 'r_mess_admin';
GRANT SELECT ON mealbridge.diet_tag        TO 'r_mess_admin';
GRANT SELECT ON mealbridge.menu_item       TO 'r_mess_admin';
GRANT SELECT ON mealbridge.surplus_batch   TO 'r_mess_admin';
GRANT SELECT ON mealbridge.batch_diet_tag  TO 'r_mess_admin';
GRANT SELECT ON mealbridge.claim           TO 'r_mess_admin';
GRANT SELECT ON mealbridge.custody_event   TO 'r_mess_admin';
GRANT SELECT ON mealbridge.surplus_forecast TO 'r_mess_admin';
-- the mess's own forecasting inputs: direct writes are harmless here
GRANT SELECT, INSERT, UPDATE         ON mealbridge.mess_meal_log TO 'r_mess_admin';
GRANT SELECT, INSERT, UPDATE, DELETE ON mealbridge.mess_menu     TO 'r_mess_admin';
-- who claimed my food: names only, never e-mail, phone or password hash
GRANT SELECT (user_id, full_name, role, site_id) ON mealbridge.app_user TO 'r_mess_admin';
GRANT SELECT, UPDATE (read_at)                   ON mealbridge.notification TO 'r_mess_admin';
GRANT SELECT ON mealbridge.v_live_feed        TO 'r_mess_admin';
GRANT SELECT ON mealbridge.v_batch_outcome    TO 'r_mess_admin';
GRANT SELECT ON mealbridge.v_impact_daily     TO 'r_mess_admin';
GRANT SELECT ON mealbridge.v_impact_summary   TO 'r_mess_admin';
GRANT SELECT ON mealbridge.v_mess_leaderboard TO 'r_mess_admin';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_post_batch    TO 'r_mess_admin';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_cancel_batch  TO 'r_mess_admin';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_rank_shelters TO 'r_mess_admin';
GRANT EXECUTE ON FUNCTION  mealbridge.fn_meals         TO 'r_mess_admin';

-- ---------------------------------------------------------------------
-- SHELTER : sees the live feed, claims, manages its own need/capacity
-- and diet exclusions, follows deliveries.
-- Blocked from: posting or editing batches, inserting claims directly,
-- touching reserved_kg, mess meal logs, audit log, password hashes.
-- ---------------------------------------------------------------------
GRANT SELECT ON mealbridge.site            TO 'r_shelter';
GRANT SELECT ON mealbridge.shelter         TO 'r_shelter';
GRANT SELECT ON mealbridge.food_category   TO 'r_shelter';
GRANT SELECT ON mealbridge.diet_tag        TO 'r_shelter';
GRANT SELECT ON mealbridge.surplus_batch   TO 'r_shelter';
GRANT SELECT ON mealbridge.batch_diet_tag  TO 'r_shelter';
GRANT SELECT ON mealbridge.claim           TO 'r_shelter';
GRANT SELECT ON mealbridge.custody_event   TO 'r_shelter';
GRANT SELECT ON mealbridge.pickup_trip     TO 'r_shelter';
GRANT SELECT ON mealbridge.trip_stop       TO 'r_shelter';
GRANT SELECT ON mealbridge.trip_item       TO 'r_shelter';
GRANT SELECT, INSERT, DELETE ON mealbridge.shelter_diet_exclusion TO 'r_shelter';
-- capacity planning: may set need and capacity, NOT the trigger-kept counter
GRANT SELECT, INSERT (shelter_site_id, day, meals_needed, capacity_kg),
              UPDATE (meals_needed, capacity_kg) ON mealbridge.shelter_day TO 'r_shelter';
GRANT SELECT (user_id, full_name, role, site_id) ON mealbridge.app_user TO 'r_shelter';
GRANT SELECT, UPDATE (read_at)                   ON mealbridge.notification TO 'r_shelter';
GRANT SELECT ON mealbridge.v_live_feed        TO 'r_shelter';
GRANT SELECT ON mealbridge.v_impact_daily     TO 'r_shelter';
GRANT SELECT ON mealbridge.v_impact_summary   TO 'r_shelter';
GRANT SELECT ON mealbridge.v_response_time    TO 'r_shelter';
GRANT SELECT ON mealbridge.v_shelter_fairness TO 'r_shelter';
GRANT SELECT ON mealbridge.v_fairness_index   TO 'r_shelter';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_rank_shelters TO 'r_shelter';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_claim_batch   TO 'r_shelter';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_cancel_claim  TO 'r_shelter';
GRANT EXECUTE ON FUNCTION  mealbridge.fn_meals         TO 'r_shelter';
-- Stage 6: the shelter's live feed is ranked by ITS OWN match score.
-- The function only reads (DEFINER rights) and returns one number.
GRANT EXECUTE ON FUNCTION  mealbridge.fn_match_score   TO 'r_shelter';

-- ---------------------------------------------------------------------
-- VOLUNTEER : sees trips and the places on them, records pickups and
-- deliveries, switches availability.
-- Blocked from: claims, shelter capacity, scoring policy, mess logs,
-- audit log, other people's e-mail and password hashes.
-- ---------------------------------------------------------------------
GRANT SELECT ON mealbridge.site            TO 'r_volunteer';
GRANT SELECT ON mealbridge.food_category   TO 'r_volunteer';
GRANT SELECT ON mealbridge.surplus_batch   TO 'r_volunteer';
GRANT SELECT ON mealbridge.custody_event   TO 'r_volunteer';
GRANT SELECT ON mealbridge.pickup_trip     TO 'r_volunteer';
GRANT SELECT ON mealbridge.trip_stop       TO 'r_volunteer';
GRANT SELECT ON mealbridge.trip_item       TO 'r_volunteer';
GRANT SELECT ON mealbridge.volunteer       TO 'r_volunteer';
-- phone is needed to call the mess/shelter contact on the way
GRANT SELECT (user_id, full_name, phone, role, site_id) ON mealbridge.app_user TO 'r_volunteer';
GRANT SELECT, UPDATE (read_at) ON mealbridge.notification TO 'r_volunteer';
-- Stage 6: claims waiting for pickup, without scores or capacity
-- (the role still has no SELECT on claim itself)
GRANT SELECT ON mealbridge.v_pickup_queue  TO 'r_volunteer';
GRANT SELECT ON mealbridge.v_trip_manifest TO 'r_volunteer';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_create_trip      TO 'r_volunteer';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_record_pickup    TO 'r_volunteer';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_record_delivery  TO 'r_volunteer';
GRANT EXECUTE ON PROCEDURE mealbridge.sp_set_availability TO 'r_volunteer';

-- ---------------------------------------------------------------------
-- PLATFORM ADMIN : reads everything, manages master data and policy,
-- runs every procedure.
-- Blocked from: changing history (custody_event, audit_log, claims,
-- batches are changed only through procedures), schema changes (no
-- DROP/ALTER/CREATE), and handing out privileges (no GRANT OPTION).
-- ---------------------------------------------------------------------
GRANT SELECT ON mealbridge.* TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.campus                 TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.site                   TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.mess                   TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.shelter                TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.diet_tag               TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.food_category          TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.menu_item              TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.app_user               TO 'r_platform_admin';
GRANT INSERT, UPDATE ON mealbridge.volunteer              TO 'r_platform_admin';
GRANT UPDATE (weight_value, description) ON mealbridge.scoring_weight TO 'r_platform_admin';
GRANT INSERT, DELETE ON mealbridge.shelter_diet_exclusion TO 'r_platform_admin';
GRANT EXECUTE ON mealbridge.* TO 'r_platform_admin';     -- all procedures and functions
-- Stage 6: lets the admin's "live concurrency demo" page show the row
-- lock that sp_claim_batch holds (monitoring only, read-only).
GRANT SELECT ON performance_schema.data_locks      TO 'r_platform_admin';
GRANT SELECT ON performance_schema.data_lock_waits TO 'r_platform_admin';
GRANT SELECT ON performance_schema.threads         TO 'r_platform_admin';

-- ---------------------------------------------------------------------
-- Stage 6 SERVICE ROLES used by the web API (not people):
--   r_auth   : the login screen. Reads ONLY the columns needed to check a
--              password and start a session. Cannot read any food data.
--   r_public : the public landing page. Reads ONLY the aggregate impact
--              views (no names of people, no contact data).
-- ---------------------------------------------------------------------
GRANT SELECT (user_id, full_name, email, password_hash, role, site_id, is_active)
      ON mealbridge.app_user TO 'r_auth';
GRANT SELECT (site_id, name) ON mealbridge.site TO 'r_auth';
GRANT SELECT ON mealbridge.v_impact_summary   TO 'r_public';
GRANT SELECT ON mealbridge.v_impact_daily     TO 'r_public';
GRANT SELECT ON mealbridge.v_fairness_index   TO 'r_public';

-- ---------------------------------------------------------------------
-- Demo logins, one per role (the web API uses these connections).
-- ---------------------------------------------------------------------
CREATE USER 'mb_mess_admin'@'localhost'     IDENTIFIED BY 'MessAdmin#Demo2026';
CREATE USER 'mb_shelter'@'localhost'        IDENTIFIED BY 'Shelter#Demo2026';
CREATE USER 'mb_volunteer'@'localhost'      IDENTIFIED BY 'Volunteer#Demo2026';
CREATE USER 'mb_platform_admin'@'localhost' IDENTIFIED BY 'PlatformAdmin#Demo2026';
CREATE USER 'mb_auth'@'localhost'           IDENTIFIED BY 'Auth#Demo2026';
CREATE USER 'mb_public'@'localhost'         IDENTIFIED BY 'Public#Demo2026';

GRANT 'r_mess_admin'     TO 'mb_mess_admin'@'localhost';
GRANT 'r_shelter'        TO 'mb_shelter'@'localhost';
GRANT 'r_volunteer'      TO 'mb_volunteer'@'localhost';
GRANT 'r_platform_admin' TO 'mb_platform_admin'@'localhost';
GRANT 'r_auth'           TO 'mb_auth'@'localhost';
GRANT 'r_public'         TO 'mb_public'@'localhost';

-- activate the role automatically at login
SET DEFAULT ROLE ALL TO 'mb_mess_admin'@'localhost', 'mb_shelter'@'localhost',
                        'mb_volunteer'@'localhost', 'mb_platform_admin'@'localhost',
                        'mb_auth'@'localhost', 'mb_public'@'localhost';

-- what each login ends up with (printed for the record)
SHOW GRANTS FOR 'mb_shelter'@'localhost' USING 'r_shelter';
