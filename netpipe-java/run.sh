#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

MAX_CHUNK_SIZE=16777216

pushd $ROOT/netpipe-Java-1.0 &> /dev/null

java Netpipe TCP -r -u $MAX_CHUNK_SIZE &
java Netpipe TCP -t -h localhost -o np.out -P -u $MAX_CHUNK_SIZE

echo "======================="
echo "Parse-able Results:"
echo "======================="
cat np.out

popd &> /dev/null
