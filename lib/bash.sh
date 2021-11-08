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
