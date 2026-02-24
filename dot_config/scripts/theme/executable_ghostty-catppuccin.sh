#!/usr/bin/env bash
set -euo pipefail

mode="${1:-toggle}"
config_file="$HOME/.config/ghostty/config"
light_theme="catppuccin-latte.conf"
dark_theme="catppuccin-mocha.conf"

if [ ! -f "$config_file" ]; then
  echo "Ghostty config not found: $config_file"
  exit 1
fi

current_theme="$(sed -nE 's/^theme[[:space:]]*=[[:space:]]*(.*)$/\1/p' "$config_file" | head -n1 | tr -d '[:space:]')"

case "$mode" in
  light)
    target_theme="$light_theme"
    ;;
  dark)
    target_theme="$dark_theme"
    ;;
  toggle)
    if [ "$current_theme" = "$light_theme" ]; then
      target_theme="$dark_theme"
    else
      target_theme="$light_theme"
    fi
    ;;
  *)
    echo "Usage: ghostty-catppuccin.sh [light|dark|toggle]"
    exit 2
    ;;
esac

if grep -qE '^theme[[:space:]]*=' "$config_file"; then
  sed -i -E "s|^theme[[:space:]]*=.*$|theme = $target_theme|" "$config_file"
else
  printf 'theme = %s\n' "$target_theme" >> "$config_file"
fi

echo "Ghostty theme set to: $target_theme"
echo "If Ghostty doesn't reload automatically, restart Ghostty."