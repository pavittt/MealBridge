"""
Builds the MealBridge ER diagrams with Graphviz (https://graphviz.org).

Why Graphviz and pinned positions: every node gets a fixed (x, y) grid
position, so related tables sit next to each other and no relationship
line has to cross another one. One overview + one diagram per area keeps
each picture small enough to read on a slide without zooming.

Notation (crow's foot, also written as text for non-specialists):
  |   exactly one          o<  zero or many         |<  one or many
Run:  python3 build_er.py   (needs the `neato` binary from graphviz)
"""
import subprocess, pathlib, html

OUT = pathlib.Path(__file__).resolve().parent.parent
FONT = "DejaVu Sans"

# One colour per functional area, used consistently in every diagram.
AREA = {
    "place":  ("#DCEBFA", "#2F6DB5"),   # sites and people
    "food":   ("#DDF3E4", "#2E8B57"),   # surplus and matching
    "move":   ("#FDEBD3", "#C9731A"),   # logistics
    "audit":  ("#F9DEDC", "#B3261E"),   # food safety and audit
    "plan":   ("#ECE2F7", "#6A3FA0"),   # forecasting and alerts
    "ref":    ("#F2F2F2", "#8A8A8A"),   # table drawn in another diagram
}

def overview_node(name, subtitle, area):
    fill, line = AREA[area]
    return (f'<<TABLE BORDER="2" COLOR="{line}" CELLBORDER="0" CELLPADDING="6" '
            f'BGCOLOR="{fill}" STYLE="ROUNDED">'
            f'<TR><TD><B><FONT POINT-SIZE="17">{name}</FONT></B></TD></TR>'
            f'<TR><TD><FONT POINT-SIZE="12" COLOR="#333333">{html.escape(subtitle)}</FONT></TD></TR>'
            f'</TABLE>>')

def table_node(name, area, cols, weak=False, note=None):
    """cols: list of (column, type, key) where key in '', 'PK', 'FK', 'PK FK', 'UK'."""
    fill, line = AREA[area]
    border = "4" if weak else "2"
    rows = [f'<TR><TD COLSPAN="3" BGCOLOR="{line}" ALIGN="CENTER">'
            f'<FONT COLOR="white" POINT-SIZE="15"><B>{name}</B></FONT></TD></TR>']
    if note:
        rows.append(f'<TR><TD COLSPAN="3" ALIGN="CENTER"><FONT POINT-SIZE="10" COLOR="#555555">'
                    f'<I>{html.escape(note)}</I></FONT></TD></TR>')
    for col, typ, key in cols:
        label = f"<B>{col}</B>" if "PK" in key else col
        if "PK" in key:
            label = f"<U>{label}</U>"
        key_cell = (f'<TD ALIGN="LEFT" WIDTH="34"><FONT POINT-SIZE="10" COLOR="{line}"><B>{key}</B></FONT></TD>'
                    if key else '<TD WIDTH="34"> </TD>')
        typ_cell = (f'<TD ALIGN="LEFT"><FONT POINT-SIZE="10" COLOR="#666666">{typ}</FONT></TD>'
                    if typ else '<TD> </TD>')
        rows.append(f'<TR>{key_cell}<TD ALIGN="LEFT">{label}</TD>{typ_cell}</TR>')
    return (f'<<TABLE BORDER="{border}" COLOR="{line}" CELLBORDER="0" CELLSPACING="0" '
            f'CELLPADDING="4" BGCOLOR="{fill}">' + "".join(rows) + '</TABLE>>')

def ref_node(name, why):
    fill, line = AREA["ref"]
    return (f'<<TABLE BORDER="1" COLOR="{line}" CELLBORDER="0" CELLPADDING="5" BGCOLOR="{fill}" STYLE="ROUNDED,DASHED">'
            f'<TR><TD><FONT POINT-SIZE="13" COLOR="#444444"><B>{name}</B></FONT></TD></TR>'
            f'<TR><TD><FONT POINT-SIZE="10" COLOR="#777777">{html.escape(why)}</FONT></TD></TR></TABLE>>')

# Crow's-foot ends. Graphviz draws arrowtail at the 'from' node and
# arrowhead at the 'to' node when dir=both.
ENDS = {"1": "teetee", "0..1": "teeodot", "N": "crowodot", "1..N": "crowtee"}

def edge(a, b, label, ca, cb, style="solid"):
    return (f'{a} -> {b} [dir=both, arrowtail={ENDS[ca]}, arrowhead={ENDS[cb]}, '
            f'xlabel=<@PAD@<FONT POINT-SIZE="12">{("<B>"+html.escape(label)+"</B><BR/>") if label else ""}'
            f'<FONT COLOR="#555555">{ca} : {cb}</FONT></FONT>@END@>, style={style}];')

def graph(title, nodes, edges, extra="", sx=1.0, sy=1.0):
    lines = ['digraph G {',
             f'  graph [layout=neato, splines=true, overlap=false, sep="+18", outputorder=edgesfirst,',
             f'         bgcolor=white, pad=0.4, forcelabels=true, fontname="{FONT}", labelloc=t, fontsize=24,',
             f'         label=<<B>{html.escape(title)}</B><BR/><FONT POINT-SIZE="12" COLOR="#666666">'
             'Crow\'s-foot notation; every line is also labelled with its cardinality in words.</FONT><BR/> >];',
             f'  node  [shape=plain, fontname="{FONT}", fontsize=12];',
             f'  edge  [fontname="{FONT}", color="#444444", penwidth=1.6, arrowsize=1.1];']
    for nid, (x, y, lab) in nodes.items():
        if lab.startswith("CIRCLE:"):   # EER specialization circle
            lines.append(f'  {nid} [pos="{x*sx},{y*sy}!", shape=circle, width=0.45, fixedsize=true, '
                         f'style=filled, fillcolor=white, color="#2F6DB5", penwidth=2, fontsize=16, label=<<B>{lab[7:]}</B>>];')
        else:
            lines.append(f'  {nid} [pos="{x*sx},{y*sy}!", label={lab}];')
    import re
    for e in edges:
        # Move the label off the line so text never sits on top of it:
        # vertical lines get the text to their right, horizontal ones below.
        if "@PAD@" in e:
            a, b = re.match(r"\s*(\w+) -> (\w+)", e).groups()
            (xa, ya), (xb, yb) = nodes[a][:2], nodes[b][:2]
            vertical = abs((ya - yb) * sy) > abs((xa - xb) * sx)
            pad, end = "", ""   # xlabels are placed by Graphviz clear of nodes and lines
            e = e.replace("@PAD@", pad).replace("@END@", end)
        lines.append("  " + e)
    lines.append(" ".join(extra.split("\n")))   # one line per node keeps pass 2 simple
    lines.append("}")
    return "\n".join(lines)

def render(stem, dot_src):
    """Two-pass render so no label is ever crossed by a line.

    Pass 1: neato lays out nodes and routes the edges WITHOUT labels and
            reports the exact edge curves (JSON).
    Pass 2: each edge label becomes its own small node with a white
            background, pinned at the middle of its own curve. Nodes are
            drawn after edges, so the white box hides the line behind the
            text. `neato -n2` keeps every position and curve from pass 1.
    """
    import json, re
    src = OUT / "src" / f"{stem}.dot"
    # Edges are matched to their labels by (tail, head) name, because the
    # layout engine does not return edges in the order they were written.
    edge_info, edge_lines, other = {}, [], []
    for line in dot_src.splitlines():
        if " -> " in line:
            a, b = re.match(r"\s*(\w+) -> (\w+)", line).groups()
            m = re.search(r", xlabel=<(.*?)>(?=, style=|\];)", line)
            label = m.group(1) if m else None
            if m:
                line = line[:m.start()] + line[m.end():]
            edge_info[(a, b)] = (label, line[line.index("[") + 1: line.rindex("]")])
            edge_lines.append(line)
        else:
            other.append(line)
    pass1 = "\n".join(other[:-1] + edge_lines + [other[-1]])
    src.write_text(pass1)
    laid = json.loads(subprocess.run(["neato", "-Tjson", str(src)], check=True,
                                     capture_output=True).stdout.decode("utf-8", "replace"), strict=False)
    names = [o["name"] for o in laid["objects"]]
    out = ["digraph G {",
           f'  graph [bb="{laid["bb"]}", bgcolor=white, pad=0.4, outputorder=edgesfirst, '
           f'fontname="{FONT}", fontsize=24, labelloc=t, label={laid_label(pass1)}];',
           f'  node [shape=plain, fontname="{FONT}"];',
           f'  edge [fontname="{FONT}", color="#444444", penwidth=1.6, arrowsize=1.1];']
    for line in other[1:-1]:                     # node lines: keep label, use laid-out pos
        m = re.match(r"\s*(\w+) \[pos=\"[^\"]*\"(.*)", line)
        if m:
            obj = laid["objects"][names.index(m.group(1))]
            out.append(f'  {m.group(1)} [pos="{obj["pos"]}"{m.group(2)}')
    for i, e in enumerate(laid.get("edges", [])):
        label, attrs = edge_info[(names[e["tail"]], names[e["head"]])]
        out.append(f'  {names[e["tail"]]} -> {names[e["head"]]} [pos="{e["pos"]}", {attrs}];')
        if label:
            x, y = place_label(e["pos"], label, laid["objects"])
            out.append(f'  lbl{i} [pos="{x},{y}", label=<<TABLE BORDER="0" CELLPADDING="2" '
                       f'BGCOLOR="white"><TR><TD>{label}</TD></TR></TABLE>>];')
    out.append("}")
    src.write_text("\n".join(out))
    for fmt in ("png", "svg"):
        args = ["neato", "-n2", f"-T{fmt}", str(src), "-o", str(OUT / f"{stem}.{fmt}")]
        if fmt == "png":
            args.insert(1, "-Gdpi=150")
        subprocess.run(args, check=True)
    print("built", stem)


def place_label(edge_pos, label_html, objects):
    """Put a label BESIDE the middle of its line (never on it), then push it
    further sideways until it overlaps no table, so text is never crossed."""
    import math, re
    pts = [tuple(map(float, p.split(","))) for p in edge_pos.split()
           if not p.startswith(("e,", "s,"))]
    (x0, y0), (x1, y1) = pts[0], pts[-1]
    mx, my = pts[len(pts) // 2]
    text = re.sub(r"<[^>]+>", "\n", label_html)
    lines_ = [t for t in text.split("\n") if t.strip()]
    w = max(len(t) for t in lines_) * 9.0 + 16         # points, DejaVu 12pt bold, with margin
    h = len(lines_) * 17 + 12
    dx, dy = x1 - x0, y1 - y0
    n = math.hypot(dx, dy) or 1
    px, py = -dy / n, dx / n                           # unit perpendicular
    boxes = []
    for o in objects:
        if "pos" in o and "width" in o:
            cx, cy = map(float, o["pos"].split(","))
            bw, bh = float(o["width"]) * 72, float(o["height"]) * 72
            boxes.append((cx - bw / 2, cy - bh / 2, cx + bw / 2, cy + bh / 2))
    def clear(cx, cy):
        return all(cx + w / 2 < bx0 or cx - w / 2 > bx1 or cy + h / 2 < by0 or cy - h / 2 > by1
                   for bx0, by0, bx1, by1 in boxes)
    # distance needed so the box just clears the line, for this line angle
    base = abs(px) * w / 2 + abs(py) * h / 2 + 4
    for k in range(0, 40):
        for sign in (1, -1):
            cx, cy = mx + sign * px * (base + 4 * k), my + sign * py * (base + 4 * k)
            if clear(cx, cy):
                return cx, cy
    return mx + px * base, my + py * base

def laid_label(dot_text):
    """Re-use the title label from the generated graph attributes."""
    i = dot_text.index("label=<<B>")
    depth, j = 0, i + len("label=")
    while True:
        if dot_text[j] == "<": depth += 1
        elif dot_text[j] == ">":
            depth -= 1
            if depth == 0: return dot_text[i + len("label="): j + 1]
        j += 1

# ---------------------------------------------------------------- overview
ov = {
    "campus":   (0,   4, overview_node("CAMPUS", "university campus", "place")),
    "mess":     (0,   2, overview_node("MESS", "hostel kitchen (donor)", "place")),
    "log":      (0,   0, overview_node("MESS_MEAL_LOG", "attendance and leftovers, feeds forecasts", "plan")),
    "cat":      (4,   4, overview_node("FOOD_CATEGORY", "sets the perishability clock", "food")),
    "batch":    (4,   2, overview_node("SURPLUS_BATCH", "food offered, with safe-until deadline", "food")),
    "custody":  (4,   0, overview_node("CUSTODY_EVENT", "food-safety chain of custody", "audit")),
    "claim":    (8.6, 2, overview_node("CLAIM", "a shelter taking a batch", "food")),
    "trip":     (8.6, 0, overview_node("PICKUP_TRIP", "volunteer run, many stops", "move")),
    "shelter":  (12.6, 2, overview_node("SHELTER", "recipient organisation", "place")),
    "sday":     (12.6, 4, overview_node("SHELTER_DAY", "daily need and capacity", "food")),
    "vol":      (12.6, 0, overview_node("VOLUNTEER", "a user who drives", "move")),
}
ov_edges = [
    edge("campus", "mess", "runs", "1", "N"),
    edge("mess", "batch", "posts", "1", "N"),
    edge("mess", "log", "keeps", "1", "N"),
    edge("cat", "batch", "classifies", "1", "N"),
    edge("batch", "claim", "claimed in", "1", "N"),
    edge("batch", "custody", "audited by", "1", "1..N"),
    edge("shelter", "claim", "makes", "1", "N"),
    edge("shelter", "sday", "declares", "1", "N"),
    edge("claim", "trip", "carried on (via TRIP_ITEM)", "N", "N"),
    edge("vol", "trip", "drives", "1", "N"),
]
legend = '''  legend [pos="6,-1.6!", label=<<TABLE BORDER="0" CELLSPACING="6"><TR>
    <TD BGCOLOR="#DCEBFA">Sites and people</TD><TD BGCOLOR="#DDF3E4">Surplus and matching</TD>
    <TD BGCOLOR="#FDEBD3">Logistics</TD><TD BGCOLOR="#F9DEDC">Food safety audit</TD>
    <TD BGCOLOR="#ECE2F7">Forecasting</TD></TR>
    <TR><TD COLSPAN="5"><FONT POINT-SIZE="11" COLOR="#555555">Core entities only. Each area has its own detailed diagram with every column (er_1 to er_5).</FONT></TD></TR></TABLE>>];'''
render("er_0_overview", graph("MealBridge: core entities (overview)", ov, ov_edges, legend, sx=1.3, sy=1.15))

# ---------------------------------------------- 1. sites and people (EER)
d1 = {
    "campus": (0, 3, table_node("CAMPUS", "place", [
        ("campus_id", "smallint", "PK"), ("name", "varchar", "UK"), ("city", "varchar", "")])),
    "site": (4.2, 3, table_node("SITE", "place", [
        ("site_id", "int", "PK"), ("site_type", "MESS | SHELTER", ""), ("name", "varchar", ""),
        ("address_line, city, pincode", "", ""), ("location", "POINT 4326", ""),
        ("contact_phone", "varchar", ""), ("is_active", "boolean", "")], note="superclass")),
    "user": (10, 3, table_node("APP_USER", "place", [
        ("user_id", "int", "PK"), ("email", "varchar", "UK"), ("full_name, phone", "", ""),
        ("password_hash", "char(60)", ""), ("role", "enum", ""),
        ("site_id", "int, NULL", "FK")], note="superclass")),
    "d1": (4.2, 0.9, "CIRCLE:d"),
    "mess": (1.8, -1.2, table_node("MESS", "place", [
        ("site_id", "int", "PK FK"), ("campus_id", "smallint", "FK"), ("hostel_block", "varchar", ""),
        ("mess_type", "enum", ""), ("daily_capacity_meals", "int", ""), ("fssai_license_no", "char(14)", "UK")],
        note="subclass, site_type = 'MESS'")),
    "shelter": (6.6, -1.2, table_node("SHELTER", "place", [
        ("site_id", "int", "PK FK"), ("shelter_type", "enum", ""), ("registration_no", "varchar", "UK"),
        ("beneficiary_count", "int", ""), ("has_refrigeration", "boolean", ""),
        ("default_capacity_kg", "decimal", "")], note="subclass, site_type = 'SHELTER'")),
    "d2": (10, 0.9, "CIRCLE:d"),
    "vol": (11.4, -1.2, table_node("VOLUNTEER", "place", [
        ("user_id", "int", "PK FK"), ("vehicle_type", "enum", ""), ("max_load_kg", "decimal", ""),
        ("home_location", "POINT 4326", ""), ("is_available", "boolean", ""), ("verified_at", "datetime", "")],
        note="subclass, role = 'VOLUNTEER'")),
}
spec = 'dir=forward, arrowhead=none, penwidth=2, color="#2F6DB5"'
d1_edges = [
    edge("campus", "mess", "runs", "1", "N"),
    edge("user", "site", "works at", "N", "0..1"),
    f'site -> d1 [{spec}, color="#2F6DB5:white:#2F6DB5", xlabel=<<FONT POINT-SIZE="11" COLOR="#2F6DB5">disjoint, total (double line)</FONT>>];',
    f'd1 -> mess [{spec}, arrowhead=normal, arrowsize=0.8];',
    f'd1 -> shelter [{spec}, arrowhead=normal, arrowsize=0.8];',
    f'user -> d2 [{spec}, style=dashed, xlabel=<<FONT POINT-SIZE="11" COLOR="#2F6DB5">partial</FONT>>];',
    f'd2 -> vol [{spec}, arrowhead=normal, arrowsize=0.8];',
]
render("er_1_sites_people", graph("1. Sites and people (EER specialization)", d1, d1_edges))

# -------------------------------------------- 2. surplus and matching
d2 = {
    "mess": (-0.8, 1.6, ref_node("MESS", "see diagram 1")),
    "cat": (3.6, 5.2, table_node("FOOD_CATEGORY", "food", [
        ("category_id", "smallint", "PK"), ("name", "varchar", "UK"), ("risk_level", "enum", ""),
        ("safe_hours_ambient / hot_held / chilled", "decimal", ""), ("kg_per_meal", "decimal", ""),
        ("co2e_kg_per_kg", "decimal, NULL", ""), ("values_source", "varchar", "")])),
    "batch": (3.6, 1.6, table_node("SURPLUS_BATCH", "food", [
        ("batch_id", "int", "PK"), ("mess_site_id", "int", "FK"), ("category_id", "smallint", "FK"),
        ("posted_by", "int, to APP_USER", "FK"), ("meal_slot, description", "", ""), ("quantity_kg", "decimal", ""),
        ("storage", "enum", ""), ("cooked_at, packed_at", "datetime", ""),
        ("safe_until", "datetime, snapshot", ""), ("status", "enum", "")])),
    "bdt": (8.2, 3.6, table_node("BATCH_DIET_TAG", "food", [
        ("batch_id", "int", "PK FK"), ("tag_code", "varchar", "PK FK")], note="what the batch contains")),
    "tag": (10.6, 5.2, table_node("DIET_TAG", "food", [
        ("tag_code", "varchar", "PK"), ("description", "varchar", "")])),
    "sde": (14.2, 3.4, table_node("SHELTER_DIET_EXCLUSION", "food", [
        ("shelter_site_id", "int", "PK FK"), ("tag_code", "varchar", "PK FK")], note="what the shelter refuses")),
    "claim": (8.4, -2.4, table_node("CLAIM", "food", [
        ("claim_id", "int", "PK"), ("batch_id", "int", "FK"), ("shelter_site_id", "int", "FK"),
        ("claimed_by", "int, to APP_USER", "FK"), ("claimed_at", "datetime(3)", ""),
        ("match_score, distance_km", "snapshot", ""), ("status", "enum", ""), ("closed_at, close_reason", "", ""),
        ("active_batch_id", "generated", "UK")], note="UK on active_batch_id = one live claim per batch")),
    "shelter": (14.2, 0.2, ref_node("SHELTER", "see diagram 1")),
    "sday": (14.2, -3.0, table_node("SHELTER_DAY", "food", [
        ("shelter_site_id", "int", "PK FK"), ("day", "date", "PK"), ("meals_needed", "int", ""),
        ("capacity_kg", "decimal", ""), ("reserved_kg", "decimal, trigger", "")],
        note="CHECK reserved_kg <= capacity_kg")),
    "w": (0, -3.4, table_node("SCORING_WEIGHT", "food", [
        ("weight_key", "varchar", "PK"), ("weight_value", "decimal 0..1", ""), ("description", "varchar", "")],
        note="match-score weights, no links")),
}
d2_edges = [
    edge("mess", "batch", "posts", "1", "N"),
    edge("cat", "batch", "classifies", "1", "N"),
    edge("batch", "bdt", "contains", "1", "N"),
    edge("tag", "bdt", "", "1", "N"),
    edge("tag", "sde", "", "1", "N"),
    edge("shelter", "sde", "excludes", "1", "N"),
    edge("batch", "claim", "claimed in", "1", "N"),
    edge("shelter", "claim", "makes", "1", "N"),
    edge("shelter", "sday", "declares", "1", "N"),
]
render("er_2_surplus_matching", graph("2. Surplus and matching", d2, d2_edges, sx=1.15, sy=1.35))

# -------------------------------------------- 3. logistics
d3 = {
    "vol": (-0.6, 2, ref_node("VOLUNTEER", "see diagram 1")),
    "trip": (3.6, 2, table_node("PICKUP_TRIP", "move", [
        ("trip_id", "int", "PK"), ("volunteer_id", "int", "FK"), ("status", "enum", ""),
        ("planned_start", "datetime", ""), ("started_at, completed_at", "datetime", ""),
        ("planned_distance_km", "decimal", "")])),
    "stop": (9.8, 2, table_node("TRIP_STOP", "move", [
        ("trip_id", "int", "PK FK"), ("stop_seq", "tinyint, partial key", "PK"), ("site_id", "int", "FK"),
        ("stop_type", "PICKUP | DROP", ""), ("planned_eta", "datetime", ""), ("arrived_at, departed_at", "datetime", "")],
        weak=True, note="weak entity (thick border)")),
    "site": (15.4, 2, ref_node("SITE", "mess or shelter, diagram 1")),
    "item": (6.7, -2.2, table_node("TRIP_ITEM", "move", [
        ("trip_id", "int", "PK FK"), ("claim_id", "int", "PK FK"), ("pickup_seq", "tinyint", "FK"),
        ("drop_seq", "tinyint", "FK")], note="CHECK pickup_seq < drop_seq")),
    "claim": (6.7, -4.8, ref_node("CLAIM", "see diagram 2")),
}
d3_edges = [
    edge("vol", "trip", "drives", "1", "N"),
    'trip -> stop [dir=both, arrowtail=teetee, arrowhead=crowtee, penwidth=3.2, xlabel=<<FONT POINT-SIZE="12"><B>has</B><BR/><FONT COLOR="#555555">1 : 1..N</FONT></FONT>>];',
    edge("site", "stop", "visited at", "1", "N"),
    edge("trip", "item", "carries", "1", "N"),
    edge("stop", "item", "pickup / drop at", "1", "N"),
    edge("claim", "item", "moved by", "1", "N"),
]
render("er_3_logistics", graph("3. Logistics: batched multi-stop pickup trips", d3, d3_edges, sx=2.5, sy=1.9))

# -------------------------------------------- 4. food safety and audit
d4 = {
    "ev": (5, 1.4, table_node("CUSTODY_EVENT", "audit", [
        ("event_id", "bigint", "PK"), ("batch_id", "int", "FK"), ("claim_id", "int, NULL", "FK"),
        ("trip_id", "int, NULL", "FK"), ("actor_user_id", "int, NULL", "FK"),
        ("event_type", "COOKED ... DELIVERED", ""), ("event_time", "datetime(3)", ""),
        ("temperature_c, hygiene_ok", "", ""), ("location", "POINT, NULL", ""),
        ("prev_hash", "char(64)", ""), ("row_hash", "char(64)", "UK")],
        note="append-only, SHA-256 hash chain per batch")),
    "batch": (0, 3.4, ref_node("SURPLUS_BATCH", "diagram 2")),
    "claim": (0, -0.6, ref_node("CLAIM", "diagram 2")),
    "trip": (10, 3.4, ref_node("PICKUP_TRIP", "diagram 3")),
    "user": (10, -0.6, ref_node("APP_USER", "diagram 1")),
    "audit": (5, -3.4, table_node("AUDIT_LOG", "audit", [
        ("audit_id", "bigint", "PK"), ("table_name, row_pk", "varchar", ""), ("action", "INSERT | UPDATE | DELETE", ""),
        ("db_user, changed_at", "", ""), ("old_values, new_values", "JSON", "")],
        note="generic change log written by triggers, no FKs")),
}
d4_edges = [
    edge("batch", "ev", "audited by", "1", "1..N"),
    edge("claim", "ev", "context of", "0..1", "N"),
    edge("trip", "ev", "context of", "0..1", "N"),
    edge("user", "ev", "records", "0..1", "N"),
]
render("er_4_food_safety_audit", graph("4. Food-safety chain of custody and audit", d4, d4_edges, sx=1.45, sy=1.2))

# -------------------------------------------- 5. forecasting and alerts
d5 = {
    "mess": (0, 2.4, ref_node("MESS", "diagram 1")),
    "log": (4, 2.4, table_node("MESS_MEAL_LOG", "plan", [
        ("mess_site_id", "int", "PK FK"), ("service_date", "date", "PK"), ("meal_slot", "enum", "PK"),
        ("expected_headcount", "int", ""), ("actual_headcount", "int, NULL", ""),
        ("prepared_kg", "decimal", ""), ("leftover_kg", "decimal, NULL", "")])),
    "menu": (8.4, 2.4, table_node("MESS_MENU", "plan", [
        ("mess_site_id", "int", "PK FK"), ("service_date", "date", "PK FK"), ("meal_slot", "enum", "PK FK"),
        ("menu_item_id", "smallint", "PK FK")], note="M:N meal service and dish")),
    "item": (12.4, 2.4, table_node("MENU_ITEM", "plan", [
        ("menu_item_id", "smallint", "PK"), ("name", "varchar", "UK"), ("category_id", "smallint", "FK")])),
    "cat": (12.4, -0.6, ref_node("FOOD_CATEGORY", "diagram 2")),
    "fc": (4, -1.0, table_node("SURPLUS_FORECAST", "plan", [
        ("mess_site_id", "int", "PK FK"), ("forecast_date", "date", "PK"), ("meal_slot", "enum", "PK"),
        ("method", "varchar", "PK"), ("predicted_kg", "decimal", ""), ("generated_at", "datetime", "")])),
    "user": (0, -3.6, ref_node("APP_USER", "diagram 1")),
    "batch": (8.4, -3.6, ref_node("SURPLUS_BATCH", "diagram 2")),
    "notif": (4, -3.6, table_node("NOTIFICATION", "plan", [
        ("notification_id", "bigint", "PK"), ("user_id", "int", "FK"), ("kind", "enum", ""),
        ("message", "varchar", ""), ("batch_id", "int, NULL", "FK"), ("created_at, read_at", "datetime", "")])),
}
d5_edges = [
    edge("mess", "log", "keeps", "1", "N"),
    edge("log", "menu", "serves", "1", "N"),
    edge("item", "menu", "served in", "1", "N"),
    edge("cat", "item", "groups", "1", "N"),
    edge("mess", "fc", "forecast for", "1", "N"),
    edge("user", "notif", "receives", "1", "N"),
    edge("batch", "notif", "about", "0..1", "N"),
]
render("er_5_forecasting_alerts", graph("5. Forecasting and alerts", d5, d5_edges))
