# MealBridge Deliverable 1: Problem Discovery Report

| | |
|---|---|
| **Course** | BCSE302P Database Systems Lab, Societal Digital Innovation Project |
| **Track** | T5 Waste and Circular Economy (surplus resources) |
| **Status** | Draft v1, 5 October 2026 |

> **How to read this report.** Every number is either cited to a source in section 7 or marked **TO COLLECT**, which means the team must gather it in fieldwork before the internal review. No survey or interview has been run yet, so this report contains no survey results.

---

## 1. Problem statement

Hostel and institutional messes cook for a forecast headcount several hours before a meal. When actual attendance is lower (exams, weekends, festivals, holidays, rain, a disliked menu), cooked food is left over. Cooked food is highly perishable, so it has only a few hours of safe life. In that window, someone must (a) notice the surplus, (b) find a nearby recipient that can use *that* food (diet, quantity, storage), (c) arrange transport, and (d) do it before it becomes unsafe. Today this usually happens through phone calls and personal contacts, or not at all, and the food is discarded.

The problem MealBridge addresses is therefore **not** "there is no app for donating food". It is a **coordination and time problem with a safety constraint**: matching a perishable, variable supply to recipients who can actually reach and use it, within a deadline, with a record that the food was handled safely.

## 2. Who is affected, and where

| Stakeholder | How they are affected | What we need to learn from them |
|---|---|---|
| Mess managers / contractors | Pay for food that is binned; no quick channel to give it away safely; worry about liability if donated food causes illness. | How often surplus happens, how much, what they do now, what stops them donating. |
| Mess kitchen staff | Do the packing and handover; extra work at the busiest time of day. | Packing practice, timing, who decides. |
| Hostel students | Their fees fund the food; many see it wasted; potential volunteers. | Do they notice waste, would they volunteer, would they pre-declare absence (improves forecasts). |
| Shelters (orphanages, old-age homes, homeless shelters, hospital attendant groups, community kitchens) | Unpredictable supply; sometimes too much at once, sometimes nothing; food sometimes arrives unsuitable or too late. | Daily need, storage, dietary restrictions, pick-up ability, how they hear of food today. |
| Volunteers (student clubs, NSS, NGO volunteers) | Coordination by chat is chaotic; wasted trips; one trip per donation. | Transport, availability, how they coordinate now. |
| Institution / environment | Food sent to landfill emits greenhouse gases; disposal cost. | Waste disposal method and cost **TO COLLECT** (ask the estate office). |

**Where:** pilot scope is one campus (VIT Vellore hostels and messes) and shelters within a deliverable radius of it. Exact number of messes, daily meals cooked and candidate shelters: **TO COLLECT** (from the hostel office, and by mapping shelters near campus).

## 3. What the public evidence says (cited, and its limits)

- UNEP's *Food Waste Index Report 2024* estimates **1.05 billion tonnes** of food waste in 2022, with **60%** at household level, and states food waste "is not just a rich country problem" [S1].
- Secondary compilations of the same UNEP report list India's household food waste at about **55 kg per capita per year** [S2]. **TO VERIFY:** before quoting this figure, confirm it and its confidence level in the UNEP report annex. A secondary source is not enough for the final version.
- **Limit of this evidence:** these are *household* figures. There is no public dataset for *hostel/mess* surplus in Indian universities that we found. That gap is exactly why primary data collection (section 5) is the core of the evidence for this project, and why the system logs surplus itself, so it produces the missing data.
- India already has a legal framework for this: the FSSAI **Food Safety and Standards (Recovery and Distribution of Surplus Food) Regulations, 2019**, which set responsibilities for food business operators (donors) and surplus food distribution organisations on handling, transport, storage and labelling [S3]. FSSAI's **IFSA / "Save Food, Share Food"** initiative registers food donating and distribution agencies [S4]. MealBridge's chain-of-custody log is designed to make it easy to show compliance with that framework. **TO VERIFY:** read the regulation text itself before citing any specific clause.

## 4. Existing-solution study (verified 5 Oct 2026)

Each row was checked against the organisation's own site or help centre on the date above. Scale figures are **their own claims**, not independently verified.

| Existing solution | What it really is (verified) | Limitation for *hostel mess → shelter* | MealBridge innovation | Expected improvement (to be measured) |
|---|---|---|---|---|
| **Feeding India (Zomato / Eternal)** [S5] | Today a **meal-programme NGO**: daily nutritious meals for children in schools and Anganwadi centres; site claims 160+ cities and 1.4 lakh+ children daily. It is funded largely via donations. Its current site does not describe surplus-food rescue. | Not a surplus-matching channel. A mess cannot post leftover dal at 2:30 pm and have it picked up. | Real-time posting of perishable surplus with a computed **safe-until deadline**, and matching only to shelters reachable before it. | Shelters receive food that would otherwise be binned; measured as kg diverted per mess per week. |
| **Robin Hood Army** [S6][S7] | Volunteer, "zero-funds" network ("Robins") distributing surplus from restaurants and the community; local chapters; site claims 406 cities, 12 countries. Its **checkin.robinhoodarmy.com** platform logs volunteer drives and badges; it does **not** do donor-to-recipient matching. | Coordination is human and chapter-based (calls / chat). No record of what food, when cooked, what temperature, who held it. Drives are scheduled, not triggered by a surplus event. | **Event-driven matching**: a new batch instantly ranks shelters by a transparent **fair match score**; **chain-of-custody log** with timestamps, hygiene checks and a tamper-evident hash chain. | Time from post to claim (minutes) and share of batches delivered before deadline; compare to baseline from interviews. |
| **OLIO** [S8][S9] | UK-based app for neighbours and businesses to give away spare food and items; "Food Waste Heroes" volunteers collect from businesses, a service businesses pay for; also ads and a premium subscription. Wikipedia lists 49 countries; we found **no India operation**. | Peer-to-peer listing model: individual collectors take small lots. Not designed for 20–100 kg cooked batches going to institutions with dietary rules, capacity limits and safety records. Not active in India. | Institution-to-institution matching with **capacity, diet and fairness constraints** enforced in the database; **multi-stop pickup batching**. | Fewer volunteer trips per kg delivered; measured as kg per trip. |
| **Too Good To Go** [S10] | Paid marketplace selling surplus "Surprise Bags" from shops and restaurants to consumers. Its help centre lists Europe, North America, Australia, New Zealand and Japan; **India is not listed**. | Commercial resale to individuals, not free redistribution to shelters. Not available in India. | Free redistribution to vulnerable groups; no payment flow; donor side is institutional messes. | Not a direct competitor; cited to show the gap. |
| **No Food Waste (Coimbatore)** [S11] | NGO founded 2014; hotline and an app where donors log excess food and volunteers collect; crowdsources "hunger spots". Operates in parts of Tamil Nadu, Andhra Pradesh, Telangana. | Closest Indian model. Public information does not describe perishability deadlines, fairness across recipients, concurrency-safe claiming or a custody audit trail. (We have not seen inside their app, so this comparison is limited to what they publish.) | **Perishability clock** in the DB, **fair-share scoring**, **race-safe claiming**, **surplus forecasting** from mess attendance so shelters are pre-alerted. | Pre-alert lead time (minutes before surplus is posted); shelter fairness (Gini of kg received). |
| **FSSAI IFSA / Save Food, Share Food** [S4] | Government alliance and registration directory of food donating and distribution agencies. | A directory, not a real-time matching or logistics system. | Uses IFSA/FSSAI registration numbers as data (mess FSSAI licence, shelter registration) and produces the handling records the 2019 regulations expect. | Compliance evidence per batch, available on demand. |
| **Campus / NGO WhatsApp groups** (common practice) | A mess manager or student posts "food available" in a group; whoever replies first takes it. **TO COLLECT:** we found no published source for this, so confirm it and its details in interviews. | Messages scroll away; two people can say "I'll take it"; no record of timing or safety; the same nearby shelter gets everything; nothing is measured. | Exactly the problems the DB solves: **one atomic claim**, **fairness**, **audit log**, **impact reports from SQL views**. | Zero double-claims (proved by the concurrency demo); measured impact instead of anecdotes. |

**Novelty in one sentence (for the viva):** existing Indian efforts are volunteer networks, directories or meal programmes; MealBridge is a *database-enforced* matching layer for perishable institutional surplus, where expiry, capacity, diet, fairness and "only one claimant" are guarantees of the schema and transactions, not of human coordination.

## 5. Evidence to collect (primary research plan)

The targets below are suggestions. Record the numbers you actually reach. Get consent, collect no personal data you don't need, and keep raw responses for the internal review.

### 5.1 Mess managers and contractors: structured interview

Suggested target: every mess in the pilot scope.

1. How many meals does your mess cook per slot (breakfast, lunch, snacks, dinner) on a typical weekday?
2. How do you decide the quantity to cook? Who decides, and how far in advance?
3. On a typical day, roughly how much cooked food is left after service, per slot? (kg, or number of vessels and vessel size)
4. Which days or situations produce the most surplus? (exam weeks, weekends, holidays, festivals, specific menus)
5. What happens to surplus today? (staff, reused next meal, animal feed, donated, discarded) Roughly what share goes to each?
6. Have you ever donated surplus? To whom, how was it arranged, and how long did it take?
7. What stops you from donating more often? (no one to call, time, transport, safety or liability worries, management rules)
8. How long after cooking would you consider each kind of dish still safe to give away? Do you follow any written guidance?
9. Do you record attendance or food prepared or wasted? On paper, in software, or not at all? Could we see anonymised past records? *(These records would seed the forecasting table.)*
10. Is your mess FSSAI-licensed or registered? Are you aware of the FSSAI surplus food regulations (2019)?
11. Who would post a surplus batch on an app, and at what point (end of service, before closing)? Would a 1-minute form be acceptable?
12. What information would you want back? (where the food went, when it was delivered, a monthly report)

### 5.2 Hostel students: online survey

Suggested target: at least 100 responses, spread across hostel blocks.

1. Hostel block and mess type (veg / non-veg / special / mixed).
2. How often do you skip a registered meal? (never, 1–2/week, 3–5/week, more)
3. Do you inform the mess when you skip? Would you, if it took one tap? (yes / maybe / no)
4. How often do you see cooked food left over or thrown away? (never … daily)
5. On a 1–5 scale, how much does food waste in the mess bother you?
6. Would you volunteer for a 30–45 minute food pickup run? How often? (never, monthly, weekly, more)
7. Do you have access to a vehicle for this? (none, bicycle, two-wheeler, car)
8. Have you seen surplus food shared through WhatsApp groups or clubs? How did it work? *(free text)*
9. What would make you trust that donated food is safe? *(free text)*

### 5.3 Shelters: structured interview

Suggested target: 5 to 10 shelters within delivery distance of the campus.

1. Type of organisation and number of people fed per day, by meal.
2. Where does your food come from today? How predictable is it?
3. Have you received surplus cooked food before? From whom? What went well or badly?
4. Dietary restrictions of residents (vegetarian only, no onion/garlic, no beef/pork, children, elderly, medical diets).
5. How much cooked food can you accept and store in a day? Do you have refrigeration?
6. How much notice do you need? What is the latest time in the day you can accept food?
7. Can you collect food yourselves? Vehicle, staff, distance you can travel.
8. How do you want to be notified? (phone call, SMS, WhatsApp, app) Who would claim on your behalf?
9. Have you ever received food that was spoiled or arrived too late? What happened?
10. What records, if any, do you keep of food received? Are you registered (trust/society/NGO Darpan/IFSA)?
11. Would a fair-share rule (no single shelter receives everything) be acceptable to you?

### 5.4 Volunteers and NGO coordinators: short interview

Suggested target: 3 to 5 people.

1. How do you coordinate pickups today (calls, WhatsApp, an app)? Walk me through the last one.
2. How often do two people respond to the same donation, or a pickup fail?
3. How many pickup points can you realistically do in one trip? Max distance, max load?
4. What information do you need at pickup and at drop-off?

### 5.5 Direct observation (the strongest evidence)

Suggested target: 7 to 14 consecutive days.

With mess permission, weigh leftover cooked food per slot for at least one mess and log: date, slot, menu, expected headcount, actual headcount (if known), prepared kg, leftover kg. This is the real seed for `mess_meal_log` and the forecasting baseline. Until this data exists, all demo data in Stage 4 will be clearly labelled as synthetic.

## 6. Baseline metrics to establish from fieldwork

| Metric | Value | Source | Why it matters |
|---|---|---|---|
| Leftover kg per mess per slot | TO COLLECT | Observation 5.5 | Size of the opportunity; forecast training data |
| Share of surplus donated today | TO COLLECT | Mess interviews | Baseline for "kg diverted" improvement |
| Time from "food available" to pickup today | TO COLLECT | Mess + volunteer interviews | Baseline for response-time improvement |
| Failed / duplicate pickups per month | TO COLLECT | Volunteer interviews | Baseline for double-claim problem |
| Shelters reached per month, and concentration | TO COLLECT | Shelter interviews | Baseline for fairness |

## 7. Sources (accessed 5 October 2026)

| ID | Source | Link |
|---|---|---|
| S1 | UNEP press release on the *Food Waste Index Report 2024* | [unep.org](https://www.unep.org/news-and-stories/press-release/world-squanders-over-1-billion-meals-day-un-report) |
| S2 | World Population Review, "Food Waste by Country" (cites the UNEP report; secondary source, verify against the [full UNEP report](https://www.unep.org/resources/publication/food-waste-index-report-2024)) | [worldpopulationreview.com](https://worldpopulationreview.com/country-rankings/food-waste-by-country) |
| S3 | Nutrition Connect, on the FSSAI surplus food regulations 2019 | [nutritionconnect.org](https://nutritionconnect.org/food-safety-standards-authority-india-fssai-guiding-optimisation-surplus-food-donation) |
| S4 | FSSAI IFSA, "Save Food, Share Food" | [sharefood.eatrightindia.gov.in](https://sharefood.eatrightindia.gov.in/) |
| S5 | Feeding India | [feedingindia.org](https://www.feedingindia.org/) |
| S6 | Robin Hood Army | [robinhoodarmy.com](https://robinhoodarmy.com/) |
| S7 | Robin Hood Army check-in platform | [checkin.robinhoodarmy.com](https://checkin.robinhoodarmy.com/) |
| S8 | Olio (Wikipedia) | [en.wikipedia.org](https://en.wikipedia.org/wiki/Olio_(app)) |
| S9 | Olio help centre, "How does Olio make money?" | [help.olioapp.com](https://help.olioapp.com/en/articles/12148782-how-does-olio-make-money) |
| S10 | Too Good To Go help centre, "Where is Too Good To Go available?" | [tgtg.zendesk.com](https://tgtg.zendesk.com/hc/en-us/articles/37835328622866-Where-is-Too-Good-To-Go-available) |
| S11 | No Food Waste (Wikipedia) | [en.wikipedia.org](https://en.wikipedia.org/wiki/No_Food_Waste) |
