ESP_EFI_ROOT='efi'
ESP_EFI_DIRECTORY="${ESP_EFI_ROOT}/boot"
ESP_EFI_FILE="${ESP_EFI_DIRECTORY}/bootx64.efi"

ESP_BIOS_ROOT='bios'
ESP_BIOS_IMAGE="${ESP_BIOS_ROOT}/core.img"

GRUBASH_BIOS_SETUP="${ESP_BIOS_ROOT}/setup"

function esp_build {
local root="${1}"
cd "${root}"

bash_remove \
"${ESP_EFI_ROOT}" \
"${ESP_BIOS_ROOT}"

grub_make_memdisk "${UUID_ESP}"

# 2 efi

bash_make_directory "${ESP_EFI_DIRECTORY}"

grub_make_image \
'x86_64-efi' \
"${ESP_EFI_FILE}"

# 2b bios

bash_make_directory "${ESP_BIOS_ROOT}"

# TODO explain why local copy
cp \
"${GRUB_BIOS_BOOT}" \
"${ESP_BIOS_ROOT}"

# make image file
grub_make_image \
'i386-pc' \
"${ESP_BIOS_IMAGE}"

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
local root="${1}"
# architectures
bash_display_usage \
"${ESP_BIOS_ROOT}" \
"${ESP_EFI_ROOT}"
# root
bash_display_usage
}
