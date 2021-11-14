VM_BIOS=1
VM_ESP=16
VM_SIZE=128

# TODO check user, dd, parted, qemu
function vm_virtualize {
local device
local file
local partition
local root

file="$(util_make_temporary_file)"
util_dump_dummy "${file}" "${VM_SIZE}"

echo -n "\
g
n


+${VM_BIOS}M
t
4
n


+${VM_ESP}M
t

uefi
n



w
" | fdisk "${file}"

device="$(util_attach_loop "${file}")"
# ESP
partition="${device}p2"
mkfs.vfat "${partition}"
root="$(util_make_temporary_directory)"
util_mount "${partition}" "${root}"
esp_build "${root}"
util_unmount "${partition}"
# data
partition="${device}p3"
mkfs.ext4 "${partition}"
root="$(util_make_temporary_directory)"
util_mount "${partition}" "${root}"
# TODO default constant
util_make_directory "${root}/fs/dummy"
util_copy \
--dereference \
'/vmlinuz' '/initrd.img' \
"${root}/fs/dummy"
# TODO constant
util_touch_file "${root}/fs/dummy/filesystem.squashfs"
util_unmount "${partition}"

util_detach_loop "${device}"

qemu-system-x86_64 \
-enable-kvm \
-m 1024 \
-nodefaults \
-vga 'virtio' \
-drive file="${file}",format='raw',if='virtio' \
-bios 'OVMF.fd' \
&

}

function vm_parted {
parted \
--script \
"${file}" \
'mktable' 'gpt' \
'unit' 'mb' \
'mkpart' 'bios' 1 2 \
'set' 1 'bios_grub' 'on' \
'mkpart' 'esp' 2 ${VM_ESP} \
'set' 2 'esp' 'on' \
'mkpart' 'data' ${VM_ESP} ${VM_SIZE}
}
