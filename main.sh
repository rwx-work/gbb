#! /usr/bin/env bash

MODULES_DIRECTORY='bash'

# TODO explain
function import_modules {
local directory="${1}"
local file
local root
local modules
local module
local path
file="$(realpath "${BASH_SOURCE[0]}")"
root="$(dirname "${file}")"
MODULES=("${file}")
readarray -t modules <<< "$(ls -1 "${root}/${directory}")"
for module in "${modules[@]}"; do
    path="${root}/${directory}/${module}"
    MODULES+=("${path}")
    source "${path}"
done
}

function main {
import_modules "${MODULES_DIRECTORY}"
# parse arguments
arg_parse "${@}"
}

main "${@}"
