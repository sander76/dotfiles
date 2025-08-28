#!/bin/bash

# Run the download_extract.sh script
"$(dirname "${BASH_SOURCE[0]}")/download_extract.sh"

# Use eget to download fzf from GitHub releases
eget junegunn/fzf --to ~/bin

# Make the binary executable
chmod +x ~/bin/fzf

echo "fzf has been downloaded and installed to ~/bin/fzf"
