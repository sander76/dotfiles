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

# Helper: clone repo if missing, pull if it exists
clone_or_pull() {
    local repo="$1"
    local dest="$2"
    shift 2
    if [ -d "$dest" ]; then
        git -C "$dest" pull
    else
        git clone "$@" "$repo" "$dest"
    fi
}

# Install zsh plugins
mkdir -p ~/.zsh

clone_or_pull https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting --depth=1
clone_or_pull https://github.com/lincheney/fzf-tab-completion.git ~/.zsh/fzf-tab-completion --depth=1

# Symlink zshrc
"$PARENT_FOLDER/create_symlink.sh" "$PARENT_FOLDER/terminal/zshrc" ~/.zshrc
