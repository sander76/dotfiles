#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

curl https://mise.run/zsh | sh

"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/mise/_config.toml" ~/.config/mise/config.toml
