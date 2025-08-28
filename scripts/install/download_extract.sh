#!/bin/bash

# Check if script is run with sudo rights
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script requires sudo privileges to install packages."
    echo "Please run with: sudo $0"
    exit 1
fi

# Exit immediately if any command fails
set -e

# Check if curl is available first, install if not found
if ! command -v curl &> /dev/null; then
    echo "curl not found. Installing curl..."
    if command -v apt-get &> /dev/null; then
        apt update && apt install -y curl
    fi
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
