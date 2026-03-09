#!/usr/bin/env bash

if [[ "$#" -lt 1 ]]; then
  echo "Usage: $0 NAME"
  exit 1
fi

export TARGET_BRANCH="release/$1"

make status -j
