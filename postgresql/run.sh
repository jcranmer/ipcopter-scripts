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
  # 10m, let's see what this gets us...
  TIME=600
  ITERS=2
  ;;
full)
  SCALES="1 21 41 61"
  # 10m
  TIME=600
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

function cleanup_db {
  if [ "$WORKLOAD" != "test" ]; then
    echo Cleaning up database $DB |& tee -a $LOG
    # From: http://www.westnet.com/~gsmith/content/postgresql/pgbench.htm
    DB=pgbench
    # psql -c 'truncate table history' $DB |& tee -a $LOG
    psql -c 'vacuum' $DB |& tee -a $LOG
    psql -c 'vacuum full' $DB |& tee -a $LOG
    psql -c 'vacuum analyze' $DB |& tee -a $LOG
    psql -c 'checkpoint' $DB |& tee -a $LOG
    # For good luck ;)
    sync
    sync
    sync
    sleep 5
  fi
}

# Run pgbench
for scale in $SCALES; do
  # Clear the database if it exists.
  dropdb --if-exists pgbench
  createdb pgbench

  # create test db once for each scale size
  pgbench -i -s $scale -h localhost pgbench

  # Do a throwaway warm-up iteration
  # LOG=$RESULTS/s${scale}.warmup.log
  # :> $LOG
  # cleanup_db
  # pgbench -n -N -s $scale -T $TIME -r -h localhost pgbench |& tee -a $LOG
  

  for iter in $(seq $ITERS); do
    LOG=$RESULTS/s${scale}.i${iter}.log

    :> $LOG

    cleanup_db

    pgbench -n -N -s $scale -T $TIME -r -h localhost pgbench |& tee -a $LOG

    # TODO: Select-only?
    # TODO: Latency numbers?
    grep tps $LOG | sed 's/^tps = \([0-9.]*\).*$/\1/' | tr '\n' ', ' |sed 's/,$/\n/' | \
      sed "s/^/$scale,$iter,/" >> $RESULTS_CSV
  done
done

# Attempt to cleanly exit the server, if we get this far...
sudo service postgresql stop
