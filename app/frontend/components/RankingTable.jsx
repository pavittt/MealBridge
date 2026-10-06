"use client";
/* Output of the matching procedure sp_rank_shelters: every shelter, its
   five component scores (0-100), the weighted match score, and the reason
   an excluded shelter is excluded. Shown to mess admins and shelters. */
import { fmt } from "@/lib/api";

const COMPONENTS = [
  ["need", "Need"], ["fairness", "Fairness"], ["distance", "Distance"], ["perish", "Time"], ["capacity", "Capacity"],
];

function Bar({ v }) {
  if (v == null) return <span className="text-muted">–</span>;
  return (
    <div className="flex items-center gap-1.5 min-w-[70px]">
      <div className="h-1.5 flex-1 rounded-full bg-surface-2 overflow-hidden">
        <div className="h-full rounded-full bg-accent" style={{ width: `${Math.min(100, v)}%` }} />
      </div>
      <span className="font-mono text-[11px] w-7 text-right">{Math.round(v)}</span>
    </div>
  );
}

export default function RankingTable({ rows, me }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <caption className="sr-only">Shelters ranked by match score</caption>
        <thead className="text-xs text-muted text-left">
          <tr>
            <th className="py-2 pr-2">#</th><th className="pr-3">Shelter</th><th className="pr-3">km</th><th className="pr-3">Travel</th>
            {COMPONENTS.map(([k, l]) => <th key={k} className="pr-3">{l}</th>)}
            <th className="pr-3">Score</th><th>Verdict</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => {
            const ok = r.verdict === "ELIGIBLE";
            return (
              <tr key={r.shelter_id} className={`border-t border-line ${r.shelter_id === me ? "bg-accent/10" : ""} ${ok ? "" : "opacity-60"}`}>
                <td className="py-2 pr-2 font-mono text-xs">{ok ? i + 1 : ""}</td>
                <td className="pr-3 font-medium whitespace-nowrap">{r.shelter}{r.shelter_id === me && <span className="chip ml-2">you</span>}</td>
                <td className="pr-3 font-mono text-xs">{fmt.n(r.km, 1)}</td>
                <td className="pr-3 font-mono text-xs">{r.travel_min} min</td>
                {COMPONENTS.map(([k]) => <td key={k} className="pr-3"><Bar v={r[k] == null ? null : Number(r[k])} /></td>)}
                <td className="pr-3 font-mono font-bold">{r.match_score ?? "–"}</td>
                <td className={`text-xs whitespace-nowrap ${ok ? "text-leaf font-semibold" : "text-muted"}`}>{r.verdict.replace("EXCLUDED: ", "✕ ")}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
      <p className="text-[11px] text-muted mt-3">
        Score = weighted average of the five components using the weights in table scoring_weight. Hard filters
        (diet, capacity left, 15 km radius, arrival before safe-until with a 30 minute buffer) give no score.
      </p>
    </div>
  );
}
