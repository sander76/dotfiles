#!/bin/bash

if command -v nano &> /dev/null; then
    echo "nano already installed"
else
    sudo apt update -y
    sudo apt -y install git
fi

if [ -e "$HOME/.nanorc" ]; then
    echo ".nano rc already exists"
else
    NANO_RC="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/nano/nanorc"
    echo "Creating nano symlink from $NANO_RC"
    
    ln -s "$NANO_RC" ~/.nanorc
fi
