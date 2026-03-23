#!/usr/bin/env bash
#
# This script makes sure that no two files exist under the workspace that may
# lead to a conflict on a case-insensitive file system (like on macOS).

TEMP_FILE="$(mktemp)"

make -j ls-files \
  | sed ':f; s|^\([^:]\+\)/\([^:/]\+\)|\1:\1/\2|g; t f' \
  | tr ':' '\n' | sort -u \
  | sort --ignore-case | uniq -i -D >> ${TEMP_FILE}

NB_DUPS=$(wc -l < ${TEMP_FILE})

if [[ ${NB_DUPS} -ne 0 ]]; then
  echo "==== ${NB_DUPS} conflicts on case-insensitive file systems ===="
  cat ${TEMP_FILE}
  rm ${TEMP_FILE}
  exit 1
fi

rm ${TEMP_FILE}
