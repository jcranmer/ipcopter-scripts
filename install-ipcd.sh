#!/bin/bash

set -ex
IPCOPTER_DIR=/home/cranmer2/ipcopter

# Build ipcd and make sure it's up-to-date first.
pushd $IPCOPTER_DIR
sudo -u cranmer2 git pull
popd
pushd $IPCOPTER_DIR/libipc
sudo -u cranmer2 make
popd
pushd $IPCOPTER_DIR/ipcd
sudo -u cranmer2 go build
popd

install $IPCOPTER_DIR/ipcd/ipcd /bin/ipcd
install $IPCOPTER_DIR/libipc/libipc.so /lib/libipc.so


# initctl stop ipcd || true
# Remove all existing ipc(d) logs
find /tmp/ipcd -maxdepth 1 -type f -name "*.log" -exec rm -f {} \;
# Remove any existing shared memory segments as well
find /dev/shm -maxdepth 1 -name "ipcd.*" -exec rm -f {} \;
# initctl start ipcd || true

echo "/lib/libipc.so" > /etc/ld.so.preload

/bin/true

ps aux|grep ipcd
