"use client";
/* Small shared UI pieces. */
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { getSession, sessionStore, useStore } from "@/lib/api";

/* ---- role guard: sends you to /login if not logged in with that role ---
   Returns the SAME user object until the session changes. Pages load
   their data in useEffect(..., [user]); if this returned a fresh object
   on every render (as getSession() does, it parses localStorage), each
   load would re-render, re-run the effect and load again, an endless
   stream of requests. Keeping the user in state stops that. */
export function useRequireRole(...roles) {
  const router = useRouter();
  const session = useStore(sessionStore);
  const [user, setUser] = useState(null);
  useEffect(() => {
    const s = getSession();
    if (!s) { router.replace("/login"); return; }
    if (roles.length && !roles.includes(s.user.role)) { router.replace("/login?wrong=1"); return; }
    // only swap the object when it is a different login
    setUser((u) => (u && u.user_id === s.user.user_id && u.role === s.user.role ? u : s.user));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [session]);
  return user;
}

/* ---- live clock that ticks every second (for countdowns) -------------- */
export function useNow(intervalMs = 1000) {
  const [now, setNow] = useState(() => Date.now());
  useEffect(() => {
    const id = setInterval(() => setNow(Date.now()), intervalMs);
    return () => clearInterval(id);
  }, [intervalMs]);
  return now;
}

/* ---- perishability countdown ring --------------------------------------
   fraction = time left / total safe window (cooked_at -> safe_until,
   both decided by MySQL's trigger). Colour moves leaf -> saffron -> red. */
const fmtEnded = (t) => t.charAt(0).toUpperCase() + t.slice(1);

export function CountdownRing({ secondsLeft, totalSeconds, size = 76, label = true, endedText = "expired" }) {
  const left = Math.max(0, secondsLeft);
  const frac = totalSeconds > 0 ? Math.min(1, left / totalSeconds) : 0;
  const r = size / 2 - 6;
  const c = 2 * Math.PI * r;
  const color = left <= 0 ? "var(--muted)" : frac > 0.5 ? "var(--leaf)" : frac > 0.2 ? "var(--warn)" : "var(--danger)";
  const h = Math.floor(left / 3600), m = Math.floor((left % 3600) / 60), s = Math.floor(left % 60);
  // keep the label inside the ring: no space before the "m" on small rings
  const gap = size >= 72 ? " " : "";
  const text = left <= 0 ? endedText : h > 0 ? `${h}h${gap}${String(m).padStart(2, "0")}m` : `${m}:${String(s).padStart(2, "0")}`;
  // a longer word ("delivered") steps down a size so it stays inside the ring
  const fontPx = (size >= 72 ? 13 : 11) - (text.length > 7 ? 2 : 0);
  return (
    <div className="relative shrink-0" style={{ width: size, height: size }}
         role="img" aria-label={left <= 0 ? fmtEnded(endedText) : `${h} hours ${m} minutes of safe time left`}>
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size / 2} cy={size / 2} r={r} stroke="var(--surface-2)" strokeWidth="6" fill="none" />
        <circle cx={size / 2} cy={size / 2} r={r} stroke={color} strokeWidth="6" fill="none" strokeLinecap="round"
                strokeDasharray={c} strokeDashoffset={c * (1 - frac)} style={{ transition: "stroke-dashoffset 1s linear, stroke .5s" }} />
      </svg>
      {label && (
        <div className="absolute inset-0 flex flex-col items-center justify-center leading-none">
          <span className="font-mono font-bold" style={{ color, fontSize: fontPx }}>{text}</span>
          {left > 0 && size >= 72 && <span className="text-[9px] text-muted mt-0.5">safe</span>}
        </div>
      )}
    </div>
  );
}

export function Skeleton({ className = "h-24" }) {
  return <div className={`skeleton ${className}`} aria-hidden="true" />;
}

export function PageHeader({ title, children, actions }) {
  return (
    <div className="flex flex-wrap items-end justify-between gap-4 mt-4 mb-10">
      <div>
        <h1 className="text-4xl sm:text-5xl">{title}</h1>
        {children && <p className="text-muted mt-3 max-w-[62ch] leading-relaxed">{children}</p>}
      </div>
      {actions && <div className="flex gap-2 flex-wrap">{actions}</div>}
    </div>
  );
}

export function ErrorBox({ error }) {
  if (!error) return null;
  return (
    <div role="alert" className="rounded-xl border border-danger/40 bg-danger/10 text-danger p-4 text-sm">
      {error.message || String(error)}
    </div>
  );
}

export function Stat({ label, value, sub, tone = "ink" }) {
  return (
    <div className="card p-5">
      <div className="text-xs text-muted font-medium">{label}</div>
      <div className="text-3xl font-semibold tracking-tight tabular-nums mt-2" style={{ color: `var(--${tone})` }}>{value}</div>
      {sub && <div className="text-[11px] text-muted mt-1.5">{sub}</div>}
    </div>
  );
}

const STATUS_TONE = {
  AVAILABLE: "text-leaf", CLAIMED: "text-sky", IN_TRANSIT: "text-warn", DELIVERED: "text-leaf",
  EXPIRED: "text-danger", CANCELLED: "text-muted", ACTIVE: "text-sky", FULFILLED: "text-leaf",
  REJECTED: "text-danger", PLANNED: "text-sky", IN_PROGRESS: "text-warn", COMPLETED: "text-leaf",
};
export function StatusChip({ status }) {
  // sentence case ("In transit"), a small dot in the status colour
  const text = String(status).replace("_", " ").toLowerCase();
  return (
    <span className={`chip ${STATUS_TONE[status] || ""}`}>
      <span className="w-1.5 h-1.5 rounded-full bg-current" aria-hidden="true" />
      {text.charAt(0).toUpperCase() + text.slice(1)}
    </span>
  );
}

/* The synthetic-data note used to sit at the foot of every page. It was taken
   off the screens on request; the SYN names and the TO VERIFY markers stay in
   the database (food_category.values_source) and in the documents. */
export function SynthNote() {
  return null;
}
