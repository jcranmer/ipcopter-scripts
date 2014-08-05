#!/bin/bash

set -e

for size in $(python -c "print ' '.join(map(lambda x:str(2**x),range(21)))"); do
  netperf -t TCP_STREAM -l 10 -fM -I 95,5 -i 3,30 -- -m $size
done
