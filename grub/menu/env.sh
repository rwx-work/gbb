# TODO implement
menuentry "show file" {
# TODO variable
cat '/grub.env'
menu_pause
}
# TODO pause
menuentry "show variables" {
set
menu_pause
}
# TODO implement
menuentry "reset defaults" {
env_set
}
