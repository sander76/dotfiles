#!/bin/bash
set -e

# Check if git command exists
if command -v git &> /dev/null; then
    echo "Git is already installed."
    
    # Check if git-core PPA is already added
    if apt-cache policy git | grep -q "git-core/ppa"; then
        echo "Git is installed from git-core PPA. Exiting."
        exit 0
    else
        echo "Git is installed but not from git-core PPA. Continuing with installation."
    fi
else
    echo "Git is not installed. Proceeding with installation."
fi

# make sure we have our preparations done.
PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"

# use custom repo to get the latest git version.
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update -y
sudo apt -y install git


# Install lib secret
# sudo apt -y install gnome-keyring make gcc libsecret-1-0 libsecret-1-dev libglib2.0-dev
# sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret


# use `git config --list` to see if config has worked.
