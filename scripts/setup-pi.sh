#!/usr/bin/env bash
# Bootstrap all pi packages from settings.json
set -e
cd "$(dirname "$0")/.."

# Prerequisite checks
for cmd in brew uv jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Error: '$cmd' is required but not installed."
    exit 1
  fi
done

echo "==> Installing rtk from Homebrew..."
brew install rtk
echo ""

echo "==> Installing CodeMapper..."
uv tool install codemapper
echo ""

echo "==> Bootstrapping pi packages..."
jq -r '.packages[]' settings.json | while read -r pkg; do
  echo "  pi install -l $pkg"
  pi install -l "$pkg"
done

echo ""
echo "==> Done. Verify with: pi list"
