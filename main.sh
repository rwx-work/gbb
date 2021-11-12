#! /usr/bin/env bash

MODULES_DIRECTORY='bash'

# TODO explain
function import_modules {
local directory="${1}"
local file="$(realpath "${BASH_SOURCE}")"
local root="$(dirname "${file}")"
local modules
local module
local path
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
