#!/bin/bash

set -e
pushd /home/cranmer2/lmbench3 &>/dev/null
# Clear old results
rm -rf results/x86_64-linux-gnu/*

# Run the results and push them
make rerun
make -C results
popd &>/dev/null
