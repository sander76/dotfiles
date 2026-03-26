#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Usage: watch_tests.sh <folder>"
    exit 1
fi

cd "$1" || exit 1
uv run pytest-discovery watch tests
