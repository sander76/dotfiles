#!/bin/bash
set -e

# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"

# use custom repo to get the latest git version.
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update -y
sudo apt -y install git

# Install git delta
~/bin/eget https://github.com/dandavison/delta --to ~/bin


# Install lib secret
sudo apt -y install make gcc git libsecret-1-0 libsecret-1-dev libglib2.0-dev
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret



# Link Git config if it doesn't exist
# Get the original user's home directory
[ ! -e ~/.config/git ] && ln -s "$PARENT_FOLDER/git" ~/.config/git


# goto `https://github.com/settings/tokens` to set a pat.