#!/bin/bash

# Check if script has write permissions to ~/bin directory
if [ ! -w "$HOME" ]; then
    echo "Error: No write permission to home directory. Please run this script as the user (not root)."
    exit 1
fi

# Create ~/bin directory if it doesn't exist
mkdir -p ~/bin

# Check if we can write to ~/bin
if [ ! -w "$HOME/bin" ]; then
    echo "Error: No write permission to ~/bin directory."
    exit 1
fi

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
