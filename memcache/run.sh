#!/bin/bash

set -e

COUNT=200000
ITERS=10000

case $WORKLOAD in
test)
  THREADS="4"
  TIME=10
  PROBS="50"
  ;;
basic)
  THREADS="1 2 4"
  TIME=30
  PROBS="0 25 50 75 100"
  ;;
full)
  THREADS="$(seq 1 16)"
  TIME=60
  PROBS="20 50 80"
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

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
echo '"Threads","Prob","Gets","Sets","Time","Ops/Sec"' > $RESULTS_CSV
for nthreads in $THREADS; do
  for prob in $PROBS; do
    LOG=$RESULTS/${nthreads}.${prob}.log
    tail -n1 $LOG | sed 's/[^0-9]*://g'|sed "s/^/$nthreads $prob/"|awk '{$1=$1}1' OFS="," >> $RESULTS_CSV
  done
done
