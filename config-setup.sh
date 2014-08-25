#!/bin/bash

case $CONFIG in
ipcd)
  ./install-ipcd.sh
  ;;
baseline)
  ./uninstall-ipcd.sh
  ;;
*)
  echo "Unrecognized configuration: CONFIG='$CONFIG'"
  exit 1
  ;;
esac
