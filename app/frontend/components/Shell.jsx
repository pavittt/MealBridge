"use client";
/* =====================================================================
   App shell: top navigation (links depend on the logged-in role), the
   theme switch, the "Under the hood" button and toasts.
   Polish: every page fades/slides in on navigation (Motion), and the
   Under-the-hood counter "pops" each time a new SQL call is recorded,
   so the eye is drawn to the database evidence, not away from it.
   MotionConfig reducedMotion="user" turns movement off for visitors
   who ask their OS for reduced motion.
   ===================================================================== */
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { MotionConfig, motion } from "motion/react";
import HoodPanel from "./HoodPanel";
import SiteIndex, { MenuButton } from "./SiteIndex";
import { getSession, hoodStore, sessionStore, setSession, toastStore, useStore } from "@/lib/api";

const HOME = { MESS_ADMIN: "/mess", SHELTER: "/shelter", VOLUNTEER: "/volunteer", PLATFORM_ADMIN: "/admin" };
const ROLE_LABEL = { MESS_ADMIN: "Mess admin", SHELTER: "Shelter", VOLUNTEER: "Volunteer", PLATFORM_ADMIN: "Platform admin" };
export const homeFor = (role) => HOME[role] || "/";

/* The mark: an accent-coloured (crimson) tile holding a bridge. The arch is the route from a
   mess to a shelter; the deck is the table it lands on; the green grain at
   the top of the arch is the meal in transit. */
export function LogoMark({ className = "w-9 h-9" }) {
  return (
    <svg viewBox="0 0 40 40" className={className} aria-hidden="true">
      <rect width="40" height="40" rx="12" fill="var(--accent)" />
      <path d="M8 27 C 11 11, 29 11, 32 27" fill="none" stroke="var(--accent-ink)" strokeWidth="3.2" strokeLinecap="round" />
      <path d="M6 28.5 H34" stroke="var(--accent-ink)" strokeWidth="3.2" strokeLinecap="round" />
      <path d="M14 28.5 V21.5 M20 28.5 V19 M26 28.5 V21.5" stroke="var(--accent-ink)" strokeWidth="1.6" strokeLinecap="round" opacity=".55" />
      <ellipse cx="20" cy="11.2" rx="3.4" ry="2.2" fill="var(--leaf)" stroke="var(--accent-ink)" strokeWidth="1.2" />
    </svg>
  );
}

/* Mark + wordmark. "Bridge" is set in the italic serif: the name reads as
   the product's promise (a meal, bridged). */
export function Logo({ size = "text-[1.35rem]", mark = "w-8 h-8" }) {
  return (
    <span className="inline-flex items-center gap-2.5">
      <LogoMark className={mark} />
      <span className={`display leading-none ${size}`} style={{ fontWeight: 600, letterSpacing: "-0.03em" }}>
        Meal<span className="text-glow" style={{ fontWeight: 500 }}>Bridge</span>
      </span>
    </span>
  );
}

function ThemeToggle() {
  // The light pastel-glass look is the default; the toggle flips to dark and back.
  // The choice is saved in localStorage and applied before paint (layout.jsx).
  const [theme, setTheme] = useState("light");
  useEffect(() => { try { setTheme(localStorage.getItem("mb_theme") === "dark" ? "dark" : "light"); } catch {} }, []);
  const apply = (t) => {
    setTheme(t);
    try { localStorage.setItem("mb_theme", t); } catch {}
    if (t === "dark") document.documentElement.setAttribute("data-theme", "dark");
    else document.documentElement.removeAttribute("data-theme");
  };
  const next = theme === "dark" ? "light" : "dark";
  return (
    <button className="btn btn-ghost !px-3 !py-1.5 text-xs text-muted" onClick={() => apply(next)}
            aria-label={`Theme: ${theme}. Switch to ${next}`} title={`Switch to ${next} theme`}>
      <span className="inline-block w-2.5 h-2.5 rounded-full border border-current"
            style={{ background: theme === "dark" ? "transparent" : "currentColor" }} aria-hidden="true" />
      <span className="hidden sm:inline">{theme === "dark" ? "Paper" : "Night"}</span>
    </button>
  );
}

function Toast() {
  const t = useStore(toastStore);
  useEffect(() => {
    if (!t) return;
    const id = setTimeout(() => toastStore.set(null), 5000);
    return () => clearTimeout(id);
  }, [t]);
  if (!t) return null;
  const color = { error: "border-danger text-danger", ok: "border-leaf text-leaf", info: "border-line" }[t.kind];
  return (
    <div role="status" aria-live="polite"
         className={`fixed bottom-5 left-1/2 -translate-x-1/2 z-[60] card px-4 py-3 shadow-xl border-2 ${color} max-w-[90vw] page-in`}
         style={{ background: "var(--surface)" }}>
      {t.message}
    </div>
  );
}

export default function Shell({ children }) {
  const path = usePathname();
  const router = useRouter();
  const session = useStore(sessionStore);
  const calls = useStore(hoodStore);
  const [hood, setHood] = useState(false);
  const [menu, setMenu] = useState(false);
  const [index, setIndex] = useState(false);   // the full-screen site index

  useEffect(() => { sessionStore.set(getSession()); }, []);
  useEffect(() => { setMenu(false); setIndex(false); }, [path]);

  const role = session?.user?.role;
  // Every main page, always visible: inline in the bar on wide screens and
  // in the full-screen index (Menu) on every screen size.
  const links = [
    ...(role ? [[homeFor(role), "My dashboard"]] : [["/", "Home"]]),
    ["/impact", "Impact"],
    ["/lab/race", "Race demo"],
    ["/lab/explain", "EXPLAIN"],
    ["/lab/custody", "Audit trail"],
    ["/lab/schema", "Schema"],
  ];
  const isActive = (href) => (href === "/" ? path === "/" : path.startsWith(href));

  return (
    <MotionConfig reducedMotion="user">
      <a href="#main" className="sr-only focus:not-sr-only focus:fixed focus:top-2 focus:left-2 btn btn-primary z-[70]">
        Skip to content
      </a>
      {/* floating "island" nav: detached from the top edge, a pill of frosted glass */}
      <header className="sticky top-3 z-40 px-3 sm:px-4">
        <div className="mx-auto max-w-7xl h-14 pl-3 pr-2 flex items-center gap-3 rounded-full border border-line glass-bar shadow-[inset_0_1px_0_var(--glass-edge),0_18px_40px_-24px_rgba(var(--shadow-tint),.9)]">
          <Link href="/" className="shrink-0 rounded-full" aria-label="MealBridge home">
            <Logo />
          </Link>
          <nav aria-label="Main" className="hidden lg:flex items-center gap-0.5 ml-1">
            {links.map(([href, label]) => (
              <Link key={href} href={href} aria-current={isActive(href) ? "page" : undefined}
                    className={`nav-link px-3 py-1.5 rounded-full text-sm font-medium whitespace-nowrap transition-colors duration-300 ${
                      isActive(href) ? "bg-surface-2 text-ink" : "text-muted hover:text-ink"}`}>
                {label}
              </Link>
            ))}
          </nav>
          <div className="ml-auto flex items-center gap-1.5">
            {role && (
              <button className="btn btn-ghost !px-3 !text-xs whitespace-nowrap" onClick={() => setHood(true)}
                      aria-label="Open the Under the hood panel" title="Under the hood: the SQL each click ran">
                <span className="font-mono">{"</>"}</span> <span className="hidden 2xl:inline">Under the hood</span>
                {calls.length > 0 && <span key={calls.length} className="chip pop !bg-accent !text-accent-ink !border-0">{calls.length}</span>}
              </button>
            )}
            <ThemeToggle />
            {role ? (
              <div className="relative hidden sm:block">
                <button className="btn btn-ghost !px-3" onClick={() => setMenu((m) => !m)} aria-expanded={menu} aria-haspopup="menu">
                  <span className="hidden 2xl:inline max-w-[160px] truncate">{session.user.full_name}</span>
                  <span className="chip">{ROLE_LABEL[role]}</span>
                </button>
                {menu && (
                  <div role="menu" className="absolute right-0 mt-3 w-64 card p-2 page-in" style={{ background: "var(--surface)" }}>
                    <div className="px-3 py-2 text-xs text-muted">
                      {session.user.site_name || "No site"} · user #{session.user.user_id}
                    </div>
                    <button role="menuitem" className="w-full text-left px-3 py-2 rounded-lg hover:bg-surface-2 text-sm text-danger"
                            onClick={() => { setSession(null); hoodStore.set([]); router.push("/login"); }}>
                      Log out
                    </button>
                  </div>
                )}
              </div>
            ) : (
              <Link href="/login" className="btn btn-primary !py-2 hidden sm:inline-flex">Log in <span className="btn-orb" aria-hidden="true">↗</span></Link>
            )}
            <MenuButton open={index} onClick={() => setIndex((v) => !v)} />
          </div>
        </div>
      </header>
      <SiteIndex open={index} onClose={() => setIndex(false)} role={role} isActive={isActive} user={session?.user}
                 onLogout={() => { setIndex(false); setSession(null); hoodStore.set([]); router.push("/login"); }} />
      {/* page transition: a new key per route replays the enter animation.
          Only opacity and y: a leftover filter/transform would trap the
          position:fixed modals inside pages. */}
      <motion.main id="main" key={path}
                   initial={{ opacity: 0, y: 10 }}
                   animate={{ opacity: 1, y: 0 }}
                   transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}>
        {children}
      </motion.main>
      <HoodPanel open={hood} onClose={() => setHood(false)} />
      {hood && <div className="fixed inset-0 z-40 bg-black/30" onClick={() => setHood(false)} aria-hidden="true" />}
      <Toast />
    </MotionConfig>
  );
}
