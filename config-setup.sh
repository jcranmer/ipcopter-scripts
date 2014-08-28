#!/bin/bash

ROOT=$(readlink -f $(dirname $0))

case $CONFIG in
ipcd)
  sudo $ROOT/uninstall-ipcd.sh
  sudo $ROOT/install-ipcd.sh
  ;;
baseline)
  sudo $ROOT/uninstall-ipcd.sh
  ;;
*)
  echo "Unrecognized configuration: CONFIG='$CONFIG'"
  exit 1
  ;;
esac
