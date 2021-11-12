#! /usr/bin/env bash

# TODO explain
BASH_FILE="$(realpath "${BASH_SOURCE}")"
# TODO explain
BASH_ROOT="$(dirname "${BASH_FILE}")"

# import bash modules
directory="${BASH_ROOT}/bash"
readarray -t modules <<< "$(ls -1 "${directory}")"
for module in "${modules[@]}"; do
    source "${directory}/${module}"
done
unset directory module modules

# parse arguments

arg_parse "${@}"
