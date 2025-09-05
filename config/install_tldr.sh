#!/bin/bash
set -e
# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

~/bin/eget https://github.com/tldr-pages/tlrc --to ~/bin --asset ^musl

