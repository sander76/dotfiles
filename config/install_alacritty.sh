#!/usr/bin/env bash
set -euo pipefail

# Install Alacritty from source on Ubuntu/Debian
# Reference: https://github.com/alacritty/alacritty/blob/master/INSTALL.md

REPO_URL="https://github.com/alacritty/alacritty.git"
BUILD_DIR="$(mktemp -d)/alacritty"

echo "==> Installing dependencies"
sudo apt-get update
sudo apt-get install -y cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

echo "==> Installing Rust (if not already installed)"
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    source "$HOME/.cargo/env"
else
    source "$HOME/.cargo/env" 2>/dev/null || true
fi

rustup override set stable
rustup update stable

echo "==> Cloning Alacritty"
git clone "$REPO_URL" "$BUILD_DIR"
cd "$BUILD_DIR"

echo "==> Building Alacritty"
cargo build --release

echo "==> Installing binary"
sudo cp target/release/alacritty /usr/local/bin/alacritty

echo "==> Installing terminfo"
if ! infocmp alacritty &>/dev/null; then
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
fi

echo "==> Installing desktop entry and icon"
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database


echo "==> Cleaning up"
rm -rf "$BUILD_DIR"

echo "Done. Alacritty $(alacritty --version) installed."
