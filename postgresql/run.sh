#!/bin/bash

set -e
set -x

# NOTES:
# * Disabled autovacuum
#   - Per suggestion at bottom of: http://www.postgresql.org/docs/9.2/static/pgbench.html
# * Bumped shared_buffers to 1024M
# * Bumped checkpoint_segments to 8
#   - Per http://www.westnet.com/~gsmith/content/postgresql/pgbench-scaling.htm
# Manually set password

case $WORKLOAD in
test)
  SCALES="1"
  # 10s
  TIME=10
  ITERS=1
  ;;
basic)
  SCALES="1 21 41 61"
  # 1m
  TIME=60
  ITERS=3
  ;;
full)
  SCALES="1 21 41 61"
  # 1m
  TIME=60
  ITERS=5
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

echo '"Scale Factor","Iteration","TPS (incl)", "TPS (excl)"' > $RESULTS_CSV

export PGUSER=postgres
export PGHOST=localhost

# Run pgbench
for scale in $SCALES; do
  # Clear the database if it exists.
  dropdb --if-exists pgbench
  createdb pgbench

  # create test db once for each scale size
  pgbench -i -s $scale -h localhost pgbench
  # do multiple iterations with same db (??)
  for iter in $(seq $ITERS); do
    LOG=$RESULTS/s${scale}.i${iter}.log

    :> $LOG

    if [ "$WORKLOAD" != "test" ]; then
      psql -c "vacuum analyze" |& tee -a $LOG
      psql -c "checkpoint" |& tee -a $LOG
      # Not sure how to properly wait for checkpoint, so, uh, let's sleep a bit
      sync
      sync
      sync
      sleep 10
    fi


    pgbench -s $scale -S -T $TIME -r -h localhost pgbench |& tee -a $LOG


    # TODO: Select-only?
    # TODO: Latency numbers?
    grep tps $LOG | sed 's/^tps = \([0-9.]*\).*$/\1/' | tr '\n' ', ' |sed 's/,$/\n/' | \
      sed "s/^/$scale,$iter,/" >> $RESULTS_CSV
  done
done

# Attempt to cleanly exit the server, if we get this far...
sudo service postgresql stop
