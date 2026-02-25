#!/usr/bin/env bash
#
# Copyright (c) 2026 SkyLabs AI, Inc.
#

PROG="make"
URL="https://www.gnu.org/software/make/"
MIN="4"

print_ver() {
  make --version | grep "GNU Make" | cut -d' ' -f3
}

source "dev/check_ver/driver.inc.sh"

