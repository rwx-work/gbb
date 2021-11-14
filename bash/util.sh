UTIL_MIB_BYTES=1048576
UTIL_NULL_DEVICE='/dev/null'
UTIL_ZERO_DEVICE='/dev/zero'

# functions

function util_get_path_device {
local path="${1}"
local mount
local source
mount="$(util_stat_path_mount "${path}")"
source="$(util_find_mount_stat "${mount}" 'SOURCE')"
util_list_block_parent "${source}"
}

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

function util_dump_dummy {
local file="${1}"
local size="${2}"
dd \
if="${UTIL_ZERO_DEVICE}" \
of="${file}" \
bs=${UTIL_MIB_BYTES} \
count=${size} \
status='none'
}

function util_display_usage {
local root="${1}"
du \
--human-readable \
--summarize \
"${root}"/* \
"${root}"
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

function util_make_temporary_directory {
mktemp \
--directory
}

function util_make_temporary_file {
mktemp
}

function util_remove {
rm \
--force \
--preserve-root \
--recursive \
"${@}"
}

function util_stat_path_mount {
local path="${1}"
stat \
--format '%m' \
"${path}"
}

function util_touch_file {
local file="${1}"
touch \
"${file}"
}

# mount

function util_attach_loop {
local file="${1}"
local loop
loop="$(losetup --find)"
losetup \
--partscan \
"${loop}" \
"${file}"
echo "${loop}"
}

function util_detach_loop {
local loop="${1}"
losetup --detach "${loop}"
}

function util_mount {
local source="${1}"
local target="${2}"
mount \
"${source}" \
"${target}"
}

function util_unmount {
local source="${1}"
umount \
"${source}"
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

function util_make_fs {
local path="${1}"
local type="${2}"
mkfs \
--type "${type}" \
"${path}" \
&> "${UTIL_NULL_DEVICE}"
}
