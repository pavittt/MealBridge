"""
Stage 5 RBAC test: logs in as each of the four demo MySQL users and tries
things the role SHOULD and SHOULD NOT be able to do. Every attempt is a
real MySQL call; the report shows MySQL's own message.

Outcome classes
  ALLOWED  the statement ran
  DENIED   MySQL refused it on PRIVILEGES (error 1142, 1143, 1370, 1044,
           1227, 1410): the role simply does not have the right
  REFUSED  the role may call the procedure, but the procedure's own
           ownership / business check said no (SIGNAL 45000 or a
           'REJECTED' result). This is row-level security done in SQL.

Writes sql/14_rbac_tests.output.md and exits non-zero if any test fails.
Run after setup.sql:   python3 tools/rbac_test.py
"""
import os, pathlib, re, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
USERS = {
    "mess_admin":     ("mb_mess_admin",     "MessAdmin#Demo2026"),
    "shelter":        ("mb_shelter",        "Shelter#Demo2026"),
    "volunteer":      ("mb_volunteer",      "Volunteer#Demo2026"),
    "platform_admin": ("mb_platform_admin", "PlatformAdmin#Demo2026"),
    # Stage 6 service logins used by the web API
    "auth":           ("mb_auth",           "Auth#Demo2026"),
    "public":         ("mb_public",         "Public#Demo2026"),
}
PRIV_ERRORS = {"1142", "1143", "1370", "1044", "1227", "1410"}

def root(sql):
    return subprocess.run(["mysql", "-uroot", "--default-character-set=utf8mb4", "mealbridge", "-N", "-B", "-e", sql],
                          text=True, encoding="utf-8", capture_output=True).stdout.strip()

LIVE = root("SELECT batch_id FROM surplus_batch WHERE description='SYN Chicken curry (live demo)'")
LIVE_TRIP = root("SELECT MAX(trip_id) FROM pickup_trip WHERE status='IN_PROGRESS'")
OTHER_CLAIM = root("SELECT claim_id FROM claim WHERE status='ACTIVE' AND shelter_site_id <> 9 LIMIT 1")

# (role, what is attempted, SQL, expected outcome)
TESTS = [
  # ---------------- MESS ADMIN ----------------
  ("mess_admin", "Read the live feed view", "SELECT COUNT(*) FROM v_live_feed", "ALLOWED"),
  ("mess_admin", "Run the matching procedure for a batch", f"CALL sp_rank_shelters({LIVE}, NULL)", "ALLOWED"),
  ("mess_admin", "Post a batch and withdraw it (own mess, via procedures)",
   "CALL sp_post_batch(3, 6, 'SNACKS', 'SYN RBAC test samosa', 5, 'AMBIENT', NOW() - INTERVAL 1 HOUR, NULL, '[\"VEG\"]', @b); "
   "CALL sp_cancel_batch(3, @b); SELECT status FROM surplus_batch WHERE batch_id = @b", "ALLOWED"),
  ("mess_admin", "Log a meal (own forecasting data), rolled back",
   "START TRANSACTION; UPDATE mess_meal_log SET leftover_kg = leftover_kg WHERE mess_site_id = 1 LIMIT 1; ROLLBACK", "ALLOWED"),
  ("mess_admin", "Read staff names (granted columns)", "SELECT full_name FROM app_user LIMIT 1", "ALLOWED"),
  ("mess_admin", "Read e-mail addresses (column not granted)", "SELECT email FROM app_user LIMIT 1", "DENIED"),
  ("mess_admin", "Read password hashes", "SELECT password_hash FROM app_user LIMIT 1", "DENIED"),
  ("mess_admin", "Post as a user who is not a mess admin (procedure checks the role)",
   "CALL sp_post_batch(10, 6, 'SNACKS', 'SYN wrong', 5, 'AMBIENT', NOW(), NULL, '[]', @b)", "REFUSED"),
  ("mess_admin", "INSERT into surplus_batch directly (bypass procedure)",
   "INSERT INTO surplus_batch (mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, safe_until) "
   "VALUES (1, 1, 3, 'LUNCH', 'x', 5, 'AMBIENT', NOW(), NOW())", "DENIED"),
  ("mess_admin", "Change a batch's quantity directly", "UPDATE surplus_batch SET quantity_kg = 1 WHERE batch_id = 1", "DENIED"),
  ("mess_admin", "Claim food (shelter action)", f"CALL sp_claim_batch(3, {LIVE}, @c, @r)", "DENIED"),
  ("mess_admin", "Read shelters' daily capacity", "SELECT * FROM shelter_day LIMIT 1", "DENIED"),
  ("mess_admin", "Read volunteers' home locations", "SELECT * FROM volunteer LIMIT 1", "DENIED"),
  ("mess_admin", "Read the audit log", "SELECT * FROM audit_log LIMIT 1", "DENIED"),
  ("mess_admin", "Change matching policy weights", "UPDATE scoring_weight SET weight_value = 1 WHERE weight_key = 'NEED'", "DENIED"),

  # ---------------- SHELTER ----------------
  ("shelter", "Read the live feed view", "SELECT batch_id, minutes_left FROM v_live_feed", "ALLOWED"),
  ("shelter", "See its match ranking for a batch", f"CALL sp_rank_shelters({LIVE}, NULL)", "ALLOWED"),
  ("shelter", "Update its need and capacity (granted columns), rolled back",
   "START TRANSACTION; UPDATE shelter_day SET meals_needed = meals_needed + 1 WHERE shelter_site_id = 9 AND day = CURRENT_DATE; ROLLBACK", "ALLOWED"),
  ("shelter", "Read the fairness dashboard view", "SELECT * FROM v_fairness_index", "ALLOWED"),
  ("shelter", "Set reserved_kg (trigger-kept counter)",
   "UPDATE shelter_day SET reserved_kg = 0 WHERE shelter_site_id = 9 AND day = CURRENT_DATE", "DENIED"),
  ("shelter", "INSERT a claim directly (skipping the locking procedure)",
   f"INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km) VALUES ({LIVE}, 9, 11, 99, 1)", "DENIED"),
  ("shelter", "Mark a batch CLAIMED directly", f"UPDATE surplus_batch SET status = 'CLAIMED' WHERE batch_id = {LIVE}", "DENIED"),
  ("shelter", "Claim as a user who is not shelter staff (procedure checks)",
   f"CALL sp_claim_batch(3, {LIVE}, @c, @r); SELECT @r", "REFUSED"),
  ("shelter", "Cancel ANOTHER shelter's claim (procedure checks ownership)",
   f"CALL sp_cancel_claim(11, {OTHER_CLAIM}, 'not mine')", "REFUSED"),
  ("shelter", "Post a batch (mess action)",
   "CALL sp_post_batch(3, 6, 'SNACKS', 'x', 5, 'AMBIENT', NOW(), NULL, '[]', @b)", "DENIED"),
  ("shelter", "Read messes' meal logs", "SELECT * FROM mess_meal_log LIMIT 1", "DENIED"),
  ("shelter", "Read phone numbers", "SELECT phone FROM app_user LIMIT 1", "DENIED"),
  ("shelter", "Read the audit log", "SELECT * FROM audit_log LIMIT 1", "DENIED"),
  ("shelter", "Delete custody history", "DELETE FROM custody_event WHERE event_id = 1", "DENIED"),

  # ---------------- VOLUNTEER ----------------
  ("volunteer", "See trips and stops", "SELECT trip_id, status FROM pickup_trip ORDER BY trip_id DESC LIMIT 2", "ALLOWED"),
  ("volunteer", "Read contact phone of sites' staff (granted column)", "SELECT full_name, phone FROM app_user WHERE site_id = 1", "ALLOWED"),
  ("volunteer", "Go off duty and back on (via procedure)",
   "CALL sp_set_availability(21, FALSE); CALL sp_set_availability(21, TRUE); SELECT is_available FROM volunteer WHERE user_id = 21", "ALLOWED"),
  ("volunteer", "Record a pickup on SOMEONE ELSE's trip (procedure checks)",
   f"CALL sp_record_pickup(19, {LIVE_TRIP}, 1, 65.0)", "REFUSED"),
  ("volunteer", "Raise its own max load directly", "UPDATE volunteer SET max_load_kg = 500 WHERE user_id = 19", "DENIED"),
  ("volunteer", "Read claims and match scores", "SELECT * FROM claim LIMIT 1", "DENIED"),
  ("volunteer", "Read shelters' daily capacity", "SELECT * FROM shelter_day LIMIT 1", "DENIED"),
  ("volunteer", "Claim food", f"CALL sp_claim_batch(19, {LIVE}, @c, @r)", "DENIED"),
  ("volunteer", "Read e-mail addresses", "SELECT email FROM app_user LIMIT 1", "DENIED"),
  ("volunteer", "Change matching policy weights", "UPDATE scoring_weight SET weight_value = 1 WHERE weight_key = 'NEED'", "DENIED"),
  ("volunteer", "Read the audit log", "SELECT * FROM audit_log LIMIT 1", "DENIED"),

  # ---------------- PLATFORM ADMIN ----------------
  ("platform_admin", "Read the audit log", "SELECT COUNT(*) FROM audit_log", "ALLOWED"),
  ("platform_admin", "Change a policy weight (audited with its login), rolled back",
   "START TRANSACTION; UPDATE scoring_weight SET weight_value = 0.350 WHERE weight_key = 'NEED'; "
   "SELECT db_user, old_values, new_values FROM audit_log ORDER BY audit_id DESC LIMIT 1; ROLLBACK", "ALLOWED"),
  ("platform_admin", "Run the auto-expire job", "CALL sp_expire_batches()", "ALLOWED"),
  ("platform_admin", "Edit custody history", "UPDATE custody_event SET notes = 'x' WHERE event_id = 1", "DENIED"),
  ("platform_admin", "Delete audit rows", "DELETE FROM audit_log WHERE audit_id = 1", "DENIED"),
  ("platform_admin", "INSERT a claim directly", f"INSERT INTO claim (batch_id, shelter_site_id, claimed_by, match_score, distance_km) VALUES ({LIVE}, 9, 1, 50, 1)", "DENIED"),
  ("platform_admin", "Rename a policy key (only weight/description columns granted)",
   "UPDATE scoring_weight SET weight_key = 'X' WHERE weight_key = 'NEED'", "DENIED"),
  ("platform_admin", "Drop a table", "DROP TABLE notification", "DENIED"),
  ("platform_admin", "Alter the schema", "ALTER TABLE claim ADD COLUMN x INT", "DENIED"),
  ("platform_admin", "Give privileges to another login", "GRANT SELECT ON mealbridge.audit_log TO 'mb_volunteer'@'localhost'", "DENIED"),
  ("platform_admin", "Create a new database login", "CREATE USER 'evil'@'%' IDENTIFIED BY 'x'", "DENIED"),
  ("platform_admin", "See current row locks (Stage 6 concurrency page)", "SELECT COUNT(*) FROM performance_schema.data_locks", "ALLOWED"),
  # ---------------- STAGE 6 additions ----------------
  ("shelter", "Rank the live feed by its own match score (Stage 6)",
   "SELECT batch_id, fn_match_score(batch_id, 7, NOW()) AS score FROM v_live_feed LIMIT 2", "ALLOWED"),
  ("volunteer", "Read the pickup queue view (Stage 6)", "SELECT claim_id, mess, shelter, quantity_kg FROM v_pickup_queue LIMIT 2", "ALLOWED"),
  ("volunteer", "Read what is loaded on trips (Stage 6 view)", "SELECT trip_id, batch_id, quantity_kg FROM v_trip_manifest LIMIT 2", "ALLOWED"),
  ("volunteer", "Read match scores through the pickup view (column not in view)", "SELECT match_score FROM v_pickup_queue", "ERROR"),
  # ---------------- AUTH (login screen) ----------------
  ("auth", "Read login columns incl. password hash", "SELECT user_id, role, password_hash FROM app_user WHERE email = 'mess.a@example.org'", "ALLOWED"),
  ("auth", "Read phone numbers", "SELECT phone FROM app_user LIMIT 1", "DENIED"),
  ("auth", "Read surplus batches", "SELECT * FROM surplus_batch LIMIT 1", "DENIED"),
  ("auth", "Change a password hash", "UPDATE app_user SET password_hash = 'x' WHERE user_id = 1", "DENIED"),
  ("auth", "Call any procedure", f"CALL sp_rank_shelters({LIVE}, NULL)", "DENIED"),
  # ---------------- PUBLIC (landing page) ----------------
  ("public", "Read the impact summary view", "SELECT meals_saved, kg_diverted FROM v_impact_summary", "ALLOWED"),
  ("public", "Read the daily impact view", "SELECT COUNT(*) FROM v_impact_daily", "ALLOWED"),
  ("public", "Read people (app_user)", "SELECT full_name FROM app_user LIMIT 1", "DENIED"),
  ("public", "Read the live feed (only for logged-in shelters)", "SELECT * FROM v_live_feed LIMIT 1", "DENIED"),
  ("public", "Read shelter fairness detail (names of shelters)", "SELECT * FROM v_shelter_fairness LIMIT 1", "DENIED"),
]

def run(role, sql):
    user, pw = USERS[role]
    env = dict(os.environ, MYSQL_PWD=pw)
    r = subprocess.run(["mysql", f"-u{user}", "--default-character-set=utf8mb4", "mealbridge", "-B", "-e", sql],
                       text=True, encoding="utf-8", capture_output=True, env=env)
    out = (r.stdout + r.stderr).strip()
    m = re.search(r"ERROR (\d+) \((\w+)\)(?: at line \d+)?: (.*)", r.stderr)
    if m:
        code, msg = m.group(1), m.group(3)
        if code in PRIV_ERRORS:
            return "DENIED", f"ERROR {code}: {msg}"
        if code == "1644":
            return "REFUSED", f"ERROR {code}: {msg}"
        return "ERROR", f"ERROR {code}: {msg}"
    if "REJECTED" in r.stdout:
        line = [l for l in r.stdout.splitlines() if "REJECTED" in l][0]
        return "REFUSED", line.strip()
    lines = [l for l in r.stdout.splitlines() if l.strip()]
    summary = " / ".join(lines[1:3]) if len(lines) > 1 else "(ok, no rows returned)"
    return "ALLOWED", summary.replace("\t", " | ")[:110]

rows, fails = [], 0
for role, what, sql, expect in TESTS:
    got, msg = run(role, sql)
    ok = got == expect
    fails += not ok
    rows.append((role, what, expect, got, "PASS" if ok else "FAIL", msg))

grants = {}
for role, (user, pw) in USERS.items():
    grants[role] = subprocess.run(["mysql", "-uroot", "--default-character-set=utf8mb4", "-N", "-B", "-e",
                                   f"SHOW GRANTS FOR '{user}'@'localhost' USING 'r_{role}'"],
                                  text=True, encoding="utf-8", capture_output=True).stdout.strip()

ver = root("SELECT CONCAT(VERSION(), ' at ', NOW())")
md = ["# MealBridge: role-based access tests (real output)", "",
      f"Run by `tools/rbac_test.py` against MySQL {ver}. Each row is a real login as that role's demo user.",
      "", f"**Result: {len(rows) - fails} of {len(rows)} tests passed.**", "",
      "- **ALLOWED**: the statement ran.",
      "- **DENIED**: MySQL refused it on privileges (the role has no right to that table, column or procedure).",
      "- **REFUSED**: the role may call the procedure, but the procedure's ownership or business check said no. MySQL has no row-level security, so this is how \"only your own rows\" is enforced.",
      ""]
for role in USERS:
    md += [f"## {role.replace('_', ' ').title()}  (`{USERS[role][0]}` → role `r_{role}`)", "",
           "| # | Attempt | Expected | Actual | | MySQL said |", "|---|---|---|---|---|---|"]
    n = 0
    for r in rows:
        if r[0] != role:
            continue
        n += 1
        msg = r[5].replace("|", "\\|")
        md.append(f"| {n} | {r[1]} | {r[2]} | {r[3]} | {r[4]} | `{msg}` |")
    md.append("")
md += ["## Appendix: effective grants per login", ""]
for role in USERS:
    md += [f"### {USERS[role][0]}", "", "```sql", grants[role], "```", ""]
# encoding="utf-8": the report contains non-ASCII characters (the arrow in the
# headings). Without it Windows uses its ANSI code page (cp1252) and crashes here.
(ROOT / "sql" / "14_rbac_tests.output.md").write_text("\n".join(md) + "\n", encoding="utf-8")
print(f"{len(rows) - fails}/{len(rows)} passed")
for r in rows:
    print(f"{r[4]}  {r[0]:<15} {r[2]:<8} {r[3]:<8} {r[1]}  :: {r[5][:90]}")
sys.exit(1 if fails else 0)
