#!/bin/bash
set -e

if which uv > /dev/null 2>&1; then
    echo "uv is already installed"
    exit 0
fi

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

curl -LsSf https://astral.sh/uv/install.sh | sh
