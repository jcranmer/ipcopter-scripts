#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

case $WORKLOAD in
test)
  MAX_CHUNK_SIZE=4
  ;;
full | basic)
  #SIZES= (default)
  MAX_CHUNK_SIZE=16777216
  ;;
*)
  echo "Unrecognized WORKLOAD '$WORKLOAD'"
  exit 1
esac

RESULTS=$PWD/results
rm -rf $RESULTS || true
mkdir -p $RESULTS

pushd $ROOT/netpipe-Java-1.0 &> /dev/null

PORT=1
while [ $PORT -lt 1024 ]; do
  PORT=$RANDOM
done
echo "Using port=$PORT"
java Netpipe TCP -r -u $MAX_CHUNK_SIZE -p $PORT &
java Netpipe TCP -t -h localhost -o $RESULTS/np.out -P -u $MAX_CHUNK_SIZE -p $PORT

echo '"Time","Throughput (bps)","Bits","Bytes","Variance"' > $RESULTS/results.csv
awk '{$1=$1}1' OFS=',' < $RESULTS/np.out >> $RESULTS/results.csv

popd &> /dev/null
