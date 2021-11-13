function bash_check_shell {
shellcheck \
--shell 'bash' \
"${@}"
}

function bash_get_directory_mountpoint {
stat \
--format '%m' \
"${1}"
}

function bash_get_directory_device {
local mountpoint
local source
mountpoint="$(bash_get_directory_mountpoint "${1}")"
source="$(bash_get_mountpoint_output "${mountpoint}" 'SOURCE')"
lsblk \
--noheadings \
--output 'PKNAME' \
"${source}"
}

function bash_get_directory_uuid {
local mountpoint
mountpoint="$(bash_get_directory_mountpoint "${1}")"
bash_get_mountpoint_output "${mountpoint}" 'UUID'
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

function bash_remove {
rm \
--force \
--recursive \
"${@}"
}

function bash_write {
local file="${1}"
local content="${2}"
    log_file_write "${file}" "${content}"
    echo -n "${content}" > "${file}"
}
