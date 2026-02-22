# Proxy configuration

# Exit if not an interactive shell
if not status is-interactive
	exit
end

# v2rayN 开启系统代理时, gsettings 命令输出 "manual", 此时开启 proxycfg
command -v gsettings >/dev/null 2>&1 || exit 0
set mode (gsettings get org.gnome.system.proxy mode 2>/dev/null)
test "$mode" = "'manual'" && proxycfg on >/dev/null 2>&1