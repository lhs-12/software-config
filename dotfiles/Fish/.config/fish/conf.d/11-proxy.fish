# Proxy configuration

# Exit if not an interactive shell
if not status is-interactive
	exit
end

proxycfg on 1>/dev/null 2>&1 # enable proxy by default