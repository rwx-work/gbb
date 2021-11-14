ESP_EFI_ROOT='efi'
ESP_EFI_DIRECTORY="${ESP_EFI_ROOT}/boot"
ESP_EFI_FILE="${ESP_EFI_DIRECTORY}/bootx64.efi"

ESP_BIOS_ROOT='bios'
ESP_BIOS_IMAGE="${ESP_BIOS_ROOT}/core.img"
ESP_BIOS_SETUP="${ESP_BIOS_ROOT}/setup"

function esp_build {
local root="${1}"
local memdisk
local esp_uuid

memdisk="$(util_make_temporary_file)"
esp_uuid="$(util_get_path_uuid "${root}")"
grub_make_memdisk "${memdisk}" "${esp_uuid}"

util_make_directory "${root}/${ESP_EFI_DIRECTORY}"
grub_make_image 'x86_64-efi' "${memdisk}" "${root}/${ESP_EFI_FILE}"

util_make_directory "${root}/${ESP_BIOS_ROOT}"
# TODO explain why local copy
util_copy "${GRUB_BIOS_BOOT}" "${root}/${ESP_BIOS_ROOT}"
grub_make_image 'i386-pc' "${memdisk}" "${root}/${ESP_BIOS_IMAGE}"
util_copy "${GRUB_BIOS_SETUP}" "${root}/${ESP_BIOS_SETUP}"

# TODO grub directory
# TODO grub env file
}

# TODO explain why absoulte path
function esp_setup_bios {
local root="${1}"
local device
device="$(util_get_path_device "${root}")"
"${root}/${ESP_BIOS_SETUP}" \
--directory "${root}/${ESP_BIOS_ROOT}" \
"${device}"
}
