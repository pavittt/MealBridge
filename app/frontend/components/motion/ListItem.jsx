"use client";
/* =====================================================================
   One animated row of a live list (shelter feed, mess batches).
   When the database changes the list (a batch is claimed, expires or is
   posted), the row slides in or out and the others glide into place
   (Motion "layout"), so the user SEES the state change MySQL made
   instead of the list jumping. Wrap the list in <AnimatePresence>.
   ===================================================================== */
import { motion } from "motion/react";

// React 19 passes `ref` as a normal prop; AnimatePresence mode="popLayout"
// needs it to measure the row that is leaving.
export default function ListItem({ children, ref }) {
  return (
    <motion.div
      ref={ref}
      layout
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, x: 40, transition: { duration: 0.25 } }}
      transition={{ duration: 0.35, ease: [0.16, 1, 0.3, 1] }}
    >
      {children}
    </motion.div>
  );
}
