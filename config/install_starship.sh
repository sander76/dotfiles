#!/bin/bash
set -e

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"
"$(dirname "${BASH_SOURCE[0]}")/install_nerdfont.sh"

curl -sS https://starship.rs/install.sh | sh
