"use client";
/* =====================================================================
   Wrapper around the 3D hero. It decides WHETHER and WHEN to draw it:

   - lazy-loaded: three.js (~150 kB gzipped) is a separate chunk fetched
     only on the landing page, after the text has rendered (dynamic import,
     ssr: false), so it never delays the first paint or the login page;
   - no WebGL (old browser, locked-down lab PC): the flat SVG is shown;
   - prefers-reduced-motion: the scene is drawn once, standing still;
   - off screen: the render loop is stopped (IntersectionObserver).
   ===================================================================== */
import dynamic from "next/dynamic";
import { useEffect, useRef, useState } from "react";
import { usePrefersReducedMotion, useThemeColors } from "@/components/motion/useMotionPrefs";

const HeroScene = dynamic(() => import("./HeroScene"), {
  ssr: false,
  loading: () => <div className="absolute inset-0 hero-glow" aria-hidden="true" />,
});

function hasWebGL() {
  try {
    const c = document.createElement("canvas");
    return !!(c.getContext("webgl2") || c.getContext("webgl"));
  } catch { return false; }
}

/* The flat fallback: a mess and a shelter joined by a route, parcel moving along it. */
export function RouteArt() {
  return (
    <svg viewBox="0 0 520 260" className="w-full h-auto" role="img" aria-label="Food moving from a hostel mess to a shelter">
      <defs>
        <linearGradient id="arc" x1="0" x2="1">
          <stop offset="0" stopColor="var(--leaf)" /><stop offset="1" stopColor="var(--accent)" />
        </linearGradient>
      </defs>
      <path id="route" d="M70 200 C 170 20, 350 20, 450 200" fill="none" stroke="url(#arc)" strokeWidth="4" strokeDasharray="10 10" strokeLinecap="round" />
      <rect x="30" y="190" width="80" height="50" rx="10" fill="var(--surface)" stroke="var(--line)" />
      <text x="70" y="220" textAnchor="middle" fontSize="13" fontWeight="700" fill="var(--ink)">Mess</text>
      <rect x="410" y="190" width="80" height="50" rx="10" fill="var(--surface)" stroke="var(--line)" />
      <text x="450" y="220" textAnchor="middle" fontSize="13" fontWeight="700" fill="var(--ink)">Shelter</text>
      <g>
        <rect x="-14" y="-11" width="28" height="22" rx="5" fill="var(--accent)" />
        <animateMotion dur="4.5s" repeatCount="indefinite" rotate="auto"><mpath href="#route" /></animateMotion>
      </g>
    </svg>
  );
}

export default function Hero3D({ bare = false, className = "" }) {
  const box = useRef(null);
  const reduced = usePrefersReducedMotion();
  const colors = useThemeColors(["bg", "surface", "surface-2", "line", "ink", "accent", "accent-2", "leaf", "sky"]);
  const [gl, setGl] = useState(null);          // null = not checked yet
  const [onScreen, setOnScreen] = useState(true);

  useEffect(() => { setGl(hasWebGL()); }, []);
  useEffect(() => {
    if (!box.current) return;
    const io = new IntersectionObserver(([e]) => setOnScreen(e.isIntersecting), { threshold: 0.01 });
    io.observe(box.current);
    return () => io.disconnect();
  }, []);

  return (
    <figure className={bare ? `absolute inset-0 m-0 ${className}` : "relative"}>
      <div ref={box} className={bare ? "absolute inset-0" : "relative aspect-[5/4] w-full"} role="img"
           aria-label="Illustration: saffron hostel messes send parcels of food along arcs to green shelters">
        {gl === false ? (
          <div className="absolute inset-0 flex items-center"><RouteArt /></div>
        ) : gl && colors.accent ? (
          <HeroScene colors={colors} running={onScreen} still={reduced} />
        ) : (
          <div className="absolute inset-0 hero-glow" aria-hidden="true" />
        )}
      </div>
      {!bare && <figcaption className="mt-2 flex flex-wrap items-center justify-center gap-x-4 gap-y-1 text-[11px] text-muted">
        <span><i className="legend-dot bg-accent" /> mess</span>
        <span><i className="legend-dot bg-leaf" /> shelter</span>
        <span>Illustrative scene, not data. The live numbers below come from MySQL.</span>
      </figcaption>}
    </figure>
  );
}
