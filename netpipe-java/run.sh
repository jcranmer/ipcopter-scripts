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

java Netpipe TCP -r -u $MAX_CHUNK_SIZE &
java Netpipe TCP -t -h localhost -o $RESULTS/np.out -P -u $MAX_CHUNK_SIZE

echo '"Time","Throughput (bps)","Bits","Bytes","Variance"' > $RESULTS/results.csv
awk '{$1=$1}1' OFS=',' < np.out >> $RESULTS/results.csv

popd &> /dev/null
