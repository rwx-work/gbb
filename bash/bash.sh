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
local directory="${1}"
stat \
--format '%m' \
"${directory}"
}

function bash_get_directory_uuid {
local directory="${1}"
local mount_point
# get mount point from directory
mount_point="$(stat --format '%m' "${directory}")"
# get uuid from mount point
findmnt \
--noheadings \
--output 'UUID' \
"${mount_point}"
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
