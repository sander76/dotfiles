#!/bin/bash

# Check if eget is installed, if not install it
if ! command -v eget &> /dev/null; then
    echo "eget not found. Installing eget..."
    curl https://zyedidia.github.io/eget.sh | sh
    # Move eget to a directory in PATH if it's not already there
    if [ -f ./eget ]; then
        mkdir -p ~/bin
        mv ./eget ~/bin/
        chmod +x ~/bin/eget
        # Add ~/bin to PATH for this session if not already there
        if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
            export PATH="$HOME/bin:$PATH"
        fi
    fi
fi

# Download fzf binary using eget and store it in ~/bin folder

# Create ~/bin directory if it doesn't exist
mkdir -p ~/bin

# Use eget to download fzf from GitHub releases
eget junegunn/fzf --to ~/bin

# Make the binary executable
chmod +x ~/bin/fzf

echo "fzf has been downloaded and installed to ~/bin/fzf"
