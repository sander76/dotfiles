#!/usr/bin/env bash

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print -u2 "Not inside a Git repository."
    exit 1
fi

branch=$(git branch --show-current) || exit 1
if [[ -z "$branch" ]]; then
    print -u2 "Cannot open a branch page while in detached HEAD state."
    exit 1
fi

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)
if [[ -z "$upstream" ]]; then
    print -u2 "Current branch has no configured upstream."
    exit 1
fi

remote="${upstream%%/*}"
remote_url=$(git remote get-url "$remote" 2>/dev/null)
if [[ -z "$remote_url" ]]; then
    print -u2 "Could not get a URL for upstream remote '$remote'."
    exit 1
fi

is_ssh_url=0
case "$remote_url" in
    https://*|http://*|ssh://*)
        [[ "$remote_url" == ssh://* ]] && is_ssh_url=1
        remote_url="${remote_url#*://}"
        host="${remote_url%%/*}"
        path="${remote_url#*/}"
        host="${host##*@}"
        ;;
    *@*:*|*:*/*)
        is_ssh_url=1
        host="${remote_url%%:*}"
        path="${remote_url#*:}"
        host="${host##*@}"
        ;;
    *)
        print -u2 "Unsupported upstream remote URL: $remote_url"
        exit 1
        ;;
esac

if (( is_ssh_url )) && command -v ssh >/dev/null 2>&1; then
    resolved_host=
    while read -r key value _; do
        if [[ "$key" == hostname ]]; then
            resolved_host="$value"
            break
        fi
    done < <(ssh -G "$host" 2>/dev/null)
    [[ -n "$resolved_host" ]] && host="$resolved_host"
fi

path="${path%.git}"
if [[ -z "$host" || -z "$path" || "$path" == "$remote_url" ]]; then
    print -u2 "Could not construct a browser URL from upstream remote '$remote'."
    exit 1
fi

url="https://${host}/${path}/tree/${branch}"
open "$url"
