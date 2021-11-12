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

BASH_ACTION_PREFIX='bash_action_'
# TODO manipulate strings without awk
BASH_ACTIONS="$(\
grep "function ${BASH_ACTION_PREFIX}" "${BASH_FILE}" \
| awk "{gsub(\"^${BASH_ACTION_PREFIX}\",\"\",\$2);print \$2}" \
)"

function bash_parse_arguments {
local positional_arguments=()
local action
ESP_ROOT="${PWD}"
while [ $# -gt 0 ]; do
    case "${1}" in
        '--debug') shift
            DEBUG=0 ;;
        '--esp-root') shift
            [ "${1}" ] && { ESP_ROOT="${1}" ; shift ; } ;;
        '--esp-uuid') shift
            [ "${1}" ] && { ESP_UUID="${1}" ; shift ; } ;;
        '-v'|'--verbose') shift
            VERBOSE=0 ;;
        *) positional_arguments+=("${1}") ; shift ;;
    esac
done
# post processing
ESP_ROOT="$(realpath "${ESP_ROOT}")"
if [ ! "${ESP_UUID}" ]; then
    ESP_UUID="$(bash_get_directory_uuid "${ESP_ROOT}")"
fi
# positional arguments
action="${@}"
if [ "${action}" ]; then
    eval "${BASH_ACTION_PREFIX}${action}"
else
    for action in "${BASH_ACTIONS[@]}"; do
        echo "${action}"
    done
fi
}

bash_parse_arguments "${@}"
