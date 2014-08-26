#!/bin/bash

set -e

SIZES="$(python -c "print ' '.join(map(lambda x:str(2**x),range(21)))")"

if [ $WORKLOAD == "test" ]; then
  SIZES="1024 2048"
fi

for size in $SIZES; do
  netperf -t TCP_STREAM -l 10 -fM -I 95,5 -i 3,30 -- -m $size
done
