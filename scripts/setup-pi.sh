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

# Set up cm alias for CodeMapper
if command -v codemapper &>/dev/null && ! command -v cm &>/dev/null; then
  rc_file="$HOME/.zshrc"
  [ ! -f "$rc_file" ] && rc_file="$HOME/.bashrc"
  if [ -f "$rc_file" ]; then
    if ! grep -q "alias cm=" "$rc_file" 2>/dev/null; then
      echo "alias cm='codemapper'" >> "$rc_file"
      echo "  → Added 'cm' alias to $rc_file"
      echo "  → Run 'source $rc_file' or restart your shell to use it."
    else
      echo "  → 'cm' alias already exists in $rc_file — skipping."
    fi
  fi
fi
echo ""

echo "==> Bootstrapping pi packages..."
jq -r '.packages[]' settings.json | while read -r pkg; do
  echo "  pi install -l $pkg"
  pi install -l "$pkg"
done

echo ""
echo "==> Done. Verify with: pi list"
