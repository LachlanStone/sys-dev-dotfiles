#!/usr/bin/env bash
set -euo pipefail

config_file="$HOME/.config/starship.toml"

if [ ! -f "$config_file" ]; then
  echo "Starship config not found: $config_file"
  exit 1
fi

if grep -qE '^disabled = true$' <(awk '/^\[git_branch\]/{flag=1;next}/^\[/{flag=0}flag' "$config_file"); then
  sed -i '/^\[git_branch\]/,/^\[/{s/^disabled = true$/disabled = false/}' "$config_file"
  echo "Starship git segment: ON"
else
  if awk '/^\[git_branch\]/{flag=1;next}/^\[/{flag=0}flag' "$config_file" | grep -q '^disabled = '; then
    sed -i '/^\[git_branch\]/,/^\[/{s/^disabled = false$/disabled = true/}' "$config_file"
  else
    sed -i '/^\[git_branch\]/a disabled = true' "$config_file"
  fi
  echo "Starship git segment: OFF"
fi

echo "Reload shell to apply: source ~/.zshrc"