"use client";
/* =====================================================================
   Chain-of-custody timeline, straight from table custody_event.
   Each event stores the SHA-256 of the previous event plus its own
   fields, so the rows form a hash chain. The verifier function
   fn_custody_first_bad_event walks the chain and names the first row
   that does not match, which is how tampering shows up.
   ===================================================================== */
import { useCallback, useEffect, useState } from "react";
import { PageHeader, Skeleton, StatusChip, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt, toast } from "@/lib/api";

const ICON = { COOKED: "🍳", PACKED: "📦", POSTED: "📣", CLAIMED: "🤝", PICKED_UP: "🛵", HYGIENE_CHECK: "🌡", DELIVERED: "✅", REJECTED: "⛔", EXPIRED: "⏰", CANCELLED: "↩" };

export default function CustodyPage() {
  const user = useRequireRole();
  const [d, setD] = useState(null);
  const [id, setId] = useState(null);
  const load = useCallback((batch) => api(`/api/lab/custody${batch ? `?batch_id=${batch}` : ""}`, { label: "Load custody chain" }).then((x) => { setD(x); setId(x.batch.batch_id); }).catch((e) => toast(e.message, "error")), []);
  useEffect(() => { if (user) load(null); }, [user, load]);
  if (!user) return null;

  return (
    <div className="mx-auto max-w-4xl px-4 sm:px-6 py-8">
      <PageHeader eyebrow="Database lab" title="Food-safety chain of custody">
        Every hand-over of a batch is one append-only row. UPDATE and DELETE on this table are refused by triggers,
        even for root, and each row's hash is computed from the previous row's hash.
      </PageHeader>

      {!d && <Skeleton className="h-80" />}
      {d && (
        <>
          <div className="card p-4 mb-5">
            <label className="label" htmlFor="pick">Batch</label>
            <select id="pick" className="input" value={id ?? ""} onChange={(e) => load(e.target.value)}>
              {d.recent.map((r) => <option key={r.batch_id} value={r.batch_id}>#{r.batch_id} · {r.description} · {r.status} · {r.events} events</option>)}
            </select>
          </div>

          <div className="card p-5 mb-5">
            <div className="flex flex-wrap items-start justify-between gap-3">
              <div>
                <h2 className="text-lg font-bold">{d.batch.description}</h2>
                <p className="text-sm text-muted">#{d.batch.batch_id} · {d.batch.mess} · {fmt.kg(d.batch.quantity_kg)} · {fmt.title(d.batch.storage)}</p>
                <p className="text-xs text-muted mt-1">cooked {fmt.dt(d.batch.cooked_at)} · safe until {fmt.dt(d.batch.safe_until)}</p>
              </div>
              <StatusChip status={d.batch.status} />
            </div>
            <div className={`mt-4 rounded-xl p-3 text-sm border ${d.chain.intact ? "border-leaf/50 bg-leaf/10 text-leaf" : "border-danger/50 bg-danger/10 text-danger"}`}>
              <b>{d.chain.intact ? "Hash chain intact." : `Tampering detected at event ${d.chain.first_bad_event}.`}</b>{" "}
              <span className="text-muted">fn_custody_first_bad_event({d.batch.batch_id}) returned {d.chain.first_bad_event}; 0 means every row's hash matches a recomputation.</span>
            </div>
          </div>

          <ol className="relative">
            {d.events.map((e, i) => (
              <li key={e.event_id} className="relative pl-12 pb-6">
                {i < d.events.length - 1 && <span className="absolute left-[18px] top-9 bottom-0 w-px bg-line" aria-hidden="true" />}
                <span className="absolute left-0 top-0 w-9 h-9 rounded-full bg-surface-2 border border-line flex items-center justify-center text-base" aria-hidden="true">{ICON[e.event_type] || "•"}</span>
                <div className="card p-4">
                  <div className="flex flex-wrap items-baseline justify-between gap-2">
                    <h3 className="font-bold">{fmt.title(e.event_type)}</h3>
                    <span className="text-xs text-muted font-mono">{new Date(e.event_time).toLocaleString([], { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit", second: "2-digit" })}</span>
                  </div>
                  <div className="mt-1 flex flex-wrap gap-1.5 text-xs">
                    <span className="chip">event #{e.event_id}</span>
                    {e.actor_user_id ? <span className="chip">by user #{e.actor_user_id}</span> : <span className="chip">written by a trigger or the expiry job</span>}
                    {e.claim_id && <span className="chip">claim #{e.claim_id}</span>}
                    {e.trip_id && <span className="chip">trip #{e.trip_id}</span>}
                    {e.temperature_c != null && <span className="chip">{e.temperature_c} °C</span>}
                    {e.hygiene_ok != null && <span className={`chip ${e.hygiene_ok ? "!text-leaf" : "!text-danger"}`}>hygiene {e.hygiene_ok ? "passed" : "failed"}</span>}
                  </div>
                  {e.notes && <p className="text-sm mt-2">{e.notes}</p>}
                  <p className="text-[10px] font-mono text-muted mt-2 break-all">
                    prev {e.prev_hash ? e.prev_hash.slice(0, 24) + "…" : "GENESIS"}<br />
                    this {e.row_hash.slice(0, 24)}… <span className="not-italic">= SHA2(prev ‖ row fields, 256)</span>
                  </p>
                </div>
              </li>
            ))}
          </ol>
          <p className="text-xs text-muted">
            Read with your login over index ix_ev_batch_time (batch_id, event_time). The verifier function is granted
            to the platform admin role only.
          </p>
        </>
      )}
      <SynthNote />
    </div>
  );
}
