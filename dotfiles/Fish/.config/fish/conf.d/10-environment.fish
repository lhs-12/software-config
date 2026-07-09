# Basic environment settings

# === Non-interactive shell config ===

# User local binaries
fish_add_path $HOME/.local/bin

# Mise shims for non-interactive shells
mise activate fish --shims | source

if not status is-interactive; exit; end

# === Interactive shell config ===

# Language
set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# Mise activate for interactive shells
mise activate fish | source

# Proxy configuration
# v2rayN 开启系统代理时, gsettings 命令输出 "manual", 此时开启 proxycfg, 否则关闭
command -v gsettings >/dev/null 2>&1; or exit 0
set mode (gsettings get org.gnome.system.proxy mode 2>/dev/null)
test "$mode" = "'manual'"; and proxycfg on >/dev/null 2>&1; or proxycfg off >/dev/null 2>&1