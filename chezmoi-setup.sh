#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_CONFIG_DIR="$HOME/.config/chezmoi"
CHEZMOI_CONFIG_FILE="$CHEZMOI_CONFIG_DIR/chezmoi.toml"

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "chezmoi is not installed. Install it first (e.g. brew install chezmoi)."
  exit 1
fi

# Workaround for chezmoi versions that fail when default source dir does not exist.
mkdir -p "$HOME/.local/share/chezmoi"

current_source=""
if chezmoi source-path >/dev/null 2>&1; then
  current_source="$(chezmoi source-path 2>/dev/null || true)"
fi

if [[ "$current_source" == "$REPO_DIR" ]]; then
  echo "chezmoi already configured for this repo, applying..."
  chezmoi apply
  exit 0
fi

echo "Setting up chezmoi for this repo..."
mkdir -p "$CHEZMOI_CONFIG_DIR"
cat > "$CHEZMOI_CONFIG_FILE" <<EOF
sourceDir = "$REPO_DIR"
EOF

chezmoi init -S "$REPO_DIR"
chezmoi apply -S "$REPO_DIR"

echo "Done. Chezmoi source is now: $(chezmoi source-path)"