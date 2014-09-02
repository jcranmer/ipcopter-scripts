#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))


ZMQ_DIR=~cranmer2/zeromq-4.0.4

RESULTS=$ROOT/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

pushd $ZMQ_DIR/perf &> /dev/null

COUNT=100000

RESULTS_CSV=$RESULTS/results.csv

echo "'Message Size','Message Count','Mean Throughput (msg/s)','Mean Throughput (Mb/s)'" > $RESULTS_CSV

for i in `seq 1 5`; do
  let 'SIZE=10**i'

  LOG=$RESULTS/${SIZE}.log

  # run throughput test
  ./local_thr tcp://lo:5555 $SIZE $COUNT >& $LOG &
  ./remote_thr tcp://localhost:5555 $SIZE $COUNT
  wait

  # Append results to csv...
  VALS=$(cat $LOG|sed -e 's/^.*://' -e 's/\[.*\]//')
  echo $VALS|awk '{$1=$1}1' OFS="," >> $RESULTS_CSV
done

popd &> /dev/null


