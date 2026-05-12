#!/bin/bash

# Script used to run python tasks collected by script "list_python_tasks.sh".
# It expects two arguments: a task list produced by that other script, and the
# kind of tests to run.

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 TASK_FILE TEST_KIND"
  echo "Possible values for TEST_KIND: quick, ocaml"
  exit 1
fi

TASK_FILE="$1"
TEST_KIND="$2"

if [[ ! -f "${TASK_FILE}" ]]; then
  echo "File \"${TASK_FILE}\" does not exist."
  exit 1
fi

if [[ "${TEST_KIND}" != "quick" && "${TEST_KIND}" != "ocaml" ]]; then
  echo "Unknown task kind \"${TEST_KIND}\" (valid options are: quick, ocaml)"
  exit 1
fi

TASK_COUNT=0
SELECTED_TASK_COUNT=0
FAILURE_COUNT=0

while IFS="," read -r TASK_DIR TASK_NAME TASK_KIND PROJECT_NAME SHORT_TASK_NAME; do
  ((TASK_COUNT++))

  if [[ "${TASK_KIND}" != "${TEST_KIND}" ]]; then
    continue
  fi

  ((SELECTED_TASK_COUNT++))

  echo
  echo "============== ${PROJECT_NAME}: ${SHORT_TASK_NAME} =============="
  echo

  PREVIOUS_FAILURE_COUNT=${FAILURE_COUNT}
  echo "Running: uv --quiet --directory \"${TASK_DIR}\" run task ${TASK_NAME}"
  uv --quiet --directory "${TASK_DIR}" run task ${TASK_NAME} || ((FAILURE_COUNT++))

  if [[ "${PREVIOUS_FAILURE_COUNT}" -ne "${FAILURE_COUNT}" ]]; then
    echo "::error ::The task run with command \`uv --quiet --directory \"${TASK_DIR}\" run task ${TASK_NAME}\` failed."
  fi

  echo
done < "${TASK_FILE}"

((SUCCESS_COUNT=${SELECTED_TASK_COUNT}-${FAILURE_COUNT}))

echo
echo "============== SUMMARY =============="
echo
echo "Attempted ${SELECTED_TASK_COUNT} selected tasks over ${TASK_COUNT}."
echo "${SUCCESS_COUNT} / ${SELECTED_TASK_COUNT} succeeded."

if (( ${FAILURE_COUNT} )); then
  echo
  echo "Number of failed tasks: ${FAILURE_COUNT} / ${SELECTED_TASK_COUNT}"
  exit 1
fi
