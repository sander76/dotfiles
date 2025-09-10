#!/bin/bash
set -e

PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"
"$PARENT_FOLDER/install_nerdfont.sh"


curl -sS https://starship.rs/install.sh | sh -s -- --force

# starship
[ ! -e ~/.config/starship.toml ] && ln -s "$PARENT_FOLDER/starship/starship.toml" ~/.config/starship.toml
