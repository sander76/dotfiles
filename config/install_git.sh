#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(dirname "${BASH_SOURCE[0]}")"

"$PARENT_FOLDER/prepare.sh"

# use custom repo to get the latest git version.
add-apt-repository ppa:git-core/ppa -y
apt update -y
apt install git -y

~/bin/eget https://github.com/dandavison/delta --to ~/bin


# Link Git config if it doesn't exist
[ ! -e ~/.config/git ] && ln -s "$PARENT_FOLDER/git" ~/.config/git
