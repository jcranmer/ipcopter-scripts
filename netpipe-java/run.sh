#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

pushd $ROOT/netpipe-Java-1.0 &> /dev/null

java Netpipe TCP -r &
java Netpipe TCP -t -h localhost -o np.out -P -u 16777216

echo "======================="
echo "Parse-able Results:"
echo "======================="
cat np.out

popd &> /dev/null
