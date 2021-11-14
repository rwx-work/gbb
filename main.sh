#! /usr/bin/env bash
MAIN_BASH_FILE="$(realpath "${BASH_SOURCE[0]}")"
MAIN_BASH_ROOT="$(dirname "${MAIN_BASH_FILE}")"

MAIN_BASH_DIRECTORY='bash'
export MAIN_GRUB_ROOT='grub'

# TODO explain
function main_import_modules {
local directory="${1}"
local modules
local module
local path
MODULES=("${MAIN_BASH_FILE}")
readarray -t modules <<< "$(ls -1 "${MAIN_BASH_ROOT}/${directory}")"
for module in "${modules[@]}"; do
    path="${MAIN_BASH_ROOT}/${directory}/${module}"
    MODULES+=("${path}")
    source "${path}"
done
}

function main {
main_import_modules "${MAIN_BASH_DIRECTORY}"
# parse arguments
arg_parse "${@}"
}

main "${@}"
