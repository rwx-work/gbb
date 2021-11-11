ESP_ROOT="${PWD}"

GRUBASH_BIOS_DIRECTORY='bios'

GRUBASH_BIOS_IMAGE="${GRUBASH_BIOS_DIRECTORY}/core.img"
GRUBASH_BIOS_SETUP="${GRUBASH_BIOS_DIRECTORY}/setup"

function grubash_wipe {
bash_remove \
"${EFI_ROOT}" \
"${GRUBASH_BIOS_DIRECTORY}"
}

function esp_display_usage {
# architectures
bash_display_usage \
"${GRUBASH_BIOS_DIRECTORY}" \
"${EFI_ROOT}"
# root
bash_display_usage
}

function grubash_clean {
bash_remove \
"${GRUB_IMAGE_ARCHIVE}"
}
