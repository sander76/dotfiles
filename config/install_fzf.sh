#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

# Use eget to download fzf from GitHub releases
~/bin/eget junegunn/fzf --to ~/bin --asset ^musl

# Make the binary executable
chmod +x ~/bin/fzf

echo "fzf has been downloaded and installed to ~/bin/fzf"

if [ -d "$HOME/repos/fzf-git.sh" ]; then
    echo "fzf-git already available."
    exit 0
else
    cd ~/repos || exit
    git clone https://github.com/junegunn/fzf-git.sh.git
fi
