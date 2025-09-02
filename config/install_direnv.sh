#!/bin/bash
set -ex

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"


sudo apt -y install direnv
