#!/bin/bash

set -e
set -x
# Clear the database if it exists.
dropdb --if-exists pgbench
createdb pgbench

# Run pgbench
pgbench -i -s 70 -h localhost pgbench
pgbench -s 70 -t 30000 -h localhost pgbench
