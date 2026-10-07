"use client";
/* =====================================================================
   LIVE CONCURRENCY DEMO.
   The API posts a fresh batch, then two shelter sessions call
   sp_claim_batch at almost the same moment. Session A is told to hold
   its row lock for 2.5 s (a demo-only switch) so you can watch B wait.
   A third session reads performance_schema.data_locks while B waits.
   Everything on this page is measured, not animated for show.
   ===================================================================== */
import { useState } from "react";
import { PageHeader, Skeleton, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt, toast } from "@/lib/api";

function Lane({ label, c, max }) {
  if (!c) return null;
  const won = c.result === "CLAIMED";
  return (
    <div className={`card p-4 border-2 ${won ? "!border-leaf" : "!border-danger"}`}>
      <div className="flex items-baseline justify-between gap-2">
        <div>
          <span className="chip">session {label}</span>
          <h3 className="font-bold mt-1">{c.shelter}</h3>
          <p className="text-xs text-muted">shelter #{c.shelter_id} · match score {c.score}</p>
        </div>
        <span className={`display text-xl font-extrabold ${won ? "text-leaf" : "text-danger"}`}>{won ? "WON" : "LOST"}</span>
      </div>
      <div className="mt-3">
        <div className="h-2 rounded-full bg-surface-2 overflow-hidden">
          <div className={`h-full rounded-full ${won ? "bg-leaf" : "bg-danger"}`} style={{ width: `${(c.took_ms / max) * 100}%` }} />
        </div>
        <p className="text-xs text-muted mt-1">returned after <b className="font-mono text-ink">{c.took_ms} ms</b>{won ? "" : " — it was blocked on A's row lock, then re-read the row"}</p>
      </div>
      <p className={`mt-3 text-sm font-mono ${won ? "text-leaf" : "text-danger"}`}>{c.result}</p>
      {won && <p className="text-xs text-muted mt-1">claim #{c.claim_id}</p>}
    </div>
  );
}

export default function RacePage() {
  const user = useRequireRole();
  const [d, setD] = useState(null);
  const [busy, setBusy] = useState(false);
  async function run() {
    setBusy(true); setD(null);
    try { setD(await api("/api/lab/race", { method: "POST", label: "Run the concurrency demo" })); }
    catch (e) { toast(e.message, "error"); } finally { setBusy(false); }
  }
  if (!user) return null;
  const max = d ? Math.max(...Object.values(d.contenders).map((c) => c.took_ms)) : 1;

  return (
    <div className="mx-auto max-w-5xl px-4 sm:px-6 py-8">
      <PageHeader title="Two shelters, one batch"
        actions={<button className="btn btn-primary" onClick={run} disabled={busy}>{busy ? "Racing…" : d ? "Run again" : "Run the race"}</button>}>
        Both shelters claim the same batch at the same moment. The database, not the application, decides that exactly
        one of them wins. Press the button and watch what happened, in milliseconds.
      </PageHeader>

      <section className="card p-5 mb-6">
        <h2 className="font-bold mb-2">The three layers that stop a double claim</h2>
        <ol className="text-sm space-y-2 list-decimal pl-5 text-muted">
          <li><b className="text-ink">Row lock.</b> sp_claim_batch runs <code className="font-mono text-xs">SELECT status, safe_until FROM surplus_batch WHERE batch_id = ? FOR UPDATE</code> inside a transaction. The second session blocks there until the first commits, then re-reads the row under its own lock and sees CLAIMED.</li>
          <li><b className="text-ink">Trigger.</b> trg_claim_bi refuses any claim on a batch that is not AVAILABLE.</li>
          <li><b className="text-ink">Unique index.</b> claim.active_batch_id is a generated column (batch_id while the claim is live, NULL otherwise) with a UNIQUE index, so at most one live claim per batch can exist even if code skipped the procedure.</li>
        </ol>
      </section>

      {busy && <Skeleton className="h-64" />}

      {d && (
        <>
          <p className="text-sm text-muted mb-3">
            Fresh batch <b className="text-ink">#{d.batch_id}</b> posted through sp_post_batch. Session A holds its lock for
            {" "}{d.hold_seconds} s; session B starts {d.b_delay_s} s later.
          </p>
          <div className="grid sm:grid-cols-2 gap-4">
            <Lane label="A" c={d.contenders.A} max={max} />
            <Lane label="B" c={d.contenders.B} max={max} />
          </div>

          <section className="card p-5 mt-6">
            <h2 className="font-bold mb-3">What InnoDB was doing while B waited</h2>
            <p className="text-xs text-muted mb-3 font-mono">SELECT ... FROM performance_schema.data_locks WHERE OBJECT_NAME = 'surplus_batch' AND LOCK_TYPE = 'RECORD'</p>
            <div className="overflow-x-auto">
              <table className="w-full text-xs">
                <thead className="text-muted text-left"><tr><th className="py-1">Session</th><th>Index</th><th>Mode</th><th>Status</th><th>Row</th></tr></thead>
                <tbody>
                  {d.locks.map((l, i) => (
                    <tr key={i} className="border-t border-line">
                      <td className="py-1 font-semibold">{l.session}</td><td className="font-mono">{l.INDEX_NAME}</td>
                      <td className="font-mono">{l.LOCK_MODE}</td>
                      <td className={l.LOCK_STATUS === "WAITING" ? "text-danger font-bold" : "text-leaf"}>{l.LOCK_STATUS}</td>
                      <td className="font-mono">{l.LOCK_DATA}</td>
                    </tr>
                  ))}
                  {d.locks.length === 0 && <tr><td colSpan={5} className="py-2 text-muted">The monitor looked after the race had already finished. Run it again.</td></tr>}
                </tbody>
              </table>
            </div>
            {d.waits.length > 0 && <p className="text-xs text-muted mt-2">data_lock_waits: thread {d.waits[0].REQUESTING_THREAD_ID} is blocked by thread {d.waits[0].BLOCKING_THREAD_ID}.</p>}
          </section>

          <section className="card p-5 mt-6">
            <h2 className="font-bold mb-3">Timeline</h2>
            <ol className="text-sm space-y-1 font-mono">
              {d.timeline.map((e, i) => (
                <li key={i} className="flex gap-3 border-t border-line py-1">
                  <span className="text-muted w-16 shrink-0 text-right">{e.t_ms} ms</span>
                  <span className={`w-16 shrink-0 font-bold ${e.who === "A" ? "text-leaf" : e.who === "B" ? "text-danger" : "text-sky"}`}>{e.who}</span>
                  <span className="text-xs break-all">{e.what}</span>
                </li>
              ))}
            </ol>
          </section>

          <section className="card p-5 mt-6">
            <h2 className="font-bold mb-2">The result in the tables</h2>
            <p className="text-sm">Batch #{d.final_batch.batch_id} is now <b>{d.final_batch.status}</b>, and the UNIQUE index allows only the one live claim:</p>
            <table className="w-full text-xs mt-3">
              <thead className="text-muted text-left"><tr><th className="py-1">claim_id</th><th>shelter</th><th>status</th><th>active_batch_id (generated, UNIQUE)</th></tr></thead>
              <tbody>
                {d.claims.map((c) => (
                  <tr key={c.claim_id} className="border-t border-line">
                    <td className="py-1">{c.claim_id}</td><td>#{c.shelter_site_id}</td><td>{c.status}</td>
                    <td className="font-mono">{c.active_batch_id ?? "NULL"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <p className="text-xs text-muted mt-2">The losing session rolled back, so it left no claim row at all.</p>
          </section>
        </>
      )}
      <SynthNote />
    </div>
  );
}
