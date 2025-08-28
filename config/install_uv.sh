#!/bin/bash
set -e
# Run the download_extract.sh script
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

curl -LsSf https://astral.sh/uv/install.sh | sh

