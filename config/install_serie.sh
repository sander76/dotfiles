#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

~/bin/eget https://github.com/lusingander/serie --to ~/bin --asset ^musl

