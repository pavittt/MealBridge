"use client";
/* =====================================================================
   "Why can't I claim this?" for ONE shelter: the output of the stored
   procedure sp_explain_my_eligibility, which only ever looks at the
   logged-in shelter. The rules come first (each must pass), then the five
   factors that make up the match score, then the result. No other
   shelter's numbers are in the data at all.
   ===================================================================== */

function Verdict({ checks }) {
  const result = checks.find((c) => c.kind === "RESULT");
  const failed = checks.filter((c) => c.kind === "RULE" && !Number(c.passed));
  const ok = Number(result?.passed) === 1;
  return (
    <div className={`rounded-2xl p-4 border ${ok ? "border-leaf/40 bg-leaf/10" : "border-danger/40 bg-danger/10"}`}>
      <div className={`font-semibold ${ok ? "text-leaf" : "text-danger"}`}>
        {ok ? `You can claim this batch. Your match score is ${Number(result.score).toFixed(1)}.`
            : failed.length ? `You can't claim this batch: ${failed.map((f) => f.label.toLowerCase()).join(", ")}.`
            : "You can't claim this batch right now."}
      </div>
      <p className="text-sm text-muted mt-1">{result?.explanation}</p>
    </div>
  );
}

export default function EligibilityPanel({ checks }) {
  const rules = checks.filter((c) => c.kind === "RULE");
  const factors = checks.filter((c) => c.kind === "FACTOR");
  return (
    <div className="space-y-5">
      <Verdict checks={checks} />

      <section>
        <h3 className="text-sm font-semibold mb-2">Rules (every one must pass)</h3>
        <ul className="space-y-2">
          {rules.map((r) => {
            const pass = Number(r.passed) === 1;
            return (
              <li key={r.code} className="flex gap-3 items-start rounded-xl border border-line p-3">
                <span className={`mt-0.5 shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${
                  pass ? "bg-leaf/15 text-leaf" : "bg-danger/15 text-danger"}`} aria-hidden="true">{pass ? "✓" : "✕"}</span>
                <div className="min-w-0">
                  <div className="font-medium text-sm">{r.label} <span className={`text-xs ${pass ? "text-leaf" : "text-danger"}`}>· {pass ? "passes" : "fails"}</span></div>
                  <p className="text-sm text-muted mt-0.5">{r.explanation}</p>
                </div>
              </li>
            );
          })}
        </ul>
      </section>

      <section>
        <h3 className="text-sm font-semibold mb-2">How your score is made up</h3>
        <ul className="space-y-3">
          {factors.map((f) => {
            const v = f.score == null ? null : Number(f.score);
            return (
              <li key={f.code}>
                <div className="flex items-baseline justify-between gap-3 text-sm">
                  <span className="font-medium">{f.label} <span className="text-xs text-muted">· weight {Number(f.weight).toFixed(2)}</span></span>
                  <span className="font-mono tabular-nums">{v == null ? "no score" : `${v.toFixed(1)} / 100`}</span>
                </div>
                <div className="h-1.5 rounded-full bg-surface-2 mt-1.5 overflow-hidden" aria-hidden="true">
                  <div className="h-full rounded-full bg-accent" style={{ width: `${v ?? 0}%` }} />
                </div>
                <p className="text-xs text-muted mt-1">{f.explanation}</p>
              </li>
            );
          })}
        </ul>
      </section>
    </div>
  );
}
