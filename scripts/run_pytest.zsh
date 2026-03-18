#!/usr/bin/env zsh

selected=$(find .pytest_discoveries -name "*.txt" | xargs cat | fzf -e)

if [[ -n "$selected" ]]; then
    print -z "uv run pytest $selected"
fi
