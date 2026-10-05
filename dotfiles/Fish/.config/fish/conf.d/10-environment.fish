# Basic environment settings

# === Non-interactive shell config ===

# User local binaries
fish_add_path -g $HOME/.local/bin

# Mise shims for non-interactive shells
mise activate fish --shims | source

if not status is-interactive; exit; end

# === Interactive shell config ===

# Language
set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# Mise activate for interactive shells
mise activate fish | source

# WSL
if test -n "$WSL_DISTRO_NAME$WSL_INTEROP"
  # Input method (WSLg / XWayland)
  set -gx XMODIFIERS @im=fcitx
  set -gx GTK_IM_MODULE fcitx
  set -gx QT_IM_MODULE fcitx
  # VSCode from Windows
  fish_add_path -g "/mnt/c/Users/L/AppData/Local/Programs/Microsoft VS Code/bin"
  # 提前结束, WSL 不配置代理
  return 0
end

# Follow system proxy on shell start (gsettings or kioslaverc backend)
type -q proxycfg; or return 0
proxycfg on >/dev/null 2>&1; or proxycfg off >/dev/null 2>&1
