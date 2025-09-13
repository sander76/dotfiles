#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

sudo apt install bat -y

