#!/usr/bin/bash
set -Eeuo pipefail

cd "$(dirname "$0")"

# Setup MSYS2
./setup-msys2.sh

# AutoHotkey
cp ./AutoHotkey/CapsLock+.ahk "$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/"
# Rime
mkdir -p $APPDATA/Rime && cp -r ./Rime/.local/share/fcitx5/rime/* $APPDATA/Rime
# WezTerm
cp ./WezTerm/.wezterm.lua $USERPROFILE
# Pictures
cp ./Pictures/Pictures/* "$USERPROFILE/Pictures/Camera Roll"
# Jetbrains
cp ./Jetbrains/.ideavimrc $USERPROFILE
# Ruff
cp -r ./Ruff/.config/ruff $APPDATA
# VSCode
mkdir -p $APPDATA/Code/User
cp ./VSCode/.config/Code/User/keybindings.json $APPDATA/Code/User/
cp ./VSCode/.config/Code/User/settings.json $APPDATA/Code/User/
# Yazi
mkdir -p $APPDATA/yazi/config && cp -r ./Yazi/.config/yazi/* $APPDATA/yazi/config/
ya pkg add kmlupreti/ayu-dark || true
ya pkg add saumyajyoti/omp || true
ya pkg add yazi-rs/plugins:full-border || true
ya pkg add ndtoan96/ouch || true
ya pkg add boydaihungst/mediainfo || true
# LazyVim
cp -r ./LazyVim/.config/nvim $LOCALAPPDATA

echo "Done."
exit 0