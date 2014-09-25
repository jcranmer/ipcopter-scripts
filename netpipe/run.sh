#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

case $WORKLOAD in
test)
  MAX_CHUNK_SIZE=4
  ITERS=1
  ;;
full | basic)
  #SIZES= (default)
  MAX_CHUNK_SIZE=16777216
  ITERS=5
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

RESULTS=$PWD/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

pushd $ROOT/NetPIPE-3.7.1 &> /dev/null

echo '"Iteration", "Perturbation", "Bytes","Throughput (Mbps)","Time (s)"' > $RESULTS/results.csv

for i in $(seq $ITERS); do
  PORT=1
  while [ $PORT -lt 1024 ]; do
    PORT=$RANDOM
  done
  echo "Using port=$PORT"
  OUT=$RESULTS/np.${i}.out

  ./NPtcp -l 1 -u $MAX_CHUNK_SIZE -P$PORT -p3 &
  sleep 1
  ./NPtcp -h localhost -o $OUT -l 1 -u $MAX_CHUNK_SIZE -P$PORT -p3

  awk '{$1=$1}1' OFS=',' < $OUT | sed "s/^/$i,$i,/" >> $RESULTS/results.csv
done

popd &> /dev/null
