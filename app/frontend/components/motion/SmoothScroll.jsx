"use client";
/* =====================================================================
   Smooth scrolling (Lenis) driven by GSAP's ticker, so the scroll story
   (GSAP ScrollTrigger) and the smooth scroll move on the same clock and
   never drift apart. Used on the landing page only: the dashboards keep
   the browser's normal scrolling, which is what people expect in a tool.
   Skipped entirely with prefers-reduced-motion.
   ===================================================================== */
import { useEffect } from "react";
import gsap from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import Lenis from "lenis";
import "lenis/dist/lenis.css";
import { usePrefersReducedMotion } from "./useMotionPrefs";

gsap.registerPlugin(ScrollTrigger);

export default function SmoothScroll() {
  const reduced = usePrefersReducedMotion();
  useEffect(() => {
    if (reduced) return;
    const lenis = new Lenis({ duration: 1.1, autoRaf: false });
    lenis.on("scroll", ScrollTrigger.update);        // keep ScrollTrigger in sync
    const tick = (time) => lenis.raf(time * 1000);   // gsap time is in seconds
    gsap.ticker.add(tick);
    gsap.ticker.lagSmoothing(0);
    return () => { gsap.ticker.remove(tick); lenis.destroy(); };
  }, [reduced]);
  return null;
}
