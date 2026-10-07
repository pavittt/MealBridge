"use client";
/* =====================================================================
   Volunteer dashboard.
   - Pickup queue: view v_pickup_queue (the role has no SELECT on claim).
   - Plan a trip from several claims: CALL sp_create_trip(...). MySQL
     orders the stops, computes ETAs with window functions and refuses a
     route on which any food would arrive after its safe-until time.
   - At each stop: sp_record_pickup (temperature) and sp_record_delivery
     (hygiene check). Each writes hash-chained custody events.
   ===================================================================== */
import dynamic from "next/dynamic";
import { useCallback, useEffect, useMemo, useState } from "react";
import { ErrorBox, PageHeader, Skeleton, StatusChip, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt, toast } from "@/lib/api";

// the map is heavy and browser-only: load it lazily so the page never waits for it
const TripMap = dynamic(() => import("@/components/TripMap"), { ssr: false, loading: () => <Skeleton className="h-full" /> });

function StopRow({ trip, s, onDone }) {
  const [temp, setTemp] = useState(s.stop_type === "PICKUP" ? "65" : "62");
  const [ok, setOk] = useState(true);
  const [notes, setNotes] = useState("");
  const [busy, setBusy] = useState(false);
  const done = !!s.departed_at;
  // a stop is actionable when every earlier stop is done
  const open = !done && trip.stops.filter((x) => x.stop_seq < s.stop_seq).every((x) => x.departed_at) && ["PLANNED", "IN_PROGRESS"].includes(trip.status);
  const items = trip.items.filter((i) => (s.stop_type === "PICKUP" ? i.pickup_seq : i.drop_seq) === s.stop_seq);

  async function act() {
    setBusy(true);
    try {
      if (s.stop_type === "PICKUP") {
        await api(`/api/volunteer/trips/${trip.trip_id}/stops/${s.stop_seq}/pickup`, { method: "POST", label: "Record pickup", body: { temperature_c: temp === "" ? null : +temp } });
        toast(`Picked up at ${s.name}`, "ok");
      } else {
        await api(`/api/volunteer/trips/${trip.trip_id}/stops/${s.stop_seq}/deliver`, { method: "POST", label: "Record delivery", body: { temperature_c: temp === "" ? null : +temp, hygiene_ok: ok, notes: notes || null } });
        toast(ok ? `Delivered to ${s.name}` : `Rejected at ${s.name}: hygiene check failed`, ok ? "ok" : "error");
      }
      onDone();
    } catch (e) { toast(e.message, "error"); } finally { setBusy(false); }
  }

  return (
    <li className="relative pl-8 pb-5">
      <span className={`absolute left-0 top-0.5 w-6 h-6 rounded-full flex items-center justify-center text-[11px] font-bold
                        ${done ? "bg-leaf text-white" : open ? "bg-accent text-accent-ink" : "bg-surface-2 text-muted border border-line"}`}>
        {done ? "✓" : s.stop_seq}
      </span>
      <div className="flex flex-wrap justify-between gap-2">
        <div>
          <div className="font-semibold">{s.stop_type === "PICKUP" ? "Pick up at" : "Drop at"} {s.name}</div>
          <div className="text-xs text-muted">ETA {fmt.time(s.planned_eta)}{done ? ` · done ${fmt.time(s.departed_at)}` : ""} · ☎ {s.contact_phone}</div>
          <div className="text-xs mt-1">{items.map((i) => `#${i.batch_id} ${i.description} (${i.quantity_kg} kg)`).join(" · ")}</div>
        </div>
      </div>
      {open && (
        <div className="mt-3 card p-3 flex flex-wrap items-end gap-3">
          <div className="w-28"><label className="label" htmlFor={`t${s.stop_seq}`}>Food temp °C</label>
            <input id={`t${s.stop_seq}`} className="input" type="number" step="0.5" min="-30" max="120" value={temp} onChange={(e) => setTemp(e.target.value)} /></div>
          {s.stop_type === "DROP" && (
            <>
              <label className="flex items-center gap-2 text-sm pb-2"><input type="checkbox" checked={ok} onChange={(e) => setOk(e.target.checked)} /> Hygiene check passed</label>
              <div className="flex-1 min-w-[140px]"><label className="label" htmlFor={`n${s.stop_seq}`}>Notes</label>
                <input id={`n${s.stop_seq}`} className="input" value={notes} onChange={(e) => setNotes(e.target.value)} placeholder={ok ? "optional" : "why it failed"} /></div>
            </>
          )}
          <button className="btn btn-primary" disabled={busy} onClick={act}>{busy ? "Saving…" : s.stop_type === "PICKUP" ? "Confirm pickup" : "Confirm delivery"}</button>
        </div>
      )}
    </li>
  );
}

export default function VolunteerPage() {
  const user = useRequireRole("VOLUNTEER");
  const [d, setD] = useState(null);
  const [err, setErr] = useState(null);
  const [sel, setSel] = useState([]);
  const [tripId, setTripId] = useState(null);
  const [busy, setBusy] = useState(false);

  const load = useCallback(() => api("/api/volunteer/overview", { label: "Load volunteer dashboard" }).then((x) => {
    setD(x);
    setTripId((cur) => cur ?? x.trips.find((t) => ["IN_PROGRESS", "PLANNED"].includes(t.status))?.trip_id ?? null);
  }).catch(setErr), []);
  useEffect(() => { if (user) load(); }, [user, load]);

  const home = d?.me ? { lat: d.me.home_lat, lon: d.me.home_lon } : null;
  const trip = d?.trips.find((t) => t.trip_id === tripId) || null;
  const load_kg = useMemo(() => (d?.queue || []).filter((q) => sel.includes(q.claim_id)).reduce((a, q) => a + Number(q.quantity_kg), 0), [d, sel]);

  async function plan() {
    setBusy(true);
    try {
      const r = await api("/api/volunteer/trips", { method: "POST", label: "Plan batched trip", body: { claim_ids: sel } });
      toast(`Trip #${r.trip_id} planned with ${sel.length} batch(es)`, "ok");
      setSel([]); setTripId(r.trip_id); await load();
    } catch (e) { toast(e.message, "error"); } finally { setBusy(false); }
  }
  async function toggleDuty() {
    try { await api("/api/volunteer/availability", { method: "POST", label: "Change availability", body: { available: !d.me.is_available } }); load(); }
    catch (e) { toast(e.message, "error"); }
  }

  if (!user) return null;
  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 py-8">
      <PageHeader title={user.full_name}
        actions={d?.me && <button className="btn btn-ghost" onClick={toggleDuty} aria-pressed={!!d.me.is_available}>
          <span className={`w-2.5 h-2.5 rounded-full ${d.me.is_available ? "bg-leaf" : "bg-muted"}`} />{d.me.is_available ? "On duty" : "Off duty"}</button>}>
        {d?.me ? `${fmt.title(d.me.vehicle_type)} · carries up to ${fmt.kg(d.me.max_load_kg)} · ${d.me.verified_at ? "ID verified" : "ID not verified yet"}` : " "}
      </PageHeader>
      <ErrorBox error={err} />

      <div className="grid lg:grid-cols-[1fr_420px] gap-6 mt-4">
        <div className="lg:sticky lg:top-20">
          <div className="card p-2 h-[420px] lg:h-[560px]">
            {d ? <TripMap home={home} queue={d.queue} trip={trip} /> : <Skeleton className="h-full" />}
          </div>
          <p className="text-[11px] text-muted mt-2">
            Markers and the route come from MySQL (ST_Latitude / ST_Longitude of site.location). The background map
            tiles are fetched from OpenStreetMap, so they need internet access.
          </p>
        </div>

        <div className="space-y-6">
          <section className="card p-5" aria-labelledby="q-h">
            <div className="flex justify-between items-baseline">
              <h2 id="q-h" className="font-bold">Waiting for pickup</h2>
              <button className="text-xs text-accent font-semibold" onClick={() => setTripId(null)}>Show all on map</button>
            </div>
            <p className="text-xs text-muted mb-3">Tick several to carry them in one trip. Total load must stay under your vehicle's limit.</p>
            {!d && <Skeleton className="h-32" />}
            {d && d.queue.length === 0 && <p className="text-sm text-muted">No claimed food is waiting right now.</p>}
            <ul className="space-y-2">
              {d?.queue.map((q) => (
                <li key={q.claim_id}>
                  <label className={`flex gap-3 items-start rounded-xl border p-3 cursor-pointer ${sel.includes(q.claim_id) ? "border-accent bg-accent/5" : "border-line"}`}>
                    <input type="checkbox" className="mt-1" checked={sel.includes(q.claim_id)}
                           onChange={(e) => setSel(e.target.checked ? [...sel, q.claim_id] : sel.filter((x) => x !== q.claim_id))} />
                    <span className="flex-1 text-sm">
                      <b>{q.description}</b> · {fmt.kg(q.quantity_kg)}
                      <span className="block text-xs text-muted">{q.mess} → {q.shelter}</span>
                      <span className={`block text-xs ${q.minutes_left < 60 ? "text-danger" : "text-muted"}`}>safe for {Math.floor(q.minutes_left / 60)} h {q.minutes_left % 60} min more</span>
                    </span>
                  </label>
                </li>
              ))}
            </ul>
            {d && d.queue.length > 0 && (
              <div className="mt-4 flex items-center justify-between gap-3">
                <span className={`text-sm ${load_kg > d.me.max_load_kg ? "text-danger" : "text-muted"}`}>{fmt.kg(load_kg)} of {fmt.kg(d.me.max_load_kg)}</span>
                <button className="btn btn-primary" disabled={!sel.length || busy} onClick={plan}>{busy ? "Planning…" : `Plan trip (${sel.length})`}</button>
              </div>
            )}
          </section>

          <section className="card p-5" aria-labelledby="t-h">
            <h2 id="t-h" className="font-bold mb-3">Your trips</h2>
            <div className="flex flex-wrap gap-2 mb-4">
              {d?.trips.map((t) => (
                <button key={t.trip_id} onClick={() => setTripId(t.trip_id)} aria-pressed={t.trip_id === tripId}
                        className={`chip cursor-pointer ${t.trip_id === tripId ? "!border-accent !text-ink" : ""}`}>
                  #{t.trip_id} · {fmt.title(t.status)}
                </button>
              ))}
              {d && d.trips.length === 0 && <span className="text-sm text-muted">No trips yet.</span>}
            </div>
            {trip && (
              <>
                <div className="flex justify-between text-xs text-muted mb-4">
                  <span>Start {fmt.time(trip.planned_start)} · {trip.planned_distance_km} km straight-line</span><StatusChip status={trip.status} />
                </div>
                <ol>{trip.stops.map((s) => <StopRow key={s.stop_seq} trip={trip} s={s} onDone={load} />)}</ol>
              </>
            )}
          </section>
        </div>
      </div>
      <SynthNote />
    </div>
  );
}
