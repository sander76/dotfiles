#!/bin/bash

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

apt install flatpak -y


flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo