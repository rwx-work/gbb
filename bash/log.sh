LOG_LEVEL_DEBUG=1
LOG_LEVEL_INFO=2
LOG_LEVEL_WARNING=3
LOG_LEVEL_ERROR=4

function log_debug {
[ ${LOG_LEVEL} -le ${LOG_LEVEL_DEBUG} ] && echo "${@}"
}

function log_error {
[ ${LOG_LEVEL} -le ${LOG_LEVEL_ERROR} ] && echo "${@}"
}

function log_info {
[ ${LOG_LEVEL} -le ${LOG_LEVEL_INFO} ] && echo "${@}"
}

function log_warning {
[ ${LOG_LEVEL} -le ${LOG_LEVEL_WARNING} ] && echo "${@}"
}

function log_file_write {
if [ "${1}" ]; then
    log_info '→' "${1}"
    [ "${2}" ] && log_debug "${2}"
fi
}
