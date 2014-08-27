#!/bin/bash

set -e

COUNT=200000
ITERS=10000
TIME=60
THREADS="$(seq 1 32)"
PROBS="0 10 20 25 33 50 67 75 80 90 100"

if [ "$WORKLOAD" == "test" ]; then
  THREADS="8"
  TIME=10
  PROBS="50"
fi

RESULTS=$PWD/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

pushd $HOME/memcachetest &>/dev/null
for nthreads in $THREADS; do
  for prob in $PROBS; do
    echo $nthreads $prob
    LOG=$RESULTS/${nthreads}.${prob}.log
    stdbuf -oL -eL ./memcachetest -h 127.0.0.1:11211 -t $nthreads -P $prob -i $ITERS -c $COUNT -l -T $TIME |& tee $LOG
  done
done
popd &>/dev/null

# Parse results into csv
# TODO: Maybe make use of latency statistics? (How?)
RESULTS_CSV=$RESULTS/results.csv
echo '"Gets","Sets","Time","Ops/Sec"' > $RESULTS_CSV
for nthreads in $THREADS; do
  for prob in $PROBS; do
    LOG=$RESULTS/${nthreads}.${prob}.log
    tail -n1 $LOG | sed 's/[^0-9]*://g'|awk '{$1=$1}1' OFS="," >> $RESULTS_CSV
  done
done
