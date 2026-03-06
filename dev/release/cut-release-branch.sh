#!/usr/bin/env bash

if [[ "$#" -lt 1 ]]; then
  echo "Usage: $0 NAME"
  exit 1
fi

export WORKTREE_TOPIC_PREFIX="release"
export WORKTREE_ARGS=""

./dev/worktrees/add.sh "$1"
