#!/bin/bash

set -ex
IPCOPTER_DIR=/home/cranmer2/ipcopter
# Stop trying to use ipcd
export IPCD_DISABLE=1

initctl stop ipcd || true

# Ensure this is removed, regardless of what initctl thinks
rm -rf /etc/ld.so.preload 2>/dev/null

rm -rf /bin/ipcd
rm -rf /lib/libipc.so

# If it's still running, kill it
killall -9 ipcd || true
