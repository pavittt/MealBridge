# MealBridge

**Project by [pavittt](https://github.com/pavittt)** · BCSE302P Database Systems Lab · Track T5, Waste and Circular Economy

MealBridge matches surplus hostel and mess food with nearby shelters. This folder holds the whole project: the MySQL implementation (schema, synthetic data, procedures, triggers, views, role-based access, with the real output of every demo) and the web application built on it (a FastAPI REST API and a Next.js front end).

> **All data is SYNTHETIC.** Every mess, shelter and person is invented (names start with `SYN`, e-mails use `example.org`). Food safe-hours and the matching constants are planning values marked **TO VERIFY**. Numbers computed from this data show that the SQL works; they are not evidence about real messes.

## 1. Quick start

### 1.1 The database alone

You need MySQL 8.0.16 or newer (tested on **MySQL 8.0.46** and **MySQL 8.4.9** on Windows 11) and an admin login.

```bash
mysql -u root -p --default-character-set=utf8mb4 < sql/setup.sql
```

In PowerShell, which has no `<`, run it as
`mysql -u root -p --default-character-set=utf8mb4 -e "source sql/setup.sql"`.

`setup.sql` also sets the character set itself (`SET NAMES utf8mb4` at the top
of `01_schema.sql`), so it loads cleanly even without the flag. That matters on
Windows, where the `mysql` client connects as `cp850` by default; procedures
and triggers created over a `cp850` connection fail later with
"Illegal mix of collations". Use the flag for your own interactive sessions too.

That one file drops and recreates the `mealbridge` database, loads about 30 days of synthetic history plus a live "today", and creates the four role logins. It takes a few seconds.

Check it worked:

```sql
USE mealbridge;
SELECT * FROM v_impact_summary\G
SELECT * FROM v_live_feed;
```

To rebuild everything and regenerate every output report (Linux or macOS, MySQL reachable as `mysql -uroot`, Python 3):

```bash
bash tools/run_all.sh
```

### 1.2 The web application

Three commands, once:

```bash
mysql -u root -p --default-character-set=utf8mb4 < sql/setup.sql   # 1. the database
pip install -r app/backend/requirements.txt              # 2. the API's packages
cd app/frontend && npm install && cd ../..               # 3. the web app's packages
```

Then every time, one command:

```bash
bash app/run_dev.sh
```

That starts both halves and prints their addresses:

| | |
|---|---|
| **The app** | <http://localhost:3000> |
| API documentation (FastAPI's own, interactive) | <http://localhost:8000/docs> |

Log in with any synthetic user and the demo password **`demo1234`**; the login
page lists accounts for each role and fills the form when you click one. For
example `mess.a@example.org` (mess admin), `shelter9@example.org` (shelter),
`arjun.vol@example.org` (volunteer), `admin1@example.org` (platform admin).

Needs Node 20 or newer and Python 3.10 or newer. If MySQL is not on
`127.0.0.1:3306`, set `MB_DB_HOST` and `MB_DB_PORT` before starting. The
volunteer map's background tiles come from OpenStreetMap, so that one panel
needs internet access; everything else works offline.

**On Windows** (no `bash`), run the two halves in two terminals instead of `run_dev.sh`:

```powershell
cd app\backend
python -m venv .venv
.venv\Scripts\python -m pip install -r requirements.txt
.venv\Scripts\python -m uvicorn mealbridge_api.main:app --port 8000
```

```powershell
cd app\frontend
npm install
npm run dev
```

**On a phone:** with the phone on the same Wi-Fi as the computer running the app,
open `http://<the computer's IP address>:3000` (find the address with
`ipconfig`). Only port 3000 has to be reachable; the website forwards `/api`
calls to the API itself. Some campus Wi-Fi networks block device-to-device
traffic; a phone hotspot avoids that.

**Change the demo passwords before any real use** (both the `demo1234`
application password in `tools/gen_seed.py` and the `mb_*` database passwords in
`sql/08_roles_grants.sql`).

### Demo logins (Stage 5)

| Login | Role | Password (demo only) |
|---|---|---|
| `mb_mess_admin` | `r_mess_admin` | `MessAdmin#Demo2026` |
| `mb_shelter` | `r_shelter` | `Shelter#Demo2026` |
| `mb_volunteer` | `r_volunteer` | `Volunteer#Demo2026` |
| `mb_platform_admin` | `r_platform_admin` | `PlatformAdmin#Demo2026` |

Change these with `ALTER USER ... IDENTIFIED BY ...` before any real use.

## 2. The documents

| Deliverable | File | PDF |
|---|---|---|
| 1. Problem Discovery | `01_problem_discovery.md` | `pdf/MealBridge_01_Problem_Discovery.pdf` |
| 2 and 3. Innovation Proposal and Software Requirements | `02_innovation_and_requirements.md` | `pdf/MealBridge_02-03_Innovation_and_Requirements.pdf` |
| 4. Database Design | `03_database_design.md` | `pdf/MealBridge_04_Database_Design.pdf` |
| 5. Application Prototype | section 8 below, and `app/` | |
| 6. Testing and Validation | `sql/*.output.md` and `app/backend/tests/` | |

Deliverable 2 and 3 carries the requirement IDs (FR-1 to FR-46, NFR-1 to NFR-12),
each with the file that implements it and the test that proves it.

## 3. What is in `sql/`

`setup.sql` is generated from the numbered files 01 and 03 to 08. To change something, edit the numbered file and run `bash tools/rebuild.sh`.

| File | What it is | Real output |
|---|---|---|
| `01_schema.sql` | DDL: 24 tables with all keys and constraints (approved in Stage 3) | |
| `02_constraint_smoke_test.sql` | Stage 3 constraint test, run against the schema alone | `02_...output.txt` |
| `03_functions.sql` | 12 functions: perishability clock, distance, travel time, meals, diet check, the 5 match-score components, `fn_match_score`, hash-chain verifier | |
| `04_procedures.sql` | 12 procedures: matching, concurrency-safe claim, posting, trips, pickup and delivery, auto-expire, forecast, site registration | |
| `05_triggers.sql` | 18 triggers and the `ev_auto_expire` event | |
| `06_views.sql` | 8 views for the live feed and the impact dashboard | |
| `07_seed_synthetic.sql` | Synthetic data, generated by `tools/gen_seed.py` | |
| `08_roles_grants.sql` | Stage 5: 4 roles, their grants, 4 demo logins | |
| `09_demo_views_procs_triggers.sql` | Views, the matching procedure, functions and every trigger in action | `09_...output.md` |
| `10_dml_examples.sql` | 12 INSERT, UPDATE and DELETE examples, each with its reason | `10_...output.md` |
| `11_queries.sql` | 20 queries (joins, nested, aggregate, window), each with a one-line purpose | `11_...output.md` |
| `12_explain_indexes.sql` | EXPLAIN and EXPLAIN ANALYZE before and after each index, on 200,000 rows | `12_...output.md` |
| `13_race_demo.sh` | Two sessions racing for one batch (it picks the two best eligible shelters at run time, so it works on any day's data) | `13_race_demo.output.txt` |
| `tools/rbac_test.py` | Logs in as each role and tries 51 allowed and forbidden actions | `14_rbac_tests.output.md` |

Each `.output.md` shows the SQL and MySQL's real output side by side. They were produced by `tools/run_report.py`, which runs the file in one MySQL session and records exactly what came back.

## 4. How the requirements map to the files

| Requirement | Where | What to show in the viva |
|---|---|---|
| Full DDL | `01_schema.sql` | Composite FK `(site_id, site_type)` for the disjoint specialization; generated `active_batch_id` with UNIQUE |
| Synthetic data | `07_seed_synthetic.sql`, `tools/gen_seed.py` | 6 messes, 10 shelters (1 closed), 12 volunteers, about 490 batches and 380 claims over about 30 days, with weekend and long-weekend peaks |
| DML with reasons | `10_dml_examples.sql` | Supertype then subtype insert; INSERT ... SELECT upsert; multi-table UPDATE; DELETE refused by FK and by trigger; ON DELETE CASCADE |
| 15+ queries | `11_queries.sql` | 20 queries; window functions in Q9 to Q13 and Q18 |
| Impact views | `06_views.sql` | `v_impact_summary`, `v_impact_daily` (meals saved, kg diverted, carbon avoided), `v_response_time`, `v_shelter_fairness`, `v_fairness_index` (Jain's index), `v_mess_leaderboard`, `v_live_feed`, `v_batch_outcome` |
| Matching procedure | `sp_rank_shelters` in `04_procedures.sql` | Section P1 of the 09 output: five component scores, the weighted score, and the reason each excluded shelter is excluded |
| Functions | `03_functions.sql` | Section F1 of the 09 output |
| Triggers: auto-expire, audit, capacity | `05_triggers.sql` | Sections T1 to T13 of the 09 output |
| Locking transaction + race | `sp_claim_batch`, `13_race_demo.sh` | One winner, one rejection, and the lock seen in `performance_schema.data_locks` |
| Indexes with EXPLAIN | `12_explain_indexes.sql` | Full scan vs index range scan, with actual milliseconds |
| Roles and grants | `08_roles_grants.sql`, `tools/rbac_test.py` | 51 of 51 tests pass |

## 5. Design points to explain

**Perishability clock.** `trg_batch_bi` sets `safe_until = cooked_at + safe hours(category, storage)` with `fn_safe_until`, and overwrites whatever the client sent. Food already past its deadline cannot be posted. The deadline inputs are frozen afterwards (`trg_batch_bu`).

**Fair matching.** `fn_match_score` first applies hard filters: diet exclusion, whole batch fits remaining capacity, within 15 km, and reachable before `safe_until` with a 30-minute buffer. It then takes a weighted average of five 0 to 100 scores: need, fairness, distance, perishability and capacity (best fit). The weights live in `scoring_weight`, so policy can change without code, and every change is audited (section P2 of the 09 output).

**Double-claim protection, three layers.**
1. `sp_claim_batch` locks the batch row with `SELECT ... FOR UPDATE`. The second session waits, then re-reads the row under its own lock and is rejected. A locking read always sees the latest committed row, not the transaction's old snapshot.
2. `trg_claim_bi` refuses a claim on a batch that is not `AVAILABLE`.
3. The UNIQUE index on the generated column `claim.active_batch_id`. Race 2 in `13_race_demo.output.txt` shows why it is needed: code that skips the lock passes the trigger check (its snapshot still says `AVAILABLE`) and is stopped only by the unique index, with error 1062.

**Capacity.** `trg_claim_ai` adds the batch's kg to `shelter_day.reserved_kg` and `trg_claim_au` gives it back on cancel or reject. `CHECK (reserved_kg <= capacity_kg)` makes over-filling impossible: the failing CHECK undoes the whole claim INSERT (T5). The trigger updates first and inserts only if the day row is missing, because MySQL checks a CHECK constraint on the row an `INSERT ... ON DUPLICATE KEY UPDATE` tries to insert, before it switches to the update.

**Auto-expire.** A trigger fires only on INSERT, UPDATE or DELETE, never on the clock. So the `ev_auto_expire` event runs `sp_expire_batches()` every 5 minutes, and the batch's AFTER UPDATE trigger writes the EXPIRED custody event at the real deadline. Between runs, `v_live_feed` hides expired food and `trg_claim_bi` refuses it.

**Chain of custody.** Each `custody_event` stores the SHA-256 of the previous event of the same batch plus its own fields. UPDATE and DELETE are blocked by triggers (even for root) and by grants. T13 drops the guard trigger, edits one old note, and `fn_custody_first_bad_event` names the edited event.

**Audit log.** Triggers write `USER()`, the real login, because `CURRENT_USER()` inside a trigger returns the trigger's definer.

**Pickup batching.** `sp_create_trip` plans one trip for several claims: pickups nearest the volunteer first, then drops nearest the last pickup, with ETAs from `LAG()` and a running `SUM() OVER`. It refuses a route on which any batch would arrive after its `safe_until`. This is a simple heuristic, not an optimal route.

**Why can't I claim this?** `sp_explain_my_eligibility(user, batch)` answers for the logged-in shelter only: each hard rule (still available, diet, space left today, 15 km radius, arrival before safe-until with the 30-minute buffer) passes or fails with that shelter's own numbers, then the five score factors with their weights. It calls the same functions as `sp_rank_shelters`, so the explanation cannot disagree with the real decision. The shelter role is granted this procedure and not `sp_rank_shelters`, so MySQL itself stops a shelter reading other shelters' capacity, fairness or scores (role test: DENIED, error 1370).

**Total specialization.** SQL cannot force a SITE row to have a subtype row, so sites are created only through `sp_register_site`, which inserts both in one transaction (P3 in the 09 output).

## 6. Roles (Stage 5)

| Role | Can | Cannot (tested) |
|---|---|---|
| Mess admin | Post and withdraw batches through procedures, log meals, see its batches, claims, forecasts and the impact views | Claim, write batches directly, read e-mails, password hashes, shelter capacity, volunteer data or the audit log, change policy |
| Shelter | Live feed, "why can or can't I claim this?" for its own shelter (`sp_explain_my_eligibility`), claim and cancel through procedures, set its need and capacity, manage diet exclusions | Read the full ranking of all shelters (`sp_rank_shelters`), insert claims directly, touch `reserved_kg`, post batches, read meal logs, phones or the audit log, delete custody history |
| Volunteer | See trips and stops, contact phones, record pickups and deliveries, go on and off duty | Read claims or capacity, change its max load, claim, read e-mails or the audit log, change policy |
| Platform admin | Read everything, manage master data and policy weights, run every procedure | Edit custody or audit history, insert claims directly, drop or alter tables, grant privileges, create logins |

Every write by the first three roles goes through a `SQL SECURITY DEFINER` procedure, so locking and business rules cannot be skipped. Where a direct write is allowed, it is column-level.

**Limitation to state honestly.** MySQL has no row-level security. "A shelter changes only its own rows" is enforced inside the procedures, which check that `p_user_id` has the right role and site (the REFUSED rows in the test report). The web API will connect with one login per role and pass the logged-in user's id; end users never get database logins.

## 7. Known gaps and values to verify

- **TO VERIFY:** safe hours per food category and storage mode, and `kg_per_meal`. These are planning values, recorded in `food_category.values_source`.
- **TO VERIFY:** the carbon factor is one global average, 2.06 kg CO2e per kg of food, from FAO (2013) *Food Wastage Footprint* (3.3 Gt CO2e over 1.6 Gt wasted). It is not category-specific and not specific to cooked food in India.
- **ASSUMPTIONS:** 15 km service radius, 1.4 road detour factor, 20 km/h average speed, 20 minutes handling, 30-minute safety buffer, and "60% of leftover can be re-served" in the data generator. All should be checked in a field trial.
- Fairness on this synthetic data: Jain's index is about 0.87. Small shelters receive more than their share per beneficiary (fair_ratio up to about 1.8) because whole-batch claims and the best-fit capacity score favour them. Tuning the weights is a Stage 7 test (P2 shows how one weight change re-ranks shelters).
- The forecast (same-weekday average over 4 weeks) has a mean absolute error of roughly 35 to 55% on this data (Q17). It is a baseline, not a claim of accuracy.
- Straight-line distance underestimates road distance; a routing API would replace `fn_travel_minutes` later.


## 8. The web application (Stage 6)

The application is in `app/`. The rule it is built around: **no screen holds
data of its own.** Every number, list and status comes from MySQL on each
request, and every write goes through one of the stored procedures.

```
app/
  backend/                        FastAPI REST API (Python)
    mealbridge_api/
      config.py                   one MySQL login per role, read from env vars
      db.py                       the only place SQL is executed; records every statement
      auth.py                     bcrypt login, signed session token, role guards
      hood.py                     what each write does inside MySQL (for the panel)
      common.py                   response envelope + "evidence" reader
      main.py                     the app, error mapping, login routes
      routers/mess.py             post, withdraw, perishability clock, matching preview
      routers/shelter.py          live feed, claim, cancel, capacity
      routers/volunteer.py        pickup queue, trips, pickup and delivery
      routers/admin.py            policy weights, audit log, expiry and forecast jobs
      routers/impact.py           the impact views, and the public landing numbers
      routers/lab.py              race demo, EXPLAIN, custody chain, schema explorer
    tests/test_api.py             15 end-to-end tests against the real database
  frontend/                       Next.js 16 + Tailwind CSS 4 (JavaScript, no TypeScript)
    app/page.jsx                  landing page (live counters, no login)
    app/login/page.jsx            login, with the synthetic demo accounts listed
    app/mess|shelter|volunteer|admin/page.jsx    the four role dashboards
    app/impact/page.jsx           the dashboard, one card per SQL view
    app/lab/race|explain|custody|schema/page.jsx the four database-visible pages
    components/HoodPanel.jsx      the "Under the hood" panel
    components/hero/              the 3D hero (React Three Fiber), lazy-loaded, with a flat fallback
    components/landing/ScrollStory.jsx   scroll story: the real SQL behind each workflow step
    components/motion/            smooth scroll, count-up numbers, animated list rows, motion prefs
    components/Shell.jsx          floating nav bar with every main page, logo, theme switch
    components/SiteIndex.jsx      full-screen "Menu": a numbered index of every page
    components/ui.jsx             countdown ring, status chips, shared pieces
    lib/api.js                    the API client that feeds the panel
  run_dev.sh                      starts both halves
```

### 8.1 How the API uses the database

**One MySQL login per role.** The API never connects as root. A shelter user's
request is served on the `mb_shelter` connection, so MySQL's own grants decide
what that request can reach. A bug in the API cannot give a shelter the mess
admin's rights. Two extra service logins exist: `mb_auth`, which can read only
the login columns of `app_user`, and `mb_public`, which can read only the three
aggregate impact views for the public landing page.

**Writes go through procedures only.** `sp_post_batch`, `sp_claim_batch`,
`sp_create_trip` and the rest run `SQL SECURITY DEFINER` and take `p_user_id`.
MySQL has no row-level security, so each procedure checks that this user has the
right role and site. The end user never gets a database login.

**Errors keep their meaning.** MySQL error 1142 (no privilege) becomes HTTP 403,
1644 (a `SIGNAL` from a procedure or trigger) becomes 400, 3819 (a CHECK
constraint) becomes 400, 1062 (a duplicate key) becomes 409 — and the message the
user sees is MySQL's own.

### 8.2 The database made visible (this is where the marks are)

| Page | What it shows |
|---|---|
| **Under the hood** panel, on every page | The exact SQL that ran for your last action, with milliseconds and row counts; the login and role used; the transaction; the triggers that fire; and the custody and audit rows those triggers actually wrote |
| **Race demo** (`/lab/race`) | Two shelter sessions claim one fresh batch. One wins, one is rejected, with a millisecond timeline and the real `performance_schema.data_locks` rows: session A's lock GRANTED, session B's WAITING |
| **EXPLAIN** (`/lab/explain`) | Five queries the app really runs, each with and without its index (`IGNORE INDEX`, so nothing is dropped). Row counts and `EXPLAIN ANALYZE` times are MySQL's own: full scan vs range or ref |
| **Audit trail** (`/lab/custody`) | The chain of custody of any batch, event by event, with each row's hash and the previous row's, and the verdict of `fn_custody_first_bad_event` |
| **Schema explorer** (`/lab/schema`) | Tables, columns, keys, CHECK constraints and indexes read live from `information_schema`; the source of every procedure, function, trigger and view with its design comment; and the six ER diagrams |
| **Impact dashboard** (`/impact`) | One card per SQL view, named on the card. A view your role is not granted shows as locked with MySQL's refusal, which makes the grants visible |

### 8.3 The screens

| Screen | What the database does |
|---|---|
| Landing page | Live counters from `v_impact_summary` and `v_impact_daily` through the `mb_public` login; no login needed. A scroll story shows the real SQL behind Post, Match, Claim and Deliver, and four cards link to the database pages |
| Login | `mb_auth` reads the bcrypt hash; the API compares it and signs a token carrying user, role and site |
| Mess admin | Post surplus (`sp_post_batch`), live perishability rings from the deadline the trigger set, who claimed each batch, "Who gets this?" runs `sp_rank_shelters`, withdraw (`sp_cancel_batch`), forecast rows, 14-day history from `v_batch_outcome` |
| Shelter | `v_live_feed` ranked by `fn_match_score` for this shelter, "Why?" shows all five components and the exclusion reasons, one-click claim (`sp_claim_batch`), capacity bar kept by `trg_claim_ai` |
| Volunteer | `v_pickup_queue` (the role cannot read `claim` at all), multi-stop trip from `sp_create_trip` with ETAs from window functions, pickup and delivery with temperature and hygiene check |
| Platform admin | Matching weights (a change is audited by `trg_weight_au`), the audit log with the real `USER()` per row, manual runs of the expiry job and the forecast |
| Light mode and phone | The same pages; dark ("Night") is the default look and the Paper/Night button in the nav switches |

### 8.3a The polish layer (3D and animation)

Added after the core screens were working, and kept away from the data: no
animation changes what a screen reads or writes.

| Piece | Where | What it does |
|---|---|---|
| 3D hero | `components/hero/HeroScene.jsx` | A small town on a round table: saffron messes send parcels along arcs to green shelters, which pulse on arrival. Labelled on the page as an illustrative scene, not data |
| Scroll story | `components/landing/ScrollStory.jsx` | Pinned panel that steps through Post, Match, Claim, Deliver as you scroll (GSAP ScrollTrigger), each with the real excerpt from `trg_batch_bi`, `fn_match_score`, `sp_claim_batch` and `trg_custody_bi`. If those files change, update the excerpts |
| Smooth scroll | `components/motion/SmoothScroll.jsx` | Lenis, on the landing page only, driven by GSAP's clock so the two never drift |
| Counting numbers | `components/motion/CountUp.jsx` | The live counters count up from 0 to the value MySQL returned; screen readers get the final value |
| Page transitions | `components/Shell.jsx` | Each page fades and rises in (Motion) |
| Live lists | `components/motion/ListItem.jsx` | A claimed or expired batch slides out of the shelter feed and mess list, so the state change MySQL made is visible |
| Under the hood counter | `components/Shell.jsx` | Pops each time a new SQL call is recorded, drawing the eye to the evidence |

Look ("night kitchen", the redesign of 5 to 6 October 2026): warm espresso
neutrals with one saffron accent (green only means "food saved"), Fraunces serif
headlines with an italic accent phrase, Geist for text and Geist Mono for SQL and
numbers, and a cream "Paper" light theme. The landing page is laid out like an
editorial site: the 3D town fills the first screen behind a full-width
**MealBridge** wordmark, a ticker runs every live figure from `v_impact_summary`,
and an "Every page" index lists all nine pages. A floating nav bar shows every
main page, and the **Menu** button opens a full-screen index of every page on any
screen size (with log in or log out). The logo is a saffron tile with a bridge
and a green grain of food (`LogoMark` in `components/Shell.jsx`, also
`app/icon.svg`).

Bug fixed in this pass: `useRequireRole` (`components/ui.jsx`) returned a new
user object on every render, so each dashboard re-ran its load effect in a
loop and sent hundreds of API requests a minute. It now keeps the user in
state; a dashboard sends its requests once, then only on its refresh timer.

Performance and access:

- three.js is a separate chunk loaded only on the landing page, after the text
  has rendered. Fewer than 40 meshes, no textures, no shadows, pixel ratio capped
  at 1.75, and the render loop stops when the hero is scrolled off screen.
- With `prefers-reduced-motion`, the 3D scene is drawn once and stands still,
  the scroll story becomes a plain list, smooth scroll is off and nothing slides.
- Without WebGL (an old or locked-down lab PC) the flat SVG drawing is shown.
- Frame rate: not measured on real hardware yet. In this build environment the
  browser had only software rendering (SwiftShader, no GPU) and reached about
  23 frames per second, which says little about a laptop with a GPU. **TO
  MEASURE:** open the landing page on the demo laptop, press F12, Performance
  panel, record 5 seconds, and note the FPS.

### 8.4 Tests

```bash
cd app/backend && python -m pytest -v      # 15 tests, against the real database (14 pass, 1 skipped)
```

They walk the whole workflow the way the UI does: a mess posts, the trigger sets
the deadline, a shelter claims, a second shelter is rejected, a volunteer plans a
trip, picks up and delivers, and the custody chain verifies. They also check that
MySQL refuses what a role may not do (a mess admin reading the fairness view, a
shelter cutting its capacity below what is reserved), that the race has exactly
one winner, and that the EXPLAIN page really shows a full scan becoming an index
range scan. Together with `tools/rbac_test.py` (67 of 67) that is 81 automated
checks.

### 8.5 What Stage 6 added to the database

Three small additions, all in the numbered files, so `bash tools/rebuild.sh`
rebuilds them:

- `v_pickup_queue` and `v_trip_manifest` (`06_views.sql`): what a volunteer needs
  to route a trip, without granting the volunteer role `SELECT` on `claim`.
- Two service roles `r_auth` and `r_public` with their logins, plus
  `EXECUTE` on `fn_match_score` for shelters and read access to
  `performance_schema.data_locks` for the platform admin, which is what the race
  page displays (`08_roles_grants.sql`).
- The synthetic users' password hashes are now real bcrypt hashes of the demo
  password `demo1234` (`tools/gen_seed.py`), so the login screen works. They were
  fixed strings before.

### 8.6 Honest limits of the prototype

- Session tokens are signed, not encrypted, and the signing secret is regenerated
  at every restart unless `MB_SECRET` is set. Fine for a demo, not for deployment.
- Demo passwords are in the repository on purpose, so an examiner can log in.
- `notification` rows are written but nothing sends SMS or e-mail.
- The volunteer map draws straight lines between stops: the stop order and ETAs
  come from `sp_create_trip`'s heuristic, not from a routing service.
- The "Under the hood" panel's trigger list is written from the trigger source in
  `hood.py`; the custody and audit rows shown beside it are read back from the
  database, so that part is evidence rather than description.

---

## 9. Tools

| Script | Purpose |
|---|---|
| `tools/rebuild.sh` | Regenerates the seed, rebuilds `sql/setup.sql`, loads it |
| `tools/run_all.sh` | `rebuild.sh` plus every demo and report |
| `tools/gen_seed.py` | Deterministic synthetic data generator (random seed 302) |
| `tools/run_report.py` | Runs a demo `.sql` file and writes its real output as `.output.md` and `.output.txt` |
| `tools/rbac_test.py` | Stage 5 role tests |
| `tools/build_pdfs.py` | Builds the PDF reports from the Markdown documents |
| `app/run_dev.sh` | Starts the API and the web app together (section 8) |

## 10. Changelog

**7 October 2026, lighter screens** (requested from screenshots)

- Removed the small label pills above titles (role names, "Database lab", the
  course tag on the landing page, "Follow one batch").
- Removed the view and login captions next to charts and figures (`v_impact_daily`,
  `v_batch_outcome`, `mb_public` and similar) and the synthetic-data and TO VERIFY
  footnotes on every page. The SYN names and TO VERIFY markers are unchanged in the
  database (`food_category.values_source`) and in the documents.
- Landing page: shorter statement, and the page now ends at the "Every page" list.
- Mess dashboard: the 14-day chart prints the kilograms on every bar.

**6 October 2026, fix-and-check pass** (every page, both themes, desktop and phone width)

- Schema explorer: the ER diagrams and the procedure, function, trigger and view
  source were empty on a fresh copy, because `diagrams/` and the numbered `sql/`
  files were missing next to `setup.sql`. Both are in the repository; the API reads them.
- Phones: pages no longer stretch sideways (grid items now shrink), the nav fits, and
  Log out moved into the Menu; the 3D town gets its own square instead of sitting behind text.
- The volunteer map no longer paints over the nav and panels.
- Schema tables: columns spaced, keys on one line, table names keep the code font;
  object descriptions no longer start mid-sentence.
- Impact charts: shelter names no longer overlap.
- Shelter feed: the label under the score said "rank 1" while "Why?" ranked that
  shelter lower; it now says it is the feed position.
- EXPLAIN: says "same time at this table size" instead of "1.0x faster".
- Consistent date format on the audit trail; "trip completed" in sentence case.
- Checked against MySQL: race (one winner), matching scores (`sp_rank_shelters`),
  impact totals. Backend tests 14 passed, 1 skipped; role tests 67 of 67.

**5 to 6 October 2026, redesign**: the "night kitchen" look, the new logo, the
editorial landing page and the full-screen Menu described in section 8.3a.

**5 October 2026, first full version**: the documents, the MySQL implementation,
the role-based access, and the web application (Stages 1 to 6).
