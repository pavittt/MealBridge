"""
Generates sql/07_seed_synthetic.sql : SYNTHETIC demo data for MealBridge.

EVERYTHING this script produces is invented for testing and demos. No row
describes a real mess, shelter, person or measurement. Names start with
"SYN", e-mails use the reserved example domain, phone numbers are dummies.

How the data is built (explain this in the viva):
  1. Reference data: 2 campuses, 6 messes, 10 shelters (1 inactive),
     diet tags, 8 food categories, 24 dishes, scoring weights.
  2. People: 2 platform admins, 6 mess admins, 10 shelter users,
     12 volunteers (1 not ID-verified, 1 unavailable).
  3. ~30 days of mess meal logs (attendance, prepared, leftover) with a
     weekly rhythm: weekends and a long weekend have lower attendance,
     so more food is left over -> realistic surplus PEAKS.
  4. Leftover food that can be safely re-served becomes surplus batches,
     one per dish, posted after each meal.
  5. Shelter responses, cancellations and volunteer trips are replayed
     IN TIME ORDER through the real database logic: claims are chosen by
     fn_match_score (the same scoring the live app uses), triggers update
     capacity and the custody chain, sp_create_trip batches pickups.
  6. sp_expire_batches() then expires whatever nobody could take in time.

All timestamps are relative to the day the seed is loaded: @d0 is the
Monday on or before 30 days ago (so weekends fall on real weekends).
36 days are generated and every event at or after the load date is
skipped in SQL, so history always runs from @d0 up to yesterday
(30-36 days, depending on the weekday), plus a live "today" built with
the real procedures.

Run:  python3 tools/gen_seed.py      (deterministic: fixed random seed)
"""
import math, random, pathlib, json

random.seed(302)                     # BCSE302P -> reproducible output
ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "sql" / "07_seed_synthetic.sql"
DAYS = 36          # generated; days on/after the load date are skipped in SQL

out = []
def emit(s=""): out.append(s)
def q(s): return "'" + str(s).replace("'", "''") + "'"
def ts(minute):                      # minutes since @d0 -> SQL expression
    return f"(@d0 + INTERVAL {int(round(minute*60))} SECOND)"
def pt(lat, lon): return f"ST_GeomFromText('POINT({lat:.5f} {lon:.5f})', 4326)"

# ----------------------------------------------------------------- data
campuses = ["SYN North Campus", "SYN South Campus"]

# id, name, campus, block, type, capacity_meals, lat, lon, has_chiller
messes = [
    (1, "SYN Mess A (Veg)",     1, "A", "VEG",     2400, 12.96920, 79.15590, True),
    (2, "SYN Mess B (Non-veg)", 1, "B", "NON_VEG", 1800, 12.97150, 79.15900, False),
    (3, "SYN Mess C (Mixed)",   1, "C", "MIXED",   2000, 12.96700, 79.16050, True),
    (4, "SYN Mess D (Special)", 1, "D", "SPECIAL",  900, 12.97000, 79.16300, False),
    (5, "SYN Mess E (Mixed)",   2, "E", "MIXED",   1500, 12.93850, 79.14300, True),
    (6, "SYN Mess F (Veg)",     2, "F", "VEG",     1200, 12.93600, 79.14650, False),
]
# id, name, type, beneficiaries, fridge, capacity_kg, lat, lon, exclusions, active
shelters = [
    (7,  "SYN Anbu Children's Home",        "ORPHANAGE",           60, True,  30, 12.97650, 79.13700, [], True),
    (8,  "SYN Sri Sai Old Age Home",        "OLD_AGE_HOME",        45, False, 20, 12.95600, 79.17200, ["SPICY", "NON_VEG"], True),
    (9,  "SYN Katpadi Night Shelter",       "HOMELESS_SHELTER",   120, False, 50, 12.98400, 79.13900, [], True),
    (10, "SYN Hospital Attendants Rest House","HOSPITAL_ATTENDANTS",200, True, 80, 12.92500, 79.13500, [], True),
    (11, "SYN Temple Annadhanam Kitchen",   "COMMUNITY_KITCHEN",  150, False, 60, 12.91600, 79.13200, ["NON_VEG", "CONTAINS_EGG", "CONTAINS_ONION_GARLIC"], True),
    (12, "SYN Little Steps Orphanage",      "ORPHANAGE",           35, False, 15, 12.95200, 79.14800, ["CONTAINS_NUTS"], True),
    (13, "SYN Gandhi Nagar Community Kitchen","COMMUNITY_KITCHEN",  90, True,  40, 12.96000, 79.13000, [], True),
    (14, "SYN Sathuvachari Women's Shelter","OTHER",               40, False, 18, 12.94000, 79.16500, ["NON_VEG"], True),
    (15, "SYN Arcot Road Old Age Home",     "OLD_AGE_HOME",        70, True,  30, 12.90500, 79.05500, ["SPICY"], True),
    (16, "SYN Bagayam Boys Home (closed)",  "ORPHANAGE",           50, False, 25, 12.88000, 79.13000, [], False),
]
diet_tags = [
    ("VEG", "Vegetarian"), ("NON_VEG", "Contains meat, fish or poultry"),
    ("CONTAINS_EGG", "Contains egg"), ("CONTAINS_DAIRY", "Contains milk, curd, ghee or paneer"),
    ("CONTAINS_NUTS", "Contains nuts (allergen)"),
    ("CONTAINS_ONION_GARLIC", "Contains onion or garlic"), ("SPICY", "Strongly spiced"),
]
# id, name, risk, ambient, hot, chilled, kg_per_meal
categories = [
    (1, "Rice, dal and sambar",           "MEDIUM", 2.0, 4.0, 24.0, 0.450),
    (2, "Vegetable curry and gravy",      "MEDIUM", 2.0, 4.0, 24.0, 0.300),
    (3, "Non-veg curry",                  "HIGH",   1.5, 3.0, 24.0, 0.300),
    (4, "Breads (chapati, parotta)",      "LOW",    6.0, 6.0, 48.0, 0.200),
    (5, "South Indian breakfast",         "MEDIUM", 3.0, 4.0, 24.0, 0.300),
    (6, "Fried snacks",                   "LOW",    6.0, 6.0, 48.0, 0.150),
    (7, "Sweets and dairy desserts",      "HIGH",   1.5, 2.0, 24.0, 0.150),
    (8, "Cut fruit and salad",            "HIGH",   2.0, 2.0, 12.0, 0.200),
]
CAT = {c[0]: c for c in categories}
CO2E = 2.06   # FAO 2013 global average, see values_source below
SOURCE = ("Safe hours and kg_per_meal: TO VERIFY (planning values, no food-safety "
          "standard cited yet). co2e: FAO 2013 Food Wastage Footprint global average "
          "3.3 Gt CO2e / 1.6 Gt wasted = 2.06 kg/kg; not category-specific, TO VERIFY.")

# dish: id, name, category, tags, slot(s)
dishes = [
    (1, "Idli with sambar", 5, ["VEG", "CONTAINS_ONION_GARLIC"], "BREAKFAST"),
    (2, "Pongal",           5, ["VEG", "CONTAINS_DAIRY", "CONTAINS_NUTS"], "BREAKFAST"),
    (3, "Upma",             5, ["VEG", "CONTAINS_ONION_GARLIC"], "BREAKFAST"),
    (4, "Masala dosa",      5, ["VEG", "CONTAINS_ONION_GARLIC", "SPICY"], "BREAKFAST"),
    (5, "Bread omelette",   4, ["CONTAINS_EGG", "CONTAINS_ONION_GARLIC"], "BREAKFAST"),
    (6, "Steamed rice",     1, ["VEG"], "LUNCH,DINNER"),
    (7, "Sambar rice",      1, ["VEG", "CONTAINS_ONION_GARLIC"], "LUNCH,DINNER"),
    (8, "Dal tadka",        1, ["VEG", "CONTAINS_ONION_GARLIC"], "LUNCH,DINNER"),
    (9, "Curd rice",        1, ["VEG", "CONTAINS_DAIRY"], "LUNCH"),
    (10, "Vegetable kurma", 2, ["VEG", "CONTAINS_ONION_GARLIC", "CONTAINS_NUTS"], "LUNCH,DINNER"),
    (11, "Aloo gobi",       2, ["VEG", "CONTAINS_ONION_GARLIC", "SPICY"], "LUNCH,DINNER"),
    (12, "Paneer butter masala", 2, ["VEG", "CONTAINS_DAIRY", "CONTAINS_ONION_GARLIC"], "DINNER"),
    (13, "Chicken curry",   3, ["NON_VEG", "CONTAINS_ONION_GARLIC", "SPICY"], "LUNCH,DINNER"),
    (14, "Egg curry",       3, ["CONTAINS_EGG", "CONTAINS_ONION_GARLIC", "SPICY"], "LUNCH,DINNER"),
    (15, "Fish fry",        3, ["NON_VEG", "SPICY"], "LUNCH"),
    (16, "Chapati",         4, ["VEG"], "LUNCH,DINNER"),
    (17, "Parotta",         4, ["VEG", "CONTAINS_EGG"], "DINNER"),
    (18, "Samosa",          6, ["VEG", "CONTAINS_ONION_GARLIC", "SPICY"], "SNACKS"),
    (19, "Medu vada",       6, ["VEG", "CONTAINS_ONION_GARLIC"], "SNACKS"),
    (20, "Onion bajji",     6, ["VEG", "CONTAINS_ONION_GARLIC"], "SNACKS"),
    (21, "Semiya payasam",  7, ["VEG", "CONTAINS_DAIRY", "CONTAINS_NUTS"], "LUNCH,DINNER"),
    (22, "Gulab jamun",     7, ["VEG", "CONTAINS_DAIRY"], "DINNER"),
    (23, "Fruit salad",     8, ["VEG"], "LUNCH,SNACKS"),
    (24, "Veg biryani",     1, ["VEG", "CONTAINS_ONION_GARLIC", "SPICY"], "LUNCH,DINNER"),
]
DISH = {d[0]: d for d in dishes}

# (meal start h, meal end h, kg prepared per head, share of capacity)
SLOTS = {
    "BREAKFAST": (7.0,  9.5,  0.25, 0.24),
    "LUNCH":     (12.0, 14.0, 0.45, 0.30),
    "SNACKS":    (16.5, 17.5, 0.12, 0.16),
    "DINNER":    (19.5, 21.5, 0.42, 0.30),
}
SLOT_ORDER = ["BREAKFAST", "LUNCH", "SNACKS", "DINNER"]

# volunteers: name, vehicle, max_load, lat, lon, verified, available
volunteers = [
    ("SYN Volunteer Arjun",   "TWO_WHEELER", 25, 12.9700, 79.1500, True,  True),
    ("SYN Volunteer Bhavya",  "CAR",         80, 12.9620, 79.1410, True,  True),
    ("SYN Volunteer Charan",  "AUTO",        60, 12.9450, 79.1500, True,  True),
    ("SYN Volunteer Divya",   "TWO_WHEELER", 25, 12.9750, 79.1620, True,  True),
    ("SYN Volunteer Eshan",   "VAN",        150, 12.9300, 79.1400, True,  True),
    ("SYN Volunteer Farah",   "CAR",         80, 12.9550, 79.1600, True,  True),
    ("SYN Volunteer Gokul",   "BICYCLE",     12, 12.9690, 79.1570, True,  True),
    ("SYN Volunteer Harini",  "TWO_WHEELER", 25, 12.9800, 79.1450, True,  True),
    ("SYN Volunteer Imran",   "AUTO",        60, 12.9200, 79.1330, True,  True),
    ("SYN Volunteer Janani",  "CAR",         80, 12.9400, 79.1700, True,  True),
    ("SYN Volunteer Karthik", "TWO_WHEELER", 25, 12.9650, 79.1520, False, True),   # ID not verified
    ("SYN Volunteer Lakshmi", "CAR",         80, 12.9500, 79.1350, True,  False),  # unavailable
]
# Stage 6: every synthetic user gets the SAME demo password, "demo1234",
# stored as a real bcrypt hash (cost 12) so the web app's login works.
# Computed once with bcrypt.hashpw(b"demo1234", bcrypt.gensalt(12)) and
# pasted here so the seed stays deterministic. DEMO ONLY: change before
# any real use.
DEMO_HASH = "$2b$12$107mBGl/SnU/2ZkMeRrk5.tR2OUpsiyIdz.67v7sOtnFEgXvPrXgi"

# ------------------------------------------------------------- header
emit("-- =====================================================================")
emit("-- MealBridge : SYNTHETIC SEED DATA            (generated, do not edit)")
emit("-- Generator: tools/gen_seed.py  (random seed 302, deterministic)")
emit("--")
emit("-- *** ALL DATA IN THIS FILE IS SYNTHETIC. ***  Names start with 'SYN',")
emit("-- e-mails use example.org, phones are dummies; every user's password is")
emit("-- the demo password 'demo1234' (bcrypt-hashed). DEMO ONLY.")
emit("-- Food safe-hours are planning values marked TO VERIFY (see")
emit("-- food_category.values_source). Statistics computed from this data")
emit("-- demonstrate the queries; they are NOT evidence about real messes.")
emit("--")
emit("-- Timeline: @d0 = the Monday on or before 30 days ago. History runs to yesterday,")
emit("-- replayed in time order through the real functions and triggers;")
emit("-- 'today' is created with the live procedures (sp_post_batch, ...).")
emit("-- =====================================================================")
emit("USE mealbridge;")
emit("SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;  -- also when run on its own; see 01_schema.sql")
emit("SET SESSION max_sp_recursion_depth = 2;   -- seed_trip falls back to single-batch trips")
emit("-- the Monday on or before 30 days ago, so day 5 and 6 of each week are real weekends")
emit("SET @d0 = CURRENT_DATE - INTERVAL 30 DAY - INTERVAL WEEKDAY(CURRENT_DATE - INTERVAL 30 DAY) DAY;")
emit()

# ------------------------------------------------------------- reference data
emit("-- ---------- reference data ----------")
for i, c in enumerate(campuses, 1):
    emit(f"INSERT INTO campus (campus_id, name, city) VALUES ({i}, {q(c)}, 'Vellore');")
for m in messes:
    emit(f"INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone) VALUES "
         f"({m[0]}, 'MESS', {q(m[1])}, {q('Hostel block ' + m[3] + ', ' + campuses[m[2]-1])}, 'Vellore', '632014', {pt(m[6], m[7])}, '90000000{m[0]:02d}');")
    emit(f"INSERT INTO mess (site_id, campus_id, hostel_block, mess_type, daily_capacity_meals, fssai_license_no) VALUES "
         f"({m[0]}, {m[2]}, {q(m[3])}, {q(m[4])}, {m[5]}, '1000000000{m[0]:04d}');")
for s in shelters:
    emit(f"INSERT INTO site (site_id, site_type, name, address_line, city, pincode, location, contact_phone, is_active) VALUES "
         f"({s[0]}, 'SHELTER', {q(s[1])}, 'SYN address', 'Vellore', '632006', {pt(s[6], s[7])}, '90000000{s[0]:02d}', {str(s[9]).upper()});")
    emit(f"INSERT INTO shelter (site_id, shelter_type, registration_no, beneficiary_count, has_refrigeration, default_capacity_kg) VALUES "
         f"({s[0]}, {q(s[2])}, 'SYN-REG-{s[0]:03d}', {s[3]}, {str(s[4]).upper()}, {s[5]:.2f});")
for t in diet_tags:
    emit(f"INSERT INTO diet_tag VALUES ({q(t[0])}, {q(t[1])});")
for s in shelters:
    for tag in s[8]:
        emit(f"INSERT INTO shelter_diet_exclusion VALUES ({s[0]}, {q(tag)});")
for c in categories:
    emit(f"INSERT INTO food_category (category_id, name, risk_level, safe_hours_ambient, safe_hours_hot_held, "
         f"safe_hours_chilled, kg_per_meal, co2e_kg_per_kg, values_source) VALUES "
         f"({c[0]}, {q(c[1])}, {q(c[2])}, {c[3]}, {c[4]}, {c[5]}, {c[6]}, {CO2E}, {q(SOURCE)});")
for d in dishes:
    emit(f"INSERT INTO menu_item (menu_item_id, name, category_id) VALUES ({d[0]}, {q(d[1])}, {d[2]});")
emit("""INSERT INTO scoring_weight VALUES
 ('NEED',          0.300, 'Share of today''s meals the shelter still lacks'),
 ('FAIRNESS',      0.250, 'Shelters that received less than their share in the last 7 days rank higher'),
 ('DISTANCE',      0.200, 'Closer shelters rank higher (0 at the 15 km service radius)'),
 ('PERISHABILITY', 0.150, 'Trip uses a small part of the food''s remaining safe time'),
 ('CAPACITY',      0.100, 'Best fit: batch fills the shelter''s remaining capacity');""")
emit()

# ------------------------------------------------------------- users
emit("-- ---------- users (demo password demo1234, bcrypt) ----------")
uid = 0
def user(name, email, role, site):
    global uid
    uid += 1
    emit(f"INSERT INTO app_user (user_id, full_name, email, phone, password_hash, role, site_id) VALUES "
         f"({uid}, {q(name)}, {q(email)}, '91000000{uid:02d}', {q(DEMO_HASH)}, {q(role)}, {site if site else 'NULL'});")
    return uid
admins = [user("SYN Platform Admin 1", "admin1@example.org", "PLATFORM_ADMIN", None),
          user("SYN Platform Admin 2", "admin2@example.org", "PLATFORM_ADMIN", None)]
mess_admin = {m[0]: user(f"SYN Mess Admin {m[3]}", f"mess.{m[3].lower()}@example.org", "MESS_ADMIN", m[0]) for m in messes}
shelter_user = {s[0]: user(f"SYN Staff {s[1][4:]}", f"shelter{s[0]}@example.org", "SHELTER", s[0]) for s in shelters}
vol_ids = []
for v in volunteers:
    vid = user(v[0], v[0].split()[-1].lower() + ".vol@example.org", "VOLUNTEER", None)
    vol_ids.append(vid)
    emit(f"INSERT INTO volunteer (user_id, vehicle_type, max_load_kg, home_location, is_available, verified_at) VALUES "
         f"({vid}, {q(v[1])}, {v[2]}, {pt(v[3], v[4])}, {str(v[6]).upper()}, "
         f"{'@d0 - INTERVAL 20 DAY' if v[5] else 'NULL'});")
emit()

# ------------------------------------------------------------- shelter days
emit("-- ---------- shelter_day: need and capacity per day (covers history, today, tomorrow) ----------")
rows = []
for d in range(DAYS + 2):
    for s in shelters:
        need = int(s[3] * random.uniform(0.85, 1.1))
        cap = round(s[5] * random.uniform(0.9, 1.1), 2)
        rows.append(f"({s[0]}, @d0 + INTERVAL {d} DAY, {need}, {cap:.2f})")
for i in range(0, len(rows), 40):
    emit("INSERT INTO shelter_day (shelter_site_id, day, meals_needed, capacity_kg) VALUES\n " + ",\n ".join(rows[i:i+40]) + ";")
emit()

# ------------------------------------------------------------- meal logs
# Calendar effects (all synthetic):
#   weekends: attendance falls (students eat out / go home)
#   days 18-20: a long weekend -> attendance falls sharply, kitchens
#               cook for the usual numbers -> the biggest surplus PEAK
#   day 11: 'hostel day' special dinner at messes 1 and 4 (over-cooked)
#   days 22-26: exams -> breakfast attendance drops (late risers)
def weekday(d):
    # @d0 is always a Monday (see the SET @d0 line), so d % 7 = 5, 6
    # are Saturday and Sunday.
    return d % 7
LONG_WEEKEND = {18, 19, 20}
logs = []
menus = []
leftovers = []  # (day, mess, slot, dish, kg)
for d in range(DAYS):
    for m in messes:
        for slot in SLOT_ORDER:
            start, end, kgph, share = SLOTS[slot]
            if m[4] == "SPECIAL" and slot == "SNACKS":
                continue
            expected = int(m[5] * share * random.uniform(0.95, 1.05))
            att = random.gauss(0.95, 0.03)
            if weekday(d) in (5, 6): att -= 0.10
            if d in LONG_WEEKEND:    att -= 0.22
            if 22 <= d <= 26 and slot == "BREAKFAST": att -= 0.12
            actual = int(expected * max(0.5, min(1.0, att)))
            prep_factor = 1.03 + (0.25 if d == 11 and m[0] in (1, 4) and slot == "DINNER" else 0)
            prepared = round(expected * kgph * prep_factor, 2)
            consumed = actual * kgph * random.gauss(1.0, 0.025)
            leftover = round(max(0.0, min(prepared, prepared - consumed)), 2)
            logs.append(f"({m[0]}, @d0 + INTERVAL {d} DAY, '{slot}', {expected}, {actual}, {prepared:.2f}, {leftover:.2f})")
            # menu: 2-3 dishes allowed for the slot and the mess type
            ok = [x for x in dishes if slot in x[4].split(",")
                  and not (m[4] == "VEG" and ("NON_VEG" in x[3] or "CONTAINS_EGG" in x[3]))]
            if m[4] == "NON_VEG":
                ok_nv = [x for x in ok if x[2] == 3]
            n = 2 if slot in ("BREAKFAST", "SNACKS") else 3
            chosen = random.sample(ok, min(n, len(ok)))
            if m[4] == "NON_VEG" and slot in ("LUNCH", "DINNER") and not any(x[2] == 3 for x in chosen):
                chosen[-1] = random.choice(ok_nv)
            if d == 11 and slot == "DINNER" and m[0] in (1, 4):
                chosen[-1] = DISH[22]
            for x in chosen:
                menus.append(f"({m[0]}, @d0 + INTERVAL {d} DAY, '{slot}', {x[0]})")
            # only food never served from the counter can be re-served:
            # assume 60% of leftover by weight (ASSUMPTION, TO VERIFY)
            postable = leftover * 0.6
            weights = [random.uniform(0.6, 1.4) * (1.6 if x[2] == 1 else 1.0) for x in chosen]
            for x, w in zip(chosen, weights):
                kg = round(postable * w / sum(weights), 2)
                if kg >= 6.0:
                    leftovers.append((d, m, slot, x, kg))
emit("-- ---------- mess_meal_log and mess_menu (~30 days) ----------")
for i in range(0, len(logs), 60):
    emit("INSERT INTO mess_meal_log (mess_site_id, service_date, meal_slot, expected_headcount, actual_headcount, prepared_kg, leftover_kg) VALUES\n "
         + ",\n ".join(logs[i:i+60]) + ";")
for i in range(0, len(menus), 80):
    emit("INSERT INTO mess_menu (mess_site_id, service_date, meal_slot, menu_item_id) VALUES\n " + ",\n ".join(menus[i:i+80]) + ";")
emit()

# ------------------------------------------------------------- seed helpers
emit("""-- ---------- seed-only helper procedures (dropped at the end) ----------
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
""")

# ------------------------------------------------------------- history events
safe_hours = {c[0]: {"AMBIENT": c[3], "HOT_HELD": c[4], "CHILLED": c[5]} for c in categories}
events = []      # (minute, order, sql)
batch_id = 0
pending_trip = []  # batches waiting to be grouped into trips
trip_candidates = []  # (pickup_minute, batch_id, kg, day, slot)
n_post = 0
for (d, m, slot, dish, kg) in leftovers:
    start, end, kgph, share = SLOTS[slot]
    cat = dish[2]
    # storage decision: messes with a blast chiller chill some cooked food
    if cat in (4, 6):
        storage = "AMBIENT"
    elif cat == 7 or cat == 8:
        storage = "CHILLED" if m[8] else "AMBIENT"
    else:
        r = random.random()
        storage = "CHILLED" if (m[8] and r < 0.35) else ("AMBIENT" if r > 0.92 else "HOT_HELD")
    cooked = d * 1440 + (end * 60) - random.uniform(45, 80)      # last cooking wave
    posted = d * 1440 + end * 60 + random.uniform(8, 45)
    packed = posted - random.uniform(4, 12)
    safe_until = cooked + safe_hours[cat][storage] * 60
    if safe_until <= posted + 1:
        continue            # trigger would refuse it: too late to post
    batch_id += 1
    b = batch_id
    desc = f"{dish[1]} ({slot.lower()} leftover)"
    events.append((posted, 0,
        f"INSERT INTO surplus_batch (batch_id, mess_site_id, category_id, posted_by, meal_slot, description, quantity_kg, storage, cooked_at, packed_at, safe_until, created_at) "
        f"SELECT {b}, {m[0]}, {cat}, {mess_admin[m[0]]}, '{slot}', {q(desc)}, {kg:.2f}, '{storage}', {ts(cooked)}, {ts(packed)}, {ts(cooked)} + INTERVAL 1 SECOND, {ts(posted)} "
        f"FROM DUAL WHERE {ts(posted)} < CURRENT_DATE;\n"
        + f"INSERT INTO batch_diet_tag SELECT batch_id, t.tag FROM surplus_batch, (" + " UNION ALL ".join(f"SELECT {q(t)} AS tag" for t in dish[3]) + f") t WHERE batch_id = {b};"))
    # shelter response: late-night posts get slower, sometimes no answer
    hour = (posted % 1440) / 60
    late = hour >= 21.5
    delay = random.lognormvariate(math.log(32 if late else 14), 0.5)
    claim_at = posted + delay
    if (late and random.random() < 0.30) or random.random() < 0.06:
        # nobody responds tonight / missed on a busy day. Food with a long
        # safe window (chilled) can still be claimed next morning.
        next_morning = (d + 1) * 1440 + random.uniform(7.5, 8.5) * 60
        if safe_until - next_morning < 180:
            continue        # no second chance -> will expire
        claim_at = next_morning
    pick = 2 if random.random() < 0.25 else 1
    events.append((claim_at, 1, f"CALL seed_claim({b}, {ts(claim_at)}, {pick});"))
    if random.random() < 0.07:
        cancel_at = claim_at + random.uniform(15, 35)
        events.append((cancel_at, 2, f"CALL seed_cancel({b}, {ts(cancel_at)}, 'no transport available');"))
        re_at = cancel_at + random.uniform(5, 15)
        events.append((re_at, 1, f"CALL seed_claim({b}, {ts(re_at)}, 1);"))
        claim_at = re_at
    trip_candidates.append((claim_at + random.uniform(10, 25), b, kg, int(claim_at // 1440), slot))

# group pickups into trips: same day+slot, pickups within 25 minutes,
# at most 3 batches and 70 kg per trip (PICKUP BATCHING)
trip_candidates.sort()
i = 0
n_trips = 0
while i < len(trip_candidates):
    t0, b0, kg0, d0_, s0 = trip_candidates[i]
    group = [b0]; load = kg0; j = i + 1
    while j < len(trip_candidates) and len(group) < 3:
        t1, b1, kg1, d1, s1 = trip_candidates[j]
        if d1 == d0_ and s1 == s0 and t1 - t0 <= 25 and load + kg1 <= 70 and random.random() < 0.8:
            group.append(b1); load += kg1; j += 1
        else:
            break
    start = max(trip_candidates[k][0] for k in range(i, j))
    fail = group[0] if random.random() < 0.04 else None
    events.append((start, 3, f"CALL seed_trip('{json.dumps(group)}', {ts(start)}, {fail if fail else 'NULL'}, 54.0);"))
    n_trips += 1
    i = j

events.sort(key=lambda e: (e[0], e[1]))
emit(f"-- ---------- history replayed in time order ({batch_id} batches generated; those on/after today are skipped) ----------")
for e in events:
    emit(e[2])
emit()
emit("-- history must end before today: drop meal logs for today or later (menus cascade)")
emit("DELETE FROM mess_meal_log WHERE service_date >= CURRENT_DATE;")
emit()
emit("-- forecasts for the 14 days before today (no alerts), used to measure forecast accuracy")
for d in range(DAYS - 14, DAYS):
    emit(f"CALL seed_forecast(@d0 + INTERVAL {d} DAY);")
emit()
emit("-- history is over: everything nobody could take in time expires now")
emit("CALL sp_expire_batches();")
emit()
emit("DROP PROCEDURE seed_claim;")
emit("DROP PROCEDURE seed_forecast;")
emit("DROP PROCEDURE seed_cancel;")
emit("DROP PROCEDURE seed_trip;")
emit()

# ------------------------------------------------------------- live 'today'
emit("""-- ---------- LIVE 'TODAY': created through the real application procedures ----------
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
""")

OUT.write_text("\n".join(out) + "\n", encoding="utf-8")
print(f"wrote {OUT}: {batch_id} historical batches, {n_trips} trip groups, {len(logs)} meal logs")
