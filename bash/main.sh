#! /usr/bin/env bash

export MAIN_GRUB_ROOT='grub'

# TODO explain
function main_import_modules {
local bash_file
local bash_root
local bash_module
local binaries
local binary
local command
local libraries
local library
local paths
bash_file="$(realpath "${BASH_SOURCE[0]}")"
bash_root="$(dirname "${bash_file}")"
PROJECT_ROOT="$(dirname "${bash_root}")"
MODULES=()
for bash_module in "${bash_root}"/*; do
    if [ "${bash_module}" != "${bash_file}" ]; then
        MODULES+=("${bash_module}")
        source "${bash_module}"
    fi
done
local -A binaries=()
for binary in "${RUN_BINARIES[@]}" "${DEV_BINARIES[@]}"; do
    command="$(command -v "${binary}")"
    ((binaries["${command}"]++))
done
local -A libraries=()
for binary in "${!binaries[@]}"; do
    readarray -t paths \
    <<< "$(ldd "${binary}" | awk '{print $3}' | grep -v '^$')"
    for library in "${paths[@]}"; do
        ((libraries["${library}"]++))
    done
done
}

function main {
main_import_modules
# parse arguments
arg_parse "${@}"
}

main "${@}"
