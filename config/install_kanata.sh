#!/bin/bash
set -e

PARENT_FOLDER="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
echo "$PARENT_FOLDER"

"$PARENT_FOLDER/prepare.sh"

~/bin/eget https://github.com/jtroo/kanata --to ~/bin --asset ^musl

# Check if the folder ~/.config/systemd/user exists. If not, create it.
if [ ! -d ~/.config/systemd/user ]; then
    mkdir -p ~/.config/systemd/user
fi

sudo systemctl daemon-reload
sudo systemctl start kanata.service
sudo systemctl enable kanata.service

# to restart the service
# systemctl restart kanata.service

# systemctl status kanata.service
