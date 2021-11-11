#! /usr/bin/env bash
BASH_SHEBANG='#! /usr/bin/env bash'
# TODO explain why eval
# TODO explain
BASH_FILE='BASH_FILE="$(realpath "${BASH_SOURCE[0]}")"'
# TODO explain
BASH_ROOT='BASH_ROOT="$(dirname "${BASH_FILE}")"'
BASH_HEADER="\
${BASH_SHEBANG}
${BASH_FILE}
${BASH_ROOT}
"
eval "${BASH_FILE}"
eval "${BASH_ROOT}"

# import bash modules
directory="${BASH_ROOT}/bash"
readarray -t modules <<< "$(ls "${directory}")"
for module in "${modules[@]}"; do
    source "${directory}/${module}"
done
unset directory module modules

BASH_ACTION="${1}"
BASH_ACTION_PREFIX='bash_action_'
BASH_ACTIONS="$(\
grep "function ${BASH_ACTION_PREFIX}" "${BASH_FILE}" \
| awk '{print $2}' \
)"


function bash_action_build {
grubash_wipe
grub_make_memdisk "${UUID_ESP}"

# 2 efi

bash_make_directory "${EFI_DIRECTORY}"

grub_make_image \
'x86_64-efi' \
"${EFI_FILE}"

# 2b bios

bash_make_directory "${GRUBASH_BIOS_DIRECTORY}"

# TODO explain why local copy
cp \
"${GRUB_BIOS}/boot.img" \
"${GRUBASH_BIOS_DIRECTORY}"

# make image file
grub_make_image \
'i386-pc' \
"${GRUBASH_BIOS_IMAGE}"

# TODO explain why absoulte path
echo -n "\
${BASH_HEADER}
${GRUB_BIOS_SETUP} \\
--directory \"\${BASH_ROOT}\" \\
\"\${1}\"
" >> "${GRUBASH_BIOS_SETUP}"
# set file executable
chmod +x "${GRUBASH_BIOS_SETUP}"

grubash_clean
bash_action_display
}

function bash_action_display {
esp_display_usage
}

# TODO implement default action
function bash_parse_arguments {
local action
if ! eval "bash_action_${BASH_ACTION}" 2> /dev/null; then
    for action in "${BASH_ACTIONS[@]}"; do
        echo "${action}"
    done
fi
}

mp="$(bash_get_directory_mountpoint "${ESP_ROOT}")"
bash_get_mountpoint_uuid "${mp}"

bash_parse_arguments
