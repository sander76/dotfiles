#!/bin/bash

# fzf Binary Installer Script
# Usage: ./install_fzf.sh <download_url>

set -e  # Exit on any error

# Function to display usage
usage() {
    echo "Usage: $0 <download_url>"
    echo ""
    echo "Example:"
    echo "  $0 https://github.com/junegunn/fzf/releases/download/v0.65.1/fzf-0.65.1-linux_amd64.tar.gz"
    echo ""
    echo "This script will:"
    echo "  1. Check if ~/bin directory exists"
    echo "  2. Download the binary from the provided URL"
    echo "  3. Extract it to a temporary folder"
    echo "  4. Copy binaries to ~/bin"
    echo "  5. Make them executable"
    echo "  6. Clean up temporary files"
    exit 1
}

# Check if URL argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No download URL provided"
    usage
fi

DOWNLOAD_URL="$1"
TEMP_DIR="/tmp"
INSTALL_DIR="$HOME/bin"

# Extract filename from URL
FILENAME=$(basename "$DOWNLOAD_URL")
TEMP_FILE="$TEMP_DIR/$FILENAME"
EXTRACT_DIR="$TEMP_DIR/extracted"

# Validate file extension
if [[ "$FILENAME" != *.tar.gz && "$FILENAME" != *.zip ]]; then
    echo "✗ Error: Unsupported file format"
    echo ""
    echo "Only .tar.gz and .zip files are supported."
    echo "Provided file: $FILENAME"
    exit 1
fi

echo "Starting installation..."
echo ""

# Check if install directory exists
echo "Checking if install directory exists..."
if [ ! -d "$INSTALL_DIR" ]; then
    echo "✗ Error: $INSTALL_DIR directory does not exist"
    echo ""
    echo "Please create the ~/bin directory first:"
    echo "  mkdir ~/bin"
    echo ""
    echo "You may also want to add it to your PATH in ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/bin:\$PATH\""
    exit 1
fi
echo "✓ Install directory exists"

# Create extraction directory
echo "Creating extraction directory..."
rm -rf "$EXTRACT_DIR"
mkdir -p "$EXTRACT_DIR"
echo "✓ Extraction directory created"

# Download the file
echo "Downloading $FILENAME..."
if curl -L -f -o "$TEMP_FILE" "$DOWNLOAD_URL"; then
    echo "✓ Download completed successfully"
else
    echo "✗ Download failed"
    exit 1
fi

if [[ "$FILENAME" == *.tar.gz ]]; then
    echo "Extracting tar.gz archive..."
    if tar -xzf "$TEMP_FILE" -C "$EXTRACT_DIR"; then
        echo "✓ Extraction completed successfully"
    else
        echo "✗ Extraction failed"
        rm -f "$TEMP_FILE"
        rm -rf "$EXTRACT_DIR"
        exit 1
    fi
elif [[ "$FILENAME" == *.zip ]]; then
    echo "Extracting zip archive..."
    if command -v unzip >/dev/null 2>&1; then
        if unzip -o "$TEMP_FILE" -d "$EXTRACT_DIR"; then
            echo "✓ Extraction completed successfully"
        else
            echo "✗ Extraction failed"
            rm -f "$TEMP_FILE"
            rm -rf "$EXTRACT_DIR"
            exit 1
        fi
    else
        echo "✗ unzip command not found. Please install unzip package."
        rm -f "$TEMP_FILE"
        rm -rf "$EXTRACT_DIR"
        exit 1
    fi
fi

# Copy extracted files to install directory and make executable
echo "Installing binaries..."
find "$EXTRACT_DIR" -type f -executable -o -name "*" | while read -r file; do
    if [ -f "$file" ] && [ -x "$file" -o ! -d "$file" ]; then
        basename_file=$(basename "$file")
        echo "Installing $basename_file..."
        cp "$file" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/$basename_file"
    fi
done
echo "✓ Installation completed"

# Clean up temporary files
echo "Cleaning up..."
rm -f "$TEMP_FILE"
rm -rf "$EXTRACT_DIR"
echo "✓ Cleanup completed"

echo ""
echo "Installation completed successfully!"

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo ""
    echo "⚠️  Note: $HOME/bin is not in your PATH"
    echo "Add this line to your ~/.bashrc or ~/.zshrc:"
    echo "export PATH=\"\$HOME/bin:\$PATH\""
    echo ""
    echo "Then reload your shell:"
    echo "source ~/.bashrc  # or source ~/.zshrc"
fi

# Verify installation
if [ -x "$INSTALL_DIR/fzf" ]; then
    echo ""
    echo "Verifying installation..."
    "$INSTALL_DIR/fzf" --version
    echo "✓ fzf is ready to use!"
else
    echo ""
    echo "⚠️  fzf binary not found at expected location"
    echo "Available files in $INSTALL_DIR:"
    ls -la "$INSTALL_DIR"
fi
