"""
Database access layer with a built-in "flight recorder".

Every SQL statement the API sends goes through DbSession.query(), which
records the exact statement (with its parameters filled in), how long
MySQL took and how many rows came back. That record is returned to the
browser with every response, and the "Under the hood" panel shows it.
So what the panel shows is what really ran, not a hand-written copy.

Connections use autocommit=True on purpose: the stored procedures run
their own START TRANSACTION ... COMMIT, and a procedure that starts a
transaction would silently commit any transaction the API had opened
around it (see the MySQL gotcha noted in the Stage 4 README).
"""
import time
import pymysql
import pymysql.cursors

from . import config


class DbError(Exception):
    """A MySQL error, kept with its error number so the API can map it to
    an HTTP status (1142 = privilege denied -> 403, 1644 = SIGNAL -> 400)."""

    def __init__(self, code, message):
        super().__init__(message)
        self.code = code
        self.message = message


class DbSession:
    """One MySQL connection, opened with the login of ONE application role."""

    def __init__(self, app_role):
        login, password = config.DB_LOGINS[app_role]
        self.app_role = app_role
        self.login = login
        self.trace = []            # list of {sql, ms, rows, error?}
        self.conn = pymysql.connect(
            host=config.DB_HOST, port=config.DB_PORT, database=config.DB_NAME,
            user=login, password=password, autocommit=True, charset="utf8mb4",
            cursorclass=pymysql.cursors.DictCursor,
        )

    # -- the one place SQL is executed ------------------------------------
    def query(self, sql, args=None, record=True):
        """Run one statement and return its rows as a list of dicts.
        record=False is used only for the panel's own bookkeeping reads."""
        with self.conn.cursor() as cur:
            text = cur.mogrify(sql, args) if args is not None else sql
            start = time.perf_counter()
            try:
                cur.execute(sql, args)
                rows = cur.fetchall() if cur.description else []
                # a CALL can return several result sets; keep the first
                # non-empty one and drain the rest so the connection is clean
                while cur.nextset():
                    more = cur.fetchall() if cur.description else []
                    if not rows and more:
                        rows = more
            except pymysql.MySQLError as e:
                code = e.args[0] if e.args else 0
                msg = e.args[1] if len(e.args) > 1 else str(e)
                if record:
                    self.trace.append({"sql": " ".join(text.split()), "ms": None,
                                       "rows": None, "error": f"ERROR {code}: {msg}"})
                raise DbError(code, msg) from None
            ms = round((time.perf_counter() - start) * 1000, 2)
            if record:
                self.trace.append({"sql": " ".join(text.split()), "ms": ms,
                                   "rows": len(rows) if rows else cur.rowcount})
            return list(rows)

    def one(self, sql, args=None):
        rows = self.query(sql, args)
        return rows[0] if rows else None

    def call(self, proc, args, outs=()):
        """CALL a stored procedure. OUT parameters are passed as MySQL user
        variables (@name) and read back with one SELECT, exactly as you
        would do it by hand in the mysql client."""
        holders = ", ".join(["%s"] * len(args) + [f"@{o}" for o in outs])
        rows = self.query(f"CALL {proc}({holders})", list(args))
        out_values = {}
        if outs:
            out_values = self.one("SELECT " + ", ".join(f"@{o} AS {o}" for o in outs))
        return rows, out_values

    def close(self):
        try:
            self.conn.close()
        except Exception:
            pass

    def __enter__(self):
        return self

    def __exit__(self, *exc):
        self.close()

    # -- what the "Under the hood" panel receives ---------------------------
    def hood(self, action=None):
        h = {"login": f"{self.login}@localhost",
             "mysql_role": config.DB_ROLE_NAMES[self.app_role],
             "statements": self.trace}
        if action:
            from .hood import ACTIONS
            h.update(ACTIONS.get(action, {}))
            h["action"] = action
        return h
