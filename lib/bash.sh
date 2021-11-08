BASH_ACTION="${1}"
BASH_FUNCTION='function'

BASH_ACTIONS="$(\
grep "${BASH_FUNCTION}" "${BASH_FILE}" \
| awk '{print $2}' \
)"

function bash_action {
if ! eval "${BASH_ACTION}" 2> /dev/null; then
    for action in "${BASH_ACTIONS[@]}"; do
        echo "${action}"
    done
fi
}

function make_directory {
mkdir \
--parents \
"${@}"
}

function remove {
rm \
--force \
--recursive \
"${@}"
}

function usage {
du \
--human-readable \
--summarize \
"${@}"
}
