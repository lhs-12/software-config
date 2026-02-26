# Basic environment settings

if not status is-interactive; exit; end # Skip non-interactive shells

# Language
set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# PATH
fish_add_path -g ~/.opencode/bin

# Mise (environment manager)
mise activate fish | source

# Proxy configuration
# v2rayN 开启系统代理时, gsettings 命令输出 "manual", 此时开启 proxycfg
command -v gsettings >/dev/null 2>&1 || exit 0
set mode (gsettings get org.gnome.system.proxy mode 2>/dev/null)
test "$mode" = "'manual'" && proxycfg on >/dev/null 2>&1