"use client";
/* =====================================================================
   Scroll storytelling: "follow one batch through the database".

   As you scroll, the panel stays put (CSS position: sticky) and steps
   through Post -> Match -> Claim -> Deliver. GSAP ScrollTrigger turns the
   scroll position into a step number and a progress bar.

   The point of this section for the marks: each step shows the REAL SQL
   that does the job, copied from the .sql files (file and line given),
   so the landing page itself says "the logic is in the database".
   If you change those files, update the excerpts here.

   Small screens and reduced motion get a plain list of the four steps.
   ===================================================================== */
import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion } from "motion/react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { usePrefersReducedMotion } from "@/components/motion/useMotionPrefs";
import Sql from "@/components/Sql";

gsap.registerPlugin(ScrollTrigger);

export const STORY = [
  {
    key: "post",
    title: "Post",
    body: "A mess admin posts leftover food. The client cannot choose the deadline: a BEFORE INSERT trigger computes safe_until from the food type and how it is stored, and refuses food that is already unsafe.",
    proves: "Business rule enforced by a trigger, not by the app",
    file: "sql/05_triggers.sql · trg_batch_bi",
    sql: `CREATE TRIGGER trg_batch_bi BEFORE INSERT ON surplus_batch
FOR EACH ROW
BEGIN
  ...
  SET NEW.safe_until = fn_safe_until(NEW.category_id,
                                     NEW.storage, NEW.cooked_at);
  IF NEW.safe_until <= NEW.created_at THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'R9: food is already past its
                          safe-until time, it cannot be posted';
  END IF;
  SET NEW.status = 'AVAILABLE';
END`,
  },
  {
    key: "match",
    title: "Match",
    body: "A stored procedure ranks every shelter in a 15 km box (found with a SPATIAL index) on need, capacity, distance, time left and fairness. Shelters that cannot get there before safe_until are excluded, with the reason.",
    proves: "Spatial index + stored function + weights kept in a table",
    file: "sql/03_functions.sql · fn_match_score",
    sql: `-- policy weights live in a table; changes are audited
SELECT MAX(IF(weight_key='NEED', weight_value, NULL)), ...
  INTO w_need, w_cap, w_dist, w_perish, w_fair
  FROM scoring_weight;

RETURN ( w_need*v_need + w_cap*v_cap + w_dist*v_dist
       + w_perish*v_perish + w_fair*v_fair )
     / NULLIF(w_need + w_cap + w_dist + w_perish + w_fair, 0);`,
  },
  {
    key: "claim",
    title: "Claim",
    body: "One click claims the whole batch. The row lock makes two shelters wait in line for the same batch: the second one reads the committed CLAIMED status and is turned away. A UNIQUE index is the second guard.",
    proves: "Transaction + SELECT … FOR UPDATE (see the Race demo)",
    file: "sql/04_procedures.sql · sp_claim_batch",
    sql: `START TRANSACTION;
  -- (2) the row lock
  SELECT status, safe_until INTO v_status, v_safe_until
    FROM surplus_batch
   WHERE batch_id = p_batch_id
     FOR UPDATE;
  -- (3) re-check under the lock
  IF v_status <> 'AVAILABLE' THEN
    ROLLBACK;
    SET p_result = CONCAT('REJECTED: batch already ',
                          v_status, ' by another shelter');
    LEAVE proc;
  END IF;
  ...
COMMIT;`,
  },
  {
    key: "deliver",
    title: "Deliver",
    body: "A volunteer carries several batches in one trip. Every hand-over is a custody event whose hash includes the previous event's hash, so editing history breaks the chain, and a trigger blocks UPDATE and DELETE outright.",
    proves: "Tamper-evident audit trail (see the Audit trail page)",
    file: "sql/05_triggers.sql · trg_custody_bi",
    sql: `CREATE TRIGGER trg_custody_bi BEFORE INSERT ON custody_event
FOR EACH ROW
BEGIN
  SET NEW.prev_hash = (SELECT row_hash FROM custody_event
                        WHERE batch_id = NEW.batch_id
                        ORDER BY event_id DESC LIMIT 1);
  SET NEW.row_hash = SHA2(CONCAT(IFNULL(NEW.prev_hash,'GENESIS'),
                     '|', CONCAT_WS('|', NEW.batch_id, ...)), 256);
END`,
  },
];

function SqlCard({ step }) {
  return (
    <div className="card overflow-hidden shadow-xl">
      <div className="flex items-center justify-between gap-2 px-4 py-2.5 border-b border-line bg-surface-2">
        <span className="font-mono text-[11px] text-muted truncate">{step.file}</span>
        <span className="chip !text-leaf shrink-0">real source</span>
      </div>
      <Sql className="!rounded-none !border-0 !bg-transparent !text-[12px] sm:!text-[13px] p-4 sm:p-5 min-h-[260px]">{step.sql}</Sql>
      <div className="px-4 py-2.5 border-t border-line text-xs"><b>Shows:</b> <span className="text-muted">{step.proves}</span></div>
    </div>
  );
}

/* Plain version: phones and reduced motion */
function StoryList() {
  return (
    <ol className="space-y-6">
      {STORY.map((s, i) => (
        <li key={s.key} className="grid lg:grid-cols-2 gap-4 items-start">
          <div>
            <div className="display text-4xl font-extrabold text-glow">{String(i + 1).padStart(2, "0")}</div>
            <h3 className="text-xl font-bold mt-1">{s.title}</h3>
            <p className="text-muted mt-1 leading-relaxed">{s.body}</p>
          </div>
          <SqlCard step={s} />
        </li>
      ))}
    </ol>
  );
}

export default function ScrollStory() {
  const section = useRef(null);
  const bar = useRef(null);
  const reduced = usePrefersReducedMotion();
  const [wide, setWide] = useState(false);
  const [step, setStep] = useState(0);

  useEffect(() => {
    const mq = window.matchMedia("(min-width: 1024px)");
    const u = () => setWide(mq.matches);
    u(); mq.addEventListener("change", u);
    return () => mq.removeEventListener("change", u);
  }, []);

  const pinned = wide && !reduced;
  useEffect(() => {
    if (!pinned || !section.current) return;
    // progress 0..1 across the tall section -> step 0..3 and the bar width.
    // Measured from the section's live position on every scroll frame, not
    // from start/end offsets cached at mount: the live figures and charts
    // above it load after the page appears and push the section down, and
    // cached offsets then left the story stuck on step 1 ("Post").
    // (straight from the scroll event: one getBoundingClientRect per event is
    // cheap, and setStep with an unchanged value does not re-render)
    const update = () => {
      const el = section.current;
      if (!el) return;
      const r = el.getBoundingClientRect();
      const travel = r.height - (window.innerHeight - 64);          // 64 px = the sticky header
      const p = travel > 0 ? Math.min(1, Math.max(0, (64 - r.top) / travel)) : 0;
      setStep(Math.min(STORY.length - 1, Math.floor(p * STORY.length)));
      if (bar.current) bar.current.style.transform = `scaleX(${p})`;
    };
    update();
    window.addEventListener("scroll", update, { passive: true });
    window.addEventListener("resize", update);
    return () => {
      window.removeEventListener("scroll", update);
      window.removeEventListener("resize", update);
    };
  }, [pinned]);

  const s = STORY[step];
  return (
    <section aria-labelledby="story-h" className="mx-auto max-w-7xl px-4 sm:px-6 py-20">
      <div className="max-w-2xl mb-8">
        <h2 id="story-h" className="text-3xl sm:text-5xl">Every rule lives <span className="text-glow">in the database</span></h2>
        <p className="text-muted mt-2">Four steps, each enforced by MySQL itself. The code on the right is the actual SQL from this project.</p>
      </div>

      {!pinned ? <StoryList /> : (
        // 4 steps x 80vh of scrolling; the inner panel sticks while you scroll
        <div ref={section} style={{ height: `${STORY.length * 80 + 20}vh` }} className="relative">
          <div className="sticky top-16 h-[calc(100vh-4rem)] flex flex-col justify-start pt-[6vh]">
            <div className="h-1 w-full bg-surface-2 rounded-full overflow-hidden mb-8" aria-hidden="true">
              <div ref={bar} className="h-full bg-accent origin-left" style={{ transform: "scaleX(0)" }} />
            </div>
            <div className="grid grid-cols-[220px_1fr_1.15fr] gap-10 items-start">
              {/* step index: click to jump */}
              <ol className="space-y-1 pt-2" aria-label="Steps">
                {STORY.map((x, i) => (
                  <li key={x.key}>
                    <button
                      onClick={() => {
                        const top = section.current.getBoundingClientRect().top + window.scrollY - 64;
                        window.scrollTo({ top: top + (i + 0.5) * (section.current.offsetHeight - (window.innerHeight - 64)) / STORY.length, behavior: "smooth" });
                      }}
                      aria-current={i === step ? "step" : undefined}
                      className={`w-full text-left px-3 py-2 rounded-xl transition-colors ${i === step ? "bg-surface-2" : "text-muted hover:text-ink"}`}>
                      <span className="font-mono text-xs mr-2">{String(i + 1).padStart(2, "0")}</span>
                      <span className="font-bold">{x.title}</span>
                    </button>
                  </li>
                ))}
              </ol>
              <div aria-live="polite">
                <AnimatePresence mode="wait">
                  <motion.div key={s.key} initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -12 }}
                              transition={{ duration: 0.35, ease: [0.16, 1, 0.3, 1] }}>
                    <div className="display text-8xl text-glow leading-none">{String(step + 1).padStart(2, "0")}</div>
                    <h3 className="text-3xl font-semibold tracking-tight mt-4">{s.title}</h3>
                    <p className="text-muted mt-3 leading-relaxed text-lg">{s.body}</p>
                  </motion.div>
                </AnimatePresence>
              </div>
              <AnimatePresence mode="wait">
                <motion.div key={s.key} initial={{ opacity: 0, x: 24, rotateY: -6 }} animate={{ opacity: 1, x: 0, rotateY: 0 }}
                            exit={{ opacity: 0, x: -16 }} transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
                            style={{ transformPerspective: 900 }}>
                  <SqlCard step={s} />
                </motion.div>
              </AnimatePresence>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
