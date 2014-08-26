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

pushd $HOME/memcachetest &>/dev/null
for nthreads in $THREADS; do
  for prob in $PROBS; do
    echo $nthreads $prob
    ./memcachetest -h 127.0.0.1:11211 -t $nthreads -P $prob -i $ITERS -c $COUNT -l -T $TIME
  done
done
popd &>/dev/null
