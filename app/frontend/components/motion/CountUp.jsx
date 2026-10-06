"use client";
/* =====================================================================
   A number that counts up from 0 to its real value the first time it
   scrolls into view. The VALUE always comes from the API (a MySQL view);
   only the counting is decoration. With reduced motion it simply shows
   the final number. Screen readers get the final number straight away
   (aria-label), not the ticking digits.
   ===================================================================== */
import { animate, useInView } from "motion/react";
import { useEffect, useRef, useState } from "react";
import { usePrefersReducedMotion } from "./useMotionPrefs";

export default function CountUp({ value, format = (v) => v, duration = 1.4 }) {
  const ref = useRef(null);
  const inView = useInView(ref, { once: true, margin: "-40px" });
  const reduced = usePrefersReducedMotion();
  const target = Number(value) || 0;
  const [shown, setShown] = useState(0);

  useEffect(() => {
    if (!inView) return;
    if (reduced) { setShown(target); return; }
    const controls = animate(0, target, { duration, ease: [0.16, 1, 0.3, 1], onUpdate: setShown });
    return () => controls.stop();
  }, [inView, reduced, target, duration]);

  return (
    <span ref={ref} aria-label={String(format(target))}>
      <span aria-hidden="true">{format(shown)}</span>
    </span>
  );
}
