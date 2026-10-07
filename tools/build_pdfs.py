"""
Turns the Markdown reports into print-ready PDFs (A4) with the ER diagrams
embedded, so the documents look the same for every reader.

Needs: python3 -m pip install markdown ; a Chromium/Chrome binary.
Run from the mealbridge folder:  python3 tools/build_pdfs.py
"""
import pathlib, subprocess, base64, os, markdown

ROOT = pathlib.Path(__file__).resolve().parent.parent
CHROME = os.environ.get("CHROME", "/opt/pw-browsers/chromium")

CSS = """
@page { size: A4; margin: 16mm 14mm 18mm 14mm; }
body { font-family: 'DejaVu Sans', Arial, sans-serif; font-size: 10pt; line-height: 1.45; color: #1d1d1d; }
h1 { font-size: 20pt; color: #1F4E79; border-bottom: 3px solid #1F4E79; padding-bottom: 6px; margin-top: 0; }
h2 { font-size: 14pt; color: #1F4E79; margin-top: 22px; border-bottom: 1px solid #c9d6e3; padding-bottom: 3px; page-break-after: avoid; }
h3 { font-size: 11.5pt; color: #2b2b2b; margin-top: 16px; page-break-after: avoid; }
p, li { orphans: 3; widows: 3; }
table { border-collapse: collapse; width: 100%; margin: 8px 0 14px; font-size: 8.6pt; page-break-inside: auto; }
tr { page-break-inside: avoid; }
th { background: #1F4E79; color: white; text-align: left; padding: 5px 6px; }
td { border: 1px solid #c9d6e3; padding: 4px 6px; vertical-align: top; }
tr:nth-child(even) td { background: #f4f8fb; }
code { font-family: 'DejaVu Sans Mono', monospace; font-size: 8.4pt; background: #eef2f6; padding: 0 3px; border-radius: 3px; }
pre { background: #f4f6f8; border: 1px solid #d9dee4; padding: 8px; font-size: 7.8pt; white-space: pre-wrap; page-break-inside: avoid; }
pre code { background: none; padding: 0; }
blockquote { margin: 10px 0; padding: 8px 12px; background: #fff7e0; border-left: 4px solid #e0a800; }
blockquote p { margin: 0; }
strong { color: #111; }
a { color: #1F4E79; text-decoration: none; }
img { width: 100%; display: block; margin: 8px auto; }
figure { margin: 12px 0; page-break-inside: avoid; text-align: center; }
figcaption { font-size: 8.5pt; color: #555; }
.pagebreak { page-break-before: always; }
.meta td:first-child { width: 22%; }
"""

def embed_images(html, base):
    """Inline local images as data URIs so the PDF is self-contained."""
    import re
    def repl(m):
        path = (base / m.group(1)).resolve()
        if path.exists():
            data = base64.b64encode(path.read_bytes()).decode()
            return f'src="data:image/png;base64,{data}"'
        return m.group(0)
    return re.sub(r'src="([^"]+\.png)"', repl, html)

def build(md_name, pdf_name, extra_html=""):
    md_text = (ROOT / md_name).read_text(encoding="utf-8")
    body = markdown.markdown(md_text, extensions=["tables", "fenced_code", "sane_lists"])
    # the empty header row of the metadata table renders as a blank band; drop it
    body = body.replace("<h2>7. Relational schema</h2>", "<h2 class=\"pagebreak\">7. Relational schema</h2>")
    body = body.replace("<thead>\n<tr>\n<th></th>\n<th></th>\n</tr>\n</thead>", "")
    html = f"<!doctype html><html><head><meta charset='utf-8'><style>{CSS}</style></head><body>{body}{extra_html}</body></html>"
    html = embed_images(html, ROOT)
    tmp = ROOT / "pdf" / (pdf_name + ".html")
    tmp.write_text(html, encoding="utf-8")
    out = ROOT / "pdf" / pdf_name
    subprocess.run([CHROME, "--headless", "--no-sandbox", "--disable-gpu",
                    "--no-pdf-header-footer", f"--print-to-pdf={out}", tmp.as_uri()],
                   check=True, capture_output=True)
    tmp.unlink()
    print("built", out)

FIGS = [
    ("er_1_sites_people", "Figure 2. Sites and people: EER specialization of SITE and APP_USER."),
    ("er_2_surplus_matching", "Figure 3. Surplus and matching: batches, diet tags, claims and shelter capacity."),
    ("er_3_logistics", "Figure 4. Logistics: batched multi-stop pickup trips and the weak entity TRIP_STOP."),
    ("er_4_food_safety_audit", "Figure 5. Food-safety chain of custody and the generic audit log."),
    ("er_5_forecasting_alerts", "Figure 6. Forecasting inputs and outputs, and notifications."),
]
appendix = '<div class="pagebreak"></div><h2>Appendix: detailed ER diagrams</h2>' + '<div class="pagebreak"></div>'.join(
    f'<figure><img src="diagrams/{f}.png"><figcaption>{c}</figcaption></figure>' for f, c in FIGS)

build("01_problem_discovery.md", "MealBridge_01_Problem_Discovery.pdf")
build("02_innovation_and_requirements.md", "MealBridge_02-03_Innovation_and_Requirements.pdf")
build("03_database_design.md", "MealBridge_04_Database_Design.pdf", appendix)
