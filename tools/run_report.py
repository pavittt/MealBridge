"""
Runs a demo .sql file against MySQL and records its REAL output.

The .sql file is split into sections by lines starting with  '-- @@ '.
    -- @@ Q1. Title of the query
    -- Purpose: one line that explains why the query exists.
    SELECT ...;
All sections run in ONE mysql session (so transactions and session
variables carry over), with --force so an expected error does not stop
the run. A marker SELECT between sections lets us cut the output back
into per-section pieces.

Writes  <file>.output.md   (title, purpose, SQL, output per section)
        <file>.output.txt  (the same as plain text)

Usage:  python3 tools/run_report.py sql/11_queries.sql [--user root] [--password ...]
"""
import argparse, os, pathlib, re, subprocess

ap = argparse.ArgumentParser()
ap.add_argument("sql")
ap.add_argument("--user", default="root")
ap.add_argument("--password", default="")
ap.add_argument("--title", default=None)
args = ap.parse_args()

path = pathlib.Path(args.sql)
lines = path.read_text().splitlines()

# ---- split into sections -------------------------------------------------
pre, sections, cur = [], [], None
for ln in lines:
    if ln.startswith("-- @@ "):
        cur = {"title": ln[6:].strip(), "desc": [], "sql": [], "in_desc": True}
        sections.append(cur)
        continue
    if cur is None:
        pre.append(ln)
    elif cur["in_desc"] and ln.startswith("--"):
        cur["desc"].append(ln[2:].strip())
    else:
        cur["in_desc"] = False
        cur["sql"].append(ln)

script = "\n".join(pre) + "\n"
for i, s in enumerate(sections, 1):
    script += f"SELECT '@@S{i}@@' AS marker;\n" + "\n".join(s["sql"]) + "\n"

env = dict(os.environ)
if args.password:
    env["MYSQL_PWD"] = args.password
res = subprocess.run(["mysql", f"-u{args.user}", "-t", "-n", "--force", "--default-character-set=utf8mb4"],
                     input=script, text=True, capture_output=False,
                     stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=env)
raw = res.stdout
# line numbers refer to the generated script, not the file: drop them
raw = re.sub(r"ERROR (\d+) \((\w+)\) at line \d+:", r"ERROR \1 (\2):", raw)

marker = re.compile(r"\+-+\+\n\| marker\s*\|\n\+-+\+\n\| @@S(\d+)@@\s*\|\n\+-+\+\n")
parts = marker.split(raw)
outputs = {}
for k in range(1, len(parts), 2):
    outputs[int(parts[k])] = parts[k + 1].rstrip()

# ---- write reports --------------------------------------------------------
title = args.title or path.stem
md = [f"# {title}", "",
      f"Real output of `{path.name}`, run as MySQL user `{args.user}` on "
      + subprocess.run(["mysql", "-uroot", "-N", "-e", "SELECT CONCAT('MySQL ', VERSION(), ' at ', NOW())"],
                       text=True, capture_output=True).stdout.strip() + ".",
      "All data is SYNTHETIC (see sql/07_seed_synthetic.sql).", ""]
txt = []
for i, s in enumerate(sections, 1):
    code = "\n".join(s["sql"]).strip()
    out = outputs.get(i, "(no output)") or "(statement ran, no result set)"
    md += [f"## {s['title']}", ""]
    if s["desc"]:
        md += [" ".join(s["desc"]), ""]
    md += ["```sql", code, "```", "", "Output:", "", "```text", out, "```", ""]
    txt += ["=" * 78, s["title"], *s["desc"], "-" * 78, out, ""]
pre_out = parts[0].strip()
if pre_out:
    txt.insert(0, "(preamble output)\n" + pre_out + "\n")

pathlib.Path(str(path.with_suffix("")) + ".output.md").write_text("\n".join(md) + "\n")
pathlib.Path(str(path.with_suffix("")) + ".output.txt").write_text("\n".join(txt) + "\n")
print(f"{path.name}: {len(sections)} sections, {raw.count('ERROR ')} error lines")
