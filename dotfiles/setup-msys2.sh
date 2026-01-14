#!/usr/bin/bash
set -euo pipefail

# ensure running in MSYS2 UCRT64 environment
if [[ -z "${MSYSTEM:-}" || "${MSYSTEM}" != "UCRT64" ]]; then
  echo "This script must be run from the MSYS2 UCRT64 shell, Exiting." >&2
  exit 1
fi

# replace pacman mirrors (https://mirror.tuna.tsinghua.edu.cn/help/msys2/)
echo "Replacing pacman mirrors..."
sed -i "s#https\?://mirror.msys2.org/#https://mirrors.tuna.tsinghua.edu.cn/msys2/#g" /etc/pacman.d/mirrorlist*

# install base packages and tooling
echo "Installing base packages and tooling..."
pacman -Syu --noconfirm
pacman -S --needed --noconfirm --disable-download-timeout base-devel mingw-w64-ucrt-x86_64-toolchain
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-ca-certificates && update-ca-trust
pacman -S --needed --noconfirm --disable-download-timeout \
  stow fish zip unzip \
  mingw-w64-ucrt-x86_64-{neovim,tree-sitter,lsd,bat,zoxide,dust,python-tldr} \
  mingw-w64-ucrt-x86_64-{yazi,ffmpeg,jq,imagemagick,mdbook} \
  mingw-w64-ucrt-x86_64-{fzf,fd,ripgrep,bottom}

# install win32yank
curl -L -o win32yank-x64.zip $(curl -s https://api.github.com/repos/equalsraf/win32yank/releases/latest | \
jq -r '.assets[] | select(.name | test("win32yank-x64.*\\.zip$")) | .browser_download_url') \
&& unzip -q -d /usr/bin/ win32yank-x64.zip && rm win32yank-x64.zip

# install Git
echo "Installing Git..."
pacman -S --needed --noconfirm git mingw-w64-ucrt-x86_64-git-lfs
git lfs install

echo "Installing Git Credential Manager..."
curl -L -o gcm-latest.zip $(curl -s https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/latest | \
jq -r '.assets[] | select(.name | test("gcm-win-x86-(?!.*symbols).*\\.zip$")) | .browser_download_url') \
&& unzip -q -d /usr/lib/git-core/ gcm-latest.zip && rm gcm-latest.zip

echo "Configuring git..."
git config --global init.defaultBranch main
git config --global core.autocrlf true
git config --global core.quotepath false
git config --global core.editor "nvim --clean"
git config --global credential.helper manager
git config --global user.name "your-name"                # edit name
git config --global user.email "you@example.com"         # edit email
git config --global http.proxy "http://127.0.0.1:10808"  # edit proxy
git config --global https.proxy "http://127.0.0.1:10808" # edit proxy

# 可选择给GitHub添加SSH认证
# ssh-keygen -t ed25519 -C "you@example.com" # 生成ED25519类型的SSH密钥对, 用邮箱标识
# eval "$(ssh-agent -s)"                     # 启动SSH代理, 用于管理SSH密钥
# ssh-add ~/.ssh/id_ed25519                  # 将生成私钥添加到SSH代理
# cat ~/.ssh/id_ed25519.pub | clip.exe       # 将公钥复制到Windows剪切板
# 访问https://github.com/settings/keys, 点击"New SSH key", 粘贴公钥并保存
# ssh -T git@github.com            # 测试SSH连接是否正常

# install Python UV and UV tools
echo "Installing Python UV and UV tools..."
pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-uv
uv tool install ruff@latest

# install Node.js
echo "Installing Node.js"
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
export PATH="$HOME/.local/share/fnm:$PATH"
fnm install --lts

# edit ~/.bashrc
echo "Edit ~/.bashrc"
RC="$HOME/.bashrc"
START_MARK="# >>> script-managed-bashrc-start >>>"
END_MARK="# <<< script-managed-bashrc-end <<<"
if grep -qF "$START_MARK" "$RC" 2>/dev/null; then
  echo "Removing previous managed block in $RC"
  awk -v start="$START_MARK" -v end="$END_MARK" '
    BEGIN { p=1 }
    p==1 && index($0, start)==1 { p=0; next }
    p==0 && index($0, end)==1 { p=1; next }
    p==1 { print }
  ' "$RC" > "$RC.tmp" && mv "$RC.tmp" "$RC"
fi
echo "Appending managed msys2 block to $RC"
cat >> "$RC" <<'EOF' # verify PATH command: echo $PATH | tr ':' '\n'
# >>> script-managed-bashrc-start >>>
if [ -n "$MSYSTEM" ] && [ "$MSYSTEM" = "UCRT64" ]; then
    export PATH="/d/Program Files/tools:$PATH"
    export PATH="$(cygpath -u "$(uv tool dir --bin)"):$PATH"
    export PATH="$HOME/.local/share/fnm:$PATH"
    export PATH="$(cygpath -u "$LOCALAPPDATA/Programs/Microsoft VS Code/bin"):$PATH"
    eval "$(fnm env)"
    eval "$(zoxide init bash)"
    alias ls='lsd'
    alias la='lsd -a'
    alias ll='lsd --long --header'
    alias lla='ll -a'
    alias lr='lsd --tree'
    alias lf='lsd -l | grep -v "^d"'
    alias ldir='lsd -l | grep "^d"'
    alias las='lsd -a | grep "^\."'
    alias less='bat'
    alias cat='bat -pp'
    alias vi='nvim --clean'
    alias vim='nvim'
    alias cdg='cd_g() { local d=$(fd -td "${1:-}" "${2:-.}" | fzf); [ -n "$d" ] && cd "$d"; }; cd_g'
    alias fdns='ipconfig -flushdns'
    alias sva='source .venv/Scripts/activate'
    alias yz='yazi'
    function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi
# <<< script-managed-bashrc-end <<<
EOF

echo "MSYS2 Setup Done. Please execute 'source ~/.bashrc'"
exit 0
