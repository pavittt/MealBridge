"""
MealBridge REST API (FastAPI).   Run:  uvicorn mealbridge_api.main:app --port 8000

Every endpoint reads from or writes to MySQL; there is no in-memory data.
Responses look like {"data": ..., "hood": {...}} where "hood" lists the
exact SQL that ran, the MySQL login and role used, and (for writes) the
transaction, triggers and the rows those triggers wrote.

Interactive API docs: http://localhost:8000/docs
"""
import os

from fastapi import Depends, FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from . import config
from .auth import check_password, current_user, make_token
from .db import DbError, DbSession
from .routers import admin, impact, lab, mess, shelter, volunteer

app = FastAPI(title="MealBridge API", version="1.0",
              description="Surplus mess food -> shelters. Every call is backed by MySQL.")

for r in (mess.router, shelter.router, volunteer.router, admin.router, impact.router, lab.router):
    app.include_router(r)

if os.path.isdir(config.DIAGRAM_DIR):
    app.mount("/api/diagrams", StaticFiles(directory=config.DIAGRAM_DIR), name="diagrams")


# ---------------------------------------------------------------------------
# Errors: a MySQL error becomes a clear HTTP error that still carries the
# statements that ran, so the UI can show WHY (e.g. the CHECK or SIGNAL).
#   1142/1143/1370 privilege denied -> 403   (the MySQL role said no)
#   1644 SIGNAL from a procedure/trigger -> 400 (a business rule said no)
#   3819 CHECK constraint violated -> 400
#   1452 foreign key (e.g. an unknown diet tag), 1264 value out of range,
#   1406 text too long, 1048 NULL not allowed -> 400 (bad input, not a crash)
#   1062 duplicate key -> 409
# ---------------------------------------------------------------------------
@app.exception_handler(DbError)
async def db_error(request: Request, exc: DbError):
    status = {1142: 403, 1143: 403, 1370: 403, 1644: 400, 3819: 400,
              1452: 400, 1264: 400, 1406: 400, 1048: 400, 1062: 409}.get(exc.code, 500)
    db = getattr(request.state, "db", None)
    return JSONResponse(status_code=status, content={
        "detail": {"message": exc.message, "mysql_error": exc.code,
                   "hood": db.hood() if db else None}})


@app.get("/api/health")
def health():
    with DbSession("PUBLIC") as db:
        db.query("SELECT 1")
    return {"ok": True}


class LoginIn(BaseModel):
    email: str
    password: str


@app.post("/api/auth/login")
def login(body: LoginIn):
    user, db = check_password(body.email.strip().lower(), body.password)
    if not user:
        raise HTTPException(401, "Wrong e-mail or password")
    return {"data": {"token": make_token(user), "user": user}, "hood": db.hood()}


@app.get("/api/auth/me")
def me(user=Depends(current_user)):
    return {"data": user}


@app.get("/api/auth/demo-accounts")
def demo_accounts():
    """Login page helper: a few synthetic accounts per role (all use the
    demo password demo1234). Read with the mb_auth login."""
    with DbSession("AUTH") as db:
        rows = db.query(
            "SELECT u.email, u.full_name, u.role, s.name AS site_name FROM app_user u "
            "  LEFT JOIN site s ON s.site_id = u.site_id "
            " WHERE u.is_active ORDER BY FIELD(u.role,'MESS_ADMIN','SHELTER','VOLUNTEER','PLATFORM_ADMIN'), u.user_id")
    picked, seen = [], {}
    for r in rows:
        seen[r["role"]] = seen.get(r["role"], 0) + 1
        if seen[r["role"]] <= 3:
            picked.append(r)
    return {"data": picked}
