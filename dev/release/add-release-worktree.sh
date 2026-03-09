#!/usr/bin/env bash

if [[ "$#" -lt 1 ]]; then
  echo "Usage: $0 NAME"
  exit 1
fi

export WORKTREE_TOPIC_PREFIX="release"

./dev/worktrees/check-remote.sh "$1" && ./dev/worktrees/add.sh "$1"
