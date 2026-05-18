#!/usr/bin/bash
set -Eeuo pipefail

cd "$(dirname "$0")"

# ===== 配置 MSYS2 环境 =====
./setup-msys2.sh

# ===== 复制配置文件 =====
# Rime
mkdir -p $APPDATA/Rime && cp -r ./Rime-Ice/.local/share/fcitx5/rime/* $APPDATA/Rime
# WezTerm
cp ./WezTerm/.wezterm.lua $USERPROFILE
# Pictures
cp ./Pictures/Pictures/Wallpapers/* "$USERPROFILE/Pictures/Camera Roll"
# Shell: Bash + Fish + PowerShell
cp ./MSYS2/Bash/.bash* $HOME
cp -r ./MSYS2/Fish/.config/fish $HOME/.config/
# OhMyPosh
cp ./OhMyPosh/.omp.json ~
# FastFetch
cp -r ./FastFetch/.config/fastfetch $HOME/.config
# Yazi
mkdir -p $APPDATA/yazi/config && cp -r ./Yazi/.config/yazi/* $APPDATA/yazi/config/
# LazyVim
cp -r ./LazyVim/.config/nvim $LOCALAPPDATA
# Jetbrains
cp ./Jetbrains/.ideavimrc $USERPROFILE
# VSCode
mkdir -p $APPDATA/Code/User
cp ./VSCode/.config/Code/User/keybindings.json $APPDATA/Code/User/
cp ./VSCode/.config/Code/User/settings.json $APPDATA/Code/User/
# Ruff
cp -r ./Ruff/.config/ruff $APPDATA
# AutoHotkey(废弃, 用 Kanata 替代, Kanata 手动配置, 不在脚本操作)
# cp ./AutoHotkey/CapsLock+.ahk "$APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/"

echo "Done."
exit 0