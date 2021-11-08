GRUBASH_BIOS_DIRECTORY='bios'

GRUBASH_BIOS_IMAGE="${GRUBASH_BIOS_DIRECTORY}/core.img"
GRUBASH_BIOS_SETUP="${GRUBASH_BIOS_DIRECTORY}/setup"

function grubash_wipe {
remove \
"${EFI_ROOT}" \
"${GRUBASH_BIOS_DIRECTORY}" \
"${GRUB_IMAGE_ROOT}"
}

function grubash_clean {
remove \
"${GRUB_IMAGE_ARCHIVE}" \
"${GRUB_IMAGE_ROOT}"
}
