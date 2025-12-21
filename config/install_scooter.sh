#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

# Use eget to download fzf from GitHub releases
~/bin/eget https://github.com/thomasschafer/scooter --to ~/bin/
