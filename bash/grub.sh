GRUB_IMAGE_MODULES=(
'memdisk' 'tar'
'search'
'part_gpt' 'part_msdos'
'lvm' 'mdraid1x'
'btrfs' 'ext2' 'iso9660' 'udf'
'exfat' 'fat' 'hfs' 'hfspluscomp' 'ntfscomp'
'linux' 'loopback' 'squash4'
#
'at_keyboard' 'keylayouts' 'keystatus' 'read'
'halt' 'reboot'
'all_video' 'gfxterm_background' 'jpeg' 'png' 'tga'
#
'date' 'echo' 'eval' 'help' 'sleep' 'test' 'true'
'cpuid' 'lspci' 'videoinfo'
'cat' 'configfile' 'hashsum' 'loadenv' 'progress' 'testspeed'
'gcry_sha256' 'gcry_sha512'
)
GRUB_IMAGE_BIOS_MODULES=(
'biosdisk'
'ntldr'
)

# TODO explain why constant
GRUB_IMAGE_COMPRESSION='xz'

GRUB_ROOT='/usr/lib/grub'
GRUB_BIOS="${GRUB_ROOT}/i386-pc"
GRUB_BIOS_SETUP="${GRUB_BIOS}/grub-bios-setup"

GRUB_IMAGE_ROOT='boot'
GRUB_IMAGE_DIRECTORY="${GRUB_IMAGE_ROOT}/grub"
GRUB_IMAGE_FILE="${GRUB_IMAGE_DIRECTORY}/grub.cfg"

GRUB_IMAGE_ARCHIVE="${GRUB_IMAGE_ROOT}.tar"

function grub_make_memdisk {
local esp_uuid="${1}"

remove "${GRUB_IMAGE_ROOT}"
make_directory "${GRUB_IMAGE_DIRECTORY}"

echo -n "\
export ESP_UUID=${esp_uuid}
search --set root --fs-uuid \${ESP_UUID}
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
local modules=("${GRUB_IMAGE_MODULES[@]}")
if [ "${architecture}" == 'i386-pc' ]; then
    modules=("${modules[@]}" "${GRUB_IMAGE_BIOS_MODULES[@]}")
fi
grub-mkimage \
--compress "${GRUB_IMAGE_COMPRESSION}" \
--memdisk "${GRUB_IMAGE_ARCHIVE}" \
--format "${architecture}" \
--output "${file}" \
"${modules[@]}"
}
