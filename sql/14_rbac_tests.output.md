# MealBridge: role-based access tests (real output)

Run by `tools/rbac_test.py` against MySQL 8.0.46-0ubuntu0.24.04.4 at 2026-10-07 09:26:27. Each row is a real login as that role's demo user.

**Result: 66 of 66 tests passed.**

- **ALLOWED**: the statement ran.
- **DENIED**: MySQL refused it on privileges (the role has no right to that table, column or procedure).
- **REFUSED**: the role may call the procedure, but the procedure's ownership or business check said no. MySQL has no row-level security, so this is how "only your own rows" is enforced.

## Mess Admin  (`mb_mess_admin` → role `r_mess_admin`)

| # | Attempt | Expected | Actual | | MySQL said |
|---|---|---|---|---|---|
| 1 | Read the live feed view | ALLOWED | ALLOWED | PASS | `4` |
| 2 | Run the matching procedure for a batch | ALLOWED | ALLOWED | PASS | `12 \| SYN Little Steps Orphanage \| 2.15 \| 29 \| 1349 \| 100.0 \| 60.6 \| 85.7 \| 97.9 \| 33.2 \| 76.16 \| ELIGIBLE / 10` |
| 3 | Post a batch and withdraw it (own mess, via procedures) | ALLOWED | ALLOWED | PASS | `CANCELLED` |
| 4 | Log a meal (own forecasting data), rolled back | ALLOWED | ALLOWED | PASS | `(ok, no rows returned)` |
| 5 | Read staff names (granted columns) | ALLOWED | ALLOWED | PASS | `SYN Platform Admin 1` |
| 6 | Read e-mail addresses (column not granted) | DENIED | DENIED | PASS | `ERROR 1143: SELECT command denied to user 'mb_mess_admin'@'localhost' for column 'email' in table 'app_user'` |
| 7 | Read password hashes | DENIED | DENIED | PASS | `ERROR 1143: SELECT command denied to user 'mb_mess_admin'@'localhost' for column 'password_hash' in table 'app_user'` |
| 8 | Post as a user who is not a mess admin (procedure checks the role) | REFUSED | REFUSED | PASS | `ERROR 1644: Only an active mess admin can post a batch` |
| 9 | INSERT into surplus_batch directly (bypass procedure) | DENIED | DENIED | PASS | `ERROR 1142: INSERT command denied to user 'mb_mess_admin'@'localhost' for table 'surplus_batch'` |
| 10 | Change a batch's quantity directly | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_mess_admin'@'localhost' for table 'surplus_batch'` |
| 11 | Claim food (shelter action) | DENIED | DENIED | PASS | `ERROR 1370: execute command denied to user 'mb_mess_admin'@'localhost' for routine 'mealbridge.sp_claim_batch'` |
| 12 | Read shelters' daily capacity | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_mess_admin'@'localhost' for table 'shelter_day'` |
| 13 | Read volunteers' home locations | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_mess_admin'@'localhost' for table 'volunteer'` |
| 14 | Read the audit log | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_mess_admin'@'localhost' for table 'audit_log'` |
| 15 | Change matching policy weights | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_mess_admin'@'localhost' for table 'scoring_weight'` |

## Shelter  (`mb_shelter` → role `r_shelter`)

| # | Attempt | Expected | Actual | | MySQL said |
|---|---|---|---|---|---|
| 1 | Read the live feed view | ALLOWED | ALLOWED | PASS | `419 \| 169 / 420 \| 179` |
| 2 | See its match ranking for a batch | ALLOWED | ALLOWED | PASS | `12 \| SYN Little Steps Orphanage \| 2.15 \| 29 \| 1349 \| 100.0 \| 60.6 \| 85.7 \| 97.9 \| 33.2 \| 76.16 \| ELIGIBLE / 10` |
| 3 | Update its need and capacity (granted columns), rolled back | ALLOWED | ALLOWED | PASS | `(ok, no rows returned)` |
| 4 | Read the fairness dashboard view | ALLOWED | ALLOWED | PASS | `9 \| 0.85 \| 0.111` |
| 5 | Set reserved_kg (trigger-kept counter) | DENIED | DENIED | PASS | `ERROR 1143: UPDATE command denied to user 'mb_shelter'@'localhost' for column 'reserved_kg' in table 'shelter_day'` |
| 6 | INSERT a claim directly (skipping the locking procedure) | DENIED | DENIED | PASS | `ERROR 1142: INSERT command denied to user 'mb_shelter'@'localhost' for table 'claim'` |
| 7 | Mark a batch CLAIMED directly | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_shelter'@'localhost' for table 'surplus_batch'` |
| 8 | Claim as a user who is not shelter staff (procedure checks) | REFUSED | REFUSED | PASS | `REJECTED: only active shelter staff can claim` |
| 9 | Cancel ANOTHER shelter's claim (procedure checks ownership) | REFUSED | REFUSED | PASS | `ERROR 1644: Not cancelled: claim is not yours or not ACTIVE` |
| 10 | Post a batch (mess action) | DENIED | DENIED | PASS | `ERROR 1370: execute command denied to user 'mb_shelter'@'localhost' for routine 'mealbridge.sp_post_batch'` |
| 11 | Read messes' meal logs | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_shelter'@'localhost' for table 'mess_meal_log'` |
| 12 | Read phone numbers | DENIED | DENIED | PASS | `ERROR 1143: SELECT command denied to user 'mb_shelter'@'localhost' for column 'phone' in table 'app_user'` |
| 13 | Read the audit log | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_shelter'@'localhost' for table 'audit_log'` |
| 14 | Delete custody history | DENIED | DENIED | PASS | `ERROR 1142: DELETE command denied to user 'mb_shelter'@'localhost' for table 'custody_event'` |
| 15 | Rank the live feed by its own match score (Stage 6) | ALLOWED | ALLOWED | PASS | `419 \| NULL / 420 \| NULL` |

## Volunteer  (`mb_volunteer` → role `r_volunteer`)

| # | Attempt | Expected | Actual | | MySQL said |
|---|---|---|---|---|---|
| 1 | See trips and stops | ALLOWED | ALLOWED | PASS | `352 \| IN_PROGRESS / 351 \| COMPLETED` |
| 2 | Read contact phone of sites' staff (granted column) | ALLOWED | ALLOWED | PASS | `SYN Mess Admin A \| 9100000003` |
| 3 | Go off duty and back on (via procedure) | ALLOWED | ALLOWED | PASS | `1` |
| 4 | Record a pickup on SOMEONE ELSE's trip (procedure checks) | REFUSED | REFUSED | PASS | `ERROR 1644: Not your open pickup stop` |
| 5 | Raise its own max load directly | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_volunteer'@'localhost' for table 'volunteer'` |
| 6 | Read claims and match scores | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_volunteer'@'localhost' for table 'claim'` |
| 7 | Read shelters' daily capacity | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_volunteer'@'localhost' for table 'shelter_day'` |
| 8 | Claim food | DENIED | DENIED | PASS | `ERROR 1370: execute command denied to user 'mb_volunteer'@'localhost' for routine 'mealbridge.sp_claim_batch'` |
| 9 | Read e-mail addresses | DENIED | DENIED | PASS | `ERROR 1143: SELECT command denied to user 'mb_volunteer'@'localhost' for column 'email' in table 'app_user'` |
| 10 | Change matching policy weights | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_volunteer'@'localhost' for table 'scoring_weight'` |
| 11 | Read the audit log | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_volunteer'@'localhost' for table 'audit_log'` |
| 12 | Read the pickup queue view (Stage 6) | ALLOWED | ALLOWED | PASS | `328 \| SYN Mess D (Special) \| SYN Gandhi Nagar Community Kitchen \| 15.00` |
| 13 | Read what is loaded on trips (Stage 6 view) | ALLOWED | ALLOWED | PASS | `2 \| 3 \| 7.85 / 3 \| 1 \| 10.89` |
| 14 | Read match scores through the pickup view (column not in view) | ERROR | ERROR | PASS | `ERROR 1054: Unknown column 'match_score' in 'field list'` |

## Platform Admin  (`mb_platform_admin` → role `r_platform_admin`)

| # | Attempt | Expected | Actual | | MySQL said |
|---|---|---|---|---|---|
| 1 | Read the audit log | ALLOWED | ALLOWED | PASS | `2142` |
| 2 | Change a policy weight (audited with its login), rolled back | ALLOWED | ALLOWED | PASS | `mb_platform_admin@localhost \| {"weight": 0.300} \| {"weight": 0.350}` |
| 3 | Run the auto-expire job | ALLOWED | ALLOWED | PASS | `(ok, no rows returned)` |
| 4 | Edit custody history | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_platform_admin'@'localhost' for table 'custody_event'` |
| 5 | Delete audit rows | DENIED | DENIED | PASS | `ERROR 1142: DELETE command denied to user 'mb_platform_admin'@'localhost' for table 'audit_log'` |
| 6 | INSERT a claim directly | DENIED | DENIED | PASS | `ERROR 1142: INSERT command denied to user 'mb_platform_admin'@'localhost' for table 'claim'` |
| 7 | Rename a policy key (only weight/description columns granted) | DENIED | DENIED | PASS | `ERROR 1143: UPDATE command denied to user 'mb_platform_admin'@'localhost' for column 'weight_key' in table 'scoring_weight'` |
| 8 | Drop a table | DENIED | DENIED | PASS | `ERROR 1142: DROP command denied to user 'mb_platform_admin'@'localhost' for table 'notification'` |
| 9 | Alter the schema | DENIED | DENIED | PASS | `ERROR 1142: ALTER command denied to user 'mb_platform_admin'@'localhost' for table 'claim'` |
| 10 | Give privileges to another login | DENIED | DENIED | PASS | `ERROR 1142: GRANT command denied to user 'mb_platform_admin'@'localhost' for table 'audit_log'` |
| 11 | Create a new database login | DENIED | DENIED | PASS | `ERROR 1227: Access denied; you need (at least one of) the CREATE USER privilege(s) for this operation` |
| 12 | See current row locks (Stage 6 concurrency page) | ALLOWED | ALLOWED | PASS | `0` |

## Auth  (`mb_auth` → role `r_auth`)

| # | Attempt | Expected | Actual | | MySQL said |
|---|---|---|---|---|---|
| 1 | Read login columns incl. password hash | ALLOWED | ALLOWED | PASS | `3 \| MESS_ADMIN \| $2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi` |
| 2 | Read phone numbers | DENIED | DENIED | PASS | `ERROR 1143: SELECT command denied to user 'mb_auth'@'localhost' for column 'phone' in table 'app_user'` |
| 3 | Read surplus batches | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_auth'@'localhost' for table 'surplus_batch'` |
| 4 | Change a password hash | DENIED | DENIED | PASS | `ERROR 1142: UPDATE command denied to user 'mb_auth'@'localhost' for table 'app_user'` |
| 5 | Call any procedure | DENIED | DENIED | PASS | `ERROR 1370: execute command denied to user 'mb_auth'@'localhost' for routine 'mealbridge.sp_rank_shelters'` |

## Public  (`mb_public` → role `r_public`)

| # | Attempt | Expected | Actual | | MySQL said |
|---|---|---|---|---|---|
| 1 | Read the impact summary view | ALLOWED | ALLOWED | PASS | `9034 \| 2752.99` |
| 2 | Read the daily impact view | ALLOWED | ALLOWED | PASS | `31` |
| 3 | Read people (app_user) | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_public'@'localhost' for table 'app_user'` |
| 4 | Read the live feed (only for logged-in shelters) | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_public'@'localhost' for table 'v_live_feed'` |
| 5 | Read shelter fairness detail (names of shelters) | DENIED | DENIED | PASS | `ERROR 1142: SELECT command denied to user 'mb_public'@'localhost' for table 'v_shelter_fairness'` |

## Appendix: effective grants per login

### mb_mess_admin

```sql
GRANT USAGE ON *.* TO `mb_mess_admin`@`localhost`
GRANT SELECT (`full_name`, `role`, `site_id`, `user_id`) ON `mealbridge`.`app_user` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`batch_diet_tag` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`campus` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`claim` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`custody_event` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`diet_tag` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`food_category` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`menu_item` TO `mb_mess_admin`@`localhost`
GRANT SELECT, INSERT, UPDATE ON `mealbridge`.`mess_meal_log` TO `mb_mess_admin`@`localhost`
GRANT SELECT, INSERT, UPDATE, DELETE ON `mealbridge`.`mess_menu` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`mess` TO `mb_mess_admin`@`localhost`
GRANT SELECT, UPDATE (`read_at`) ON `mealbridge`.`notification` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`site` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`surplus_batch` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`surplus_forecast` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`v_batch_outcome` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`v_impact_daily` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`v_impact_summary` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`v_live_feed` TO `mb_mess_admin`@`localhost`
GRANT SELECT ON `mealbridge`.`v_mess_leaderboard` TO `mb_mess_admin`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_cancel_batch` TO `mb_mess_admin`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_post_batch` TO `mb_mess_admin`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_rank_shelters` TO `mb_mess_admin`@`localhost`
GRANT EXECUTE ON FUNCTION `mealbridge`.`fn_meals` TO `mb_mess_admin`@`localhost`
GRANT `r_mess_admin`@`%` TO `mb_mess_admin`@`localhost`
```

### mb_shelter

```sql
GRANT USAGE ON *.* TO `mb_shelter`@`localhost`
GRANT SELECT (`full_name`, `role`, `site_id`, `user_id`) ON `mealbridge`.`app_user` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`batch_diet_tag` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`claim` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`custody_event` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`diet_tag` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`food_category` TO `mb_shelter`@`localhost`
GRANT SELECT, UPDATE (`read_at`) ON `mealbridge`.`notification` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`pickup_trip` TO `mb_shelter`@`localhost`
GRANT SELECT, INSERT (`capacity_kg`, `day`, `meals_needed`, `shelter_site_id`), UPDATE (`capacity_kg`, `meals_needed`) ON `mealbridge`.`shelter_day` TO `mb_shelter`@`localhost`
GRANT SELECT, INSERT, DELETE ON `mealbridge`.`shelter_diet_exclusion` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`shelter` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`site` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`surplus_batch` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`trip_item` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`trip_stop` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`v_fairness_index` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`v_impact_daily` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`v_impact_summary` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`v_live_feed` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`v_response_time` TO `mb_shelter`@`localhost`
GRANT SELECT ON `mealbridge`.`v_shelter_fairness` TO `mb_shelter`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_cancel_claim` TO `mb_shelter`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_claim_batch` TO `mb_shelter`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_rank_shelters` TO `mb_shelter`@`localhost`
GRANT EXECUTE ON FUNCTION `mealbridge`.`fn_match_score` TO `mb_shelter`@`localhost`
GRANT EXECUTE ON FUNCTION `mealbridge`.`fn_meals` TO `mb_shelter`@`localhost`
GRANT `r_shelter`@`%` TO `mb_shelter`@`localhost`
```

### mb_volunteer

```sql
GRANT USAGE ON *.* TO `mb_volunteer`@`localhost`
GRANT SELECT (`full_name`, `phone`, `role`, `site_id`, `user_id`) ON `mealbridge`.`app_user` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`custody_event` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`food_category` TO `mb_volunteer`@`localhost`
GRANT SELECT, UPDATE (`read_at`) ON `mealbridge`.`notification` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`pickup_trip` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`site` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`surplus_batch` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`trip_item` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`trip_stop` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`v_pickup_queue` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`v_trip_manifest` TO `mb_volunteer`@`localhost`
GRANT SELECT ON `mealbridge`.`volunteer` TO `mb_volunteer`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_create_trip` TO `mb_volunteer`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_record_delivery` TO `mb_volunteer`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_record_pickup` TO `mb_volunteer`@`localhost`
GRANT EXECUTE ON PROCEDURE `mealbridge`.`sp_set_availability` TO `mb_volunteer`@`localhost`
GRANT `r_volunteer`@`%` TO `mb_volunteer`@`localhost`
```

### mb_platform_admin

```sql
GRANT USAGE ON *.* TO `mb_platform_admin`@`localhost`
GRANT SELECT, EXECUTE ON `mealbridge`.* TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`app_user` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`campus` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`diet_tag` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`food_category` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`menu_item` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`mess` TO `mb_platform_admin`@`localhost`
GRANT UPDATE (`description`, `weight_value`) ON `mealbridge`.`scoring_weight` TO `mb_platform_admin`@`localhost`
GRANT INSERT, DELETE ON `mealbridge`.`shelter_diet_exclusion` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`shelter` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`site` TO `mb_platform_admin`@`localhost`
GRANT INSERT, UPDATE ON `mealbridge`.`volunteer` TO `mb_platform_admin`@`localhost`
GRANT SELECT ON `performance_schema`.`data_lock_waits` TO `mb_platform_admin`@`localhost`
GRANT SELECT ON `performance_schema`.`data_locks` TO `mb_platform_admin`@`localhost`
GRANT SELECT ON `performance_schema`.`threads` TO `mb_platform_admin`@`localhost`
GRANT `r_platform_admin`@`%` TO `mb_platform_admin`@`localhost`
```

### mb_auth

```sql
GRANT USAGE ON *.* TO `mb_auth`@`localhost`
GRANT SELECT (`email`, `full_name`, `is_active`, `password_hash`, `role`, `site_id`, `user_id`) ON `mealbridge`.`app_user` TO `mb_auth`@`localhost`
GRANT SELECT (`name`, `site_id`) ON `mealbridge`.`site` TO `mb_auth`@`localhost`
GRANT `r_auth`@`%` TO `mb_auth`@`localhost`
```

### mb_public

```sql
GRANT USAGE ON *.* TO `mb_public`@`localhost`
GRANT SELECT ON `mealbridge`.`v_fairness_index` TO `mb_public`@`localhost`
GRANT SELECT ON `mealbridge`.`v_impact_daily` TO `mb_public`@`localhost`
GRANT SELECT ON `mealbridge`.`v_impact_summary` TO `mb_public`@`localhost`
GRANT `r_public`@`%` TO `mb_public`@`localhost`
```

