#!/bin/bash

set -e

case $WORKLOAD in
test)
  SIZES="4"
  ITERS="2"
  TIME=5
  ;;
basic)
  SIZES="$(python -c "print ' '.join(map(lambda x:str(8**x),range(7)))")"
  ITERS="5"
  TIME=10
  ;;
full)
  SIZES="$(python -c "print ' '.join(map(lambda x:str(2**x),range(21)))")"
  ITERS="20"
  TIME=10
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

RESULTS=$PWD/results
rm -rf $RESULTS || /bin/true
mkdir -p $RESULTS

iperf -s >& /dev/null &
IPERF_SERVER=$!

for size in $SIZES; do
  for iter in $(seq $ITERS); do
    LOG=$RESULTS/${size}.${iter}.log
    stdbuf -oL -eL iperf -c localhost -fK -l $size -t $TIME |& tee $LOG
  done
done

# Stop server
kill $!

# build result csv
RESULT_CSV=$RESULTS/results.csv

echo '"Iteration","Buffer Size","Throughput KB/s"' > $RESULT_CSV

for size in $SIZES; do
  for iter in $(seq $ITERS); do
    LOG=$RESULTS/${size}.${iter}.log
    sed -n 's@.* \([0-9\.]*\) KBytes/sec.*$@\1@p' $LOG|sed "s/^/$iter $size /"|awk '{$1=$1}1' OFS=',' >> $RESULT_CSV
  done
done
