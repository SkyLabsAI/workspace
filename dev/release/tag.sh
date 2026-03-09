#!/usr/bin/env bash

if [[ "$#" -lt 1 ]]; then
  echo "Usage: $0 NAME [RC_NUMBER]"
  exit 1
fi

RELEASE_NAME="$1"
RELEASE_SUFFIX=""

if [[ "$#" -eq 2 ]]; then
  if [[ ! "$2" =~ ^[0-9]+$ ]]; then
    echo "The release candidate number should be a number ($2 given)."
    exit 1
  fi

  RELEASE_SUFFIX="-rc$2"
fi

export TARGET_BRANCH="release/${RELEASE_NAME}"

if make status-no-fetch -j 2>&1 | grep -q '.*'; then
  echo "Status of the release branch is not clean."
  exit 1
fi

make -j tag TAG_ARGS="release-${RELEASE_NAME}${RELEASE_SUFFIX}"
