#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

pushd $ROOT &> /dev/null

tar xvf NetPIPE-3.7.1.tar.gz
cd NetPIPE-3.7.1
patch -p1 -i ../fix_port_flag.patch
make

popd &> /dev/null
