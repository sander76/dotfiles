#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    printf 'Usage: %s <working-directory> <filename>\n' "$0" >&2
    exit 2
fi

working_directory=$1
filename=$2

cd -- "$working_directory"
ruff format -- "$filename"
