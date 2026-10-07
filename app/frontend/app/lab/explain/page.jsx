"use client";
/* =====================================================================
   EXPLAIN panel: the same query with and without its index.
   "Before" uses IGNORE INDEX, so nothing has to be dropped on a live
   database; MySQL then plans the query as if the index did not exist.
   The milliseconds come from EXPLAIN ANALYZE, which really runs it.
   ===================================================================== */
import { useEffect, useState } from "react";
import { PageHeader, Skeleton, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt, toast } from "@/lib/api";
import Sql from "@/components/Sql";

function Side({ tone, title, plan, sql }) {
  const good = tone === "after";
  return (
    <div className={`rounded-2xl border-2 p-4 ${good ? "border-leaf/50 bg-leaf/5" : "border-line"}`}>
      <div className="flex items-baseline justify-between">
        <h4 className="font-bold text-sm">{title}</h4>
        <span className={`chip ${good ? "text-leaf" : "text-muted"}`}>{plan.type}</span>
      </div>
      <div className="mt-3 grid grid-cols-3 gap-2 text-center">
        <div><div className="text-[10px] text-muted uppercase">Index used</div><div className="font-mono text-xs font-bold mt-0.5">{plan.key || "none"}</div></div>
        <div><div className="text-[10px] text-muted uppercase">Rows examined</div><div className="font-mono text-sm font-bold mt-0.5">{fmt.n(plan.rows)}</div></div>
        <div><div className="text-[10px] text-muted uppercase">Actual time</div><div className="font-mono text-sm font-bold mt-0.5">{plan.actual_ms ?? "–"} ms</div></div>
      </div>
      <details className="mt-3">
        <summary className="text-xs text-accent cursor-pointer font-semibold">EXPLAIN ANALYZE output</summary>
        <pre className="sql mt-2 max-h-56 overflow-auto">{plan.analyze}</pre>
        <Sql className="mt-2">{sql}</Sql>
      </details>
    </div>
  );
}

export default function ExplainPage() {
  const user = useRequireRole();
  const [d, setD] = useState(null);
  useEffect(() => { if (user) api("/api/lab/explain", { label: "Run EXPLAIN before/after" }).then(setD).catch((e) => toast(e.message, "error")); }, [user]);
  if (!user) return null;

  return (
    <div className="mx-auto max-w-5xl px-4 sm:px-6 py-8">
      <PageHeader title="Query plans, before and after indexing">
        Five queries the app really runs. "Without the index" asks MySQL to ignore that index; "with it" is what the
        app gets. Row counts and milliseconds are MySQL's own, measured just now.
      </PageHeader>

      {!d && <div className="space-y-4">{[0, 1, 2].map((i) => <Skeleton key={i} className="h-48" />)}</div>}
      {d && (
        <>
          <p className="text-sm text-muted mb-5">
            Table sizes right now: {Object.entries(d.table_rows).map(([t, n]) => `${t} ${fmt.n(n)} rows`).join(" · ")}.
            The effect grows with the table; sql/12_explain_indexes.md repeats this on 200,000 rows.
          </p>
          <div className="space-y-6">
            {d.cases.map((c) => {
              const speed = c.before.actual_ms && c.after.actual_ms ? (c.before.actual_ms / c.after.actual_ms) : null;
              return (
                <section key={c.id} className="card p-5">
                  <div className="flex flex-wrap items-baseline justify-between gap-2 mb-1">
                    <h3 className="font-bold">{c.title}</h3>
                    {speed && (
                      // on a table this small a sub-millisecond query can time the same either way;
                      // then say so instead of claiming "1.0× faster"
                      <span className={`chip ${speed >= 1.15 ? "!text-leaf" : ""}`}>
                        {speed >= 1.15 ? `${speed.toFixed(1)}× faster` : "same time at this table size"} · {fmt.n(c.before.rows)} → {fmt.n(c.after.rows)} rows read
                      </span>
                    )}
                  </div>
                  <p className="text-xs text-muted mb-4 font-mono">{c.index} on {c.columns}</p>
                  <div className="grid md:grid-cols-2 gap-4">
                    <Side tone="before" title="Without the index" plan={c.before} sql={c.before_sql} />
                    <Side tone="after" title="With the index" plan={c.after} sql={c.after_sql} />
                  </div>
                </section>
              );
            })}
          </div>
          <p className="text-xs text-muted mt-6">
            Reading the plan: <b>ALL</b> is a full table scan (every row read), <b>range</b> walks only the matching
            part of the index, <b>ref</b> jumps straight to the matching rows. "Rows" is MySQL's estimate of how many
            rows it must examine.
          </p>
        </>
      )}
      <SynthNote />
    </div>
  );
}
