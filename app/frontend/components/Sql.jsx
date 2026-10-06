/* =====================================================================
   <Sql> : a <pre> block with SQL syntax colouring.
   A tiny tokenizer (one regular expression), no library: comments,
   strings, numbers, SQL keywords, and this project's own objects
   (fn_*, sp_*, trg_*, v_*, ev_*), each wrapped in a span with a class.
   The text itself is never changed, so what you read is exactly the
   statement MySQL ran (the panel and the lab pages rely on that).
   ===================================================================== */
const KEYWORDS = new Set((
  "select from where and or not in is null as on join left right inner outer cross group by order having limit " +
  "insert into values update set delete create trigger procedure function view index table begin end if then else " +
  "elseif declare default return returns for each row before after start transaction commit rollback call leave " +
  "signal sqlstate message_text case when distinct union all exists like between asc desc into primary key " +
  "foreign references unique check constraint over partition window with recursive lock share nowait skip locked " +
  "explain analyze ignore force use do sleep sql security definer reads data deterministic modifies while loop " +
  "repeat until open close fetch cursor handler continue exit found interval true false"
).split(" "));

const TOKEN = /(--[^\n]*|#[^\n]*|\/\*[\s\S]*?\*\/)|('(?:[^'\\]|\\.|'')*')|(\b\d+(?:\.\d+)?\b)|(\b(?:fn|sp|trg|v|ev|idx|mb|r)_[a-z0-9_]+\b)|([A-Za-z_][A-Za-z0-9_]*)/gi;

function tokens(text) {
  const out = [];
  let last = 0, m, i = 0;
  TOKEN.lastIndex = 0;
  while ((m = TOKEN.exec(text))) {
    if (m.index > last) out.push(text.slice(last, m.index));
    const [w, com, str, num, obj, word] = m;
    const cls = com ? "tk-com" : str ? "tk-str" : num ? "tk-num" : obj ? "tk-obj"
              : word && KEYWORDS.has(word.toLowerCase()) ? "tk-kw" : null;
    out.push(cls ? <span key={i++} className={cls}>{w}</span> : w);
    last = m.index + w.length;
  }
  if (last < text.length) out.push(text.slice(last));
  return out;
}

export default function Sql({ children, className = "" }) {
  const text = children == null ? "" : String(children);
  return <pre className={`sql ${className}`}>{tokens(text)}</pre>;
}
