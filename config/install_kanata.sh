#!/bin/bash
set -e


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
