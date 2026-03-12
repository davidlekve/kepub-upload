#!/usr/bin/env bash
set -euo pipefail

# kepub-upload installer
# Usage: curl -sL https://raw.githubusercontent.com/<user>/kepub-upload/main/install.sh | bash

REPO="https://github.com/<user>/kepub-upload"
PREFIX="${PREFIX:-$HOME/.local}"
CLONE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/kepub-upload"

info()  { echo -e "\033[0;34m>\033[0m $1"; }
ok()    { echo -e "\033[0;32m>\033[0m $1"; }
error() { echo -e "\033[0;31mx\033[0m $1" >&2; }

# Check git
if ! command -v git &>/dev/null; then
  error "git is required. Install it first."
  exit 1
fi

# Clone or update
if [[ -d "$CLONE_DIR/.git" ]]; then
  info "Updating kepub-upload..."
  git -C "$CLONE_DIR" pull --quiet
else
  info "Installing kepub-upload..."
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone "$REPO" "$CLONE_DIR" --quiet --depth 1
fi

# Install
make -C "$CLONE_DIR" install PREFIX="$PREFIX"

# Verify
if command -v kepub-upload &>/dev/null; then
  ok "kepub-upload $(kepub-upload --version) installed to $PREFIX/bin/"
else
  ok "Installed to $PREFIX/bin/kepub-upload"
  echo
  echo "Make sure $PREFIX/bin is in your PATH:"
  echo "  export PATH=\"$PREFIX/bin:\$PATH\""
fi
