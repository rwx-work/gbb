ESP_ROOT="${PWD}"

GRUBASH_BIOS_DIRECTORY='bios'

GRUBASH_BIOS_IMAGE="${GRUBASH_BIOS_DIRECTORY}/core.img"
GRUBASH_BIOS_SETUP="${GRUBASH_BIOS_DIRECTORY}/setup"

function esp_build {
bash_remove \
"${EFI_ROOT}" \
"${GRUBASH_BIOS_DIRECTORY}"

grub_make_memdisk "${UUID_ESP}"

# 2 efi

bash_make_directory "${EFI_DIRECTORY}"

grub_make_image \
'x86_64-efi' \
"${EFI_FILE}"

# 2b bios

bash_make_directory "${GRUBASH_BIOS_DIRECTORY}"

# TODO explain why local copy
cp \
"${GRUB_BIOS}/boot.img" \
"${GRUBASH_BIOS_DIRECTORY}"

# make image file
grub_make_image \
'i386-pc' \
"${GRUBASH_BIOS_IMAGE}"

# TODO explain why absoulte path
echo -n "\
${BASH_HEADER}
${GRUB_BIOS_SETUP} \\
--directory \"\${BASH_ROOT}\" \\
\"\${1}\"
" >> "${GRUBASH_BIOS_SETUP}"
# set file executable
chmod +x "${GRUBASH_BIOS_SETUP}"

bash_remove \
"${GRUB_IMAGE_ARCHIVE}"
}

function esp_display_usage {
# architectures
bash_display_usage \
"${GRUBASH_BIOS_DIRECTORY}" \
"${EFI_ROOT}"
# root
bash_display_usage
}
