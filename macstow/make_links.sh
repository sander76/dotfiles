#!/bin/bash

set -e

ensure_link() {
    local source=$1
    local target=$2

    if [ -e "$target" ] || [ -L "$target" ]; then
        if [ ! -L "$target" ]; then
            printf 'Error: %s exists and is not a symlink\n' "$target" >&2
            return 1
        fi

        if [ "$(readlink "$target")" != "$source" ]; then
            printf 'Error: %s is a symlink to the wrong target\n' "$target" >&2
            return 1
        fi

        return 0
    fi

    ln -s "$source" "$target"
}

ensure_link "$HOME/repos/dotfiles/macstow/.zshrc" "$HOME/.zshrc"
ensure_link "$HOME/repos/dotfiles/macstow/.vim" "$HOME/.vim"
ensure_link "$HOME/repos/dotfiles/macstow/.config/ghostty" "$HOME/.config/ghostty"
ensure_link "$HOME/repos/dotfiles/macstow/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
ensure_link "$HOME/repos/dotfiles/macstow/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
ensure_link "$HOME/repos/dotfiles/macstow/.ideavimrc" "$HOME/.ideavimrc"
