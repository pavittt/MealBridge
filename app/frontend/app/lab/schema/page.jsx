"use client";
/* =====================================================================
   Schema explorer + ER diagrams.
   Tables, columns, keys, CHECK constraints and indexes come from
   information_schema, so this page cannot drift from the real database.
   The procedures, functions, triggers and views are shown with the
   comment block above them in the .sql file, which is where the design
   decision is explained.
   ===================================================================== */
import { useEffect, useMemo, useState } from "react";
import { PageHeader, Skeleton, SynthNote, useRequireRole } from "@/components/ui";
import { api, fmt, toast } from "@/lib/api";
import Sql from "@/components/Sql";

const DIAGRAM_TITLES = {
  er_0_overview: "Overview: all areas",
  er_1_sites_people: "Sites and people",
  er_2_surplus_matching: "Surplus and matching",
  er_3_logistics: "Logistics: trips and stops",
  er_4_food_safety_audit: "Food safety and audit",
  er_5_forecasting_alerts: "Forecasting and alerts",
};
const KEY_LABEL = { PRI: "primary key", UNI: "unique", MUL: "indexed" };

// One-line summary for an object card: the whole comment block as one
// paragraph, minus the object's own name at the start (the card shows it).
function blurb(o) {
  const text = (o.comment || "").split("\n").map((l) => l.trim()).filter(Boolean).join(" ");
  const rest = text.startsWith(o.name) ? text.slice(o.name.length).replace(/^\s*(\([^)]*\))?\s*[:\-–]?\s*/, "") : text;
  return rest || text;
}

export default function SchemaPage() {
  const user = useRequireRole();
  const [d, setD] = useState(null);
  const [tab, setTab] = useState("tables");
  const [table, setTable] = useState(null);
  const [q, setQ] = useState("");
  const [obj, setObj] = useState(null);

  useEffect(() => { if (user) api("/api/lab/schema", { label: "Read information_schema" }).then((x) => { setD(x); setTable(x.tables.find((t) => t.type === "BASE TABLE")?.name); }).catch((e) => toast(e.message, "error")); }, [user]);

  const tables = useMemo(() => (d?.tables || []).filter((t) => t.name.toLowerCase().includes(q.toLowerCase())), [d, q]);
  const cols = (d?.columns || []).filter((c) => c.tbl === table);
  const cons = (d?.constraints || []).filter((c) => c.tbl === table);
  const idx = (d?.indexes || []).filter((i) => i.tbl === table);
  const objects = useMemo(() => (d?.objects || []).filter((o) => o.name.toLowerCase().includes(q.toLowerCase())), [d, q]);

  // the counts in the header come from what the API just read, so they
  // stay right when a procedure or view is added
  const count = (pred) => (d ? (d.tables || []).filter(pred).length : null);
  const kinds = (k) => (d ? (d.objects || []).filter((o) => o.kind === k).length : null);
  const n = (v, one, many) => (v == null ? "…" : `${v} ${v === 1 ? one : many}`);
  const events = kinds("EVENT");

  if (!user) return null;
  return (
    <div className="mx-auto max-w-7xl px-4 sm:px-6 py-8">
      <PageHeader title="Schema explorer">
        {n(count((t) => t.type === "BASE TABLE"), "table", "tables")}, {n(count((t) => t.type === "VIEW"), "view", "views")},{" "}
        {n(kinds("FUNCTION"), "function", "functions")}, {n(kinds("PROCEDURE"), "procedure", "procedures")},{" "}
        {n(kinds("TRIGGER"), "trigger", "triggers")} and {events === 1 ? "one scheduled event" : n(events, "scheduled event", "scheduled events")}.
        Read live from information_schema, so what you see is the database as it is right now.
      </PageHeader>

      <div className="flex gap-2 mb-5 flex-wrap">
        {[["tables", "Tables and constraints"], ["objects", "Procedures, functions, triggers, views"], ["er", "ER diagrams"]].map(([k, l]) => (
          <button key={k} onClick={() => setTab(k)} aria-pressed={tab === k}
                  className={`btn ${tab === k ? "btn-primary" : "btn-ghost"}`}>{l}</button>
        ))}
        {tab !== "er" && <input className="input !w-48 ml-auto" placeholder="Filter by name…" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Filter" />}
      </div>

      {!d && <Skeleton className="h-96" />}

      {d && tab === "tables" && (
        <div className="grid lg:grid-cols-[260px_1fr] gap-6">
          <nav className="card p-2 max-h-[70vh] overflow-y-auto" aria-label="Tables">
            {tables.map((t) => (
              <button key={t.name} onClick={() => setTable(t.name)} aria-current={table === t.name}
                      className={`w-full text-left px-3 py-2 rounded-lg text-sm font-mono ${table === t.name ? "bg-surface-2 font-bold" : "hover:bg-surface-2"}`}>
                {t.name}
                <span className="float-right text-[10px] text-muted font-sans mt-0.5">{t.type === "VIEW" ? "view" : `≈ ${fmt.n(t.approx_rows)}`}</span>
              </button>
            ))}
          </nav>

          <div className="space-y-5">
            <section className="card p-5">
              <h2 className="font-bold mb-3 font-mono">{table}</h2>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="text-xs text-muted text-left"><tr><th className="py-1">Column</th><th>Type</th><th>Null</th><th>Key</th><th>Default / generated</th></tr></thead>
                  <tbody>
                    {cols.map((c) => (
                      <tr key={c.name} className="border-t border-line">
                        <td className="py-1.5 font-mono font-medium">{c.name}</td>
                        <td className="font-mono text-xs text-muted">{c.type}</td>
                        <td className="text-xs">{c.nullable === "YES" ? "yes" : "no"}</td>
                        <td className="text-xs whitespace-nowrap">{KEY_LABEL[c.col_key] || ""}</td>
                        <td className="text-xs font-mono text-muted">{c.gen_expr ? `AS (${c.gen_expr})` : c.dflt ?? ""} {c.extra && c.extra !== "STORED GENERATED" ? c.extra : ""}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </section>

            {cons.length > 0 && (
              <section className="card p-5">
                <h3 className="font-bold mb-3">Constraints</h3>
                <ul className="space-y-2 text-sm">
                  {cons.map((c) => (
                    <li key={c.name} className="border-t border-line pt-2">
                      <span className="chip">{c.type.toLowerCase()}</span>
                      <span className="font-mono text-xs ml-2">{c.name}</span>
                      <div className="text-xs text-muted mt-1 font-mono break-all">
                        {c.type === "CHECK" ? c.check_clause
                          : c.type === "FOREIGN KEY" ? `(${c.cols}) → ${c.ref_table} (${c.ref_cols})`
                          : `(${c.cols})`}
                      </div>
                    </li>
                  ))}
                </ul>
              </section>
            )}

            {idx.length > 0 && (
              <section className="card p-5">
                <h3 className="font-bold mb-3">Indexes</h3>
                <table className="w-full text-sm">
                  <thead className="text-xs text-muted text-left"><tr><th className="py-1">Name</th><th>Columns</th><th>Type</th><th>Unique</th></tr></thead>
                  <tbody>
                    {idx.map((i) => (
                      <tr key={i.name} className="border-t border-line">
                        <td className="py-1.5 font-mono text-xs">{i.name}</td><td className="font-mono text-xs">{i.cols}</td>
                        <td className="text-xs">{i.type}</td><td className="text-xs">{i.non_unique ? "" : "yes"}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </section>
            )}
          </div>
        </div>
      )}

      {d && tab === "objects" && (
        <div className="grid md:grid-cols-2 xl:grid-cols-3 gap-4">
          {objects.map((o) => (
            <button key={o.kind + o.name} onClick={() => setObj(o)} className="card p-4 text-left hover:border-accent transition-colors">
              <span className="chip">{o.kind.toLowerCase()}</span>
              <h3 className="font-mono font-bold mt-2 text-sm break-all">{o.name}</h3>
              <p className="text-xs text-muted mt-1 line-clamp-3">{blurb(o)}</p>
              <span className="text-[10px] text-muted font-mono">{o.file}</span>
            </button>
          ))}
        </div>
      )}

      {d && tab === "er" && (
        <div className="space-y-6">
          {d.diagrams.map((f) => {
            const key = f.replace(".png", "");
            return (
              <figure key={f} className="card p-4">
                <figcaption className="font-bold mb-3">{DIAGRAM_TITLES[key] || key}</figcaption>
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src={`/api/diagrams/${f}`} alt={`ER diagram: ${DIAGRAM_TITLES[key] || key}`} className="w-full rounded-xl bg-white" />
                <p className="text-xs text-muted mt-2">Built by diagrams/src/build_er.py (Graphviz). <a className="text-accent" href={`/api/diagrams/${key}.svg`} target="_blank" rel="noreferrer">Open the SVG</a></p>
              </figure>
            );
          })}
        </div>
      )}

      {obj && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4" role="dialog" aria-modal="true" aria-label={obj.name}>
          <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={() => setObj(null)} />
          <div className="relative card w-full max-w-4xl max-h-[88vh] overflow-y-auto p-6 page-in" style={{ background: "var(--surface)" }}>
            <div className="flex items-start justify-between gap-4">
              <div>
                <span className="chip">{obj.kind.toLowerCase()}</span>
                <h2 className="text-xl font-bold font-mono mt-2">{obj.name}</h2>
                <p className="text-xs text-muted font-mono">{obj.file}</p>
              </div>
              <button className="btn btn-ghost !px-3" onClick={() => setObj(null)} aria-label="Close">✕</button>
            </div>
            {obj.comment && <p className="text-sm whitespace-pre-line mt-4 text-muted">{obj.comment}</p>}
            <Sql className="mt-4">{obj.source}</Sql>
          </div>
        </div>
      )}
      <SynthNote />
    </div>
  );
}
