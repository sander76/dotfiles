#!/bin/bash
set -e
# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
"$PARENT_FOLDER/prepare.sh"

sudo apt install zsh

chsh -s "$(which zsh)"

[ ! -e ~/.zshrc ] && ln -s "$PARENT_FOLDER/terminal/zshrc" ~/.zshrc 
