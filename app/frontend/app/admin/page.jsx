"use client";
/* =====================================================================
   Platform admin: matching policy, audit log, and the two jobs.
   Changing a weight is a plain column-level UPDATE on scoring_weight;
   trigger trg_weight_au writes the old and new value to audit_log, so
   the panel can show that policy changes are always traceable.
   ===================================================================== */
import { useCallback, useEffect, useState } from "react";
import { ErrorBox, PageHeader, Skeleton, Stat, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt, toast } from "@/lib/api";

export default function AdminPage() {
  const user = useRequireRole("PLATFORM_ADMIN");
  const [d, setD] = useState(null);
  const [err, setErr] = useState(null);
  const [edit, setEdit] = useState({});
  const [busy, setBusy] = useState(null);
  const load = useCallback(() => api("/api/admin/overview", { label: "Load admin dashboard" }).then((x) => { setD(x); setEdit(Object.fromEntries(x.weights.map((w) => [w.weight_key, w.weight_value]))); }).catch(setErr), []);
  useEffect(() => { if (user) load(); }, [user, load]);

  const total = Object.values(edit).reduce((a, v) => a + Number(v || 0), 0);

  async function save(key) {
    setBusy(key);
    try { await api(`/api/admin/weights/${key}`, { method: "PUT", label: `Change weight ${key}`, body: { weight_value: Number(edit[key]) } }); toast(`${key} weight updated. The next match score uses it.`, "ok"); load(); }
    catch (e) { toast(e.message, "error"); } finally { setBusy(null); }
  }
  async function run(what) {
    setBusy(what);
    try {
      if (what === "expire") { await api("/api/admin/expire", { method: "POST", label: "Run the expiry job" }); toast("sp_expire_batches finished", "ok"); }
      else { const r = await api("/api/admin/forecast", { method: "POST", label: "Generate tomorrow's forecast", body: {} }); toast(`Forecast for ${r.day}: ${r.forecast.length} mess/slot rows`, "ok"); }
      load();
    } catch (e) { toast(e.message, "error"); } finally { setBusy(null); }
  }

  if (!user) return null;
  const c = d?.counts;
  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 py-8">
      <PageHeader eyebrow="Platform admin" title="Policy and audit"
        actions={<>
          <button className="btn btn-ghost" disabled={busy === "expire"} onClick={() => run("expire")}>{busy === "expire" ? "Running…" : "Run expiry job"}</button>
          <button className="btn btn-ghost" disabled={busy === "forecast"} onClick={() => run("forecast")}>{busy === "forecast" ? "Running…" : "Forecast tomorrow"}</button>
        </>}>
        The matching weights live in a table, so policy changes need no code change, and a trigger audits every one.
      </PageHeader>
      <ErrorBox error={err} />

      <div className="grid grid-cols-2 lg:grid-cols-6 gap-4 mb-6">
        {!c && [0, 1, 2, 3, 4, 5].map((i) => <Skeleton key={i} className="h-24" />)}
        {c && <>
          <Stat label="Messes" value={c.messes} /><Stat label="Shelters" value={c.shelters} /><Stat label="Volunteers" value={c.volunteers} />
          <Stat label="Available now" value={c.available_batches} tone="leaf" /><Stat label="Active claims" value={c.active_claims} tone="sky" /><Stat label="Open trips" value={c.open_trips} tone="accent" />
        </>}
      </div>

      <div className="grid lg:grid-cols-2 gap-6">
        <section className="card p-5" aria-labelledby="w-h">
          <h2 id="w-h" className="font-bold">Matching policy weights</h2>
          <p className="text-xs text-muted mb-4">fn_match_score takes a weighted average of the five component scores. Weights come from table scoring_weight at every call.</p>
          {!d && <Skeleton className="h-56" />}
          <ul className="space-y-4">
            {d?.weights.map((w) => (
              <li key={w.weight_key}>
                <div className="flex items-baseline justify-between gap-2">
                  <label className="font-semibold text-sm" htmlFor={`w-${w.weight_key}`}>{fmt.title(w.weight_key)}</label>
                  <span className="font-mono text-sm">{Number(edit[w.weight_key]).toFixed(3)}</span>
                </div>
                <p className="text-xs text-muted">{w.description}</p>
                <div className="flex gap-2 items-center mt-1">
                  <input id={`w-${w.weight_key}`} type="range" min="0" max="1" step="0.025" className="flex-1"
                         value={edit[w.weight_key] ?? 0} onChange={(e) => setEdit({ ...edit, [w.weight_key]: e.target.value })} />
                  <button className="btn btn-ghost !py-1 !text-xs" disabled={busy === w.weight_key || Number(edit[w.weight_key]) === Number(w.weight_value)}
                          onClick={() => save(w.weight_key)}>Save</button>
                </div>
              </li>
            ))}
          </ul>
          {d && <p className={`text-xs mt-4 ${Math.abs(total - 1) > 0.001 ? "text-warn" : "text-muted"}`}>
            Weights add up to {total.toFixed(3)}. The score divides by the sum, so they need not be exactly 1, but
            keeping them at 1 makes the numbers easier to explain.
          </p>}
        </section>

        <section className="card p-5" aria-labelledby="a-h">
          <h2 id="a-h" className="font-bold">Audit log, newest first</h2>
          <p className="text-xs text-muted mb-3">Written by triggers. db_user is USER(), the real login, because CURRENT_USER() inside a trigger would return the trigger's definer. Nobody can UPDATE or DELETE these rows.</p>
          {!d && <Skeleton className="h-72" />}
          <div className="max-h-[520px] overflow-y-auto">
            <table className="w-full text-xs">
              <thead className="text-muted text-left sticky top-0 bg-surface"><tr><th className="py-1">#</th><th>Row</th><th>Action</th><th>Login</th><th>When</th></tr></thead>
              <tbody>
                {d?.audit.map((a) => (
                  <tr key={a.audit_id} className="border-t border-line align-top">
                    <td className="py-1.5">{a.audit_id}</td>
                    <td className="font-mono">{a.table_name} #{a.row_pk}</td>
                    <td>{a.action}</td>
                    <td className="font-mono">{a.db_user}</td>
                    <td className="whitespace-nowrap text-muted">{fmt.dt(a.changed_at)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </div>
      <SynthNote />
    </div>
  );
}
