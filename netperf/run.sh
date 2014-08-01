#!/bin/bash

set -e
netperf -t TCP_STREAM -l 90
