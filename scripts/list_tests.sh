#!/bin/bash

# list_tests - Find and list all folders containing Python files and the Python files themselves

set -euo pipefail

# Get root directory from command line argument, default to current directory
ROOT_DIR="${1:-.}"

# Find folders containing Python files and show relative paths
find "$ROOT_DIR" -type d -name ".venv" -prune -o -type f -name "*.py" -exec dirname {} \; | sort -u

# Find Python files and show relative paths
find "$ROOT_DIR" -type d -name ".venv" -prune -o -type f -name "test_*.py" -print | sort
