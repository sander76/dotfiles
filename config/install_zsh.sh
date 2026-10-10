#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
"$PARENT_FOLDER/prepare.sh"

# Install zsh if not already installed
if ! command -v zsh &>/dev/null; then
    sudo apt install zsh -y
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

# Install zsh plugins via sheldon (config comes from the stow tree:
# ~/.config/sheldon/plugins.toml, applied by `stow -t ~ stow`)
sheldon lock

