"use client";
/* =====================================================================
   Impact dashboard. Every number and chart is one SQL VIEW
   (sql/06_views.sql), read with YOUR role's MySQL login. A view your
   role is not granted shows as a locked card with MySQL's own error,
   which makes the role grants visible.
   ===================================================================== */
import { useEffect, useState } from "react";
import { Bar, BarChart, CartesianGrid, Legend, Line, LineChart, ReferenceLine, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { ErrorBox, PageHeader, Skeleton, Stat, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt } from "@/lib/api";

const tip = { contentStyle: { background: "var(--surface)", border: "1px solid var(--line)", borderRadius: 12, fontSize: 12 }, cursor: { fill: "var(--surface-2)" } };
const axis = { tick: { fontSize: 11, fill: "var(--muted)" }, axisLine: false, tickLine: false };

function Panel({ title, view, block, children, className = "" }) {
  return (
    <section className={`card p-5 ${className}`}>
      <div className="flex flex-wrap items-baseline justify-between gap-2 mb-3">
        <h2 className="font-bold">{title}</h2>
        <code className="text-[11px] text-muted font-mono">{view}</code>
      </div>
      {!block && <Skeleton className="h-56" />}
      {block?.denied && (
        <div className="h-48 flex flex-col items-center justify-center text-center rounded-xl bg-surface-2 p-4">
          <div className="text-2xl" aria-hidden="true">🔒</div>
          <p className="font-semibold mt-2">Your role is not granted this view</p>
          <p className="text-xs text-muted font-mono mt-1 max-w-md">{block.denied}</p>
        </div>
      )}
      {block?.rows && children(block.rows)}
    </section>
  );
}

export default function ImpactPage() {
  const user = useRequireRole();
  const [d, setD] = useState(null);
  const [err, setErr] = useState(null);
  useEffect(() => { if (user) api("/api/impact", { label: "Load impact views" }).then(setD).catch(setErr); }, [user]);
  if (!user) return null;
  const s = d?.summary?.rows?.[0];

  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 py-8">
      <PageHeader eyebrow="Impact" title="What the platform has saved">
        Read with your login ({user.role.toLowerCase().replace("_", " ")}). Synthetic data
        {s ? `, ${s.from_day} to ${s.to_day}` : ""}.
      </PageHeader>
      <ErrorBox error={err} />

      {d?.summary?.denied ? null : (
        <div className="grid grid-cols-2 lg:grid-cols-5 gap-4 mb-6">
          {!s && [0, 1, 2, 3, 4].map((i) => <Skeleton key={i} className="h-24" />)}
          {s && <>
            <Stat label="Meals saved" value={fmt.n(s.meals_saved)} sub="fn_meals(kg, category)" tone="leaf" />
            <Stat label="Food diverted" value={fmt.kg(s.kg_diverted)} sub={`${s.batches_delivered} of ${s.batches_posted} batches`} />
            <Stat label="Carbon avoided" value={`${fmt.n(s.co2e_avoided_kg)} kg`} sub="CO₂e · factor TO VERIFY" />
            <Stat label="Rescue rate" value={`${s.rescue_rate_pct}%`} sub={`${fmt.kg(s.kg_expired)} still expired`} tone="accent" />
            <Stat label="Response time" value={`${s.avg_response_min} min`} sub={`post → delivery ${s.avg_post_to_delivery_min} min`} />
          </>}
        </div>
      )}

      <div className="grid lg:grid-cols-2 gap-6">
        <Panel title="Food delivered vs expired, per day" view="v_impact_daily" block={d?.daily} className="lg:col-span-2">
          {(rows) => (
            <div className="h-72">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={rows} barCategoryGap={2}>
                  <CartesianGrid vertical={false} stroke="var(--line)" />
                  <XAxis dataKey="day" {...axis} tickFormatter={(v) => v.slice(5)} interval={4} />
                  <YAxis {...axis} unit=" kg" width={60} />
                  <Tooltip {...tip} formatter={(v, n) => [fmt.kg(v), n]} />
                  <Legend wrapperStyle={{ fontSize: 12 }} />
                  <Bar dataKey="kg_delivered" name="Delivered" stackId="a" fill="var(--chart-1)" stroke="var(--surface)" strokeWidth={1} />
                  <Bar dataKey="kg_expired" name="Expired" stackId="a" fill="var(--chart-2)" stroke="var(--surface)" strokeWidth={1} radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          )}
        </Panel>

        <Panel title="Rescue rate per day" view="v_impact_daily.rescue_rate_pct" block={d?.daily}>
          {(rows) => (
            <div className="h-56">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={rows}>
                  <CartesianGrid vertical={false} stroke="var(--line)" />
                  <XAxis dataKey="day" {...axis} tickFormatter={(v) => v.slice(5)} interval={6} />
                  <YAxis {...axis} unit="%" domain={[0, 100]} width={44} />
                  <Tooltip {...tip} formatter={(v) => [`${v}%`, "rescued"]} />
                  <Line dataKey="rescue_rate_pct" stroke="var(--chart-1)" strokeWidth={2} dot={false} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          )}
        </Panel>

        <Panel title="Fairness: share received vs share of need" view="v_shelter_fairness" block={d?.fairness}>
          {(rows) => (
            <>
              <div className="h-80">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={rows.map((r) => ({ ...r, name: r.shelter.replace("SYN ", "") }))} layout="vertical" margin={{ left: 10 }}>
                    <XAxis type="number" {...axis} domain={[0, "dataMax"]} />
                    <YAxis type="category" dataKey="name" {...axis} width={190} interval={0} />
                    <Tooltip {...tip} formatter={(v) => [v, "fair ratio (1.00 = fair)"]} />
                    <ReferenceLine x={1} stroke="var(--muted)" strokeDasharray="4 4" label={{ value: "fair", fontSize: 10, fill: "var(--muted)", position: "top" }} />
                    <Bar dataKey="fair_ratio" fill="var(--chart-3)" radius={[0, 4, 4, 0]} barSize={12} />
                  </BarChart>
                </ResponsiveContainer>
              </div>
              {d?.jain?.rows?.[0] && (
                <p className="text-sm mt-2">Jain's fairness index <b className="font-mono">{d.jain.rows[0].jain_index}</b>
                  <span className="text-muted"> (1.000 = perfectly even per beneficiary, {d.jain.rows[0].worst_possible} = one shelter gets all) · v_fairness_index</span></p>
              )}
            </>
          )}
        </Panel>

        <Panel title="Shelter response time" view="v_response_time" block={d?.response}>
          {(rows) => (
            <div className="h-96">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={rows.map((r) => ({ ...r, name: r.shelter.replace("SYN ", "") }))} layout="vertical" margin={{ left: 10 }}>
                  <XAxis type="number" {...axis} unit=" min" />
                  <YAxis type="category" dataKey="name" {...axis} width={190} interval={0} />
                  <Tooltip {...tip} />
                  <Legend wrapperStyle={{ fontSize: 12 }} />
                  <Bar dataKey="avg_response_min" name="Average" fill="var(--chart-3)" radius={[0, 4, 4, 0]} barSize={8} />
                  <Bar dataKey="median_response_min" name="Median" fill="var(--chart-1)" radius={[0, 4, 4, 0]} barSize={8} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          )}
        </Panel>

        <Panel title="Mess leaderboard" view="v_mess_leaderboard (RANK() OVER)" block={d?.leaderboard}>
          {(rows) => (
            <table className="w-full text-sm">
              <thead className="text-xs text-muted text-left"><tr><th className="py-1">Rank</th><th>Mess</th><th className="text-right">Posted</th><th className="text-right">Rescued</th><th className="text-right">Rate</th></tr></thead>
              <tbody>
                {rows.map((r) => (
                  <tr key={r.mess} className="border-t border-line">
                    <td className="py-2 font-mono font-bold">{r.rank_by_kg_rescued}</td><td>{r.mess}</td>
                    <td className="text-right">{fmt.kg(r.kg_posted)}</td><td className="text-right">{fmt.kg(r.kg_rescued)}</td><td className="text-right">{r.rescue_rate_pct}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </Panel>
      </div>
      <SynthNote />
    </div>
  );
}
