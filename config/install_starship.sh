#!/bin/bash
set -e

# make sure we have our preparations done.
"$(dirname "${BASH_SOURCE[0]}")/prepare.sh"

# Download and install FiraCode Nerd Font Mono
FONT_DIR="$HOME/.local/share/fonts/FiraCode"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
TEMP_DIR=$(mktemp -d)

echo "Installing FiraCode Nerd Font Mono..."

# Create fonts directory if it doesn't exist
mkdir -p "$FONT_DIR"

# Download the font
echo "Downloading FiraCode Nerd Font..."
curl -L "$FONT_URL" -o "$TEMP_DIR/FiraCode.zip"

# Extract the font
echo "Extracting font files..."
unzip -q "$TEMP_DIR/FiraCode.zip" -d "$FONT_DIR"

# Update font cache
# echo "Updating font cache..."
# fc-cache -fv

# Clean up
rm -rf "$TEMP_DIR"

echo "FiraCode Nerd Font Mono installation complete!"
