#!/usr/bin/bash
set -Eeuo pipefail
cd "$(dirname "$0")"
BASE_DIR="$PWD"

# 确保在 MSYS2 UCRT64 环境中运行
if [[ -z "${MSYSTEM:-}" || "${MSYSTEM}" != "UCRT64" ]]; then
  echo "This script must be run from the MSYS2 UCRT64 shell, Exiting." >&2
  exit 1
fi

# 确保 HOME 目录与 Windows 统一
if ! grep -qE '^[[:space:]]*db_home:[[:space:]]+windows' /etc/nsswitch.conf 2>/dev/null; then
  echo "Error: HOME directory is not unified with Windows." >&2
  echo "Please edit /etc/nsswitch.conf to set 'db_home: windows' and migrate home directory files," >&2
  echo "then close all MSYS2 terminal processes and reopen to continue." >&2
  exit 1
fi

# ===== 配置区域: 开始 =====
# 必填参数
declare -A REQUIRED_VARS
REQUIRED_VARS["git_username"]=""  # 设置 Git 用户名
REQUIRED_VARS["git_email"]=""     # 设置 Git 邮箱
# 选填参数(可为空)
declare -A OPTIONAL_VARS
OPTIONAL_VARS["git_proxy"]=""     # 设置 Git 代理地址, 比如 http://127.0.0.1:10808
OPTIONAL_VARS["github_token"]=""  # 设置 GITHUB_TOKEN, 用于解决 Github 访问限流(更建议放 Windows 用户环境变量)
# ===== 配置区域: 结束 =====

# 安全创建符号链接函数
safe_ln() {
    local src="$1" dst="$2"
    [[ ! -e "$src" ]] && { echo "ERROR: $src 不存在"; return 1; }
    [[ -e "$dst" || -L "$dst" ]] && { echo "WARN: $dst 已存在, 跳过"; return 0; }
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst" && echo "OK: $dst"
}
safe_ln_each() {
    local src_dir="$1" dst_dir="$2"
    [[ ! -d "$src_dir" ]] && { echo "ERROR: $src_dir 不存在"; return 1; }
    mkdir -p "$dst_dir"
    find "$src_dir" -type f | while read -r src; do
        local rel="${src#$src_dir/}"
        safe_ln "$src" "$dst_dir/$rel" || true
    done
}

# 设置 MSYS2 环境变量以支持原生符号链接
export MSYS=winsymlinks:nativestrict

# 检查必填参数
for param in "${!REQUIRED_VARS[@]}"; do
  if [[ -z "${REQUIRED_VARS[$param]}" ]]; then
    echo "Error: Required parameter '$param' is not set. Please edit the configuration." >&2
    exit 1
  fi
done

# GITHUB_TOKEN 参数处理: 环境变量 ; curl 请求头
if [[ -n "${OPTIONAL_VARS[github_token]:-}" ]]; then
  export GITHUB_TOKEN=${OPTIONAL_VARS[github_token]}
  CURL_GH_AUTH=(-H "Authorization: Bearer ${OPTIONAL_VARS[github_token]}")
else
  CURL_GH_AUTH=()
fi

# git_proxy 参数处理: 该参数不为空, 说明用户使用了系统代理, 脚本中设置相关网络变量优化下载 http(s)_proxy (可作用于 curl)
if [[ -n "${OPTIONAL_VARS[git_proxy]:-}" ]]; then
  export http_proxy="${OPTIONAL_VARS[git_proxy]}"
  export https_proxy="${OPTIONAL_VARS[git_proxy]}"
fi

# 替换 pacman 镜像源 (https://mirror.tuna.tsinghua.edu.cn/help/msys2/)
echo "Replacing pacman mirrors..."
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*

# 安装基础包和工具链
echo "Installing base packages and tooling..."
pacman -Syu --noconfirm
pacman -S --needed --noconfirm --disable-download-timeout base-devel mingw-w64-ucrt-x86_64-toolchain
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-ca-certificates && update-ca-trust
pacman -S --needed --noconfirm --disable-download-timeout \
  stow fish tmux zip unzip \
  mingw-w64-ucrt-x86_64-{neovim,tree-sitter,lsd,bat,zoxide,dust,tldr,oh-my-posh,fastfetch} \
  mingw-w64-ucrt-x86_64-{yazi,ffmpeg,jq,imagemagick,poppler,mediainfo,mdbook} \
  mingw-w64-ucrt-x86_64-{fzf,fd,ripgrep,delta}

# 安装 win32yank
curl -L -o win32yank-x64.zip $(curl -s "${CURL_GH_AUTH[@]}" https://api.github.com/repos/equalsraf/win32yank/releases/latest | \
jq -r '.assets[] | select(.name | test("win32yank-x64.*\\.zip$")) | .browser_download_url') \
&& unzip -q -d /usr/bin/ win32yank-x64.zip && rm win32yank-x64.zip

# 安装 Git
echo "Installing Git..."
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-{git,git-lfs}

echo "Installing Git LFS..."
git lfs install

echo "Installing Git Credential Manager..."
curl -L -o gcm-latest.zip $(curl -s "${CURL_GH_AUTH[@]}" https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | \
jq -r '.assets[] | select(.name | test("gcm-win-x64-(?!.*symbols).*\\.zip$")) | .browser_download_url') \
&& unzip -q -d "$(git --exec-path)" gcm-latest.zip && rm gcm-latest.zip
git credential-manager configure

echo "Configuring git..."
# git 基本配置
git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global core.quotepath false
git config --global core.editor "nvim --clean"
git config --global user.name "${REQUIRED_VARS[git_username]}"
git config --global user.email "${REQUIRED_VARS[git_email]}"
# git diff/merge: 使用 git-delta 和 neovim
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
# 不设置 delta.side-by-side true , 需要时加环境变量: DELTA_FEATURES=+side-by-side git diff
# git 代理设置
if [[ -n "${OPTIONAL_VARS[git_proxy]:-}" ]]; then
  git config --global http.proxy "${OPTIONAL_VARS[git_proxy]}"
  git config --global https.proxy "${OPTIONAL_VARS[git_proxy]}"
else
  git config --global --unset http.proxy 2>/dev/null || true
  git config --global --unset https.proxy 2>/dev/null || true
fi

# 可选择给GitHub添加SSH认证
# ssh-keygen -t ed25519 -C "you@example.com" # 生成ED25519类型的SSH密钥对, 用邮箱标识
# eval "$(ssh-agent -s)"                     # 启动SSH代理, 用于管理SSH密钥
# ssh-add ~/.ssh/id_ed25519                  # 将生成私钥添加到SSH代理
# cat ~/.ssh/id_ed25519.pub | clip.exe       # 将公钥复制到Windows剪切板
# 访问 https://github.com/settings/keys , 点击"New SSH key", 粘贴公钥并保存
# ssh -T git@github.com                      # 测试SSH连接是否正常

# 安装 Mise: 下载 mise.exe 和 mise-shim.exe 到 C:\Users\xxx\.local\bin
# 安装后可通过命令升级: mise self-update
echo "Installing Mise..."
curl -L -o mise.zip $(curl -s "${CURL_GH_AUTH[@]}" https://api.github.com/repos/jdx/mise/releases/latest | \
jq -r '.assets[] | select(.name | test("windows-x64.zip$")) | .browser_download_url' | tr -d '\r') \
&& unzip -q mise.zip -d /tmp/mise && cp /tmp/mise/mise/bin/mise*.exe "$HOME/.local/bin/" && rm -rf mise.zip /tmp/mise
# Mise 配置
safe_ln "$BASE_DIR/MSYS2/Mise/config.toml" "$HOME/.config/mise/config.toml"
# Aube 配置
safe_ln "$BASE_DIR/MSYS2/Aube/config.toml" "$HOME/.config/aube/config.toml"
# 根据 Mise 配置文件安装工具
$HOME/.local/bin/mise upgrade

# ===== 复制配置文件 =====

# --- cp 配置(有运行时文件或需要额外修改的) ---
# Pictures
cp ./Pictures/Pictures/Wallpapers/* "$HOME/Pictures/Camera Roll"
# VSCode
mkdir -p $APPDATA/Code/User
cp ./VSCode/.config/Code/User/keybindings.json $APPDATA/Code/User/
cp ./VSCode/.config/Code/User/settings.json $APPDATA/Code/User/

# --- ln -s 配置 ---
# Rime
safe_ln_each "$BASE_DIR/Rime-Ice/.local/share/fcitx5/rime" "$APPDATA/Rime"
# WezTerm
safe_ln "$BASE_DIR/WezTerm/.wezterm.lua" "$HOME/.wezterm.lua"
# Shell: Bash + Fish + PowerShell + Pwsh
safe_ln_each "$BASE_DIR/MSYS2/Bash" "$HOME"
safe_ln "$BASE_DIR/MSYS2/Fish/.config/fish" "$HOME/.config/fish"
safe_ln "$BASE_DIR/MSYS2/PowerShell5/WindowsPowerShell" "$HOME/Documents/WindowsPowerShell"
safe_ln "$BASE_DIR/MSYS2/Pwsh/PowerShell" "$HOME/Documents/PowerShell"
# OhMyPosh
safe_ln "$BASE_DIR/OhMyPosh/.om-posh.json" "$HOME/.om-posh.json"
# FastFetch
safe_ln "$BASE_DIR/FastFetch/.config/fastfetch" "$HOME/.config/fastfetch"
# Yazi
safe_ln "$BASE_DIR/Yazi/.config/yazi" "$APPDATA/yazi/config"
# LazyVim
safe_ln "$BASE_DIR/LazyVim/.config/nvim" "$LOCALAPPDATA/nvim"
# Jetbrains
safe_ln "$BASE_DIR/Jetbrains/.ideavimrc" "$HOME/.ideavimrc"
# Ruff
safe_ln "$BASE_DIR/Ruff/.config/ruff" "$APPDATA/ruff"

echo "MSYS2 Setup Done."
exit 0
