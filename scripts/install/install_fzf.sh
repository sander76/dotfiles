#!/bin/bash

install_fzf() {
    echo "Installing fzf..."
    if ! brew install fzf; then
        return 1
    fi
    # Add fzf key bindings and fuzzy completion
    if ! $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc; then
        return 1
    fi

    cd ~/repos || exit
    git clone https://github.com/junegunn/fzf-git.sh.git

}
