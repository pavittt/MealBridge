"use client";
/* =====================================================================
   "Under the hood" panel.
   Shows, for the latest API call (or any earlier one), exactly what the
   database did: the MySQL login + role, every SQL statement with its
   time and row count, the transaction, the triggers that fire, and the
   rows those triggers actually wrote (custody events, audit rows).
   All of it comes from the API response; nothing here is hard-coded.
   ===================================================================== */
import { useEffect, useState } from "react";
import { hoodStore, useStore, fmt } from "@/lib/api";
import Sql from "@/components/Sql";

export default function HoodPanel({ open, onClose }) {
  const calls = useStore(hoodStore);
  const [idx, setIdx] = useState(0);
  // Default to the newest WRITE (a call with a named action), because that is
  // the one with a transaction and triggers to show. Reads that happen right
  // after it (the page reloading itself) would otherwise hide it.
  useEffect(() => {
    const write = calls.findIndex((c) => c.hood?.action);
    setIdx(write >= 0 && write <= 3 ? write : 0);
  }, [calls]);
  useEffect(() => {
    const onKey = (e) => e.key === "Escape" && onClose();
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [onClose]);

  const c = calls[idx];
  const h = c?.hood;
  return (
    // "invisible" when closed: otherwise its shadow bleeds onto the right edge
    // of every page, and its buttons stay reachable with the Tab key.
    <aside
      aria-label="Under the hood"
      className={`fixed inset-y-0 right-0 z-50 w-full max-w-[560px] bg-surface border-l border-line shadow-2xl
                  transition-[transform,visibility] duration-300 ${open ? "translate-x-0 visible" : "translate-x-full invisible"} flex flex-col`}
      aria-hidden={!open}
    >
      <div className="flex items-center justify-between px-5 py-4 border-b border-line">
        <div>
          <h2 className="text-lg font-bold">Under the hood</h2>
          <p className="text-xs text-muted">What MySQL did for each action on this page</p>
        </div>
        <button className="btn btn-ghost !px-3" onClick={onClose} aria-label="Close panel">✕</button>
      </div>

      {calls.length > 1 && (
        <div className="px-5 py-2 border-b border-line">
          <label className="label" htmlFor="hood-pick">Call</label>
          <select id="hood-pick" className="input" value={idx} onChange={(e) => setIdx(+e.target.value)}>
            {calls.map((k, i) => (
              <option key={i} value={i}>
                {fmt.time(k.at)} · {k.hood?.action ? k.hood.action.replace("_", " ") + " · " : ""}{k.method} {k.path}
                {k.error ? " · ERROR" : ""}
              </option>
            ))}
          </select>
        </div>
      )}

      <div className="flex-1 overflow-y-auto px-5 py-4 space-y-5 text-sm">
        {!c && <p className="text-muted">Do something on the page (post, claim, open a list) and the SQL appears here.</p>}
        {c && (
          <>
            <section>
              <div className="flex flex-wrap gap-2">
                <span className="chip">login <b className="text-ink">{h.login}</b></span>
                <span className="chip">role <b className="text-ink">{h.mysql_role}</b></span>
                {h.procedure && <span className="chip">procedure <b className="text-ink">{h.procedure}</b></span>}
              </div>
              {c.error && (
                <div className="mt-3 rounded-xl border border-danger/40 bg-danger/10 p-3 text-danger">
                  <b>MySQL refused it{c.mysqlError ? ` (error ${c.mysqlError})` : ""}:</b> {c.error}
                </div>
              )}
            </section>

            {h.transaction && (
              <section>
                <h3 className="font-bold mb-1">Transaction</h3>
                <p className="text-muted leading-relaxed">{h.transaction}</p>
                {h.guard && <p className="mt-2 text-muted"><b className="text-ink">Guard:</b> {h.guard}</p>}
              </section>
            )}

            <section>
              <h3 className="font-bold mb-2">SQL that ran ({h.statements?.length || 0})</h3>
              <ol className="space-y-2">
                {h.statements?.map((s, i) => (
                  <li key={i}>
                    <Sql className={s.error ? "!border-danger" : ""}>{s.sql}</Sql>
                    <div className="mt-1 text-[11px] text-muted">
                      {s.error ? <span className="text-danger">{s.error}</span> : <>{s.ms} ms · {s.rows} row(s)</>}
                    </div>
                  </li>
                ))}
              </ol>
            </section>

            {h.triggers?.length > 0 && (
              <section>
                <h3 className="font-bold mb-2">Triggers fired</h3>
                <ul className="space-y-2">
                  {h.triggers.map((t) => (
                    <li key={t.name} className="rounded-xl border border-line p-3">
                      <div className="font-mono text-xs font-bold text-accent">{t.name}</div>
                      <div className="text-[11px] text-muted">{t.on}</div>
                      <div className="mt-1">{t.does}</div>
                    </li>
                  ))}
                </ul>
              </section>
            )}

            {h.evidence && (
              <section>
                <h3 className="font-bold mb-1">Evidence: rows the triggers wrote</h3>
                <p className="text-[11px] text-muted mb-2">Read afterwards with {h.evidence.read_with}</p>
                {h.evidence.custody_events.length > 0 && (
                  <table className="w-full text-xs mb-3">
                    <thead className="text-muted text-left"><tr><th>event</th><th>type</th><th>batch</th><th>hash (prev → row)</th></tr></thead>
                    <tbody>
                      {h.evidence.custody_events.map((e) => (
                        <tr key={e.event_id} className="border-t border-line">
                          <td className="py-1">{e.event_id}</td><td className="font-semibold">{e.event_type}</td>
                          <td>{e.batch_id}</td>
                          <td className="font-mono">{e.prev_hash || "GENESIS"} → {e.row_hash}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
                {h.evidence.audit_rows.length > 0 && (
                  <table className="w-full text-xs">
                    <thead className="text-muted text-left"><tr><th>audit</th><th>table</th><th>action</th><th>db_user (USER())</th></tr></thead>
                    <tbody>
                      {h.evidence.audit_rows.map((a) => (
                        <tr key={a.audit_id} className="border-t border-line">
                          <td className="py-1">{a.audit_id}</td><td>{a.table_name} #{a.row_pk}</td>
                          <td>{a.action}</td><td className="font-mono">{a.db_user}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </section>
            )}
          </>
        )}
      </div>
    </aside>
  );
}
