#!/bin/bash


if [ $# -eq 0 ]; then
    selected_repo=$(find ~/repos ~/baringa -maxdepth 3 -type f -name '.envrc' -exec dirname {} \; | fzf)
else
    selected_repo=$(find ~/repos ~/baringa -maxdepth 3 -type f -name '.envrc' -exec dirname {} \; | fzf -q "$1")
fi

if [ -n "$selected_repo" ]; then
    cd "$selected_repo"
    code $selected_repo
fi
