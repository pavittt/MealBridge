"use client";
/* =====================================================================
   Page transition: "lifting the cloche".
   Every new page is SERVED: a saffron serving dome covers the screen for
   a moment, a wisp of steam rises from its handle, a little card reads
   "Now serving: <page>", and then the dome is lifted up and tipped back
   in 3D to reveal the page underneath, which itself slides in like a
   tray being set down on the table.

   Cheap on purpose (this runs on an 8 GB laptop): one SVG and a few
   transforms and opacities, no canvas, no blur, nothing left mounted
   after ~1 s. Skipped on the very first load (the landing page has its
   own entrance) and completely under prefers-reduced-motion.
   ===================================================================== */
import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";

// what the little menu card says for each page
const DISHES = [
  ["/mess", "the mess kitchen"],
  ["/shelter", "your shelter's feed"],
  ["/volunteer", "today's pickup route"],
  ["/admin", "policy and audit"],
  ["/impact", "the impact numbers"],
  ["/lab/race", "a race, fresh off the lock"],
  ["/lab/explain", "query plans, before and after"],
  ["/lab/custody", "the chain of custody"],
  ["/lab/schema", "the whole schema"],
  ["/login", "the login"],
  ["/", "the home page"],
];
const dishFor = (path) => (DISHES.find(([p]) => (p === "/" ? path === "/" : path.startsWith(p))) || [null, "the next page"])[1];

const ease = [0.32, 0.72, 0, 1];

function Dome() {
  return (
    <svg viewBox="0 0 240 150" className="w-[min(62vw,420px)] h-auto drop-shadow-[0_30px_40px_rgba(0,0,0,.55)]" aria-hidden="true">
      <defs>
        <linearGradient id="cloche-metal" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#ffb27a" />
          <stop offset=".45" stopColor="var(--accent)" />
          <stop offset="1" stopColor="var(--accent-2)" />
        </linearGradient>
        <linearGradient id="cloche-shine" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0" stopColor="#fff" stopOpacity="0" />
          <stop offset=".5" stopColor="#fff" stopOpacity=".55" />
          <stop offset="1" stopColor="#fff" stopOpacity="0" />
        </linearGradient>
      </defs>
      {/* the dome */}
      <path d="M22 128 C 22 58, 218 58, 218 128 Z" fill="url(#cloche-metal)" />
      {/* a highlight sliding across the metal */}
      <path d="M60 110 C 70 80, 110 72, 140 76" fill="none" stroke="url(#cloche-shine)" strokeWidth="7" strokeLinecap="round" opacity=".8" />
      {/* the handle */}
      <rect x="108" y="52" width="24" height="12" rx="6" fill="var(--accent-2)" />
      <circle cx="120" cy="50" r="7" fill="#ffb27a" />
      {/* the rim and the plate */}
      <rect x="12" y="126" width="216" height="9" rx="4.5" fill="var(--accent-2)" />
      <ellipse cx="120" cy="140" rx="116" ry="7" fill="var(--surface-2)" />
    </svg>
  );
}

function Steam() {
  // three wisps that curl up from the handle
  return (
    <div className="absolute left-1/2 -translate-x-1/2 -top-14 flex gap-3" aria-hidden="true">
      {[0, 1, 2].map((i) => (
        <motion.span key={i} className="block w-1.5 h-10 rounded-full"
                     style={{ background: "linear-gradient(to top, color-mix(in oklab, var(--ink) 55%, transparent), transparent)" }}
                     initial={{ opacity: 0, y: 10, scaleY: 0.6 }}
                     animate={{ opacity: [0, 0.8, 0], y: [10, -14, -30], x: [0, i === 1 ? 4 : -4, 0], scaleY: [0.6, 1, 0.8] }}
                     transition={{ duration: 0.9, delay: 0.05 + i * 0.12, ease: "easeOut" }} />
      ))}
    </div>
  );
}

export default function Cloche({ path }) {
  const reduced = useReducedMotion();
  const first = useRef(true);
  const [serving, setServing] = useState(null);   // { key, dish } while the dome is up

  useEffect(() => {
    if (first.current) { first.current = false; return; }   // not on the first load
    if (reduced) return;
    const key = Date.now();
    setServing({ key, dish: dishFor(path) });
    const id = setTimeout(() => setServing((s) => (s?.key === key ? null : s)), 60);
    return () => clearTimeout(id);
  }, [path, reduced]);

  return (
    <AnimatePresence>
      {serving && (
        <motion.div key={serving.key} aria-hidden="true"
                    className="fixed inset-0 z-[65] pointer-events-none flex items-center justify-center"
                    style={{ perspective: 1200 }}
                    initial={{ opacity: 1 }} exit={{ opacity: 1 }}>
          {/* the table under the dome fades away as the lid lifts */}
          <motion.div className="absolute inset-0"
                      style={{ background: "radial-gradient(60% 60% at 50% 55%, color-mix(in oklab, var(--accent) 22%, var(--bg)), var(--bg))" }}
                      initial={{ opacity: 1 }} exit={{ opacity: 0 }} transition={{ duration: 0.55, delay: 0.5, ease }} />
          {/* the dome: holds for a beat, then is lifted up and tipped back */}
          <motion.div className="relative flex flex-col items-center" style={{ transformOrigin: "50% 100%" }}
                      initial={{ y: 0, rotateX: 0, scale: 1 }}
                      exit={{ y: "-75vh", rotateX: 58, rotateZ: -6, scale: 0.85, transition: { duration: 0.75, delay: 0.42, ease } }}>
            <Steam />
            <Dome />
            <motion.div className="mt-5 px-4 py-2 rounded-xl border border-line text-sm font-medium"
                        style={{ background: "var(--surface)", rotate: -2 }}
                        initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -6, transition: { duration: 0.2 } }}
                        transition={{ duration: 0.25 }}>
              <span className="text-muted">Now serving:</span> <span className="display text-accent">{serving.dish}</span>
            </motion.div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
