"use client";
/* =====================================================================
   Mess admin dashboard.
   - Post surplus: CALL sp_post_batch(...). We never send safe_until;
     the BEFORE INSERT trigger computes it, and the card shows MySQL's value.
   - Each batch has a live perishability countdown ring.
   - "Who gets this?" runs the matching procedure sp_rank_shelters.
   - Withdraw: CALL sp_cancel_batch (only AVAILABLE batches of this mess).
   ===================================================================== */
import { useCallback, useEffect, useMemo, useState } from "react";
import { AnimatePresence } from "motion/react";
import Modal from "@/components/Modal";
import ListItem from "@/components/motion/ListItem";
import RankingTable from "@/components/RankingTable";
import { CountdownRing, ErrorBox, PageHeader, Skeleton, StatusChip, SynthNote, useNow, useRequireRole } from "@/components/ui";
import { api, fmt, serverOffset, toast } from "@/lib/api";

const SLOTS = ["BREAKFAST", "LUNCH", "SNACKS", "DINNER"];
const STORAGE = [["HOT_HELD", "Hot-held", "safe_hours_hot_held"], ["AMBIENT", "Room temp", "safe_hours_ambient"], ["CHILLED", "Chilled", "safe_hours_chilled"]];

// "YYYY-MM-DDTHH:mm" in local time, for <input type="datetime-local">
const toLocalInput = (ms) => { const d = new Date(ms); d.setSeconds(0, 0); return new Date(d - d.getTimezoneOffset() * 60000).toISOString().slice(0, 16); };

function PostForm({ options, offset, onPosted }) {
  const [f, setF] = useState(() => ({
    category_id: "", meal_slot: "LUNCH", description: "", quantity_kg: "", storage: "HOT_HELD",
    cooked_at: toLocalInput(Date.now() + offset - 30 * 60000), diet_tags: ["VEG"],
  }));
  const [busy, setBusy] = useState(false);
  const [err, setErr] = useState(null);
  const set = (k) => (e) => setF({ ...f, [k]: e.target.value });
  const cat = options.categories.find((c) => c.category_id === +f.category_id);
  const hours = cat ? Number(cat[STORAGE.find((s) => s[0] === f.storage)[2]]) : null;

  async function submit(e) {
    e.preventDefault();
    setBusy(true); setErr(null);
    try {
      const b = await api("/api/mess/batches", {
        method: "POST", label: "Post surplus batch",
        body: { ...f, category_id: +f.category_id, quantity_kg: +f.quantity_kg, cooked_at: f.cooked_at + ":00" },
      });
      toast(`Batch #${b.batch_id} posted. MySQL set safe-until to ${fmt.time(b.safe_until)}.`, "ok");
      setF({ ...f, description: "", quantity_kg: "" });
      onPosted();
    } catch (e2) { setErr(e2); } finally { setBusy(false); }
  }

  return (
    <form onSubmit={submit} className="card p-5 space-y-4" aria-labelledby="post-h">
      <h2 id="post-h" className="text-lg font-bold">Post surplus</h2>
      <div>
        <label className="label" htmlFor="cat">Food type</label>
        <select id="cat" className="input" required value={f.category_id} onChange={set("category_id")}>
          <option value="">Choose…</option>
          {options.categories.map((c) => <option key={c.category_id} value={c.category_id}>{c.name} ({c.risk_level.toLowerCase()} risk)</option>)}
        </select>
      </div>
      <div>
        <label className="label" htmlFor="desc">Description</label>
        <input id="desc" className="input" required minLength={3} maxLength={255} placeholder="e.g. Sambar rice, 2 vessels"
               value={f.description} onChange={set("description")} />
      </div>
      <div className="grid grid-cols-2 gap-3">
        <div>
          <label className="label" htmlFor="qty">Quantity (kg)</label>
          <input id="qty" className="input" type="number" step="0.1" min="0.1" max="2000" required value={f.quantity_kg} onChange={set("quantity_kg")} />
        </div>
        <div>
          <label className="label" htmlFor="slot">Meal</label>
          <select id="slot" className="input" value={f.meal_slot} onChange={set("meal_slot")}>
            {SLOTS.map((s) => <option key={s} value={s}>{fmt.title(s)}</option>)}
          </select>
        </div>
      </div>
      <fieldset>
        <legend className="label">Storage</legend>
        <div className="grid grid-cols-3 gap-2">
          {STORAGE.map(([v, l]) => (
            <label key={v} className={`btn btn-ghost !text-xs cursor-pointer ${f.storage === v ? "!border-accent !bg-accent/10" : ""}`}>
              <input type="radio" name="storage" value={v} checked={f.storage === v} onChange={set("storage")} className="sr-only" />{l}
            </label>
          ))}
        </div>
      </fieldset>
      <div>
        <label className="label" htmlFor="cooked">Cooked at</label>
        <input id="cooked" className="input" type="datetime-local" required value={f.cooked_at} onChange={set("cooked_at")} />
      </div>
      <fieldset>
        <legend className="label">Contains (diet tags)</legend>
        <div className="flex flex-wrap gap-1.5">
          {options.diet_tags.map((t) => {
            const on = f.diet_tags.includes(t.tag_code);
            return (
              <button key={t.tag_code} type="button" aria-pressed={on} title={t.description}
                      onClick={() => setF({ ...f, diet_tags: on ? f.diet_tags.filter((x) => x !== t.tag_code) : [...f.diet_tags, t.tag_code] })}
                      className={`chip cursor-pointer ${on ? "!bg-ink !text-bg !border-ink" : ""}`}>
                {fmt.title(t.tag_code)}
              </button>
            );
          })}
        </div>
      </fieldset>
      {hours != null && (
        <p className="text-xs text-muted rounded-lg bg-surface-2 p-2.5">
          {cat.name} stored {STORAGE.find((s) => s[0] === f.storage)[1].toLowerCase()} is safe for <b className="text-ink">{hours} h</b> after
          cooking. The trigger <code className="font-mono">trg_batch_bi</code> will set safe-until, not this form.
          <span className="block mt-1">Source: {cat.values_source}</span>
        </p>
      )}
      <ErrorBox error={err} />
      <button className="btn btn-primary w-full" disabled={busy}>{busy ? "Posting…" : "Post batch"}</button>
    </form>
  );
}

function BatchCard({ b, now, offset, onRank, onCancel }) {
  const left = (new Date(b.safe_until).getTime() - (now + offset)) / 1000;
  const live = ["AVAILABLE", "CLAIMED", "IN_TRANSIT"].includes(b.status);
  return (
    <article className="card p-4 flex gap-4">
      {/* a delivered or withdrawn batch did not expire: the ring says so */}
      <CountdownRing secondsLeft={live ? left : 0} totalSeconds={b.safe_window_s}
                     endedText={live || b.status === "EXPIRED" ? "expired" : b.status === "DELIVERED" ? "delivered" : "closed"} />
      <div className="flex-1 min-w-0">
        <div className="flex items-start justify-between gap-2">
          <div className="min-w-0">
            <h3 className="font-bold truncate">{b.description}</h3>
            <p className="text-xs text-muted">#{b.batch_id} · {b.category} · {fmt.title(b.meal_slot)} · posted {fmt.time(b.created_at)}</p>
          </div>
          <StatusChip status={b.status} />
        </div>
        <div className="mt-2 flex flex-wrap gap-2 text-xs">
          <span className="chip">{fmt.kg(b.quantity_kg)}</span>
          <span className="chip">≈ {b.meals_equiv} meals</span>
          <span className="chip">{fmt.title(b.storage)}</span>
          <span className="chip">safe until {fmt.time(b.safe_until)}</span>
        </div>
        {b.claimed_by_shelter && (
          <p className="mt-2 text-sm">Claimed by <b>{b.claimed_by_shelter}</b> <span className="text-muted">· score {b.match_score} at {fmt.time(b.claimed_at)}</span></p>
        )}
        <div className="mt-3 flex gap-2">
          <button className="btn btn-ghost !py-1.5 !text-xs" onClick={() => onRank(b)}>Who gets this?</button>
          {b.status === "AVAILABLE" && <button className="btn btn-ghost !py-1.5 !text-xs text-danger" onClick={() => onCancel(b)}>Withdraw</button>}
        </div>
      </div>
    </article>
  );
}

export default function MessPage() {
  const user = useRequireRole("MESS_ADMIN");
  const [d, setD] = useState(null);
  const [opts, setOpts] = useState(null);
  const [hist, setHist] = useState(null);
  const [err, setErr] = useState(null);
  const [rank, setRank] = useState(null);
  const now = useNow();

  const load = useCallback(() => {
    api("/api/mess/overview", { label: "Load mess dashboard" }).then(setD).catch(setErr);
    api("/api/mess/history").then(setHist).catch(() => {});
  }, []);
  useEffect(() => {
    if (!user) return;
    load();
    api("/api/mess/form-options").then(setOpts).catch(setErr);
    const id = setInterval(load, 30000);       // refresh claims every 30 s
    return () => clearInterval(id);
  }, [user, load]);

  const offset = useMemo(() => serverOffset(d?.server_now), [d?.server_now]);

  async function openRank(b) {
    setRank({ batch: b, rows: null });
    try { const r = await api(`/api/mess/batches/${b.batch_id}/ranking`, { label: "Run matching procedure" }); setRank({ batch: b, rows: r.ranking }); }
    catch (e) { setRank(null); toast(e.message, "error"); }
  }
  async function cancel(b) {
    if (!confirm(`Withdraw batch #${b.batch_id}?`)) return;
    try { await api(`/api/mess/batches/${b.batch_id}/cancel`, { method: "POST", label: "Withdraw batch" }); toast("Batch withdrawn", "ok"); load(); }
    catch (e) { toast(e.message, "error"); }
  }

  if (!user) return null;
  const today = d?.batches || [];
  const totals = today.reduce((a, b) => ({ kg: a.kg + Number(b.quantity_kg), live: a.live + (b.status === "AVAILABLE" ? 1 : 0) }), { kg: 0, live: 0 });

  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 py-8">
      <PageHeader title={d?.mess?.name || "Your mess"}>
        {d?.mess ? `${d.mess.campus}, block ${d.mess.hostel_block} · ${fmt.title(d.mess.mess_type)} · ${fmt.n(d.mess.daily_capacity_meals)} meals a day` : " "}
      </PageHeader>
      <ErrorBox error={err} />

      <div className="grid lg:grid-cols-[380px_1fr] gap-6 mt-4">
        <div className="space-y-6">
          {opts && d ? <PostForm options={opts} offset={offset} onPosted={load} /> : <Skeleton className="h-[560px]" />}
          <section className="card p-5" aria-labelledby="fc-h">
            <h2 id="fc-h" className="font-bold">Surplus forecast</h2>
            <p className="text-xs text-muted mb-3">sp_generate_forecast: average leftover on the same weekday over the last 4 weeks. A baseline, not a promise (error is roughly 35 to 55% on this data).</p>
            {!d && <Skeleton className="h-16" />}
            {d && d.forecast.length === 0 && <p className="text-sm text-muted">No forecast stored for today or tomorrow.</p>}
            <ul className="space-y-1 text-sm">
              {d?.forecast.map((f) => (
                <li key={f.forecast_date + f.meal_slot} className="flex justify-between border-t border-line pt-1">
                  <span>{f.forecast_date} · {fmt.title(f.meal_slot)}</span><b>{fmt.kg(f.predicted_kg)}</b>
                </li>
              ))}
            </ul>
          </section>
        </div>

        <section aria-labelledby="today-h">
          <div className="flex items-baseline justify-between mb-3 flex-wrap gap-2">
            <h2 id="today-h" className="text-xl font-bold">Today and yesterday</h2>
            <span className="text-sm text-muted">{today.length} batches · {fmt.kg(totals.kg)} · {totals.live} waiting for a shelter</span>
          </div>
          <div className="grid xl:grid-cols-2 gap-4">
            {!d && [0, 1, 2, 3].map((i) => <Skeleton key={i} className="h-36" />)}
            {d && today.length === 0 && <p className="text-muted">Nothing posted yet today.</p>}
            <AnimatePresence mode="popLayout">
              {today.map((b) => (
                <ListItem key={b.batch_id}>
                  <BatchCard b={b} now={now} offset={offset} onRank={openRank} onCancel={cancel} />
                </ListItem>
              ))}
            </AnimatePresence>
          </div>

          {hist && hist.length > 0 && (
            <div className="card p-5 mt-6">
              <h2 className="font-bold mb-3">Last 14 days at this mess</h2>
              <div className="flex items-end gap-1.5" role="img" aria-label="Daily kg delivered versus expired">
                {(() => {
                  // one bar per day: expired stacked on top of delivered, scaled to the busiest day
                  const max = Math.max(...hist.map((x) => Number(x.kg_posted))) || 1;
                  const H = 120;   // px, so the heights do not depend on a percentage parent
                  const kg = (v) => Math.round(Number(v));
                  // the kilograms are printed above each bar, always (not only on hover):
                  // delivered in green, expired in red when there was any
                  return hist.map((h) => (
                    <div key={h.day} className="flex-1 min-w-0 flex flex-col justify-end items-stretch gap-px" style={{ height: H + 30 }}
                         title={`${h.day}: ${h.kg_delivered} kg delivered, ${h.kg_expired} kg expired of ${h.kg_posted} kg`}>
                      <div className="text-center leading-tight tabular-nums mb-0.5" aria-hidden="true">
                        {Number(h.kg_expired) > 0 && <div className="text-[9px] text-danger">{kg(h.kg_expired)}</div>}
                        <div className="text-[10px] font-semibold text-leaf">{Number(h.kg_delivered) > 0 ? kg(h.kg_delivered) : ""}</div>
                      </div>
                      <div className="bg-danger/70 rounded-t" style={{ height: (Number(h.kg_expired) / max) * H }} />
                      <div className="bg-leaf rounded-b" style={{ height: (Number(h.kg_delivered) / max) * H }} />
                    </div>
                  ));
                })()}
              </div>
              <div className="flex gap-1.5 mt-1">
                {hist.map((h) => <div key={h.day} className="flex-1 text-[9px] text-muted text-center">{h.day.slice(8)}</div>)}
              </div>
              <div className="flex gap-4 mt-2 text-xs text-muted"><span><span className="inline-block w-2 h-2 bg-leaf rounded-sm" /> kg delivered</span><span><span className="inline-block w-2 h-2 bg-danger/70 rounded-sm" /> kg expired</span></div>
            </div>
          )}
        </section>
      </div>

      <Modal open={!!rank} wide title={rank ? `Matching for batch #${rank.batch.batch_id}: ${rank.batch.description}` : ""} onClose={() => setRank(null)}>
        <p className="text-xs text-muted mb-3 font-mono">CALL sp_rank_shelters({rank?.batch.batch_id}, NULL)</p>
        {rank?.rows ? <RankingTable rows={rank.rows} /> : <Skeleton className="h-64" />}
      </Modal>
      <SynthNote />
    </div>
  );
}
