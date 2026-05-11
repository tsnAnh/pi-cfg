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

# Link pi-superpowers skills into agent skills dir
SUPERPOWERS_DIR="$HOME/.pi/agent/git/github.com/coctostan/pi-superpowers"
if [ -d "$SUPERPOWERS_DIR/skills" ]; then
  echo ""
  echo "==> Linking pi-superpowers skills..."
  SKILLS_DIR="$HOME/.pi/agent/skills"
  mkdir -p "$SKILLS_DIR"
  for skill in "$SUPERPOWERS_DIR/skills"/*/; do
    name=$(basename "$skill")
    link="$SKILLS_DIR/$name"
    if [ ! -e "$link" ]; then
      ln -sf "$skill" "$link"
      echo "  → Linked $name"
    fi
  done
fi

echo ""
echo "==> Done. Verify with: pi list"
