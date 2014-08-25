#!/bin/bash

set -e

ROOT=$(readlink -f $(dirname $0))

pushd $ROOT &> /dev/null

tar xvf netpipe-Java-1.0.tar.gz
cd netpipe-Java-1.0
make

popd &> /dev/null
