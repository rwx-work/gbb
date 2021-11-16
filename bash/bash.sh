function bash_check_shell {
shellcheck \
--shell 'bash' \
"${@}"
}

function bash_write_file {
local file="${1}"
local content="${2}"
log_file_write "${file}" "${content}"
echo -n "${content}" > "${file}"
}
