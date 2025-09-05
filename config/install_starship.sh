#!/bin/bash
set -e

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"
"$(dirname "${BASH_SOURCE[0]}")/install_nerdfont.sh"


#AI! the install script which is downloaded accepts the "--force" flag. How to add that to the below line?
curl -sS https://starship.rs/install.sh | sh
