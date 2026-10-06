"use client";
/* =====================================================================
   Two small hooks the animated pieces share.

   usePrefersReducedMotion()  true when the visitor asked the OS for
     less motion. Every animation in the app checks this and shows a
     still version instead (WCAG 2.3.3).
   useThemeColors(names)      reads the design-system CSS variables
     (--accent, --leaf, ...) as real colour strings, and re-reads them
     when the theme switches, so the WebGL scene matches light/dark mode.
   ===================================================================== */
import { useEffect, useState } from "react";

export function usePrefersReducedMotion() {
  const [reduced, setReduced] = useState(false);
  useEffect(() => {
    const mq = window.matchMedia("(prefers-reduced-motion: reduce)");
    const update = () => setReduced(mq.matches);
    update();
    mq.addEventListener("change", update);
    return () => mq.removeEventListener("change", update);
  }, []);
  return reduced;
}

export function useThemeColors(names) {
  const read = () => {
    if (typeof window === "undefined") return {};
    const css = getComputedStyle(document.documentElement);
    return Object.fromEntries(names.map((n) => [n, css.getPropertyValue(`--${n}`).trim()]));
  };
  const [colors, setColors] = useState(read);
  useEffect(() => {
    const update = () => setColors(read());
    update();
    // the theme toggle sets data-theme on <html>; "system" follows the OS
    const obs = new MutationObserver(update);
    obs.observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] });
    const mq = window.matchMedia("(prefers-color-scheme: dark)");
    mq.addEventListener("change", update);
    return () => { obs.disconnect(); mq.removeEventListener("change", update); };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  return colors;
}
