#!/bin/bash

set -e
pushd $HOME/memcachetest &>/dev/null
./memcachetest -h 127.0.0.1:11211 -t 1 -P 33 -i 10000 -c 200000 -l -T 60
popd &>/dev/null
