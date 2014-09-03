#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))


ZMQ_DIR=~cranmer2/zeromq-4.0.4

RESULTS=$PWD/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

pushd $ZMQ_DIR/perf &> /dev/null

case $WORKLOAD in
test | full | basic)
  ITERS=5
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

RESULTS_CSV=$RESULTS/results.csv

echo "'Message Size','Message Count','Mean Throughput (msg/s)','Mean Throughput (Mb/s)'" > $RESULTS_CSV

for i in `seq 0 $ITERS`; do
  let 'SIZE=10**i'
  let 'COUNT=10**(7-i)'

  LOG=$RESULTS/${SIZE}.log

  # run throughput test
  ./local_thr tcp://lo:5555 $SIZE $COUNT >& $LOG &
  ./remote_thr tcp://localhost:5555 $SIZE $COUNT
  wait
  sleep 1

  # Append results to csv...
  VALS=$(cat $LOG|sed -e 's/^.*://' -e 's/\[.*\]//')
  echo $VALS|awk '{$1=$1}1' OFS="," >> $RESULTS_CSV
done

popd &> /dev/null


