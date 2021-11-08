GRUBASH_BIOS_DIRECTORY='bios'

GRUBASH_BIOS_IMAGE="${GRUBASH_BIOS_DIRECTORY}/core.img"
GRUBASH_BIOS_SETUP="${GRUBASH_BIOS_DIRECTORY}/setup"

function grubash_wipe {
remove \
"${EFI_ROOT}" \
"${GRUBASH_BIOS_DIRECTORY}"
}

function grubash_make_image {
local esp_uuid="${1}"

remove "${GRUB_IMAGE_ROOT}"
make_directory "${GRUB_IMAGE_DIRECTORY}"

echo -n "\
search --set root --fs-uuid ${esp_uuid}
unset prefix
pager=1
normal
" >> "${GRUB_IMAGE_FILE}"

tar \
--create \
--auto-compress \
--file "${GRUB_IMAGE_ARCHIVE}" \
"${GRUB_IMAGE_ROOT}"

remove "${GRUB_IMAGE_ROOT}"
}

function grubash_clean {
remove \
"${GRUB_IMAGE_ARCHIVE}"
}
