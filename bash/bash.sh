function bash_copy {
cp \
--recursive \
"${@}"
}

function bash_display_usage {
du \
--human-readable \
--summarize \
"${@}"
}

function bash_get_directory_mountpoint {
stat \
--format '%m' \
"${1}"
}

function bash_get_mountpoint_uuid {
findmnt \
--noheadings \
--output 'UUID' \
"${1}"
}

function bash_list {
ls \
--all \
--color \
-l \
-p \
"${@}"
}

function bash_make_directory {
mkdir \
--parents \
"${@}"
}

function bash_parted {
parted \
--script \
"${@}"
}

function bash_remove {
rm \
--force \
--recursive \
"${@}"
}
