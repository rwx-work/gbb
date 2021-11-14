VM_ESP=16

# TODO check user, dd, parted, qemu
function vm_virtualize {
local device
local directory
local file
local partition

file="$(util_make_temporary_file)"
util_dump_dummy "${file}" "${VM_SIZE}"

echo -n "\
g
n


+1M
n


+${VM_ESP}M
n



w
" | fdisk "${file}"

device="$(util_attach_loop "${file}")"

# ESP
partition="${device}p2"
mkfs.vfat "${partition}"
util_mount "${partition}" '/mnt'
esp_build '/mnt'
util_unmount '/mnt'
# data
partition="${device}p3"
mkfs.ext4 "${partition}"
util_mount "${partition}" '/mnt'
# TODO default constant
util_make_directory '/mnt/fs/dummy'
util_copy '/vmlinuz' '/initrd.img' '/mnt/fs/dummy'
# TODO constant
util_touch_file '/mnt/fs/dummy/filesystem.squashfs'
util_unmount '/mnt'

util_detach_loop "${device}"

qemu-system-x86_64 \
-enable-kvm \
-m 1024 \
-nodefaults \
-vga 'virtio' \
-drive file="${file}",format='raw',if='virtio' \
-bios 'OVMF.fd'

}

function vm_parted {
VM_SIZE=128
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
