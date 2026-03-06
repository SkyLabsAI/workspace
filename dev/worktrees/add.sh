#!/bin/sh -xe

export topic=$1

[ -n "$WORKTREE_TOPIC_PREFIX" ] || WORKTREE_TOPIC_PREFIX=$USER
export WORKTREE_TOPIC_PREFIX

[ -v WORKTREE_ARGS ] || WORKTREE_ARGS="-t"
export WORKTREE_ARGS

make loop LOOP_COMMAND=dev/worktrees/helpers/repo-add.sh -j

# TODO use post_create to copy configs to worktree.
