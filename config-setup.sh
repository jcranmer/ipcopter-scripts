#!/bin/bash

ROOT=$(readlink -f $(dirname $0))

################################################################################
# Regardless, disable ipcd for now.
# We want to start it fresh if we're using it,
# and it's probably best it's not active during setup
sudo $ROOT/uninstall-ipcd.sh

################################################################################
# Stop any/all currently running services
# that might be active.

# Benchmark-related services
SERVICES="apache2 mailman postgresql netperf memcached"
# Misc system services that can only introduce noise
SERVICES="$SERVICES lightdm bluetooth cups cups-browsed postfix saned"

for S in $SERVICES; do
  sudo service $S stop || true
done

################################################################################
# Ensure CPU scaling/etc is in order

# Disable ondemand frequency scaling
sudo service ondemand stop || true
# for good measure, disable it from starting entirely
sudo update-rc.d ondemand disable || true

# Disable turbo-boost
echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost

# Little script ("what could possibly go wrong") to offline HT cores,
# which AFAIK is effectively equivalent to disabling HT in BIOS
# Be careful to not skip the space at the beginning nor the end
CPUS_TO_SKIP=" $(cat /sys/devices/system/cpu/cpu*/topology/thread_siblings_list | sed 's/[^0-9].*//' | sort | uniq | tr "\r\n" "  ") "
for CPU_PATH in /sys/devices/system/cpu/cpu[0-9]*; do
    CPU="$(echo $CPU_PATH | tr -cd "0-9")"
    echo "$CPUS_TO_SKIP" | grep " $CPU " > /dev/null
    if [ $? -ne 0 ]; then
        echo "Taking CPU $CPU offline...\n"
        echo 0 | sudo tee $CPU_PATH/online
    fi
done

################################################################################
# Setup ipcd situation as specified by $CONFIG
case $CONFIG in
ipcd)
  sudo $ROOT/install-ipcd.sh
  ;;
baseline)
  # (Nothing to do here, already disabled at top of script.)
  ;;
*)
  echo "Unrecognized configuration: CONFIG='$CONFIG'"
  exit 1
  ;;
esac

