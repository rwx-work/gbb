ARG_ACTION_PREFIX='arg_action_'

# actions

function arg_action_build {
esp_build "${ESP_ROOT}"
arg_action_display
}

function arg_action_display {
esp_display_usage "${ESP_ROOT}"
}

function arg_action_setup_bios {
esp_setup_bios "${ESP_ROOT}"
}

function arg_action_virtualize {
vm_virtualize "${ESP_ROOT}"
}

# parsing

function arg_parse {
local positional_arguments=()
local action
local actions
# pre process
ESP_ROOT="${PWD}"
LOG_LEVEL=${LOG_LEVEL_WARNING}
# process
while [ $# -gt 0 ]; do
    case "${1}" in
        '--debug') shift
            LOG_LEVEL=${LOG_LEVEL_DEBUG} ;;
        '--esp-root') shift
            [ "${1}" ] && { ESP_ROOT="${1}" ; shift ; } ;;
        '--esp-uuid') shift
            [ "${1}" ] && { ESP_UUID="${1}" ; shift ; } ;;
        '-v'|'--verbose') shift
            LOG_LEVEL=${LOG_LEVEL_INFO} ;;
        *) positional_arguments+=("${1}") ; shift ;;
    esac
done
# post process
ESP_ROOT="$(realpath "${ESP_ROOT}")"
if [ ! "${ESP_UUID}" ]; then
    ESP_UUID="$(bash_get_directory_uuid "${ESP_ROOT}")"
fi
# positional arguments
action="${positional_arguments}"
if [ "${action}" ]; then
    eval "${ARG_ACTION_PREFIX}${action}"
else
    # TODO manipulate strings without awk
    actions="$(\
grep "function ${ARG_ACTION_PREFIX}" "${BASH_SOURCE}" \
| awk "{gsub(\"^${ARG_ACTION_PREFIX}\",\"\",\$2);print \$2}" \
)"
    for action in "${actions[@]}"; do
        echo "${action}"
    done
fi
}
