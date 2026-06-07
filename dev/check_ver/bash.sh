#!/usr/bin/env bash
#
# Copyright (c) 2026 SkyLabs AI, Inc.
#

PROG="bash"
URL="https://www.gnu.org/software/bash/"
MIN="5.2"

print_ver() {
  VER="$(bash --version | grep "bash" | sed -r 's/^.* version ([0-9.]+).*$/\1/')"
  if ! [[ "${VER}" =~ ([^\.]*)\.([^\.]*) ]]; then
    >&2 echo "Error: could not parse the output of 'bash --version'."
    >&2 bash --version
    exit 1
  fi
  echo "${VER}"
}

source "dev/check_ver/driver.inc.sh"
