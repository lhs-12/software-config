#!/usr/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

./setup-msys2.sh

stow -t "$USERPROFILE" wezterm Jetbrains || true
stow -t "$APPDATA" --no-folding --ignore='^(?!(ruff|yazi|Code)(/|$)).*' . || true
stow -t "$LOCALAPPDATA" --ignore='^(?!(nvim)(/|$)).*' . || true
stow -t "$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup" AutoHotkey || true

echo "Done."
exit 0