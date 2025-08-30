#!/bin/bash

echo "Installing FZF"


if [[ -f ~/bin/fzf ]]; then
    echo "fzf already exists"
else
    eget junegunn/fzf --to ~/bin/
fi

BASHRC_FILE="$HOME/.bashrc"
TARGET_LINE='eval "$(~/bin/fzf --bash)"'

if ! grep -Fxq "$TARGET_LINE" "$BASHRC_FILE"; then
    echo "Editing bashrc to get fzf working"
    echo "$TARGET_LINE" >> "$BASHRC_FILE"
fi

echo "Finished installing FZF"