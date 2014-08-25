#!/bin/bash

set -e
IPCOPTER_DIR=/home/cranmer2/ipcopter
# Stop trying to use ipcd
export IPCD_DISABLE=1
if (initctl status ipcd|grep start); then
  initctl stop ipcd
fi

rm -rf /bin/ipcd
rm -rf /lib/libipc.so
#rm -rf /etc/ld.so.preload

# If it's still running, kill it
#killall -9 ipcd
