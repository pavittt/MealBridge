#!/usr/bin/env bash
# Starts the MealBridge API and web app together, for local development.
#   bash app/run_dev.sh
# Stop both with Ctrl-C. Needs: the database loaded (sql/setup.sql),
# Python packages from app/backend/requirements.txt, and `npm install`
# already run once in app/frontend.
set -euo pipefail
cd "$(dirname "$0")"

( cd backend  && python3 -m uvicorn mealbridge_api.main:app --port 8000 ) &
API=$!
( cd frontend && npm run dev ) &
WEB=$!
trap 'kill $API $WEB 2>/dev/null' EXIT INT TERM
echo
echo "  API  http://localhost:8000/docs"
echo "  App  http://localhost:3000"
echo
wait
