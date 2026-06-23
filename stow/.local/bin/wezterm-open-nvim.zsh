#!/usr/bin/env zsh

# wezterm-open-nvim: parse a "file[:line[:col]]" selection and open in nvim.
# Usage: wezterm-open-nvim <selection>
# Matches: path/to/file.py  |  path/to/file.py:4  |  path/to/file.py:4:10

sel="${1}"

# Strip surrounding whitespace
sel="${sel#"${sel%%[! ]*}"}"
sel="${sel%"${sel##*[! ]}"}"

[[ -z "$sel" ]] && exit 0

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
