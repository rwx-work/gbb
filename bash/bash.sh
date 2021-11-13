function bash_check_shell {
shellcheck \
--shell 'bash' \
"${@}"
}

function bash_get_directory_device {
local mount
local source
mount="$(util_stat_path_mount "${1}")"
source="$(bash_get_mountpoint_output "${mount}" 'SOURCE')"
lsblk \
--noheadings \
--output 'PKNAME' \
"${source}"
}

function bash_get_directory_uuid {
local mount
mount="$(util_stat_path_mount "${1}")"
bash_get_mountpoint_output "${mount}" 'UUID'
}

function bash_get_mountpoint_output {
findmnt \
--noheadings \
--output "${2}" \
"${1}"
}

function bash_parted {
parted \
--script \
"${@}"
}

function bash_write {
local file="${1}"
local content="${2}"
    log_file_write "${file}" "${content}"
    echo -n "${content}" > "${file}"
}
