#!/usr/bin/env bash

# Derive a safe pipe name from the current working directory
# Replace '/' with '_' and strip leading underscore
CWD="$(pwd)"
SAFE_CWD="${CWD//\//_}"
SAFE_CWD="${SAFE_CWD#_}"
PIPE="/tmp/nvim_${SAFE_CWD}.pipe"

if [[ ! -S "$PIPE" ]]; then
    # No existing server for this directory — start a new nvim session
    exec nvim --listen "$PIPE" "$@"
else
    if [[ $# -gt 0 ]]; then
        # Pipe exists and a file was provided — open it in the running instance
        # --remote only accepts filenames; extract any +N line-jump arg separately
        line_num=''
        files=()
        for arg in "$@"; do
            if [[ "$arg" =~ ^\+([0-9]+)$ ]]; then
                line_num="${BASH_REMATCH[1]}"
            else
                files+=("$arg")
            fi
        done
        if [[ -n "$line_num" && ${#files[@]} -gt 0 ]]; then
            nvim --headless --server "$PIPE" --remote "${files[@]}"
            nvim --headless --server "$PIPE" --remote-send ":${line_num}<CR>"
        else
            nvim --headless --server "$PIPE" --remote "$@"
        fi
    else
        # Pipe exists but no file — just attach to the running instance
        exec nvim --server "$PIPE" --remote-ui
    fi
fi
