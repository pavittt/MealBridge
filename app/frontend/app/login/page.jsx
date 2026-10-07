"use client";
/* Login. The API checks the bcrypt hash with the mb_auth MySQL login
   (which can read only login columns) and returns a signed token. */
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { homeFor } from "@/components/Shell";
import { ErrorBox, Skeleton } from "@/components/ui";
import { api, setSession } from "@/lib/api";

const ROLE_LABEL = { MESS_ADMIN: "Mess admin", SHELTER: "Shelter", VOLUNTEER: "Volunteer", PLATFORM_ADMIN: "Platform admin" };

export default function Login() {
  const router = useRouter();
  // Query string read from the URL itself. useSearchParams() would need a
  // Suspense boundary around this whole page, which would leave the form
  // behind a skeleton until hydration finishes.
  const [params, setParams] = useState(null);
  useEffect(() => { setParams(new URLSearchParams(window.location.search)); }, []);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [err, setErr] = useState(null);
  const [busy, setBusy] = useState(false);
  const [demo, setDemo] = useState(null);

  useEffect(() => {
    if (!params) return;
    const r = params.get("role");
    api("/api/auth/demo-accounts").then((rows) => {
      setDemo(rows);
      const pick = r && rows.find((x) => x.role === r);
      if (pick) { setEmail(pick.email); setPassword("demo1234"); }
    }).catch(setErr);
  }, [params]);

  async function submit(e) {
    e.preventDefault();
    setBusy(true); setErr(null);
    try {
      const d = await api("/api/auth/login", { method: "POST", body: { email, password }, label: "Log in" });
      setSession(d);
      router.push(homeFor(d.user.role));
    } catch (e2) { setErr(e2); } finally { setBusy(false); }
  }

  const groups = demo ? Object.groupBy?.(demo, (d) => d.role) ?? demo.reduce((a, d) => ((a[d.role] ||= []).push(d), a), {}) : null;

  return (
    <div className="mx-auto max-w-5xl px-4 sm:px-6 py-12 grid md:grid-cols-2 gap-8 items-start">
      <form onSubmit={submit} className="card p-6 sm:p-8 space-y-4">
        <h1 className="text-3xl font-extrabold">Log in</h1>
        {params?.get("wrong") && <p className="text-sm text-warn">That page belongs to another role. Log in with its account.</p>}
        <div>
          <label className="label" htmlFor="email">E-mail</label>
          <input id="email" className="input" type="email" autoComplete="username" required value={email} onChange={(e) => setEmail(e.target.value)} />
        </div>
        <div>
          <label className="label" htmlFor="pw">Password</label>
          <input id="pw" className="input" type="password" autoComplete="current-password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        </div>
        <ErrorBox error={err} />
        <button className="btn btn-primary w-full" disabled={busy}>{busy ? "Checking…" : "Log in"}</button>
        <p className="text-xs text-muted leading-relaxed">
          Each role reaches MySQL with its own database login (mb_mess_admin, mb_shelter, mb_volunteer,
          mb_platform_admin), so MySQL's grants decide what you can see and do.
        </p>
      </form>

      <section className="space-y-4" aria-labelledby="demo-h">
        <h2 id="demo-h" className="text-xl font-bold">Demo accounts</h2>
        <p className="text-sm text-muted">Every demo account uses the password <code className="font-mono">demo1234</code>. Click one to fill the form.</p>
        {!groups && <Skeleton className="h-64" />}
        {groups && Object.entries(groups).map(([role, list]) => (
          <div key={role}>
            <div className="text-xs font-medium text-muted mb-2">{ROLE_LABEL[role]}</div>
            <div className="grid gap-2">
              {list.map((d) => (
                <button key={d.email} type="button" onClick={() => { setEmail(d.email); setPassword("demo1234"); }}
                        className={`card px-4 py-2.5 text-left hover:border-accent transition-colors ${email === d.email ? "!border-accent" : ""}`}>
                  <div className="text-sm font-semibold">{d.full_name}</div>
                  <div className="text-xs text-muted">{d.email}{d.site_name ? ` · ${d.site_name}` : ""}</div>
                </button>
              ))}
            </div>
          </div>
        ))}
      </section>
    </div>
  );
}
