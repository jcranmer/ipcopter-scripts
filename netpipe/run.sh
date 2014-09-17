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

pushd $ROOT/NetPIPE-3.7.1 &> /dev/null

./NPtcp -l 1 -u $MAX_CHUNK_SIZE &
sleep 1
./NPtcp -h localhost -o $RESULTS/np.out -l 1 -u $MAX_CHUNK_SIZE

# Shame that java version has better information?
echo '"Bytes","Throughput (Mbps)","Time (s)"' > $RESULTS/results.csv
awk '{$1=$1}1' OFS=',' < $RESULTS/np.out >> $RESULTS/results.csv

popd &> /dev/null
