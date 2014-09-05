#!/bin/bash

set -ex
IPCOPTER_DIR=/home/cranmer2/ipcopter
# Stop trying to use ipcd
export IPCD_DISABLE=1

rm -f /etc/ld.so.preload 2>/dev/null
killall -9 ipcd || true

# Ensure this is removed, regardless of what initctl thinks

rm -f /bin/ipcd
rm -f /lib/libipc.so

# If it's still running, kill it
killall -9 ipcd || true
