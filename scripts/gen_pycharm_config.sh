#!/bin/bash

set -eu

script_dir=$(cd "$(dirname "$0")" && pwd)
source_file="$script_dir/pycharm-state.xml"

if [[ $# -ne 1 || -z "$1" ]]; then
    printf 'Usage: %s <target-folder>\n' "${0##*/}" >&2
    exit 2
fi

workspace_dir=$1
case "$workspace_dir" in
    -*) workspace_dir="./$workspace_dir" ;;
esac

if [[ ! -f "$source_file" ]]; then
    printf 'Source file not found: %s\n' "$source_file" >&2
    exit 1
fi

mkdir -p "$workspace_dir"

while :; do
    name=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 27)
    [[ ${#name} -eq 27 ]] || continue

    destination="$workspace_dir/$name"
    [[ -e "$destination" || -L "$destination" ]] || break
done

cp "$source_file" "$destination"
printf '<component name="ProjectId" id="%s" />\n' "$name" > "$workspace_dir/workspace.xml"
printf 'Created %s\n' "$destination"
