menuentry "show file content" {
cat "${env_path}"
menu_pause
}
# TODO pause
menuentry "show variables" {
set
menu_pause
}
menuentry "reset defaults" {
env_set
# TODO env_apply?
}
