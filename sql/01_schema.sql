-- =====================================================================
-- MealBridge : relational schema (DDL)                 Stage 3 deliverable
-- Target: MySQL 8.0.16+ (needs CHECK constraints, SRID-aware spatial
--         indexes, generated columns, window functions later on).
--
-- Reading guide for the viva:
--   * Every table states its primary key, candidate keys (UNIQUE) and
--     foreign keys explicitly. Business rules that fit in a single row
--     are CHECK constraints; rules that span tables (e.g. "a mess admin
--     must belong to a MESS site") are enforced by triggers in Stage 4.
--   * Comments marked [FD] list the functional dependencies used in the
--     normalization write-up (03_database_design.md, section 5).
--   * Comments marked [IDX] point to the indexing strategy (section 6).
--   * Two columns are deliberate, trigger-maintained denormalizations:
--       surplus_batch.safe_until  and  shelter_day.reserved_kg
--     Both are justified in section 5.4 of the design document.
-- =====================================================================

-- Force the connection character set, whatever the client defaults to.
-- The Windows mysql client connects as cp850 (the console code page).
-- Procedures, functions and triggers remember the connection character set
-- they were created under, so under cp850 their string literals become
-- cp850 and comparing them with utf8mb4 columns fails with
-- "Illegal mix of collations". SET NAMES makes setup.sql safe to load
-- from any client, with or without --default-character-set=utf8mb4.
SET NAMES utf8mb4 COLLATE utf8mb4_0900_ai_ci;

DROP DATABASE IF EXISTS mealbridge;
CREATE DATABASE mealbridge
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE mealbridge;

-- ---------------------------------------------------------------------
-- 1. CAMPUS : a university campus that runs one or more messes.
-- [FD] campus_id -> name, city ;  name -> campus_id (candidate key)
-- ---------------------------------------------------------------------
CREATE TABLE campus (
  campus_id   SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(120) NOT NULL,
  city        VARCHAR(80)  NOT NULL,
  CONSTRAINT uq_campus_name UNIQUE (name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. SITE : EER superclass of every physical location food moves between.
--    Specialization {MESS, SHELTER} is DISJOINT and TOTAL: each site is
--    exactly one of the two, recorded by the discriminator site_type.
--    location is a geographic POINT (SRID 4326 = WGS-84 lat/long) so we
--    can use ST_Distance_Sphere() and a SPATIAL index for "nearby" search.
-- [FD] site_id -> site_type, name, address_line, city, pincode,
--                 location, contact_phone, is_active, created_at
-- ---------------------------------------------------------------------
CREATE TABLE site (
  site_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  site_type      ENUM('MESS','SHELTER') NOT NULL,
  name           VARCHAR(150) NOT NULL,
  address_line   VARCHAR(255) NOT NULL,
  city           VARCHAR(80)  NOT NULL,
  pincode        CHAR(6)      NOT NULL,
  location       POINT        NOT NULL SRID 4326,
  contact_phone  VARCHAR(15)  NOT NULL,
  is_active      BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_site_pincode CHECK (pincode REGEXP '^[1-9][0-9]{5}$'),
  CONSTRAINT chk_site_phone   CHECK (contact_phone REGEXP '^\\+?[0-9]{10,14}$'),
  -- Composite candidate key used as the target of the subtype FKs below,
  -- so a MESS row can only ever point at a site whose type is 'MESS'.
  CONSTRAINT uq_site_id_type UNIQUE (site_id, site_type),
  SPATIAL INDEX sx_site_location (location)                     -- [IDX-1]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. MESS : subclass of SITE (hostel / institutional kitchen = donor).
--    site_type is pinned to 'MESS' by a generated column + composite FK.
--    This makes the disjointness of the specialization a DB guarantee.
-- [FD] site_id -> campus_id, hostel_block, mess_type,
--                 daily_capacity_meals, fssai_license_no
--      fssai_license_no -> site_id  (candidate key)
-- ---------------------------------------------------------------------
CREATE TABLE mess (
  site_id               INT UNSIGNED PRIMARY KEY,
  site_type             ENUM('MESS','SHELTER')
                          GENERATED ALWAYS AS ('MESS') STORED,
  campus_id             SMALLINT UNSIGNED NOT NULL,
  hostel_block          VARCHAR(40)  NOT NULL,
  mess_type             ENUM('VEG','NON_VEG','MIXED','SPECIAL') NOT NULL,
  daily_capacity_meals  INT UNSIGNED NOT NULL,
  fssai_license_no      CHAR(14)     NOT NULL,   -- FSSAI licence numbers are 14 digits
  CONSTRAINT uq_mess_fssai UNIQUE (fssai_license_no),
  CONSTRAINT chk_mess_capacity CHECK (daily_capacity_meals > 0),
  CONSTRAINT chk_mess_fssai CHECK (fssai_license_no REGEXP '^[0-9]{14}$'),
  CONSTRAINT fk_mess_site FOREIGN KEY (site_id, site_type)
    REFERENCES site (site_id, site_type),
  CONSTRAINT fk_mess_campus FOREIGN KEY (campus_id)
    REFERENCES campus (campus_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. SHELTER : subclass of SITE (recipient organisation).
-- [FD] site_id -> shelter_type, registration_no, beneficiary_count,
--                 has_refrigeration, default_capacity_kg
--      registration_no -> site_id (candidate key)
-- ---------------------------------------------------------------------
CREATE TABLE shelter (
  site_id              INT UNSIGNED PRIMARY KEY,
  site_type            ENUM('MESS','SHELTER')
                         GENERATED ALWAYS AS ('SHELTER') STORED,
  shelter_type         ENUM('ORPHANAGE','OLD_AGE_HOME','HOMELESS_SHELTER',
                            'HOSPITAL_ATTENDANTS','COMMUNITY_KITCHEN',
                            'OTHER') NOT NULL,
  registration_no      VARCHAR(40)  NOT NULL,  -- NGO / Darpan / trust reg. no.
  beneficiary_count    INT UNSIGNED NOT NULL,
  has_refrigeration    BOOLEAN      NOT NULL DEFAULT FALSE,
  default_capacity_kg  DECIMAL(7,2) NOT NULL,  -- how much cooked food it can take per day
  CONSTRAINT uq_shelter_reg UNIQUE (registration_no),
  CONSTRAINT chk_shelter_benef CHECK (beneficiary_count > 0),
  CONSTRAINT chk_shelter_cap   CHECK (default_capacity_kg > 0),
  CONSTRAINT fk_shelter_site FOREIGN KEY (site_id, site_type)
    REFERENCES site (site_id, site_type)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. DIET_TAG : lookup of dietary characteristics (VEG, CONTAINS_EGG, ...).
--    Used twice: what a batch CONTAINS, and what a shelter EXCLUDES.
-- [FD] tag_code -> description
-- ---------------------------------------------------------------------
CREATE TABLE diet_tag (
  tag_code     VARCHAR(30) PRIMARY KEY,
  description  VARCHAR(200) NOT NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. SHELTER_DIET_EXCLUSION : multivalued attribute of SHELTER, moved to
--    its own table to satisfy 1NF ("no beef, no onion/garlic" etc).
-- [FD] none beyond the trivial one; the whole row is the key (BCNF).
-- ---------------------------------------------------------------------
CREATE TABLE shelter_diet_exclusion (
  shelter_site_id  INT UNSIGNED NOT NULL,
  tag_code         VARCHAR(30)  NOT NULL,
  PRIMARY KEY (shelter_site_id, tag_code),
  CONSTRAINT fk_sde_shelter FOREIGN KEY (shelter_site_id)
    REFERENCES shelter (site_id) ON DELETE CASCADE,
  CONSTRAINT fk_sde_tag FOREIGN KEY (tag_code)
    REFERENCES diet_tag (tag_code)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. APP_USER : every login. role drives the MySQL role it maps to
--    (Stage 5). MESS_ADMIN / SHELTER users belong to exactly one site;
--    VOLUNTEER / PLATFORM_ADMIN users belong to none (row-level CHECK).
--    "site type matches role" spans two tables -> trigger in Stage 4.
-- [FD] user_id -> full_name, email, phone, password_hash, role,
--                 site_id, is_active, created_at
--      email -> user_id (candidate key)
-- ---------------------------------------------------------------------
CREATE TABLE app_user (
  user_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name      VARCHAR(120) NOT NULL,
  email          VARCHAR(190) NOT NULL,
  phone          VARCHAR(15)  NOT NULL,
  password_hash  CHAR(60)     NOT NULL,          -- bcrypt output, never plain text
  role           ENUM('MESS_ADMIN','SHELTER','VOLUNTEER','PLATFORM_ADMIN') NOT NULL,
  site_id        INT UNSIGNED NULL,
  is_active      BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_user_email UNIQUE (email),
  CONSTRAINT chk_user_email CHECK (email LIKE '%_@_%._%'),
  CONSTRAINT chk_user_site_by_role CHECK (
       (role IN ('MESS_ADMIN','SHELTER')         AND site_id IS NOT NULL)
    OR (role IN ('VOLUNTEER','PLATFORM_ADMIN')   AND site_id IS NULL)),
  CONSTRAINT fk_user_site FOREIGN KEY (site_id) REFERENCES site (site_id),
  INDEX ix_user_site (site_id)                                  -- [IDX-2]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 8. VOLUNTEER : subclass of APP_USER (partial specialization: only
--    users with role VOLUNTEER have a row). Extra attributes for routing.
-- [FD] user_id -> vehicle_type, max_load_kg, home_location,
--                 is_available, verified_at
-- ---------------------------------------------------------------------
CREATE TABLE volunteer (
  user_id        INT UNSIGNED PRIMARY KEY,
  vehicle_type   ENUM('BICYCLE','TWO_WHEELER','AUTO','CAR','VAN') NOT NULL,
  max_load_kg    DECIMAL(6,2) NOT NULL,
  home_location  POINT NOT NULL SRID 4326,
  is_available   BOOLEAN NOT NULL DEFAULT TRUE,
  verified_at    DATETIME NULL,                   -- NULL = ID not yet verified
  CONSTRAINT chk_vol_load CHECK (max_load_kg > 0),
  CONSTRAINT fk_vol_user FOREIGN KEY (user_id)
    REFERENCES app_user (user_id) ON DELETE CASCADE,
  SPATIAL INDEX sx_vol_home (home_location)                     -- [IDX-3]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 9. FOOD_CATEGORY : reference data that drives the PERISHABILITY CLOCK.
--    safe_hours_* values MUST be sourced from food-safety guidance before
--    real use. Seed values in Stage 4 will be marked UNVERIFIED.
--    co2e_kg_per_kg is the emission factor for "carbon avoided"; it is
--    NULL until a cited factor is entered (no invented numbers).
-- [FD] category_id -> name, risk_level, safe_hours_ambient,
--                     safe_hours_hot_held, safe_hours_chilled,
--                     kg_per_meal, co2e_kg_per_kg, values_source
--      name -> category_id (candidate key)
-- ---------------------------------------------------------------------
CREATE TABLE food_category (
  category_id          SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name                 VARCHAR(80) NOT NULL,
  risk_level           ENUM('LOW','MEDIUM','HIGH') NOT NULL,
  safe_hours_ambient   DECIMAL(4,1) NOT NULL,
  safe_hours_hot_held  DECIMAL(4,1) NOT NULL,
  safe_hours_chilled   DECIMAL(4,1) NOT NULL,
  kg_per_meal          DECIMAL(4,3) NOT NULL,   -- converts kg to meal-equivalents
  co2e_kg_per_kg       DECIMAL(6,3) NULL,
  -- Where the numbers above came from. Seed rows say 'TO VERIFY ...' so
  -- an unsourced value can never be mistaken for a cited one (Stage 4).
  values_source        VARCHAR(255) NOT NULL DEFAULT 'TO VERIFY: no source cited',
  CONSTRAINT uq_category_name UNIQUE (name),
  CONSTRAINT chk_cat_hours CHECK (
        safe_hours_ambient  > 0
    AND safe_hours_hot_held > 0
    AND safe_hours_chilled  >= safe_hours_ambient),
  CONSTRAINT chk_cat_meal CHECK (kg_per_meal > 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 10. SURPLUS_BATCH : one posting of surplus cooked food by a mess.
--     safe_until = cooked_at + safe_hours(category, storage). It is a
--     SNAPSHOT taken by a BEFORE INSERT trigger (Stage 4), so later edits
--     to food_category never silently change an already-posted deadline.
--     A batch is claimed WHOLE (no partial claims) - see design doc 4.3.
-- [FD] batch_id -> mess_site_id, category_id, posted_by, meal_slot,
--                  description, quantity_kg, storage, cooked_at,
--                  packed_at, safe_until, status, created_at
-- ---------------------------------------------------------------------
CREATE TABLE surplus_batch (
  batch_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  mess_site_id  INT UNSIGNED NOT NULL,
  category_id   SMALLINT UNSIGNED NOT NULL,
  posted_by     INT UNSIGNED NOT NULL,
  meal_slot     ENUM('BREAKFAST','LUNCH','SNACKS','DINNER') NOT NULL,
  description   VARCHAR(255) NOT NULL,
  quantity_kg   DECIMAL(7,2) NOT NULL,
  storage       ENUM('AMBIENT','HOT_HELD','CHILLED') NOT NULL,
  cooked_at     DATETIME NOT NULL,
  packed_at     DATETIME NULL,
  safe_until    DATETIME NOT NULL,
  status        ENUM('AVAILABLE','CLAIMED','IN_TRANSIT','DELIVERED',
                     'EXPIRED','CANCELLED') NOT NULL DEFAULT 'AVAILABLE',
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_batch_qty    CHECK (quantity_kg > 0 AND quantity_kg <= 2000),
  CONSTRAINT chk_batch_order  CHECK (cooked_at <= created_at),
  CONSTRAINT chk_batch_pack   CHECK (packed_at IS NULL OR packed_at >= cooked_at),
  CONSTRAINT chk_batch_expiry CHECK (safe_until > cooked_at),
  CONSTRAINT fk_batch_mess FOREIGN KEY (mess_site_id) REFERENCES mess (site_id),
  CONSTRAINT fk_batch_cat  FOREIGN KEY (category_id)  REFERENCES food_category (category_id),
  CONSTRAINT fk_batch_user FOREIGN KEY (posted_by)    REFERENCES app_user (user_id),
  -- Live feed + auto-expire job: "status = AVAILABLE ordered by deadline"
  INDEX ix_batch_status_deadline (status, safe_until),          -- [IDX-4]
  -- Mess dashboard / history: "this mess's batches, newest first"
  INDEX ix_batch_mess_created (mess_site_id, created_at)        -- [IDX-5]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 11. BATCH_DIET_TAG : multivalued attribute of SURPLUS_BATCH (1NF).
--     Matching rule: a shelter may receive a batch only if NO tag of the
--     batch appears in that shelter's exclusion list (NOT EXISTS query).
-- ---------------------------------------------------------------------
CREATE TABLE batch_diet_tag (
  batch_id  INT UNSIGNED NOT NULL,
  tag_code  VARCHAR(30)  NOT NULL,
  PRIMARY KEY (batch_id, tag_code),
  CONSTRAINT fk_bdt_batch FOREIGN KEY (batch_id)
    REFERENCES surplus_batch (batch_id) ON DELETE CASCADE,
  CONSTRAINT fk_bdt_tag FOREIGN KEY (tag_code) REFERENCES diet_tag (tag_code),
  INDEX ix_bdt_tag (tag_code)                                   -- [IDX-6]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 12. SHELTER_DAY : per-shelter, per-day need and capacity.
--     reserved_kg is maintained by triggers on CLAIM (Stage 4) and the
--     CHECK below makes over-filling a shelter impossible at DB level.
-- [FD] (shelter_site_id, day) -> meals_needed, capacity_kg, reserved_kg
-- ---------------------------------------------------------------------
CREATE TABLE shelter_day (
  shelter_site_id  INT UNSIGNED NOT NULL,
  day              DATE NOT NULL,
  meals_needed     INT UNSIGNED NOT NULL,
  capacity_kg      DECIMAL(7,2) NOT NULL,
  reserved_kg      DECIMAL(7,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (shelter_site_id, day),
  CONSTRAINT chk_sd_cap CHECK (capacity_kg > 0),
  CONSTRAINT chk_sd_reserved CHECK (reserved_kg >= 0 AND reserved_kg <= capacity_kg),
  CONSTRAINT fk_sd_shelter FOREIGN KEY (shelter_site_id) REFERENCES shelter (site_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 13. CLAIM : a shelter claiming a batch.
--     DOUBLE-CLAIM GUARD, layer 2 (layer 1 is SELECT ... FOR UPDATE in the
--     claim procedure): active_batch_id equals batch_id while the claim is
--     live and NULL otherwise. A UNIQUE index on it means at most ONE live
--     claim per batch, because UNIQUE ignores NULLs. This emulates a
--     partial unique index, which MySQL does not support directly.
--     match_score and distance_km are snapshots of the score at claim
--     time (for the fairness audit), not values derivable later.
-- [FD] claim_id -> batch_id, shelter_site_id, claimed_by, claimed_at,
--                  match_score, distance_km, status, closed_at,
--                  close_reason
--      (batch_id, status) -> active_batch_id   (generated column)
-- ---------------------------------------------------------------------
CREATE TABLE claim (
  claim_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  batch_id         INT UNSIGNED NOT NULL,
  shelter_site_id  INT UNSIGNED NOT NULL,
  claimed_by       INT UNSIGNED NOT NULL,
  claimed_at       DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  match_score      DECIMAL(5,2) NOT NULL,
  distance_km      DECIMAL(6,2) NOT NULL,
  status           ENUM('ACTIVE','FULFILLED','CANCELLED','REJECTED')
                     NOT NULL DEFAULT 'ACTIVE',
  closed_at        DATETIME(3)  NULL,
  close_reason     VARCHAR(255) NULL,
  active_batch_id  INT UNSIGNED
                     GENERATED ALWAYS AS
                     (IF(status IN ('ACTIVE','FULFILLED'), batch_id, NULL)) STORED,
  CONSTRAINT uq_claim_one_live_per_batch UNIQUE (active_batch_id),
  CONSTRAINT chk_claim_score CHECK (match_score BETWEEN 0 AND 100),
  CONSTRAINT chk_claim_dist  CHECK (distance_km >= 0),
  CONSTRAINT chk_claim_close CHECK (
       (status = 'ACTIVE' AND closed_at IS NULL)
    OR (status <> 'ACTIVE' AND closed_at IS NOT NULL)),
  CONSTRAINT fk_claim_batch   FOREIGN KEY (batch_id)        REFERENCES surplus_batch (batch_id),
  CONSTRAINT fk_claim_shelter FOREIGN KEY (shelter_site_id) REFERENCES shelter (site_id),
  CONSTRAINT fk_claim_user    FOREIGN KEY (claimed_by)      REFERENCES app_user (user_id),
  -- Fairness and impact views group by shelter over a time window
  INDEX ix_claim_shelter_time (shelter_site_id, claimed_at),    -- [IDX-7]
  INDEX ix_claim_batch (batch_id)                               -- [IDX-8]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 14. PICKUP_TRIP : one volunteer run that may cover several messes and
--     several shelters (pickup batching).
-- [FD] trip_id -> volunteer_id, status, planned_start, started_at,
--                 completed_at, planned_distance_km
-- ---------------------------------------------------------------------
CREATE TABLE pickup_trip (
  trip_id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  volunteer_id         INT UNSIGNED NOT NULL,
  status               ENUM('PLANNED','IN_PROGRESS','COMPLETED','ABORTED')
                         NOT NULL DEFAULT 'PLANNED',
  planned_start        DATETIME NOT NULL,
  started_at           DATETIME NULL,
  completed_at         DATETIME NULL,
  planned_distance_km  DECIMAL(6,2) NULL,
  CONSTRAINT chk_trip_times CHECK (
        (started_at IS NULL OR started_at >= planned_start - INTERVAL 1 DAY)
    AND (completed_at IS NULL OR (started_at IS NOT NULL AND completed_at >= started_at))),
  CONSTRAINT fk_trip_vol FOREIGN KEY (volunteer_id) REFERENCES volunteer (user_id),
  INDEX ix_trip_vol_status (volunteer_id, status)               -- [IDX-9]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 15. TRIP_STOP : WEAK ENTITY owned by PICKUP_TRIP. Identified by
--     (trip_id, stop_seq): stop 1, 2, 3 ... of that trip.
-- [FD] (trip_id, stop_seq) -> site_id, stop_type, planned_eta,
--                             arrived_at, departed_at
-- ---------------------------------------------------------------------
CREATE TABLE trip_stop (
  trip_id      INT UNSIGNED NOT NULL,
  stop_seq     TINYINT UNSIGNED NOT NULL,
  site_id      INT UNSIGNED NOT NULL,
  stop_type    ENUM('PICKUP','DROP') NOT NULL,
  planned_eta  DATETIME NOT NULL,
  arrived_at   DATETIME NULL,
  departed_at  DATETIME NULL,
  PRIMARY KEY (trip_id, stop_seq),
  CONSTRAINT chk_stop_seq CHECK (stop_seq BETWEEN 1 AND 20),
  CONSTRAINT chk_stop_times CHECK (
    departed_at IS NULL OR (arrived_at IS NOT NULL AND departed_at >= arrived_at)),
  CONSTRAINT fk_stop_trip FOREIGN KEY (trip_id)
    REFERENCES pickup_trip (trip_id) ON DELETE CASCADE,
  CONSTRAINT fk_stop_site FOREIGN KEY (site_id) REFERENCES site (site_id),
  INDEX ix_stop_site (site_id)                                  -- [IDX-10]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 16. TRIP_ITEM : which claims a trip carries, and at which stops each one
--     is picked up and dropped. CHECK guarantees pickup happens before drop.
--     That the pickup stop's site is the batch's mess (and the drop stop's
--     site is the claiming shelter) spans 4 tables -> trigger in Stage 4.
-- [FD] (trip_id, claim_id) -> pickup_seq, drop_seq
-- ---------------------------------------------------------------------
CREATE TABLE trip_item (
  trip_id     INT UNSIGNED NOT NULL,
  claim_id    INT UNSIGNED NOT NULL,
  pickup_seq  TINYINT UNSIGNED NOT NULL,
  drop_seq    TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (trip_id, claim_id),
  CONSTRAINT chk_item_order CHECK (pickup_seq < drop_seq),
  CONSTRAINT fk_item_pickup FOREIGN KEY (trip_id, pickup_seq)
    REFERENCES trip_stop (trip_id, stop_seq),
  CONSTRAINT fk_item_drop FOREIGN KEY (trip_id, drop_seq)
    REFERENCES trip_stop (trip_id, stop_seq),
  CONSTRAINT fk_item_claim FOREIGN KEY (claim_id) REFERENCES claim (claim_id),
  INDEX ix_item_claim (claim_id)                                -- [IDX-11]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 17. CUSTODY_EVENT : append-only food-safety chain of custody.
--     row_hash = SHA2(prev_hash || this row's fields) is filled by a
--     trigger (Stage 4), giving a tamper-evident hash chain per batch;
--     UPDATE/DELETE are blocked by triggers and by not granting them.
-- [FD] event_id -> batch_id, claim_id, trip_id, event_type, event_time,
--                  actor_user_id, temperature_c, hygiene_ok, notes,
--                  location, prev_hash, row_hash
--      row_hash -> event_id (candidate key; SHA-256 collisions ignored)
-- ---------------------------------------------------------------------
CREATE TABLE custody_event (
  event_id       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  batch_id       INT UNSIGNED NOT NULL,
  claim_id       INT UNSIGNED NULL,
  trip_id        INT UNSIGNED NULL,
  event_type     ENUM('COOKED','PACKED','POSTED','CLAIMED','PICKED_UP',
                      'DELIVERED','HYGIENE_CHECK','REJECTED','EXPIRED',
                      'CANCELLED') NOT NULL,
  event_time     DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  actor_user_id  INT UNSIGNED NULL,            -- NULL = written by a trigger/job
  temperature_c  DECIMAL(4,1) NULL,
  hygiene_ok     BOOLEAN NULL,
  notes          VARCHAR(255) NULL,
  location       POINT SRID 4326 NULL,
  prev_hash      CHAR(64) NULL,                -- NULL only for a batch's first event
  row_hash       CHAR(64) NOT NULL,
  CONSTRAINT uq_event_hash UNIQUE (row_hash),
  CONSTRAINT chk_event_temp CHECK (temperature_c IS NULL OR temperature_c BETWEEN -30 AND 120),
  CONSTRAINT chk_event_hygiene CHECK (event_type <> 'HYGIENE_CHECK' OR hygiene_ok IS NOT NULL),
  CONSTRAINT fk_ev_batch FOREIGN KEY (batch_id)      REFERENCES surplus_batch (batch_id),
  CONSTRAINT fk_ev_claim FOREIGN KEY (claim_id)      REFERENCES claim (claim_id),
  CONSTRAINT fk_ev_trip  FOREIGN KEY (trip_id)       REFERENCES pickup_trip (trip_id),
  CONSTRAINT fk_ev_actor FOREIGN KEY (actor_user_id) REFERENCES app_user (user_id),
  -- Audit timeline: "all events of batch X in order"
  INDEX ix_ev_batch_time (batch_id, event_time)                 -- [IDX-12]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 18. MENU_ITEM : dish master used by the forecasting inputs.
-- [FD] menu_item_id -> name, category_id ; name -> menu_item_id
-- ---------------------------------------------------------------------
CREATE TABLE menu_item (
  menu_item_id  SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  category_id   SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT uq_menu_item_name UNIQUE (name),
  CONSTRAINT fk_mi_cat FOREIGN KEY (category_id) REFERENCES food_category (category_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 19. MESS_MEAL_LOG : one row per mess, date and meal slot. This is the
--     history the surplus forecast is computed from (attendance vs.
--     prepared vs. left over).
-- [FD] (mess_site_id, service_date, meal_slot) -> expected_headcount,
--        actual_headcount, prepared_kg, leftover_kg
-- ---------------------------------------------------------------------
CREATE TABLE mess_meal_log (
  mess_site_id        INT UNSIGNED NOT NULL,
  service_date        DATE NOT NULL,
  meal_slot           ENUM('BREAKFAST','LUNCH','SNACKS','DINNER') NOT NULL,
  expected_headcount  INT UNSIGNED NOT NULL,
  actual_headcount    INT UNSIGNED NULL,       -- NULL until the meal is over
  prepared_kg         DECIMAL(7,2) NOT NULL,
  leftover_kg         DECIMAL(7,2) NULL,
  PRIMARY KEY (mess_site_id, service_date, meal_slot),
  CONSTRAINT chk_log_qty CHECK (
        prepared_kg > 0
    AND (leftover_kg IS NULL OR (leftover_kg >= 0 AND leftover_kg <= prepared_kg))),
  CONSTRAINT fk_log_mess FOREIGN KEY (mess_site_id) REFERENCES mess (site_id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 20. MESS_MENU : M:N between a meal service and the dishes served
--     (a meal has many dishes; a dish appears in many meals).
-- ---------------------------------------------------------------------
CREATE TABLE mess_menu (
  mess_site_id  INT UNSIGNED NOT NULL,
  service_date  DATE NOT NULL,
  meal_slot     ENUM('BREAKFAST','LUNCH','SNACKS','DINNER') NOT NULL,
  menu_item_id  SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (mess_site_id, service_date, meal_slot, menu_item_id),
  CONSTRAINT fk_menu_log FOREIGN KEY (mess_site_id, service_date, meal_slot)
    REFERENCES mess_meal_log (mess_site_id, service_date, meal_slot) ON DELETE CASCADE,
  CONSTRAINT fk_menu_item FOREIGN KEY (menu_item_id) REFERENCES menu_item (menu_item_id),
  -- "how much is left over when dish X is served" (forecast feature)
  INDEX ix_menu_item (menu_item_id)                             -- [IDX-13]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 21. SURPLUS_FORECAST : output of the SQL forecasting procedure, kept so
--     forecast accuracy can be measured later against mess_meal_log.
-- [FD] (mess_site_id, forecast_date, meal_slot, method)
--        -> predicted_kg, generated_at
-- ---------------------------------------------------------------------
CREATE TABLE surplus_forecast (
  mess_site_id   INT UNSIGNED NOT NULL,
  forecast_date  DATE NOT NULL,
  meal_slot      ENUM('BREAKFAST','LUNCH','SNACKS','DINNER') NOT NULL,
  method         VARCHAR(40) NOT NULL,          -- e.g. 'WEEKDAY_MA_4W'
  predicted_kg   DECIMAL(7,2) NOT NULL,
  generated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (mess_site_id, forecast_date, meal_slot, method),
  CONSTRAINT chk_fc_kg CHECK (predicted_kg >= 0),
  CONSTRAINT fk_fc_mess FOREIGN KEY (mess_site_id) REFERENCES mess (site_id),
  INDEX ix_fc_date (forecast_date, meal_slot)                   -- [IDX-14]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 22. SCORING_WEIGHT : tunable weights of the fair-matching score, so the
--     platform admin can change policy without changing code.
-- [FD] weight_key -> weight_value, description
-- ---------------------------------------------------------------------
CREATE TABLE scoring_weight (
  weight_key    VARCHAR(30) PRIMARY KEY,   -- NEED, CAPACITY, DISTANCE, FAIRNESS, ...
  weight_value  DECIMAL(4,3) NOT NULL,
  description   VARCHAR(200) NOT NULL,
  CONSTRAINT chk_weight CHECK (weight_value BETWEEN 0 AND 1)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 23. NOTIFICATION : pre-alerts to shelters (forecast) and claim updates.
-- [FD] notification_id -> user_id, kind, message, batch_id, created_at, read_at
-- ---------------------------------------------------------------------
CREATE TABLE notification (
  notification_id  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id          INT UNSIGNED NOT NULL,
  kind             ENUM('FORECAST_PREALERT','NEW_MATCH','CLAIM_UPDATE',
                        'TRIP_ASSIGNED','EXPIRY_WARNING') NOT NULL,
  message          VARCHAR(255) NOT NULL,
  batch_id         INT UNSIGNED NULL,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at          DATETIME NULL,
  CONSTRAINT fk_notif_user  FOREIGN KEY (user_id)  REFERENCES app_user (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_notif_batch FOREIGN KEY (batch_id) REFERENCES surplus_batch (batch_id),
  -- "my unread notifications": read_at IS NULL filter on the user's rows
  INDEX ix_notif_user_unread (user_id, read_at, created_at)     -- [IDX-15]
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 24. AUDIT_LOG : generic row-change audit written by triggers (who
--     changed what). old/new values are JSON snapshots: they are an
--     opaque historical record, never queried relationally, which is why
--     a JSON column is acceptable here and not a 1NF violation in spirit.
-- [FD] audit_id -> table_name, row_pk, action, db_user, changed_at,
--                  old_values, new_values
-- ---------------------------------------------------------------------
CREATE TABLE audit_log (
  audit_id    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  table_name  VARCHAR(64) NOT NULL,
  row_pk      VARCHAR(64) NOT NULL,
  action      ENUM('INSERT','UPDATE','DELETE') NOT NULL,
  db_user     VARCHAR(100) NOT NULL DEFAULT (CURRENT_USER()),
  changed_at  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  old_values  JSON NULL,
  new_values  JSON NULL,
  INDEX ix_audit_table_row (table_name, row_pk, changed_at)     -- [IDX-16]
) ENGINE=InnoDB;
