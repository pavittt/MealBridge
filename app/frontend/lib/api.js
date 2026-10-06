"use client";
/* =====================================================================
   API client + two tiny shared stores.

   api(path, options)  calls the FastAPI backend (through the Next.js
   /api rewrite). Every response is {data, hood}. The "hood" (the SQL
   that really ran) is pushed into hoodStore, and the "Under the hood"
   panel re-renders with it. Errors carry MySQL's own message.

   There is NO mock data anywhere in the frontend: if the API is down,
   the screens say so.
   ===================================================================== */
import { useSyncExternalStore } from "react";

/* ---- a minimal store (subscribe / get / set) ------------------------ */
function createStore(initial) {
  let value = initial;
  const subs = new Set();
  return {
    get: () => value,
    set: (v) => { value = typeof v === "function" ? v(value) : v; subs.forEach((f) => f()); },
    subscribe: (f) => { subs.add(f); return () => subs.delete(f); },
  };
}
export function useStore(store) {
  return useSyncExternalStore(store.subscribe, store.get, store.get);
}

/* hoodStore keeps the last 25 calls, newest first */
export const hoodStore = createStore([]);
export const toastStore = createStore(null);

export function toast(message, kind = "info") {
  toastStore.set({ message, kind, id: Date.now() });
}

/* ---- session (token kept in localStorage) --------------------------- */
const KEY = "mb_session";
export function getSession() {
  try { return JSON.parse(localStorage.getItem(KEY)) || null; } catch { return null; }
}
export function setSession(s) {
  try { s ? localStorage.setItem(KEY, JSON.stringify(s)) : localStorage.removeItem(KEY); } catch {}
  sessionStore.set(s);
}
export const sessionStore = createStore(null);

export class ApiError extends Error {
  constructor(status, message, detail) { super(message); this.status = status; this.detail = detail; }
}

/* ---- the call ------------------------------------------------------- */
export async function api(path, { method = "GET", body, label } = {}) {
  const s = getSession();
  const headers = { "Content-Type": "application/json" };
  if (s?.token) headers.Authorization = `Bearer ${s.token}`;
  let res;
  try {
    res = await fetch(path, { method, headers, body: body ? JSON.stringify(body) : undefined });
  } catch {
    throw new ApiError(0, "Cannot reach the API. Is the backend running on port 8000?");
  }
  let json = null;
  try { json = await res.json(); } catch {}
  const entry = { at: new Date(), method, path, label: label || `${method} ${path}`, status: res.status };
  if (!res.ok) {
    const d = json?.detail;
    const msg = typeof d === "string" ? d : d?.message || `HTTP ${res.status}`;
    if (d?.hood) hoodStore.set((h) => [{ ...entry, hood: d.hood, error: msg, mysqlError: d.mysql_error }, ...h].slice(0, 25));
    if (res.status === 401 && s) setSession(null);
    throw new ApiError(res.status, msg, d);
  }
  if (json?.hood) hoodStore.set((h) => [{ ...entry, hood: json.hood }, ...h].slice(0, 25));
  return json?.data;
}

/* ---- formatting helpers -------------------------------------------- */
export const fmt = {
  kg: (v) => (v == null ? "–" : `${Number(v).toLocaleString("en-IN", { maximumFractionDigits: 1 })} kg`),
  n: (v, d = 0) => (v == null ? "–" : Number(v).toLocaleString("en-IN", { maximumFractionDigits: d })),
  time: (v) => (v ? new Date(v).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) : "–"),
  dt: (v) => (v ? new Date(v).toLocaleString([], { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" }) : "–"),
  title: (s) => (s ? String(s).replace(/_/g, " ").toLowerCase().replace(/^\w/, (c) => c.toUpperCase()) : ""),
};

/* server time vs browser time: countdowns use the SERVER clock, since
   MySQL's NOW() decides expiry */
export function serverOffset(serverNow) {
  return serverNow ? new Date(serverNow).getTime() - Date.now() : 0;
}
