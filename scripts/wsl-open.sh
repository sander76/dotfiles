#!/usr/bin/env bash
# Open files/URLs with the Windows default application from WSL.
if [[ -z "$1" ]]; then
  echo "Usage: open <file|url>"
  exit 1
fi
/mnt/c/Windows/explorer.exe "$(wslpath -w "$1")"
