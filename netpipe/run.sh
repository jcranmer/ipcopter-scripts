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

PORT=1
while [ $PORT -lt 1024 ]; do
  PORT=$RANDOM
done
echo $PORT

./NPtcp -l 1 -u $MAX_CHUNK_SIZE -P$PORT &
sleep 1
./NPtcp -h localhost -o $RESULTS/np.out -l 1 -u $MAX_CHUNK_SIZE -P$PORT

# Shame that java version has better information?
echo '"Bytes","Throughput (Mbps)","Time (s)"' > $RESULTS/results.csv
awk '{$1=$1}1' OFS=',' < $RESULTS/np.out >> $RESULTS/results.csv

popd &> /dev/null
