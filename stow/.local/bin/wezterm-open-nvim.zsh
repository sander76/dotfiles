#!/usr/bin/env zsh

# wezterm-open-nvim: parse a "file[:line[:col]]" selection and open in nvim.
# Usage: wezterm-open-nvim <selection>
# Matches: path/to/file.py  |  path/to/file.py:4  |  path/to/file.py:4:10

sel="${1}"

# Strip surrounding whitespace
sel="${sel#"${sel%%[! ]*}"}"
sel="${sel%"${sel##*[! ]}"}"

[[ -z "$sel" ]] && exit 0

# Try file::test or file::test[params] (e.g. Rust test paths)
# Captures: file=part before ::, test_name=word after :: (strips [params])
if [[ "$sel" =~ ^([^: ]+)::([_[:alnum:]]+)$ ]]; then
    file="${match[1]}"
    test_name="${match[2]}"
    exec maybe_nvim.sh "+/$test_name" "$file"
fi

# Try file:line:col, then file:line, then bare file
if [[ "$sel" =~ ^(.+):([0-9]+):[0-9]+$ ]]; then
    file="${match[1]}"
    line="${match[2]}"
elif [[ "$sel" =~ ^(.+):([0-9]+)$ ]]; then
    file="${match[1]}"
    line="${match[2]}"
else
    file="$sel"
    line=""
fi

if [[ -n "$line" ]]; then
    exec maybe_nvim.sh +"$line" "$file"
else
    exec maybe_nvim.sh "$file"
fi
