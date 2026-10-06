#!/usr/bin/env bash
# Rebuilds the database from scratch and regenerates EVERY real-output
# report of Stages 4 and 5. Run from anywhere:  bash tools/run_all.sh
# Needs: a local MySQL 8 server where 'mysql -uroot' works (socket auth),
#        python3. Takes about a minute.
set -euo pipefail
cd "$(dirname "$0")/.."
bash tools/rebuild.sh                                   # setup.sql -> fresh database
python3 tools/run_report.py sql/09_demo_views_procs_triggers.sql \
        --title "MealBridge: views, matching procedure, functions and triggers (real output)"
python3 tools/run_report.py sql/10_dml_examples.sql  --title "MealBridge: DML examples (real output)"
python3 tools/run_report.py sql/11_queries.sql       --title "MealBridge: 20 queries with real output"
python3 tools/run_report.py sql/12_explain_indexes.sql --title "MealBridge: indexes, EXPLAIN before and after (real output)"
bash sql/13_race_demo.sh > /dev/null && echo "13_race_demo.output.txt written"
python3 tools/rbac_test.py | grep "passed"
