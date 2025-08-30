#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

# "$PARENT_FOLDER/prepare.sh"

# # use custom repo to get the latest git version.
# sudo add-apt-repository ppa:git-core/ppa -y
# sudo apt update -y
# sudo apt install git -y

# ~/bin/eget https://github.com/dandavison/delta --to ~/bin



# Link Git config if it doesn't exist
# Get the original user's home directory
[ ! -e ~/.config/git ] && ln -s "$PARENT_FOLDER/git" ~/.config/git
