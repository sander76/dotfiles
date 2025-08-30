#!/bin/bash
set -e


"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

curl -LsSf https://astral.sh/uv/install.sh | sh

