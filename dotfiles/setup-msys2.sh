#!/usr/bin/bash
set -Eeuo pipefail
cd "$(dirname "$0")"
BASE_DIR="$PWD"

# 日志颜色
R='\e[31m'; G='\e[32m'; Y='\e[33m'; N='\e[0m'

# ===== 配置区域: 开始 =====
# 初次部署需要填写, 后续再执行全部可留空(会去找已设置过的值)
GIT_USERNAME=""   # Git 用户名
GIT_EMAIL=""      # Git 邮箱
GITHUB_TOKEN=""   # GitHub Token (留空则尝试从 git credential 获取)
GIT_PROXY=""      # Git 代理 (空=不动, 有值=设置, clear=删除)
# ===== 配置区域: 结束 =====

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

# 检查 Windows 开发者模式开启, 并设置 MSYS2 环境变量, 以支持原生符号链接
dev_mode=$(powershell.exe -Command \
  '(Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock).AllowDevelopmentWithoutDevLicense' \
  2>/dev/null | tr -d '\r')
if [[ "$dev_mode" != "1" ]]; then
  echo "Error: Windows Developer Mode is not enabled. Please enable it in Windows Settings > System > Advanced > Developer Mode" >&2
  exit 1
fi
export MSYS=winsymlinks:nativestrict

# 幂等复制: 文件内容相同则跳过
safe_cp() {
    local src="$1" dst="$2"
    [[ ! -e "$src" ]] && { echo -e "${R}ERROR:${N} $src does not exist!"; return 1; }
    if [[ -e "$dst" ]]; then
        cmp -s "$src" "$dst" && return 0
        echo -e "${Y}WARN:${N} $dst differs from $src, copy skipped!"
        return 0
    fi
    mkdir -p "$(dirname "$dst")" && cp "$src" "$dst" && echo -e "${G}OK:${N} CP $src -> $dst"
}

# 符号链接辅助函数. 不用 stow 原因: windows 目录分散不统一 ; --adopt 风险大, 使用更保守策略
# 单个文件/目录创建符号链接
safe_ln() {
    local src="$1" dst="$2"
    [[ ! -e "$src" ]] && { echo -e "${R}ERROR:${N} $src does not exist!"; return 1; }
    if [[ -L "$dst" ]]; then
        local target
        target="$(readlink "$dst")"
        [[ "$target" == "$src" ]] && return 0
        echo -e "${Y}WARN:${N} $dst is a symlink to $target, expected $src. Handle manually and retry!"
        return 0
    elif [[ -e "$dst" ]]; then
        echo -e "${Y}WARN:${N} $dst exists and is not a symlink, skipped. Handle manually and retry!"
        return 0
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst" && echo -e "${G}OK:${N} LINK $src -> $dst"
}
# 遍历源目录下每个文件, 单独建立软链接. 适用于目录中存在非托管文件的情况
safe_ln_each() {
    local src_dir="$1" dst_dir="$2"
    [[ ! -d "$src_dir" ]] && { echo -e "${R}ERROR:${N} $src_dir does not exist!"; return 1; }
    mkdir -p "$dst_dir"
    find "$src_dir" -type f | while read -r src; do
        local rel="${src#$src_dir/}"
        safe_ln "$src" "$dst_dir/$rel" || true
    done
}

# ===== 配置参数处理 =====
# GIT_USERNAME / GIT_EMAIL: 首次运行需在配置区域填写, 重跑时从 git config 回退
if command -v git &>/dev/null; then
  [[ -z "$GIT_USERNAME" ]] && GIT_USERNAME=$(git config --global user.name 2>/dev/null || true)
  [[ -z "$GIT_EMAIL" ]]    && GIT_EMAIL=$(git config --global user.email 2>/dev/null || true)
fi
if [[ -z "$GIT_USERNAME" || -z "$GIT_EMAIL" ]]; then
  echo "Error: GIT_USERNAME and GIT_EMAIL are not set." >&2
  echo "Fill them in the config section before running." >&2
  exit 1
fi

# GITHUB_TOKEN: 优先配置值, 其次从 git credential 获取
if [[ -z "$GITHUB_TOKEN" ]]; then
  GITHUB_TOKEN=$(printf 'protocol=https\nhost=github.com\n\n' | git credential fill 2>/dev/null | sed -n 's/^password=//p') || true
fi
if [[ -n "$GITHUB_TOKEN" ]]; then
  export GITHUB_TOKEN
  CURL_GH_AUTH=(-H "Authorization: Bearer $GITHUB_TOKEN")
else
  echo "Error: GITHUB_TOKEN is not set. Provide one or configure git credential." >&2
  exit 1
fi

# GIT_PROXY: 三态, 仅处理环境变量供 curl 使用 (git config 部分在 git 安装后处理)
if [[ "$GIT_PROXY" == "clear" ]]; then
  unset http_proxy https_proxy
elif [[ -n "$GIT_PROXY" ]]; then
  export http_proxy="$GIT_PROXY" https_proxy="$GIT_PROXY"
fi

# 替换 pacman 镜像源 (https://mirror.tuna.tsinghua.edu.cn/help/msys2/)
echo "Replacing pacman mirrors..."
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*

# 安装基础包和工具链
echo "Installing base packages and tooling..."
pacman -Syu --noconfirm
pacman -S --needed --noconfirm --disable-download-timeout base-devel mingw-w64-ucrt-x86_64-toolchain 2>&1 | sed '/warning:.*is up to date -- skipping/d'
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-ca-certificates && update-ca-trust
pacman -S --needed --noconfirm --disable-download-timeout \
  stow fish tmux zip unzip \
  mingw-w64-ucrt-x86_64-{neovim,tree-sitter,lsd,bat,zoxide,dust,tldr,oh-my-posh,fastfetch} \
  mingw-w64-ucrt-x86_64-{yazi,ffmpeg,jq,imagemagick,poppler,mediainfo,mdbook} \
  mingw-w64-ucrt-x86_64-{fzf,fd,ripgrep,delta} \
  2>&1 | sed '/warning:.*is up to date -- skipping/d'

# 安装 win32yank
curl -L -o win32yank-x64.zip $(curl -s "${CURL_GH_AUTH[@]}" https://api.github.com/repos/equalsraf/win32yank/releases/latest | \
jq -r '.assets[] | select(.name | test("win32yank-x64.*\\.zip$")) | .browser_download_url') \
&& unzip -qo -d /usr/bin/ win32yank-x64.zip && rm win32yank-x64.zip

# 安装 Git
echo "Installing Git..."
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-{git,git-lfs} 2>&1 | sed '/warning:.*is up to date -- skipping/d'

echo "Installing Git LFS..."
git lfs install

echo "Installing Git Credential Manager..."
curl -L -o gcm-latest.zip $(curl -s "${CURL_GH_AUTH[@]}" https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | \
jq -r '.assets[] | select(.name | test("gcm-win-x64-(?!.*symbols).*\\.zip$")) | .browser_download_url') \
&& unzip -qo -d "$(git --exec-path)" gcm-latest.zip && rm gcm-latest.zip
git credential-manager configure

echo "Configuring git..."
# git 基本配置
git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global core.quotepath false
git config --global core.editor "nvim --clean"
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
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
if [[ "$GIT_PROXY" == "clear" ]]; then
  git config --global --unset http.proxy 2>/dev/null || true
  git config --global --unset https.proxy 2>/dev/null || true
elif [[ -n "$GIT_PROXY" ]]; then
  git config --global http.proxy "$GIT_PROXY"
  git config --global https.proxy "$GIT_PROXY"
fi

# 幂等追加 PATH
append_path(){ case ":$PATH:" in *:"$1":*) ;; *) PATH="${PATH:+$PATH:}$1" ;; esac; }
mkdir -p "$HOME/.local/bin"
append_path "$HOME/.local/bin"

if command -v mise &> /dev/null; then
  mise self-update -y # 更新 Mise
else
  # 安装 Mise: 下载 mise.exe 和 mise-shim.exe 到 C:\Users\xxx\.local\bin
  echo "Installing Mise..."
  curl -L -o mise.zip $(curl -s "${CURL_GH_AUTH[@]}" https://api.github.com/repos/jdx/mise/releases/latest | \
  jq -r '.assets[] | select(.name | test("windows-x64.zip$")) | .browser_download_url' | tr -d '\r') \
  && unzip -q mise.zip -d /tmp/mise && cp /tmp/mise/mise/bin/mise*.exe "$HOME/.local/bin/" && rm -rf mise.zip /tmp/mise
fi
# Mise 配置
safe_ln "$BASE_DIR/MSYS2/Mise/.config/mise" "$HOME/.config/mise"
# Aube 配置
safe_ln "$BASE_DIR/MSYS2/Mise/.config/aube" "$HOME/.config/aube"
# 根据 Mise 配置文件安装工具
mise upgrade

# 获取 mise shims 路径
MISE_SHIMS_WIN="$(mise activate pwsh --shims 2>/dev/null | sed -n "s/.*'\([^']*\)'.*/\1/p")"
export MISE_SHIMS_WIN
# 幂等添加 Windows 用户环境变量: $HOME/.local/bin 和 mise shims
powershell.exe -NoProfile -Command - <<'PS_EOF'
$want = @("$env:USERPROFILE\.local\bin")
if ($env:MISE_SHIMS_WIN) { $want += $env:MISE_SHIMS_WIN }
$raw = (Get-Item HKCU:\Environment).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
$parts = @($raw -split ';' | Where-Object { $_ })
$norm = @($parts | ForEach-Object { $_.TrimEnd('\') })
$added = @($want | Where-Object { $_.TrimEnd('\') -notin $norm })
if ($added) { Set-ItemProperty HKCU:\Environment Path -Type ExpandString -Value (($added + $parts) -join ';'); Write-Host "Added to User PATH:"; $added | ForEach-Object { Write-Host "  + $_" } } else { Write-Host "User PATH already contains mise paths, skip." }
PS_EOF

# ===== 复制配置文件 =====
echo -e "\n\e[36m========== Deploying config files ==========\e[0m"

# --- cp 配置(适用于需要额外修改或不常改动的配置文件) ---

# Pictures
for f in ./Pictures/Pictures/Wallpapers/*; do safe_cp "$f" "$HOME/Pictures/Camera Roll/$(basename "$f")"; done
# VSCode
mkdir -p $APPDATA/Code/User
safe_cp ./VSCode/.config/Code/User/keybindings.json $APPDATA/Code/User/keybindings.json
safe_cp ./VSCode/.config/Code/User/settings.json $APPDATA/Code/User/settings.json

# --- ln -s 配置 ---

# Rime
safe_ln_each "$BASE_DIR/Rime-Ice/.local/share/fcitx5/rime" "$APPDATA/Rime"
# 适配 default.custom.yaml 中的 __include: rime_ice_suggestion:/ 引用(AUR 特殊配置)
# 前提: rime-ice 通过 git clone 安装到 $APPDATA/Rime
# 处理: 放一个空 patch 文件, 并排除git跟踪
echo 'patch:' > "$APPDATA/Rime/rime_ice_suggestion.yaml"
grep -qxF 'rime_ice_suggestion.yaml' "$APPDATA/Rime/.git/info/exclude" 2>/dev/null || echo 'rime_ice_suggestion.yaml' >> "$APPDATA/Rime/.git/info/exclude"

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

echo -e "\nMSYS2 Setup Done."
exit 0
