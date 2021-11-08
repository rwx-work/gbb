# TODO explain why constant
GRUB_IMAGE_COMPRESSION='xz'
GRUB_DIRECTORY='/usr/lib/grub'
GRUB_IMAGE_ROOT='boot'

GRUB_BIOS="${GRUB_DIRECTORY}/i386-pc"
GRUB_IMAGE_DIRECTORY="${GRUB_IMAGE_ROOT}/grub"
GRUB_IMAGE_ARCHIVE="${GRUB_IMAGE_ROOT}.tar"

GRUB_BIOS_SETUP="${GRUB_BIOS}/grub-bios-setup"
GRUB_IMAGE_FILE="${GRUB_IMAGE_DIRECTORY}/grub.cfg"

function grub_make_memdisk {
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

function grub_make_image {
local architecture="${1}"
local file="${2}"
shift 2
local modules=("${MODULES[@]}")
if [ "${architecture}" == 'i386-pc' ]; then
    modules=("${modules[@]}" "${MODULES_BIOS[@]}")
fi
grub-mkimage \
--compress "${GRUB_IMAGE_COMPRESSION}" \
--memdisk "${GRUB_IMAGE_ARCHIVE}" \
--format "${architecture}" \
--output "${file}" \
"${modules[@]}"

}
