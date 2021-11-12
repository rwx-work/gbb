ESP_EFI_ROOT='efi'
ESP_EFI_DIRECTORY="${ESP_EFI_ROOT}/boot"
ESP_EFI_FILE="${ESP_EFI_DIRECTORY}/bootx64.efi"

ESP_BIOS_ROOT='bios'
ESP_BIOS_IMAGE="${ESP_BIOS_ROOT}/core.img"
ESP_BIOS_SETUP="${ESP_BIOS_ROOT}/setup"

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
cp "${GRUB_BIOS_BOOT}" "${ESP_BIOS_ROOT}"
cp "${GRUB_BIOS_SETUP}" "${ESP_BIOS_SETUP}"

# make image file
grub_make_image \
'i386-pc' \
"${ESP_BIOS_IMAGE}"

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

# TODO explain why absoulte path
function esp_setup_bios {
local root="${1}"
# TODO mountpoint from directory
# TODO device from mountpoint
# TODO device if partition
"${root}/${ESP_BIOS_SETUP}" \
--directory "${root}/${ESP_BIOS_ROOT}" \
"${device}"
}
