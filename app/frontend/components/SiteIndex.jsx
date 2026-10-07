"use client";
/* =====================================================================
   The site index: a full-screen menu listing EVERY main page, opened
   from the "Menu" button in the nav on any screen size. Big numbered
   serif links slide up one after another (staggered); Esc closes it.
   Pages that need a login say so, and role dashboards go straight to
   the login form with that role's demo accounts.
   ===================================================================== */
import Link from "next/link";
import { useEffect } from "react";
import { AnimatePresence, motion } from "motion/react";
import { homeFor } from "./Shell";

const ease = [0.32, 0.72, 0, 1];

export function MenuButton({ open, onClick }) {
  return (
    <button className="btn btn-ghost !pl-4 !pr-1.5 !py-1.5 !text-sm" onClick={onClick} aria-expanded={open}
            aria-controls="site-index" aria-label={open ? "Close the site index" : "Open the site index: every page"}>
      <span className="hidden sm:inline">{open ? "Close" : "Menu"}</span>
      {/* two lines that fold into an X */}
      <span className="relative w-8 h-8 rounded-full bg-surface-2 inline-flex items-center justify-center" aria-hidden="true">
        <span className="absolute h-[1.5px] w-3.5 bg-current transition-transform duration-500"
              style={{ transitionTimingFunction: "var(--ease)", transform: open ? "rotate(45deg)" : "translateY(-3px)" }} />
        <span className="absolute h-[1.5px] w-3.5 bg-current transition-transform duration-500"
              style={{ transitionTimingFunction: "var(--ease)", transform: open ? "rotate(-45deg)" : "translateY(3px)" }} />
      </span>
    </button>
  );
}

const GROUPS = (role) => [
  {
    title: "Use it",
    note: "One dashboard per role",
    items: [
      ["MESS_ADMIN", "Mess kitchen", "Post tonight's surplus and watch its safe time run down."],
      ["SHELTER", "Shelter", "Food ranked for you by the database. Claim with one click."],
      ["VOLUNTEER", "Volunteer", "Pick up from several messes on one route."],
      ["PLATFORM_ADMIN", "Platform admin", "Tune the matching weights and read the audit log."],
    ].map(([r, t, d]) => [role === r ? homeFor(r) : `/login?role=${r}`, t, d, role && role !== r ? "switch login" : role ? "" : "log in"]),
  },
  {
    title: "See the database",
    note: "MySQL doing the work, live",
    items: [
      ["/lab/race", "Race demo", "Two shelters, one batch, one row lock."],
      ["/lab/explain", "EXPLAIN", "The same query with and without its index."],
      ["/lab/custody", "Audit trail", "A hash-chained chain of custody, verified."],
      ["/lab/schema", "Schema", "Tables, keys, triggers and procedures, read live."],
    ].map(([h, t, d]) => [h, t, d, role ? "" : "log in"]),
  },
  {
    title: "Explore",
    note: "The overview",
    items: [
      ["/", "Home", "The story of one batch, from kitchen to shelter. No login needed."],
      ["/impact", "Impact", "Meals, kilograms and carbon, from the impact views."],
    ].map(([h, t, d]) => [h, t, d, h === "/impact" && !role ? "log in" : ""]),
  },
];

export default function SiteIndex({ open, onClose, role, isActive, user, onLogout }) {
  useEffect(() => {
    if (!open) return;
    const onKey = (e) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => { window.removeEventListener("keydown", onKey); document.body.style.overflow = prev; };
  }, [open, onClose]);

  let n = 0;
  return (
    <AnimatePresence>
      {open && (
        <motion.div id="site-index" role="dialog" aria-modal="true" aria-label="Site index"
                    className="fixed inset-0 z-30 overflow-y-auto"
                    style={{ background: "color-mix(in oklab, var(--bg) 88%, transparent)", backdropFilter: "blur(28px) saturate(140%)", WebkitBackdropFilter: "blur(28px) saturate(140%)" }}
                    initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} transition={{ duration: 0.45, ease }}>
          {/* who is logged in, and the way out (on phones the nav bar has no room for it) */}
          <div className="mx-auto max-w-7xl px-5 sm:px-8 pt-24 flex flex-wrap items-center justify-between gap-3 text-sm">
            {user ? (
              <>
                <span className="text-muted">Logged in as <b className="text-ink">{user.full_name}</b>{user.site_name ? ` · ${user.site_name}` : ""}</span>
                <button className="btn btn-ghost !py-1.5 !text-xs text-danger" onClick={onLogout}>Log out</button>
              </>
            ) : (
              <>
                <span className="text-muted">Not logged in. Every demo account uses the password <span className="font-mono">demo1234</span>.</span>
                <Link href="/login" onClick={onClose} className="btn btn-primary !py-1.5 !text-xs">Log in</Link>
              </>
            )}
          </div>
          <div className="mx-auto max-w-7xl px-5 sm:px-8 pt-8 pb-16 grid grid-cols-1 gap-12 lg:grid-cols-3">
            {GROUPS(role).map((g, gi) => (
              <section key={g.title} aria-labelledby={`ix-${gi}`} className="min-w-0">
                <motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.05 + gi * 0.06, duration: 0.6, ease }}
                            className="flex items-baseline justify-between border-b border-line pb-3 mb-2">
                  <h2 id={`ix-${gi}`} className="text-sm font-medium" style={{ fontFamily: "var(--font-sans)", letterSpacing: 0 }}>{g.title}</h2>
                  <span className="text-xs text-muted">{g.note}</span>
                </motion.div>
                <ul>
                  {g.items.map(([href, t, d, tag]) => {
                    n += 1;
                    const i = n;
                    return (
                      <motion.li key={t} className="overflow-hidden"
                                 initial={{ opacity: 0, y: 40 }} animate={{ opacity: 1, y: 0 }}
                                 transition={{ delay: 0.1 + i * 0.045, duration: 0.7, ease }}>
                        <Link href={href} onClick={onClose} aria-current={isActive(href) ? "page" : undefined}
                              className="group grid grid-cols-[2.25rem_minmax(0,1fr)_auto] items-baseline gap-2 py-3 border-b border-line/60">
                          <span className="font-mono text-xs text-muted tabular-nums">{String(i).padStart(2, "0")}</span>
                          <span>
                            <span className={`display block text-3xl sm:text-4xl transition-[color,transform] duration-500 group-hover:translate-x-1.5 ${isActive(href) ? "text-accent" : "group-hover:text-accent"}`}
                                  style={{ transitionTimingFunction: "var(--ease)" }}>
                              {t}
                            </span>
                            <span className="block text-sm text-muted mt-1">{d}</span>
                          </span>
                          <span className="flex items-center gap-2">
                            {tag && <span className="chip">{tag}</span>}
                            <span className="btn-orb !mr-0 !bg-surface-2 group-hover:!bg-accent group-hover:text-accent-ink" aria-hidden="true">↗</span>
                          </span>
                        </Link>
                      </motion.li>
                    );
                  })}
                </ul>
              </section>
            ))}
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
