GRUBASH_BIOS_DIRECTORY='bios'

GRUBASH_BIOS_IMAGE="${GRUBASH_BIOS_DIRECTORY}/core.img"
GRUBASH_BIOS_SETUP="${GRUBASH_BIOS_DIRECTORY}/setup"

function grubash_wipe {
remove \
"${EFI_ROOT}" \
"${GRUBASH_BIOS_DIRECTORY}"
}

function grubash_get_uuid {
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

function grubash_display_usage {
# architectures
display_usage \
"${GRUBASH_BIOS_DIRECTORY}" \
"${EFI_ROOT}"
# root
display_usage
}

function grubash_clean {
remove \
"${GRUB_IMAGE_ARCHIVE}"
}
