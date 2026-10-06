"use client";
/* Accessible dialog: Escape closes, focus moves into it, background dims.
   Rendered into <body> through a portal: the glass cards use
   backdrop-filter, and a position:fixed element inside such a card is
   positioned relative to the card instead of the window. The dialog
   itself is opaque so the page behind never shows through the text. */
import { useEffect, useRef } from "react";
import { createPortal } from "react-dom";

export default function Modal({ open, title, onClose, children, wide = false }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!open) return;
    ref.current?.focus();
    const onKey = (e) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open, onClose]);
  if (!open) return null;
  return createPortal(
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" role="dialog" aria-modal="true" aria-label={title}>
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={onClose} aria-hidden="true" />
      <div ref={ref} tabIndex={-1}
           className={`relative card w-full ${wide ? "max-w-5xl" : "max-w-lg"} max-h-[88vh] overflow-y-auto p-6 shadow-2xl page-in outline-none`}
           style={{ background: "var(--surface)" }}>
        <div className="flex items-start justify-between gap-4 mb-4">
          <h2 className="text-xl font-bold">{title}</h2>
          <button className="btn btn-ghost !px-3" onClick={onClose} aria-label="Close">✕</button>
        </div>
        {children}
      </div>
    </div>,
    document.body
  );
}
