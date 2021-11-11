#! /usr/bin/env bash
BASH_SHEBANG='#! /usr/bin/env bash'
# TODO explain why eval
# TODO explain
BASH_FILE='BASH_FILE="$(realpath "${BASH_SOURCE[0]}")"'
# TODO explain
BASH_ROOT='BASH_ROOT="$(dirname "${BASH_FILE}")"'
BASH_HEADER="\
${BASH_SHEBANG}
${BASH_FILE}
${BASH_ROOT}
"
eval "${BASH_FILE}"
eval "${BASH_ROOT}"

# import bash modules
directory="${BASH_ROOT}/bash"
readarray -t modules <<< "$(ls -1 "${directory}")"
for module in "${modules[@]}"; do
    source "${directory}/${module}"
done
unset directory module modules

BASH_ACTION="${1}"
BASH_ACTION_PREFIX='bash_action_'
BASH_ACTIONS="$(\
grep "function ${BASH_ACTION_PREFIX}" "${BASH_FILE}" \
| awk "{gsub(\"^${BASH_ACTION_PREFIX}\",\"\",\$2);print \$2}" \
)"


function bash_action_build {
esp_build "${ESP_ROOT}"
bash_action_display
}

function bash_action_display {
esp_display_usage "${ESP_ROOT}"
}

# TODO parse argument
ESP_ROOT="${PWD}"
# TODO implement default action
function bash_parse_arguments {
local action
if ! eval "bash_action_${BASH_ACTION}" 2> /dev/null; then
    for action in "${BASH_ACTIONS[@]}"; do
        echo "${action}"
    done
fi
}

mp="$(bash_get_directory_mountpoint "${ESP_ROOT}")"
bash_get_mountpoint_uuid "${mp}"

bash_parse_arguments
