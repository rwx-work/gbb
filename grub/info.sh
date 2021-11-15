function info {
menuentry "cmd | ${grub_cpu}-${grub_platform} ← ${cmdpath}" { menu 'cmd' }
menuentry "env | ${env_rw} }" { menu 'env' }
}
