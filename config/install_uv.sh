#!/bin/bash
set -e

#AI! check if uv is already installed (by using which command) if exists, do nothing. If not exists, perform the below actions.

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

curl -LsSf https://astral.sh/uv/install.sh | sh

