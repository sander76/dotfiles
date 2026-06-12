#!/usr/bin/env zsh

selected_test=$(~/repos/dotfiles/scripts/list_tests.sh tests | fzf \
    --header 'CTRL-D: collect tests from selected file' \
    --bind 'ctrl-d:reload(uv run pytest {1} --collect-only -q 2>/dev/null | sort -u || echo "No tests found")')

if [[ -n "$selected_test" ]]; then
    print -z "uv run pytest '$selected_test'"
fi
