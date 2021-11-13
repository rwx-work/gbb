LOG_LEVEL_DEBUG=0
LOG_LEVEL_INFO=1
LOG_LEVEL_WARNING=2
LOG_LEVEL_ERROR=3
LOG_LEVELS=('debug' 'info' 'warning' 'error')

LOG_LEVEL=${LOG_LEVEL_WARNING}

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
local file="${1}"
local content="${2}"
if [ "${file}" ]; then
    log_info '→' "${file}"
    [ "${content}" ] && log_debug "${content}"
fi
}

function log_level {
local level="${1}"
echo "${LOG_LEVELS["${level}"]}"
}
