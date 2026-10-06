"""
Configuration of the MealBridge API.

The key design point for the viva: the API never connects to MySQL as
root. It holds ONE MySQL login per application role (created in
sql/08_roles_grants.sql). When a shelter user calls the API, the API
uses the mb_shelter login, so MySQL itself enforces what that role may
touch. A bug in the API cannot give a shelter the mess admin's rights.

Every value can be overridden with an environment variable, so the same
code runs on a laptop and on a server.
"""
import os
import secrets

DB_HOST = os.getenv("MB_DB_HOST", "127.0.0.1")
DB_PORT = int(os.getenv("MB_DB_PORT", "3306"))
DB_NAME = os.getenv("MB_DB_NAME", "mealbridge")

# app role  ->  (MySQL login, password).  Demo passwords from 08_roles_grants.sql.
DB_LOGINS = {
    "MESS_ADMIN":     (os.getenv("MB_LOGIN_MESS", "mb_mess_admin"),
                       os.getenv("MB_PW_MESS", "MessAdmin#Demo2026")),
    "SHELTER":        (os.getenv("MB_LOGIN_SHELTER", "mb_shelter"),
                       os.getenv("MB_PW_SHELTER", "Shelter#Demo2026")),
    "VOLUNTEER":      (os.getenv("MB_LOGIN_VOLUNTEER", "mb_volunteer"),
                       os.getenv("MB_PW_VOLUNTEER", "Volunteer#Demo2026")),
    "PLATFORM_ADMIN": (os.getenv("MB_LOGIN_ADMIN", "mb_platform_admin"),
                       os.getenv("MB_PW_ADMIN", "PlatformAdmin#Demo2026")),
    # service logins (not people): login screen and public landing page
    "AUTH":           (os.getenv("MB_LOGIN_AUTH", "mb_auth"),
                       os.getenv("MB_PW_AUTH", "Auth#Demo2026")),
    "PUBLIC":         (os.getenv("MB_LOGIN_PUBLIC", "mb_public"),
                       os.getenv("MB_PW_PUBLIC", "Public#Demo2026")),
}

# MySQL role that each login activates (shown in the "under the hood" panel)
DB_ROLE_NAMES = {
    "MESS_ADMIN": "r_mess_admin", "SHELTER": "r_shelter", "VOLUNTEER": "r_volunteer",
    "PLATFORM_ADMIN": "r_platform_admin", "AUTH": "r_auth", "PUBLIC": "r_public",
}

# Secret that signs session tokens. A random one per start is fine for a
# demo (everyone is logged out on restart); set MB_SECRET in production.
SECRET = os.getenv("MB_SECRET") or secrets.token_hex(32)
TOKEN_HOURS = 12

# Folder with the ER diagrams and the .sql sources (shown in the schema explorer)
HERE = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.abspath(os.path.join(HERE, "..", "..", ".."))   # .../mealbridge
DIAGRAM_DIR = os.path.join(PROJECT_DIR, "diagrams")
SQL_DIR = os.path.join(PROJECT_DIR, "sql")
