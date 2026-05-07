#!/bin/bash

# Outputs the list of all CI python tasks that are available under the current
# working directory. CI python tasks are taskipy task declared in the project
# configuration file (pyproject.toml), whose name ends in "_ci". Tasks whose
# name end in "_ocaml_ci" are additionally identified as requiring the full
# set of FM dependencies to be built.
#
# In the output, each CI python task gets a line
#   <PROJECT_DIR>,<TASK_NAME>,<TASK_KIND>,<PROJECT_NAME>,<SHORT_TASK_NAME>
# where:
# - <PROJECT_DIR> is the directory of the project defining that task,
# - <TASK_NAME> is the full task name (ending in "_ci"),
# - <TASK_KIND> is either "quick" or "ocaml",
# - <PROJECT_NAME> is the python project name, as defined in the toml file,
# - <SHORT_TASK_NAME> is <TASK_NAME> without its "_ci" / "_ocaml_ci" suffix.
#
# The output can be computed with multiple processes, and the number of jobs
# is controlled via the NBJOBS environment variable.

project_tasks(){
  PROJECT_CONFIG="$1"
  PROJECT_DIR="$(dirname "${PROJECT_CONFIG}")"
  PROJECT_NAME=$(uvx --quiet --from toml-cli toml get --toml-path "${PROJECT_CONFIG}" project.name)

  for TASK in $( (uvx --quiet --directory ${PROJECT_DIR} --from taskipy task --list || echo -n) | grep -Eo '^[^ ]+_ci\b' ); do
    KIND="$( (echo "${TASK}" | grep -Eq '_ocaml_ci$') && echo -n "ocaml" || echo -n "quick" )"
    SHORT=$(echo "${TASK}" | sed -re 's/(_ocaml)?_ci$//')
    echo "${PROJECT_DIR},${TASK},${KIND},${PROJECT_NAME},${SHORT}"
  done
}
export -f project_tasks

find -type f -name 'pyproject.toml' \
  | xargs -P "${NBJOBS:-1}" -I {} bash -c 'project_tasks "$@"' _ {} \
  | LC_ALL=C sort
