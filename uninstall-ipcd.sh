#!/bin/bash

set -ex
IPCOPTER_DIR=/home/cranmer2/ipcopter
# Stop trying to use ipcd
export IPCD_DISABLE=1

initctl stop ipcd || true

rm -rf /bin/ipcd
rm -rf /lib/libipc.so
# Ensure this has been removed!
rm -rf /etc/ld.so.preload

# If it's still running, kill it
killall -9 ipcd || true
