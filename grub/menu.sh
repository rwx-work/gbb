function menu {
menu="${1}"
if [ "${menu}" ]; then
    export menu
    configfile "${prefix}/menu/${menu}.sh"
else
    configfile "${prefix}/grub.cfg"
fi
}

function menu_pause {
echo -n 'Press Enter: '
read
}

function menu_split {
menuentry '' { clear }
}
