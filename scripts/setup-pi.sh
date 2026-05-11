#!/usr/bin/env bash
# Bootstrap all pi packages from settings.json
set -e
cd "$(dirname "$0")/.."

# Prerequisite checks
for cmd in brew cargo jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Error: '$cmd' is required but not installed."
    exit 1
  fi
done

echo "==> Installing rtk from Homebrew..."
brew install rtk
echo ""

echo "==> Installing CodeMapper (cm)..."
cargo install --git https://github.com/p1rallels/codemapper.git
echo ""

echo "==> Bootstrapping pi packages..."
jq -r '.packages[]' settings.json | while read -r pkg; do
  echo "  pi install $pkg"
  pi install "$pkg"
done

echo ""
echo "==> Done. Verify with: pi list"
