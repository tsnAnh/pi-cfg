#!/usr/bin/env bash
# Bootstrap all pi packages from settings.json
set -e
cd "$(dirname "$0")/.."

echo "==> Installing rtk from Homebrew..."
brew install rtk
echo ""

echo "==> Installing CodeMapper..."
pipx install git+https://github.com/MikeyBeez/codemapper.git
echo ""

echo "==> Bootstrapping pi packages..."
jq -r '.packages[]' settings.json | while read -r pkg; do
  echo "  pi install -l $pkg"
  pi install -l "$pkg"
done

echo ""
echo "==> Done. Verify with: pi list"
