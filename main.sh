#! /usr/bin/env bash
# TODO explain why eval
# TODO explain
BASH_FILE="$(realpath "${BASH_SOURCE[0]}")"
# TODO explain
BASH_ROOT="$(dirname "${BASH_FILE}")"

# import bash modules
directory="${BASH_ROOT}/bash"
readarray -t modules <<< "$(ls -1 "${directory}")"
for module in "${modules[@]}"; do
    source "${directory}/${module}"
done
unset directory module modules

# actions

function bash_action_build {
esp_build "${ESP_ROOT}"
bash_action_display
}

function bash_action_display {
esp_display_usage "${ESP_ROOT}"
}

function bash_action_setup_bios {
esp_setup_bios "${ESP_ROOT}"
}

function bash_action_virtualize {
vm_virtualize "${ESP_ROOT}"
}

# parse

arg_parse "${@}"
