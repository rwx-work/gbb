DEV_BINARIES+=('qemu-system-x86_64')

VM_BIOS=1
VM_ESP=128
VM_SIZE=256

# TODO check user, qemu
function vm_virtualize {
local device
local directory
local file
local partition
local root

file="$(util_make_temporary_file)"
util_dump_dummy "${file}" "${VM_SIZE}"

util_partition \
"${file}" 'g' \
'n' '' '' "+${VM_BIOS}M" \
'n' '' '' "+${VM_ESP}M" \
'n' '' '' '' \
't' 1 4 \
't' 2 'uefi'

device="$(util_attach_loop "${file}")"
# ESP
partition="${device}p2"
util_make_fs "${partition}" 'vfat'
root="$(util_make_temporary_directory)"
util_mount "${partition}" "${root}"
esp_build "${root}"
util_unmount "${partition}"
# data
partition="${device}p3"
util_make_fs "${partition}" 'ext4'
root="$(util_make_temporary_directory)"
util_mount "${partition}" "${root}"
# TODO default constant
directory="${root}/fs/dummy"
util_make_directory "${directory}"
util_copy \
'/vmlinuz' '/initrd.img' \
"${directory}"
# TODO constant
util_touch_file "${directory}/filesystem.squashfs"
util_unmount "${partition}"

util_detach_loop "${device}"

# TODO efi/bios
qemu-system-x86_64 \
-enable-kvm \
-m 1024 \
-nodefaults \
-vga 'virtio' \
-full-screen \
-drive file="${file}",format='raw',if='virtio' \
-bios 'OVMF.fd' \
&

}
