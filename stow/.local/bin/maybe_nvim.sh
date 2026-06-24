#!/usr/bin/env bash

# Derive a safe pipe name from the current working directory
# Replace '/' with '_' and strip leading underscore
CWD="$(pwd)"
SAFE_CWD="${CWD//\//_}"
SAFE_CWD="${SAFE_CWD#_}"
PIPE="/tmp/nvim_${SAFE_CWD}.pipe"

# Normalise file::test[params] → +/test file so the rest of the script
# can handle it uniformly.  The [params] suffix (e.g. pytest parametrize
# brackets) is stripped; only the bare test name is used for the search.
new_args=()
for arg in "$@"; do
    if [[ "$arg" =~ ^([^:[:space:]]+)::([_[:alnum:]]+)(\[.*\])?$ ]]; then
        # file::test[params]  →  +/test file  (strips [params])
        new_args=("+/${BASH_REMATCH[2]}" "${BASH_REMATCH[1]}")
    elif [[ "$arg" =~ ^(.+):([0-9]+)(:[0-9]+)?$ ]]; then
        # file:line[:col]  →  +line file  (col is ignored)
        new_args=("+${BASH_REMATCH[2]}" "${BASH_REMATCH[1]}")
    else
        new_args+=("$arg")
    fi
done
set -- "${new_args[@]}"

if [[ ! -S "$PIPE" ]]; then
    # No existing server for this directory — start a new nvim session
    exec nvim --listen "$PIPE" "$@"
else
    if [[ $# -gt 0 ]]; then
        # Pipe exists and a file was provided — open it in the running instance
        # --remote only accepts filenames; extract any +N line-jump arg separately
        line_num=''
        search_pattern=''
        files=()
        for arg in "$@"; do
            if [[ "$arg" =~ ^\+([0-9]+)$ ]]; then
                line_num="${BASH_REMATCH[1]}"
            elif [[ "$arg" =~ ^\+/(.+)$ ]]; then
                search_pattern="${BASH_REMATCH[1]}"
            else
                files+=("$arg")
            fi
        done
        if [[ -n "$line_num" && ${#files[@]} -gt 0 ]]; then
            nvim --headless --server "$PIPE" --remote "${files[@]}"
            nvim --headless --server "$PIPE" --remote-send ":${line_num}<CR>"
        elif [[ -n "$search_pattern" && ${#files[@]} -gt 0 ]]; then
            nvim --headless --server "$PIPE" --remote "${files[@]}"
            nvim --headless --server "$PIPE" --remote-send ":/${search_pattern}<CR>"
        else
            nvim --headless --server "$PIPE" --remote "$@"
        fi
    else
        # Pipe exists but no file — just attach to the running instance
        exec nvim --server "$PIPE" --remote-ui
    fi
fi
