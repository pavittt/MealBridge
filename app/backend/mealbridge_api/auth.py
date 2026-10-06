"""
Login and sessions.

1. The browser sends e-mail + password to POST /api/auth/login.
2. The API reads that user's bcrypt hash using the mb_auth login, which
   can read ONLY the login columns of app_user (sql/08_roles_grants.sql).
3. bcrypt.checkpw compares. On success the API returns a signed token
   holding user_id, role and site_id.
4. Every later request sends the token. The API checks the signature and
   then opens a MySQL connection with the login of THAT role, and passes
   user_id to the procedures as p_user_id (MySQL has no row-level
   security, so the procedures check ownership with it).

The token is a small HMAC-SHA256-signed JSON string (the same idea as a
JWT, written out so it can be explained line by line).
"""
import base64
import hashlib
import hmac
import json
import time

import bcrypt
from fastapi import Depends, Header, HTTPException, Request

from . import config
from .db import DbSession


def _b64(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).decode().rstrip("=")


def _unb64(text: str) -> bytes:
    return base64.urlsafe_b64decode(text + "=" * (-len(text) % 4))


def make_token(user: dict) -> str:
    payload = {"uid": user["user_id"], "role": user["role"], "site": user["site_id"],
               "name": user["full_name"], "exp": int(time.time()) + config.TOKEN_HOURS * 3600}
    body = _b64(json.dumps(payload, separators=(",", ":")).encode())
    sig = _b64(hmac.new(config.SECRET.encode(), body.encode(), hashlib.sha256).digest())
    return f"{body}.{sig}"


def read_token(token: str) -> dict:
    try:
        body, sig = token.split(".")
        good = _b64(hmac.new(config.SECRET.encode(), body.encode(), hashlib.sha256).digest())
        if not hmac.compare_digest(sig, good):          # constant-time compare
            raise ValueError("bad signature")
        payload = json.loads(_unb64(body))
        if payload["exp"] < time.time():
            raise ValueError("expired")
        return payload
    except Exception:
        raise HTTPException(401, "Please log in again")


def check_password(email: str, password: str):
    """Returns (user dict or None, the DbSession used, for the hood panel)."""
    db = DbSession("AUTH")
    try:
        user = db.one(
            "SELECT u.user_id, u.full_name, u.role, u.site_id, u.is_active, u.password_hash, "
            "       s.name AS site_name "
            "  FROM app_user u LEFT JOIN site s ON s.site_id = u.site_id "
            " WHERE u.email = %s", (email,))
    finally:
        db.close()
    # never show the hash in the panel
    for st in db.trace:
        st["sql"] = st["sql"].replace("u.password_hash, ", "u.password_hash /* compared in Python with bcrypt, never sent back */, ")
    if not user or not user["is_active"]:
        return None, db
    if not bcrypt.checkpw(password.encode(), user["password_hash"].encode()):
        return None, db
    user.pop("password_hash")
    return user, db


def current_user(authorization: str = Header(default="")) -> dict:
    """FastAPI dependency: the logged-in user, from the Bearer token."""
    if not authorization.startswith("Bearer "):
        raise HTTPException(401, "Please log in")
    return read_token(authorization[7:])


def require(*roles):
    """Dependency factory: only these application roles may call the route.
    (MySQL would refuse anyway; this gives a clean 403 before connecting.)"""
    def dep(user: dict = Depends(current_user)):
        if user["role"] not in roles:
            raise HTTPException(403, f"This page is for {', '.join(roles)} users")
        return user
    return dep


def role_db(request: Request, user: dict = Depends(current_user)):
    """Dependency: a MySQL connection opened with the CALLER'S ROLE login.
    Stored on request.state so the error handler can still return the
    statements that ran before an error."""
    db = DbSession(user["role"])
    request.state.db = db
    try:
        yield db
    finally:
        db.close()
