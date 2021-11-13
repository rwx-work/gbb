function bash_check_shell {
shellcheck \
--shell 'bash' \
"${@}"
}

function bash_get_directory_device {
local mount
local source
mount="$(util_stat_path_mount "${1}")"
source="$(util_find_mount_stat "${mount}" 'SOURCE')"
lsblk \
--noheadings \
--output 'PKNAME' \
"${source}"
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
