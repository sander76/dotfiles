#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
APP_PATH="$SCRIPT_DIR/build/Tiler.app"

mkdir -p "$APP_PATH/Contents/MacOS"
cp "$SCRIPT_DIR/Info.plist" "$APP_PATH/Contents/Info.plist"
swiftc -O -framework AppKit -framework ApplicationServices \
	"$SCRIPT_DIR/tiler.swift" -o "$APP_PATH/Contents/MacOS/Tiler"

printf 'Built %s\n' "$APP_PATH"
