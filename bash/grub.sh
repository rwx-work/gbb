RUN_BINARIES+=('grub-mkimage' 'tar')

GRUB_IMAGE_MODULES=(
'regexp'
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
'all_video' 'videoinfo' 'gfxterm_background' 'jpeg' 'png' 'tga'
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
export GRUB_BIOS_BOOT="${GRUB_BIOS}/boot.img"
export GRUB_BIOS_SETUP="${GRUB_BIOS}/grub-bios-setup"
export GRUB_FONT='/usr/share/grub/unicode.pf2'

GRUB_ENV_HEADER='# GRUB Environment Block
'
GRUB_ENV_SIZE=1024

GRUB_IMAGE_ROOT='boot'
GRUB_IMAGE_DIRECTORY="${GRUB_IMAGE_ROOT}/grub"
GRUB_IMAGE_FILE="${GRUB_IMAGE_DIRECTORY}/grub.cfg"

function grub_make_memdisk {
local file="${1}"
local esp_uuid="${2}"
local grub_root="${3}"
local grub_env="${4}"
local root
root="$(util_make_temporary_directory)"

util_make_directory "${root}/${GRUB_IMAGE_DIRECTORY}"

bash_write_file "${root}/${GRUB_IMAGE_FILE}" "\
esp_uuid='${esp_uuid}'
env_path='${grub_env}'

search \\
--fs-uuid \"\${esp_uuid}\" \\
--set 'root'
prefix='${grub_root}'
pager=1
normal
"

log_file_write "${file}"
tar \
--create \
--file "${file}" \
--directory "${root}" \
"${GRUB_IMAGE_ROOT}"
}

function grub_make_image {
local architecture="${1}"
local memdisk="${2}"
local file="${3}"
shift 3
local modules
modules=("${GRUB_IMAGE_MODULES[@]}")
if [ "${architecture}" == 'i386-pc' ]; then
    modules+=("${GRUB_IMAGE_BIOS_MODULES[@]}")
fi
log_file_write "${file}"
grub-mkimage \
--compress "${GRUB_IMAGE_COMPRESSION}" \
--memdisk "${memdisk}" \
--format "${architecture}" \
--output "${file}" \
"${modules[@]}"
}

function grub_make_env {
local file="${1}"
local length
local padding
length=$((GRUB_ENV_SIZE-${#GRUB_ENV_HEADER}))
padding="$(printf "%${length}s" | tr ' ' '#')"
bash_write_file "${file}" "${GRUB_ENV_HEADER}${padding}"
}
