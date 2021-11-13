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

function util_make_directory {
mkdir \
--parents \
"${@}"
}

function util_remove {
rm \
--force \
--recursive \
"${@}"
}

function util_stat_mountpoint {
stat \
--format '%m' \
"${1}"
}
