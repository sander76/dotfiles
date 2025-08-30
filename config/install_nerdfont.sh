#!/bin/bash
set -e

# todo: check for existence of nerdfont.

# make sure we have our preparations done.

# Download and install FiraCode Nerd Font Mono
FONT_DIR="$HOME/.local/share/fonts/FiraCode"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
TEMP_DIR=$(mktemp -d)


mkdir -p "$FONT_DIR"

if [ "$(ls -A ${FONT_DIR})" ]; then
    echo "${FONT_DIR} contains files. Assuming font is already installed."
    exit 0
fi

"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

echo "Installing FiraCode Nerd Font Mono..."


# Download the font
echo "Downloading FiraCode Nerd Font..."
curl -L "$FONT_URL" -o "$TEMP_DIR/FiraCode.zip"

# Extract the font
echo "Extracting font files..."
unzip -q "$TEMP_DIR/FiraCode.zip" -d "$FONT_DIR"

# Clean up
rm -rf "$TEMP_DIR"

echo "FiraCode Nerd Font Mono installation complete!"
