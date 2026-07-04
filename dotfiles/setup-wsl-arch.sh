#!/bin/bash
set -Eeuo pipefail
cd "$(dirname "$0")"
BASE_DIR="$PWD"

# ===== 配置区域: 开始 =====
declare -A SCRIPT_VARS
SCRIPT_VARS["git_username"]=""  # 设置 Git 用户名
SCRIPT_VARS["git_email"]=""     # 设置 Git 邮箱
# ===== 配置区域: 结束 =====

# 关于环境变量
# WSL2 systemd 下 environment.d 可用, 写入后 systemctl --user daemon-reload 生效
# 但 WSL2 的 environment.d 只注入到 systemd user 环境, 不会传播到普通 shell, 
# 因此 ~/.config/environment.d 和 ~/.bashrc 两边都要写
# PATH 等追加型变量不支持 environment.d (会覆盖), 所以只写 ~/.bashrc (用 append_path 函数)

# 检查是否非 root
if [[ $EUID -eq 0 ]]; then
  echo "Error: 请用普通用户执行此脚本" >&2
  exit 1
fi

# 检查 Windows 字体文件是否存在
WINDOWS_FONTS=(
  "/mnt/c/Windows/Fonts/MiSans VF.ttf"
  "/mnt/c/Windows/Fonts/MiSans L3.ttf"
  "/mnt/c/Windows/Fonts/MisansTC-Regular.ttf"
  "/mnt/c/Windows/Fonts/LXGWNeoZhiSongScreenFull.ttf"
)

for font in "${WINDOWS_FONTS[@]}"; do
  if [[ ! -f "$font" ]]; then
    echo "Error: Windows 字体文件不存在: $font" >&2
    exit 1
  fi
done

# 检查 MSYS2 目录 Git Credential Manager 是否存在
GCM_PATH="/mnt/c/msys64/ucrt64/libexec/git-core/git-credential-manager.exe"
if [[ ! -f "$GCM_PATH" ]]; then
  echo "Error: Git Credential Manager 不存在: $GCM_PATH" >&2
  echo "请确保 MSYS2 已安装 git-credential-manager" >&2
  exit 1
fi

# 检查参数已填写
for param in "${!SCRIPT_VARS[@]}"; do
  if [[ -z "${SCRIPT_VARS[$param]}" ]]; then
    echo "Error: 参数 '$param' 未设置, 请编辑脚本开头的配置区域" >&2
    exit 1
  fi
done

# 请求 sudo 权限并保持后台存活
echo "正在请求管理员权限..."
if ! sudo -v; then
  echo "Error: 需要管理员权限才能继续" >&2
  exit 1
fi
( while true; do sudo -n true 2>/dev/null || exit; sleep 60 || exit; done ) &
SUDO_PID=$!
trap 'kill -- -$SUDO_PID 2>/dev/null || true' EXIT INT TERM

# --- 基础环境安装配置 ---

echo "=== 安装常用包 ==="
sudo pacman -S --needed --noconfirm \
  fastfetch lolcat cmatrix \
  bash-completion fish oh-my-posh perl-image-exiftool \
  openssh wget man-pages man-db less ouch zip unzip 7zip pacman-contrib bind traceroute \
  stow tmux lsd bat bat-extras zoxide dust yazi tldr btop \
  neovim fzf fd ripgrep lazygit jq imagemagick resvg poppler mdbook mediainfo \
  ttf-nerd-fonts-symbols{,-mono}

echo "=== 安装字体 ==="
# pacman 包: Iosevka Term (monospace) + Noto 西文 + Noto Emoji
sudo pacman -S --needed --noconfirm fontconfig ttc-iosevka noto-fonts{,-emoji}
# 从 Windows 复制: MiSans (sans-serif) + LXGW (serif)
sudo mkdir -p /usr/share/fonts/my-fonts
sudo cp "${WINDOWS_FONTS[@]}" /usr/share/fonts/my-fonts/
sudo chown -R root: /usr/share/fonts/my-fonts
sudo chmod 644 /usr/share/fonts/my-fonts/*
sudo fc-cache -fv

# echo "=== 安装输入法 ==="
# sudo pacman -S --needed --noconfirm fcitx5-im fcitx5-rime rime-ice-git
# WSLg 走 XWayland
# 启动: fcitx5 --disable=wayland > /dev/null 2>&1 &
# 配置GUI: fcitx5-configtool
# 重载: fcitx5-remote -r
# 关闭: pkill fcitx5
# 诊断: fcitx5-diagnose

echo "=== 安装 Docker ==="
sudo pacman -S --needed --noconfirm docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo "=== Git 安装配置 ==="
sudo pacman -S --needed --noconfirm git git-lfs git-delta
git lfs install
git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global core.quotepath false
git config --global core.editor "nvim --clean"
git config --global user.name "${SCRIPT_VARS[git_username]}"
git config --global user.email "${SCRIPT_VARS[git_email]}"
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.hyperlinks true
git config --global delta.line-numbers true
git config --global delta.syntax-theme base16
git config --global diff.tool nvimdiff
git config --global difftool.prompt false
git config --global merge.tool nvimdiff
git config --global mergetool.prompt false
git config --global merge.conflictStyle zdiff3
# Git Credential Manager: 依赖 Windows 侧 MSYS2 安装的 GCM, 用于权限认证
git config --global credential.helper "/mnt/c/msys64/ucrt64/libexec/git-core/git-credential-manager.exe"
# 由于 MSYS2 那边已用 gh 登录, WSL 能间接获取 Github 认证信息, 因此 mise upgrade 无需设置 GITHUB_TOKEN 环境变量
# 查看信息: printf 'protocol=https\nhost=github.com\n\n' | git credential fill

# stow dotfiles
echo "=== stow dotfiles ==="
bash setup-dotfiles.sh dotfiles-wsl-arch.conf --auto
# stow --adopt 会把系统文件拉取回 dotfiles, 需要回滚
git restore .

# 安装 Mise 并按照其配置文件安装工具
echo "=== 安装 Mise ==="
curl https://mise.run | sh
$HOME/.local/bin/mise upgrade
# 二次执行, 使 npm 之类的包也被安装
$HOME/.local/bin/mise upgrade

echo ""
echo "=== 安装完成 ==="
echo "建议重启 WSL"
