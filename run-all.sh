#!/bin/bash

set -e

for file in *; do
  # A "test" is a directory
  if [ ! -d $file ]; then
    continue
  fi

  # Remove old runs
  rm -f $file-setup.log
  rm -f $file-run.log

  echo -e Setting up test "\e[1;31m$file\e[0m"
  sudo $file/setup.sh |& tee $file-setup.log

  echo -e Running test "\e[1;31m$file\e[0m"
  $file/run.sh |& tee $file-run.log
done
