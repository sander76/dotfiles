#!/bin/bash

# Download fzf binary using eget and store it in ~/bin folder

# Create ~/bin directory if it doesn't exist
mkdir -p ~/bin

# Use eget to download fzf from GitHub releases
eget junegunn/fzf --to ~/bin

# Make the binary executable
chmod +x ~/bin/fzf

echo "fzf has been downloaded and installed to ~/bin/fzf"
