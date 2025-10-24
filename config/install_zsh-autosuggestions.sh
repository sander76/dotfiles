#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

mkdir -p .zsh

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# see zshrc file for init.
