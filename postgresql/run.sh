#!/bin/bash

set -e
set -x
# Clear the database if it exists.
dropdb --if-exists pgbench
createdb pgbench

SCALE_FACTOR=30
TIME=600

case $WORKLOAD in
test)
  TIME=10
  ;;
basic)
  # 1m
  TIME=60
  ;;
full)
  # 10m
  TIME=600
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

RESULTS=$PWD/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

# Run pgbench
LOG=$RESULTS/s30.log
pgbench -i -s $SCALE_FACTOR -h localhost pgbench |& tee $LOG
pgbench -s $SCALE_FACTOR -T $TIME -r -h localhost pgbench |& tee -a $LOG

# Create results csv
RESULTS_CSV=$RESULTS/results.csv

# For now, just the two TPS values.
# TODO: Other parameters?
# TODO: Select-only?
# TODO: Latency numbers?
grep tps $LOG | sed 's/^tps = \([0-9.]*\).*$/\1/' | tr '\n' ', ' |sed 's/,$/\n/' > $RESULTS_CSV
