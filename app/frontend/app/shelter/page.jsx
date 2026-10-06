"use client";
/* =====================================================================
   Shelter dashboard.
   - Live feed: view v_live_feed ranked by fn_match_score(batch, my shelter).
   - Claim: CALL sp_claim_batch -> transaction with SELECT ... FOR UPDATE.
     If another shelter got there first, MySQL's answer is shown as is.
   - Today's capacity: a column-level UPDATE on shelter_day; the CHECK
     constraint refuses capacity below what is already reserved.
   ===================================================================== */
import { useCallback, useEffect, useMemo, useState } from "react";
import { AnimatePresence } from "motion/react";
import Modal from "@/components/Modal";
import ListItem from "@/components/motion/ListItem";
import RankingTable from "@/components/RankingTable";
import { CountdownRing, ErrorBox, PageHeader, Skeleton, StatusChip, SynthNote, useNow, useRequireRole } from "@/components/ui";
import { api, fmt, serverOffset, toast } from "@/lib/api";

function CapacityCard({ today, onSaved }) {
  const [edit, setEdit] = useState(false);
  const [v, setV] = useState({ meals_needed: "", capacity_kg: "" });
  const [err, setErr] = useState(null);
  useEffect(() => { if (today) setV({ meals_needed: today.meals_needed, capacity_kg: today.capacity_kg }); }, [today]);
  if (!today) return <Skeleton className="h-40" />;
  const pct = Math.min(100, (today.reserved_kg / today.capacity_kg) * 100);
  async function save(e) {
    e.preventDefault(); setErr(null);
    try { await api("/api/shelter/today", { method: "PUT", label: "Update today's capacity", body: { meals_needed: +v.meals_needed, capacity_kg: +v.capacity_kg } }); setEdit(false); onSaved(); toast("Saved", "ok"); }
    catch (e2) { setErr(e2); }
  }
  return (
    <section className="card p-5" aria-labelledby="cap-h">
      <div className="flex justify-between items-start">
        <h2 id="cap-h" className="font-bold">Today's capacity</h2>
        <button className="text-xs text-accent font-semibold" onClick={() => setEdit((x) => !x)}>{edit ? "Close" : "Edit"}</button>
      </div>
      <div className="mt-3 h-3 rounded-full bg-surface-2 overflow-hidden" role="progressbar" aria-valuenow={Math.round(pct)} aria-valuemin={0} aria-valuemax={100} aria-label="Capacity reserved">
        <div className="h-full bg-sky rounded-full transition-all" style={{ width: `${pct}%` }} />
      </div>
      <div className="mt-2 text-sm flex justify-between">
        <span><b>{fmt.kg(today.reserved_kg)}</b> reserved</span><span className="text-muted">of {fmt.kg(today.capacity_kg)}</span>
      </div>
      <p className="text-xs text-muted mt-1">{today.meals_needed} meals needed today. reserved_kg is kept by trigger trg_claim_ai; you cannot edit it.</p>
      {edit && (
        <form onSubmit={save} className="mt-4 space-y-3">
          <div className="grid grid-cols-2 gap-3">
            <div><label className="label" htmlFor="mn">Meals needed</label><input id="mn" className="input" type="number" min="0" value={v.meals_needed} onChange={(e) => setV({ ...v, meals_needed: e.target.value })} /></div>
            <div><label className="label" htmlFor="ck">Capacity kg</label><input id="ck" className="input" type="number" step="0.5" min="0.5" value={v.capacity_kg} onChange={(e) => setV({ ...v, capacity_kg: e.target.value })} /></div>
          </div>
          <ErrorBox error={err} />
          <button className="btn btn-primary w-full">Save</button>
        </form>
      )}
    </section>
  );
}

function FeedCard({ b, rank, now, offset, onClaim, onWhy, busy }) {
  const left = (new Date(b.safe_until).getTime() - (now + offset)) / 1000;
  const total = (new Date(b.safe_until) - new Date(b.posted_at)) / 1000;   // ring scale: posted -> deadline
  const eligible = b.match_score != null;
  return (
    <article className={`card p-4 flex gap-4 items-center ${eligible ? "" : "opacity-60"}`}>
      <div className="text-center w-14 shrink-0">
        <div className="text-2xl font-semibold tabular-nums" style={{ color: eligible ? "var(--accent)" : "var(--muted)" }}>{eligible ? Math.round(b.match_score) : "–"}</div>
        {/* the feed position, not the shelter's place among all shelters (that is in "Why?") */}
        <div className="text-[10px] text-muted leading-tight mt-0.5">{eligible ? `your score · #${rank} here` : "not eligible"}</div>
      </div>
      <div className="flex-1 min-w-0">
        <h3 className="font-bold truncate">{b.description}</h3>
        <p className="text-xs text-muted">{b.mess} · {b.category}</p>
        <div className="mt-2 flex flex-wrap gap-1.5">
          <span className="chip">{fmt.kg(b.quantity_kg)}</span>
          <span className="chip">≈ {b.meals_equiv} meals</span>
          <span className="chip">{fmt.title(b.storage)}</span>
          {b.diet_tags?.split(",").map((t) => <span key={t} className="chip">{fmt.title(t)}</span>)}
        </div>
      </div>
      <CountdownRing secondsLeft={left} totalSeconds={total} size={64} />
      <div className="flex flex-col gap-2 shrink-0">
        <button className="btn btn-primary" disabled={!eligible || busy} onClick={() => onClaim(b)}>{busy ? "Claiming…" : "Claim"}</button>
        <button className="btn btn-ghost !py-1 !text-xs" onClick={() => onWhy(b)}>Why?</button>
      </div>
    </article>
  );
}

export default function ShelterPage() {
  const user = useRequireRole("SHELTER");
  const [d, setD] = useState(null);
  const [claims, setClaims] = useState(null);
  const [err, setErr] = useState(null);
  const [busy, setBusy] = useState(null);
  const [why, setWhy] = useState(null);
  const now = useNow();

  const load = useCallback(() => {
    api("/api/shelter/feed", { label: "Load live feed" }).then(setD).catch(setErr);
    api("/api/shelter/claims").then(setClaims).catch(() => {});
  }, []);
  useEffect(() => {
    if (!user) return;
    load();
    const id = setInterval(load, 15000);     // the feed is live: refresh every 15 s
    return () => clearInterval(id);
  }, [user, load]);
  const offset = useMemo(() => serverOffset(d?.server_now), [d?.server_now]);

  async function claim(b) {
    setBusy(b.batch_id);
    try {
      const r = await api(`/api/shelter/batches/${b.batch_id}/claim`, { method: "POST", label: "Claim batch" });
      toast(`Claimed! Claim #${r.claim_id}. A volunteer can now pick it up.`, "ok");
    } catch (e) { toast(e.message, "error"); }
    finally { setBusy(null); load(); }
  }
  async function cancel(c) {
    if (!confirm(`Cancel claim #${c.claim_id}? The food goes back to the feed if still safe.`)) return;
    try { await api(`/api/shelter/claims/${c.claim_id}/cancel`, { method: "POST", label: "Cancel claim", body: { reason: "Shelter cancelled from the app" } }); toast("Claim cancelled", "ok"); load(); }
    catch (e) { toast(e.message, "error"); }
  }
  async function openWhy(b) {
    setWhy({ b, rows: null });
    try { const r = await api(`/api/shelter/batches/${b.batch_id}/why`, { label: "Explain match score" }); setWhy({ b, rows: r.ranking, me: r.me }); }
    catch (e) { setWhy(null); toast(e.message, "error"); }
  }

  if (!user) return null;
  let rank = 0;
  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 py-8">
      <PageHeader eyebrow="Shelter" title={d?.shelter?.name || user.site_name}>
        {d?.shelter ? `${fmt.title(d.shelter.shelter_type)} · ${d.shelter.beneficiary_count} people · ${d.shelter.has_refrigeration ? "has a fridge" : "no fridge"}${d.shelter.excludes ? ` · excludes ${d.shelter.excludes.split(",").map(fmt.title).join(", ")}` : ""}` : " "}
      </PageHeader>
      <ErrorBox error={err} />
      <div className="grid lg:grid-cols-[1fr_340px] gap-6 mt-4">
        <section aria-labelledby="feed-h">
          <div className="flex items-baseline justify-between mb-3">
            <h2 id="feed-h" className="text-xl font-bold">Available now, best match first</h2>
            <span className="text-xs text-muted">refreshes every 15 s</span>
          </div>
          <div className="space-y-3">
            {!d && [0, 1, 2].map((i) => <Skeleton key={i} className="h-28" />)}
            {d && d.batches.length === 0 && <div className="card p-8 text-center text-muted">No food available right now. You will be alerted when a mess posts.</div>}
            <AnimatePresence mode="popLayout">
              {d?.batches.map((b) => (
                <ListItem key={b.batch_id}>
                  <FeedCard b={b} rank={b.match_score != null ? ++rank : 0} now={now} offset={offset} onClaim={claim} onWhy={openWhy} busy={busy === b.batch_id} />
                </ListItem>
              ))}
            </AnimatePresence>
          </div>
        </section>
        <aside className="space-y-6">
          <CapacityCard today={d?.today} onSaved={load} />
          <section className="card p-5" aria-labelledby="claims-h">
            <h2 id="claims-h" className="font-bold mb-3">Your claims</h2>
            {!claims && <Skeleton className="h-40" />}
            <ul className="space-y-3">
              {claims?.slice(0, 8).map((c) => (
                <li key={c.claim_id} className="border-t border-line pt-3 text-sm">
                  <div className="flex justify-between gap-2"><b className="truncate">{c.description}</b><StatusChip status={c.batch_status} /></div>
                  <div className="text-xs text-muted">#{c.claim_id} · {c.mess} · {fmt.kg(c.quantity_kg)} · {fmt.dt(c.claimed_at)}{c.trip_status ? ` · trip ${fmt.title(c.trip_status).toLowerCase()}` : ""}</div>
                  {c.status === "ACTIVE" && c.batch_status === "CLAIMED" && (
                    <button className="text-xs text-danger font-semibold mt-1" onClick={() => cancel(c)}>Cancel claim</button>
                  )}
                </li>
              ))}
            </ul>
          </section>
        </aside>
      </div>
      <Modal open={!!why} wide title={why ? `Why this score? Batch #${why.b.batch_id}` : ""} onClose={() => setWhy(null)}>
        <p className="text-xs text-muted mb-3 font-mono">CALL sp_rank_shelters({why?.b.batch_id}, NULL) · your row is highlighted</p>
        {why?.rows ? <RankingTable rows={why.rows} me={why.me} /> : <Skeleton className="h-64" />}
      </Modal>
      <SynthNote />
    </div>
  );
}
