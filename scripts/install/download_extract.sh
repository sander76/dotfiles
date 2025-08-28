#!/bin/bash

# Exit immediately if any command fails
set -e

# Check if curl is available first
#AI! is curl does not exist, install it.
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl first."
    exit 1
fi

# Create ~/bin directory if it doesn't exist
mkdir -p ~/bin


# Check if eget is installed, if not install it
if ! command -v eget &> /dev/null; then
    echo "eget not found. Installing eget..."
    curl https://zyedidia.github.io/eget.sh | sh
    # Move eget to a directory in PATH if it's not already there
    if [ -f ./eget ]; then
        mv ./eget ~/bin/
        chmod +x ~/bin/eget
        # Add ~/bin to PATH for this session if not already there
        if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
            export PATH="$HOME/bin:$PATH"
        fi
    fi
fi


# Use eget to download fzf from GitHub releases
eget junegunn/fzf --to ~/bin

# Make the binary executable
chmod +x ~/bin/fzf

echo "fzf has been downloaded and installed to ~/bin/fzf"
