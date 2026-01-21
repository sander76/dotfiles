#!/bin/bash
set -ex

# Check if bin is already installed
if bin ls &> /dev/null; then
    echo "bin is already installed"
    exit 0
fi

# Download bin from releases using curl
TEMP_DIR=$(mktemp -d)
curl -L "https://github.com/marcosnils/bin/releases/download/v0.24.2/bin_0.24.2_linux_amd64" -o "$TEMP_DIR/bin"
# tar -xzf "$TEMP_DIR/bin.tar.gz" -C "$TEMP_DIR"
# mv "$TEMP_DIR/bin" ~/bin/bin
chmod +x "$TEMP_DIR/bin"

# Have bin manage itself
"$TEMP_DIR/bin" install github.com/marcosnils/bin

rm -rf "$TEMP_DIR"

echo "bin has been installed and is now managed by itself"
