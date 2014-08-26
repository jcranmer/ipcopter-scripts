#!/bin/bash

set -e
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
#echo "/lib/libipc.so" > /etc/ld.so.preload
initctl restart ipcd
