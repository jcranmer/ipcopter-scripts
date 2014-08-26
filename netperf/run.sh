#!/bin/bash

set -e

SIZES="$(python -c "print ' '.join(map(lambda x:str(2**x),range(21)))")"
CONFID="95,5"
ITERS="3,30"
TIME=10

if [ $WORKLOAD == "test" ]; then
  SIZES="4"
  ITERS="2,2"
  TIME=5
fi

for size in $SIZES; do
  netperf -t TCP_STREAM -l $TIME -fM -I $CONFID -i $ITERS -- -m $size
done
