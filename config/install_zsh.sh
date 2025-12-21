#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
"$PARENT_FOLDER/prepare.sh"

sudo apt install zsh -y

# log off and on for changes to take effect
chsh -s "$(which zsh)"

"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/terminal/zshrc" ~/.zshrc
