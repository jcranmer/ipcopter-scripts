#!/bin/bash

set -e

RESULTS=$PWD/results
rm -rf $RESULTS || /bin/true
mkdir -p $RESULTS
RESULT_CSV=$RESULTS/results.csv

mkdir -p /home/cranmer2/lmbench3/bin/x86_64-linux-gnu
cp $(dirname $0)/CONFIG.rahman /home/cranmer2/lmbench3/bin/x86_64-linux-gnu/CONFIG.$(hostname)

pushd /home/cranmer2/lmbench3 &>/dev/null
# Clear old results
rm -rf results/x86_64-linux-gnu/*

# Run the results and push them
make rerun
make -C results

python <<EOF
f = open('results/x86_64-linux-gnu/$(hostname).0')
o = open("$RESULT_CSV", "w")
blockHeader = None
for line in f:
  line = line.strip()
  if line.startswith('['):
    continue
  if ':' in line:
    pieces = line.split(':')
    o.write('"%s",%s\n' % (pieces[0], pieces[1].split(' ')[1]))
    continue
  if not line.strip():
    blockHeader = None
    continue
  if blockHeader is None:
    blockHeader = line
    if line.startswith('"'):
      blockHeader = blockHeader[1:]
    continue
  pieces = line.split()
  o.write('"%s %s",%s\n' % (blockHeader, pieces[0], pieces[1]))
EOF
popd &>/dev/null
