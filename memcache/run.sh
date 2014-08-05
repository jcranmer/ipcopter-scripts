#!/bin/bash

set -e
pushd $HOME/memcachetest &>/dev/null
for nthreads in $(seq 1 32); do
  for prob in 0 10 20 25 33 50 67 75 80 90 100; do
    echo $nthreads $prob
    ./memcachetest -h 127.0.0.1:11211 -t $nthreads -P $prob -i 10000 -c 200000 -l -T 60
  done
done
popd &>/dev/null
