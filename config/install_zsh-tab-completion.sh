#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

mkdir -p .zsh

git clone https://github.com/lincheney/fzf-tab-completion.git ~/.zsh/fzf-tab-completion  --depth=1


# see zshrc file for init.
