#!/bin/bash
#
# This script is meant to be used as a LOOP_COMMAND.
#

set -euf -o pipefail

if [[ $# -ne 5 ]]; then
  echo "Error: five command line arguments expected."
  exit 1
fi

REPO_PATH="$1"
REPO_URL="$2"
REPO_DEFAULT="$3"
REPO_DIR="$4"
REPO_MODE="$5"

# Fetch only if requested.
if [[ "${FETCH:-false}" = "true" ]]; then
  git -C ${REPO_DIR} fetch --quiet origin
fi

CUR_BRANCH="$(git -C ${REPO_DIR} branch --show-current)"
CLEAN="true"

if [[ "${CUR_BRANCH}" = "" ]]; then
  STATUS="no_branch"
  CLEAN="false"
elif [[ "${CUR_BRANCH}" = ${REPO_DEFAULT} ]]; then
  STATUS="\e[0;32m${CUR_BRANCH}\e[0m"
  BEHIND=$(git -C ${REPO_DIR} rev-list --count HEAD..origin/${REPO_DEFAULT})
  AHEAD=$(git -C ${REPO_DIR} rev-list --count origin/${REPO_DEFAULT}..HEAD)
  if [[ "${BEHIND}" -gt 0 ]]; then
    STATUS="${STATUS}, \e[0;33mbehind(${BEHIND})\e[0m"
    CLEAN="false"
  fi
  if [[ "${AHEAD}" -gt 0 ]]; then
    STATUS="${STATUS}, \e[0;33mahead(${AHEAD})\e[0m"
    CLEAN="false"
  fi
  if ! git -C ${REPO_DIR} diff HEAD --quiet; then
    STATUS="${STATUS}, \e[0;33mdirty\e[0m"
    CLEAN="false"
  fi
  if git -C ${REPO_DIR} status --porcelain | grep -q "^??"; then
    STATUS="${STATUS}, \e[0;33muntracked_files\e[0m"
    CLEAN="false"
  fi
else
  CLEAN="false"
  STATUS="\e[0;33m${CUR_BRANCH}\e[0m"
  BEHIND=$(git -C ${REPO_DIR} rev-list --count HEAD..origin/${REPO_DEFAULT})
  if [[ "${BEHIND}" -gt 0 ]]; then
    STATUS="${STATUS}, \e[0;31mneeds_rebase(${BEHIND})\e[0m"
  fi
  if ! git -C ${REPO_DIR} config "branch.${CUR_BRANCH}.remote" > /dev/null; then
    STATUS="${STATUS}, no_remote"
  else
    BEHIND=$(git -C ${REPO_DIR} rev-list --count HEAD..origin/${CUR_BRANCH})
    AHEAD=$(git -C ${REPO_DIR} rev-list --count origin/${CUR_BRANCH}..HEAD)
    if [[ "${BEHIND}" -gt 0 ]]; then
      STATUS="${STATUS}, \e[0;33mbehind(${BEHIND})\e[0m"
    fi
    if [[ "${AHEAD}" -gt 0 ]]; then
      STATUS="${STATUS}, \e[0;33mahead(${AHEAD})\e[0m"
    fi
    if ! git -C ${REPO_DIR} diff HEAD --quiet; then
      STATUS="${STATUS}, \e[0;33mdirty\e[0m"
    fi
    if git -C ${REPO_DIR} status --porcelain | grep -q "^??"; then
      STATUS="${STATUS}, \e[0;33muntracked_files\e[0m"
    fi
  fi
fi

if [[ "${CLEAN}" = "false" ]]; then
  echo -e "${REPO_DIR}: ${STATUS}"
fi
