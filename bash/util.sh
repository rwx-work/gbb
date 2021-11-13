function util_get_path_uuid {
local path="${1}"
local mount
mount="$(util_stat_path_mount "${path}")"
util_find_mount_stat "${mount}" 'UUID'
}

# coreutils

function util_copy {
cp \
--recursive \
"${@}"
}

function util_display_usage {
du \
--human-readable \
--summarize \
"${@}"
}

function util_list {
ls \
--all \
--color \
-l \
-p \
"${@}"
}

function util_make_directory {
mkdir \
--parents \
"${@}"
}

function util_remove {
rm \
--force \
--recursive \
"${@}"
}

function util_stat_path_mount {
local path="${1}"
stat \
--format '%m' \
"${path}"
}

# util-linux

function util_find_mount_stat {
local mount="${1}"
local stat="${2}"
findmnt \
--noheadings \
--output "${stat}" \
"${mount}"
}

function util_list_block_parent {
local block="${1}"
lsblk \
--noheadings \
--output 'PKNAME' \
"${block}"
}
