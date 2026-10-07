"use client";
/* =====================================================================
   Landing page, laid out like an editorial / luxury brand site.
   1. Hero: one big glass slab, words left and the 3D town right (stacked
      on phones; they never overlap), live "meals saved" from MySQL, and the
      MealBridge wordmark under the slab.
   2. Ticker: every live figure from v_impact_summary, running sideways.
   3. Statement + the daily delivered chart and the other live figures.
   4. Scroll story (components/landing/ScrollStory): the real SQL behind
      each step of the workflow.
   5. Index: every page of the app as a numbered list.
   No statistic on this page is typed in by hand: all of them are read
   through the mb_public login from the impact views.
   ===================================================================== */
import Link from "next/link";
import { useEffect, useState } from "react";
import { motion } from "motion/react";
import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis } from "recharts";
import { Skeleton } from "@/components/ui";
import Hero3D from "@/components/hero/Hero3D";
import ScrollStory from "@/components/landing/ScrollStory";
import SmoothScroll from "@/components/motion/SmoothScroll";
import CountUp from "@/components/motion/CountUp";
import { api, fmt } from "@/lib/api";

const ease = [0.32, 0.72, 0, 1];
// shared "rise into view" animation for sections below the fold
const rise = {
  initial: { opacity: 0, y: 32 },
  whileInView: { opacity: 1, y: 0 },
  viewport: { once: true, margin: "-80px" },
  transition: { duration: 0.9, ease },
};

// Every page of the app, for the index at the bottom
const INDEX = [
  ["/login?role=MESS_ADMIN", "Mess kitchen", "Post surplus in seconds; its safe time counts down from the moment it was cooked.", "Use it"],
  ["/login?role=SHELTER", "Shelter", "Food ranked for you by a stored procedure. One click claims it, and only one shelter can.", "Use it"],
  ["/login?role=VOLUNTEER", "Volunteer", "Pick up from several messes on one route, every stop logged.", "Use it"],
  ["/login?role=PLATFORM_ADMIN", "Platform admin", "Tune the matching weights and read the audit log.", "Use it"],
  ["/lab/race", "Race demo", "Two shelters claim one batch at the same instant. MySQL's row lock picks one winner, live from performance_schema.data_locks.", "Database"],
  ["/lab/explain", "EXPLAIN", "The same query with and without its index: access type, rows examined, measured time.", "Database"],
  ["/lab/custody", "Audit trail", "A batch's chain of custody, each event hashed with the one before it, verified by a stored function.", "Database"],
  ["/lab/schema", "Schema", "Tables, keys and indexes read live from information_schema, with every procedure and trigger's source.", "Database"],
  ["/impact", "Impact", "Meals, kilograms and carbon over time, from the impact views. Any login can open it.", "Log in"],
];

function Ticker({ s }) {
  // two copies side by side; the strip slides left by exactly one copy, forever
  const items = s ? [
    [fmt.n(s.meals_saved), "meals delivered"],
    [fmt.kg(s.kg_diverted), "of food diverted"],
    [`${s.rescue_rate_pct}%`, "of posted food rescued"],
    [`${fmt.n(s.co2e_avoided_kg)} kg`, "CO₂e avoided"],
    [`${fmt.n(s.avg_response_min)} min`, "average time to first claim"],
    [`${s.from_day} → ${s.to_day}`, "read live from MySQL"],
  ] : [];
  const row = (k) => (
    <div className="flex shrink-0 items-baseline gap-10 pr-10" aria-hidden={k === 1 || undefined}>
      {items.map(([v, l]) => (
        <span key={l} className="flex items-baseline gap-3 whitespace-nowrap">
          <span className="display text-3xl sm:text-4xl text-glow">{v}</span>
          <span className="text-sm text-muted">{l}</span>
          <span className="text-accent/60 text-lg" aria-hidden="true">•</span>
        </span>
      ))}
    </div>
  );
  return (
    <section aria-label="Live figures from the database" className="relative border-y border-line py-6 overflow-hidden marquee-mask">
      {!s ? <Skeleton className="h-10 mx-6" /> : (
        <div className="flex w-max marquee">{row(0)}{row(1)}</div>
      )}
    </section>
  );
}

export default function Landing() {
  const [d, setD] = useState(null);
  const [err, setErr] = useState(null);
  useEffect(() => { api("/api/public/impact").then(setD).catch(setErr); }, []);
  const s = d?.summary;
  return (
    <div>
      <SmoothScroll />

      {/* ---------- 1. hero: one big glass slab ----------
          Two columns that never overlap: the words on the left, the 3D town in
          its own box on the right (on wide screens it spills over the slab's
          top, right and bottom edges, like a dish breaking out of a card).
          On phones the town stacks under the words. */}
      <section className="mx-auto max-w-7xl px-4 sm:px-6 pt-8 sm:pt-12 pb-6" aria-labelledby="hero-h">
        <div className="slab relative grid lg:grid-cols-[minmax(0,1fr)_minmax(0,1fr)] items-center gap-6 lg:gap-2 px-6 py-10 sm:px-12 sm:py-14 lg:min-h-[640px]">
          <div className="relative z-10 lg:pr-4">
            <motion.h1 id="hero-h" className="text-[2.6rem] sm:text-6xl leading-[1.02]"
                       initial={{ opacity: 0, y: 24 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1, duration: 0.9, ease }}>
              Tonight's extra rice <span className="text-glow">reaches a shelter</span> before it spoils.
            </motion.h1>
            <motion.p className="mt-6 text-base sm:text-lg text-muted leading-relaxed max-w-[46ch]"
                      initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3, duration: 0.9, ease }}>
              A hostel mess posts its surplus. The database ranks nearby shelters, lets exactly one claim it, and keeps a
              tamper-evident trail until it is delivered. Every rule lives in MySQL.
            </motion.p>
            <motion.div className="mt-8 flex flex-wrap items-center gap-3"
                        initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.45, duration: 0.9, ease }}>
              <Link href="/login" className="btn btn-primary !pl-6 !pr-2 !py-2 !text-base">Open the app <span className="btn-orb !w-9 !h-9 !mr-0" aria-hidden="true">↗</span></Link>
              <a href="#story-h" className="btn btn-ghost !px-6 !py-3 !text-base">See how the database does it</a>
            </motion.div>
            <motion.div className="mt-10 inline-flex items-center gap-4 card px-5 py-3.5"
                        initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.6, duration: 0.9, ease }}>
              <span className="live-dot" aria-hidden="true" />
              <span>
                <span className="block text-xs text-muted">Meals saved, live</span>
                <span className="block text-3xl font-semibold tracking-tight tabular-nums text-leaf">
                  {s ? <CountUp value={s.meals_saved} format={fmt.n} /> : <span className="text-muted">…</span>}
                </span>
              </span>
              {err && <span className="text-xs text-danger">{err.message}</span>}
            </motion.div>
          </div>
          <motion.div className="relative aspect-square sm:aspect-[5/4] -mx-2 sm:mx-0 lg:-mr-16 lg:scale-[1.12] lg:origin-left"
                      initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.15, duration: 1.2, ease }}>
            <Hero3D bare />
          </motion.div>
        </div>

        {/* the wordmark, under the slab, never over the animation */}
        <motion.div className="wordmark display text-center leading-[.85] whitespace-nowrap select-none mt-8 sm:mt-12" aria-hidden="true"
                    initial={{ opacity: 0, y: 40 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3, duration: 1.2, ease }}>
          Meal<span className="text-glow">Bridge</span>
        </motion.div>
      </section>

      {/* ---------- 2. live ticker ---------- */}
      <div id="ticker"><Ticker s={s} /></div>

      {/* ---------- 3. statement + live figures ---------- */}
      <section className="mx-auto max-w-7xl px-4 sm:px-6 py-16 sm:py-24" aria-labelledby="live-h">
       <div className="slab px-6 py-10 sm:px-12 sm:py-14">
        <motion.p className="display text-3xl sm:text-5xl leading-[1.12] max-w-5xl" {...rise}>
          Food that would be thrown away tonight, <span className="text-glow">matched to a shelter in minutes</span>,
          with every rule enforced by the database itself.
        </motion.p>

        <div className="mt-16 flex items-end justify-between flex-wrap gap-3 mb-8">
          <h2 id="live-h" className="text-2xl sm:text-3xl flex items-center gap-3"><span className="live-dot" aria-hidden="true" />Live from the database</h2>
          <span className="text-xs text-muted font-mono">
            SELECT * FROM v_impact_summary
            {s ? ` · ${s.from_day} to ${s.to_day}` : ""}
          </span>
        </div>
        <div className="grid lg:grid-cols-12 gap-4">
          <motion.div className="bezel lg:col-span-7" {...rise}>
            <div className="card h-full p-5 sm:p-6 flex flex-col">
              <div className="flex items-baseline justify-between">
                <div className="text-xs font-medium text-muted">Kilograms delivered per day</div>
              </div>
              <div className="mt-4 h-56 flex-1">
                {!d?.daily ? <Skeleton className="h-full" /> : (
                  <ResponsiveContainer width="100%" height="100%">
                    <AreaChart data={d.daily} margin={{ top: 8, right: 8, left: 8, bottom: 0 }}>
                      <defs>
                        <linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
                          <stop offset="0" stopColor="var(--leaf)" stopOpacity={0.45} /><stop offset="1" stopColor="var(--leaf)" stopOpacity={0} />
                        </linearGradient>
                      </defs>
                      <XAxis dataKey="day" tick={{ fontSize: 10, fill: "var(--muted)" }} tickFormatter={(v) => v.slice(5)} interval={6} axisLine={false} tickLine={false} />
                      <Tooltip contentStyle={{ background: "var(--surface)", border: "1px solid var(--line)", borderRadius: 12 }}
                               formatter={(v) => [fmt.kg(v), "delivered"]} />
                      <Area type="monotone" dataKey="kg_delivered" stroke="var(--leaf)" fill="url(#g)" strokeWidth={2} />
                    </AreaChart>
                  </ResponsiveContainer>
                )}
              </div>
            </div>
          </motion.div>
          <div className="lg:col-span-5 grid grid-cols-2 gap-4">
            {!s && [0, 1, 2, 3].map((i) => <Skeleton key={i} className="h-32" />)}
            {s && [
              ["Meals saved", s.meals_saved, fmt.n, "meal-equivalents delivered", "leaf"],
              ["Food diverted", s.kg_diverted, fmt.kg, `${s.rescue_rate_pct}% of posted kg rescued`, "ink"],
              ["Carbon avoided", s.co2e_avoided_kg, (v) => `${fmt.n(v)} kg`, "CO₂e avoided", "ink"],
              ["Avg. response", s.avg_response_min, (v) => `${fmt.n(v)} min`, "post to first claim", "accent"],
            ].map(([l, v, f, sub, tone], i) => (
              <motion.div key={l} className="bezel" {...rise} transition={{ ...rise.transition, delay: i * 0.08 }}>
                <div className="card card-lift h-full p-5">
                  <div className="text-xs font-medium text-muted">{l}</div>
                  <div className="text-2xl sm:text-3xl font-semibold tracking-tight mt-3 tabular-nums" style={{ color: `var(--${tone})` }}>
                    <CountUp value={v} format={f} />
                  </div>
                  <div className="text-[11px] text-muted mt-2">{sub}</div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
       </div>
      </section>

      {/* ---------- 4. scroll story: the SQL behind each step ---------- */}
      <ScrollStory />

      {/* ---------- 5. the index: every page ---------- */}
      <section className="mx-auto max-w-7xl px-4 sm:px-6 py-16 sm:py-24" aria-labelledby="index-h">
       <div className="slab px-6 py-10 sm:px-12 sm:py-14">
        <motion.div className="flex items-end justify-between flex-wrap gap-4 mb-10" {...rise}>
          <h2 id="index-h" className="text-4xl sm:text-6xl">Every <span className="text-glow">page</span></h2>
          <p className="text-muted max-w-sm text-sm leading-relaxed">
            Four dashboards, one per role, and four pages that show MySQL doing the work. Every screen also has an
            <span className="font-mono"> {"</>"} Under the hood</span> panel with the exact SQL each click ran.
          </p>
        </motion.div>
        <ol className="border-t border-line">
          {INDEX.map(([href, t, body, kind], i) => (
            <motion.li key={href} {...rise} transition={{ ...rise.transition, delay: Math.min(i, 4) * 0.05 }}>
              <Link href={href} className="index-row group grid grid-cols-[2.5rem_minmax(0,1fr)_auto] md:grid-cols-[3.5rem_minmax(0,1fr)_minmax(0,1.1fr)_auto] items-center gap-4 py-6 border-b border-line">
                <span className="font-mono text-xs text-muted tabular-nums">{String(i + 1).padStart(2, "0")}</span>
                <span className="display text-3xl sm:text-5xl transition-[transform,color] duration-700 group-hover:translate-x-3 group-hover:text-accent"
                      style={{ transitionTimingFunction: "var(--ease)" }}>{t}</span>
                <span className="hidden md:block text-sm text-muted leading-relaxed max-w-md">{body}</span>
                <span className="flex items-center gap-3">
                  <span className="chip hidden sm:inline-flex">{kind}</span>
                  <span className="btn-orb !mr-0 !w-11 !h-11 !bg-surface-2 group-hover:!bg-accent group-hover:text-accent-ink" aria-hidden="true">↗</span>
                </span>
              </Link>
            </motion.li>
          ))}
        </ol>
       </div>
      </section>

    </div>
  );
}
