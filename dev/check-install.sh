#!/usr/bin/env bash

set -u
# make -C "$WORKSPACE" ide-prepare
TOOLS=( rocq-ed cpp2v-toolchain pm cpp2v rocq )

REALPATH=$(which grealpath || echo realpath)

ERRORS=0
MARGIN=30

SPACES=""
for x in $(seq $MARGIN); do
    SPACES+="."
done
for tool in "${TOOLS[@]}"; do
    tag="[$tool] $SPACES"
    if ! TOOL_PATH=$(which "$tool") || ! [[ -x "$TOOL_PATH" ]] ; then
        tag="ERROR${tag}"
        echo "${tag:0:${MARGIN}} NOT INSTALLED"
        ERRORS=$((ERRORS + 1))
    elif [[ -n ${VERBOSE-} ]]; then
        tag="INSTALL${tag}"
        TOOL_PATH=$($REALPATH "$TOOL_PATH" --relative-to "$WORKSPACE")
        echo "${tag:0:${MARGIN}} in $TOOL_PATH"
    fi
done

[[ $ERRORS -eq 0 ]]
