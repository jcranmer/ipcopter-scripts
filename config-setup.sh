#!/bin/bash

ROOT=$(readlink -f $(dirname $0))

case $CONFIG in
ipcd)
  $ROOT/install-ipcd.sh
  ;;
baseline)
  $ROOT/uninstall-ipcd.sh
  ;;
*)
  echo "Unrecognized configuration: CONFIG='$CONFIG'"
  exit 1
  ;;
esac
