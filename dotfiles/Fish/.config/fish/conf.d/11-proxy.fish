# Proxy configuration

if not status is-interactive; exit; end # Skip non-interactive shells

# v2rayN 开启系统代理时, gsettings 命令输出 "manual", 此时开启 proxycfg
command -v gsettings >/dev/null 2>&1 || exit 0
set mode (gsettings get org.gnome.system.proxy mode 2>/dev/null)
test "$mode" = "'manual'" && proxycfg on >/dev/null 2>&1