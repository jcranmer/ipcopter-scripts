#!/bin/bash

set -e
set -x

case $WORKLOAD in
test)
  SCALES="1"
  TIME=10
  ;;
basic)
  # 1m
  SCALES="1 31 61"
  TIME=60
  ;;
full)
  SCALES="1 11 21 31 41 51 61 71"
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

# Create results csv
RESULTS_CSV=$RESULTS/results.csv

echo '"TPS (incl)", "TPS (excl)"' > $RESULTS_CSV

# Run pgbench
for scale in $SCALES; do
  LOG=$RESULTS/s${scale}.log
  # Clear the database if it exists.
  dropdb --if-exists pgbench
  createdb pgbench

  pgbench -i -s $scale -h localhost pgbench |& tee $LOG
  pgbench -s $scale -T $TIME -r -h localhost pgbench |& tee -a $LOG


  # TODO: Select-only?
  # TODO: Latency numbers?
  grep tps $LOG | sed 's/^tps = \([0-9.]*\).*$/\1/' | tr '\n' ', ' |sed 's/,$/\n/' | \
    sed 's/^/$scale,/' >> $RESULTS_CSV
done
