#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

~/bin/eget https://github.com/jesseduffield/lazygit --to ~/bin

"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/lazygit" ~/.config/lazygit
