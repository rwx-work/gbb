function menu {
menu="${1}"
if [ "${menu}" ]; then
    export menu
    configfile "${prefix}/${menu}.sh"
else
    configfile "${prefix}/grub.cfg"
fi
}

function menu_separate {
menuentry '' { clear }
}
