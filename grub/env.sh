function env_set {
gfx_mode='800x600'
terminal_output='gfxterm'
time_out=10
}

function env {
local action="${1}"
setparams \
'gfxmode' 'terminal_output' 'time_out'
if [ "${action}" == 'export' ]; then
    # TODO implement
    echo
fi
if [ "${action}" == 'load' ]; then
    load_env --file "${env_path}" "${@}"
fi
if [ "${action}" == 'save' ]; then
    save_env --file "${env_path}" "${@}"
fi
if [ "${action}" == 'unset' ]; then
    # TODO implement
    echo
fi
}

function env_apply {
#
gfxmode="${gfx_mode}x32,auto"
terminal_output 'console'
terminal_output "${terminal_output}"
#
if [ "${default}" ]; then timeout=${time_out}; else unset timeout; fi
}

function env_init {
env_set
env_rw='ø'
# TODO variable
if [ -f '/grub.env' ]; then
    env_rw='⋅'
    if env 'load'; then
        env_rw='r'
        if env 'save'; then
            env_rw='w'
        fi
    fi
fi
env_apply
}
