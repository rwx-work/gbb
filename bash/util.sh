# coreutils

function util_copy {
cp \
--recursive \
"${@}"
}

function util_display_usage {
du \
--human-readable \
--summarize \
"${@}"
}

function util_list {
ls \
--all \
--color \
-l \
-p \
"${@}"
}
