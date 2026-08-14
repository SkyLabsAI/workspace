#!/usr/bin/env bash

INDENT="no"
QUIET="no"
SKIP_FIRST_LINE="no"
CMD=""
PROG=""

usage () {
    cat <<EOF
usage:
  $0 run [--indent] [--quiet] [--skip-first-line] [--heading=HEADING] --
         PROGRAM [ARGS ..]
  $0 eval [--indent] [--quiet] [--skip-first-line] [--heading=HEADING] --
         SHELL_COMMAND

Call SHELL_COMMAND ARGS and add some formatting elements such as
spacing, indentation and heading to the output of said command.

  --indent
    Prefix each line of output of SHELL_COMMAND with two spaces.

  --quiet
    Prefix each line of output of SHELL_COMMAND with two spaces.

  --skip-first-line
    Start output with blank line.

  --heading=HEADING
    Output HEADING on its own line before calling SHELL_COMMAND. HEADING
    is not affected by --indent.

  PROGRAM [ARGS ..]
    A program and its arguments; it will be run by $0. If the
    command is prefixed by '@', it is the equivalent to flag --quiet.

  SHELL_COMMAND
    A single argument comprising a complete shell command to be run
    verbatim.
EOF
}

yes_no () {
    if [[ $1 =~ --no-.* ]]; then
        echo "no"
    else
        echo "yes"
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --indent|--no-indent)
            INDENT="$(yes_no $1)" ;;
        --quiet|--no-quiet)
            QUIET="$(yes_no $1)" ;;
        --skip-first-line|--no-skip-first-line)
            SKIP_FIRST_LINE="$(yes_no $1)" ;;
        --heading=*)
            [[ $1 =~ --heading=(.*) ]]
            HEADING="${BASH_REMATCH[1]}" ;;
        run|eval)
            CMD="$1" ;;
        --)
            shift
            PROG="$1"
            if [[ $PROG =~ @.* ]]; then
                PROG="${PROG/#@/}"
                QUIET=yes
            fi
            shift
            break ;;
        *)
            echo "Invalid argument $HD"
            usage
            exit -1
    esac
    shift
done

do_run () {
    local cmd="$1" ; shift ;
    if [[ $QUIET == "no" ]]; then
        echo "$cmd ${*@Q}" # only works on Bash 4.4
    fi
    if [[ "$INDENT" == "no" ]]; then
        "$cmd" "$@"
    else
        "$cmd" "$@" | gsed "s/^/  /"; test ${PIPESTATUS[0]} -eq 0
    fi
}

do_eval () {
    if [[ $QUIET == "no" ]]; then
        echo "${*@Q}" # only works on Bash 4.4
    fi
    if [[ "$INDENT" == "no" ]]; then
        eval "$@"
    else
        eval "$@" | gsed "s/^/  /"; test ${PIPESTATUS[0]} -eq 0
    fi
}

if [[ "$CMD" =~ run|eval ]]; then
    if [[ "$SKIP_FIRST_LINE" == yes ]]; then
        echo
    fi
    if [[ -n "$HEADING" ]]; then
        echo "$HEADING"
    fi
    if [[ "$CMD" == run ]]; then
        do_run "$PROG" "$@"
    else
        do_eval "$PROG" "$@"
    fi
else
    echo "Invalid command: $CMD"
    exit -1
fi
