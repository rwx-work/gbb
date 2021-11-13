VM_ESP=16
VM_SIZE=128

# TODO check user, dd, parted, qemu-nbd
function vm_virtualize {
local root="${1}"
local file
local dev
local directory
local device

cd "${root}"
file="$(util_make_temporary_file)"

# TODO make bash function
dd \
if='/dev/zero' \
of="${file}" \
bs=1048576 \
count=${VM_SIZE} \
status=none

bash_parted "${file}" \
'mktable' 'gpt' \
'unit' 'mb' \
'mkpart' 'bios' 1 2 \
'set' 1 'bios_grub' 'on' \
'mkpart' 'esp' 2 ${VM_ESP} \
'set' 2 'esp' 'on' \
'mkpart' 'data' ${VM_ESP} ${VM_SIZE}

for dev in /dev/nbd*; do
    echo "→ ${dev}"
    if qemu-nbd --connect "${dev}" --format 'raw' "${file}"; then
        directory="$(util_make_temporary_directory)"
        # esp
        device="${dev}p2"
        mkfs.vfat "${device}"
        mount "${device}" "${directory}"
        util_copy "${ESP_EFI_ROOT}" "${ESP_BIOS_ROOT}" "${directory}"
        util_list "${directory}"
        umount "${directory}"
        # data
        device="${dev}p3"
        mkfs.ext4 "${device}"
        mount "${device}" "${directory}"
        util_make_directory "${directory}/fs"
        util_list "${directory}"
        umount "${directory}"
        # exit
        echo "← ${dev}"
        qemu-nbd --disconnect "${dev}"
        break
    fi
done
}
