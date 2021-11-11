BASH_ACTION="${1}"
BASH_FUNCTION='function'

BASH_ACTIONS="$(\
grep "${BASH_FUNCTION}" "${BASH_FILE}" \
| awk '{print $2}' \
)"

# TODO implement default action
function bash_parse {
local action
if ! eval "${BASH_ACTION}" 2> /dev/null; then
    for action in "${BASH_ACTIONS[@]}"; do
        echo "${action}"
    done
fi
}

function bash_display_usage {
du \
--human-readable \
--summarize \
"${@}"
}

function bash_get_directory_mountpoint {
stat \
--format '%m' \
"${1}"
}

function bash_get_mountpoint_uuid {
findmnt \
--noheadings \
--output 'UUID' \
"${1}"
}

function bash_make_directory {
mkdir \
--parents \
"${@}"
}

function bash_remove {
rm \
--force \
--recursive \
"${@}"
}
