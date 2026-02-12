function proxycfg --description "proxy config management"
	set -l PROXY_ENV \
		http_proxy https_proxy ftp_proxy rsync_proxy all_proxy \
		HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY

	switch $argv[1]
		case on
			set -gx proxy   "http://127.0.0.1:10808"
			set -gx noproxy "localhost,127.0.0.1,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
			for envar in (string split ' ' $PROXY_ENV)
				set -gx $envar $proxy
			end
			set -gx no_proxy $noproxy
			set -gx NO_PROXY $noproxy
			git config --global http.proxy  $proxy
			git config --global https.proxy $proxy
			echo "Proxy enabled: $proxy"

		case off
			for envar in (string split ' ' $PROXY_ENV)
				set -eg $envar
			end
			set -eg no_proxy NO_PROXY
			git config --global --unset http.proxy
			git config --global --unset https.proxy
			echo "Proxy disabled"

		case status
			echo "=== Proxy Status ==="
			for envar in (string split ' ' $PROXY_ENV) no_proxy NO_PROXY
				set -l val (printenv $envar 2>/dev/null)
				printf '%-12s %s\n' $envar (set -q $envar && echo $val || echo "(not set)")
			end
			set -l val (git config --global --get http.proxy 2>/dev/null)
			printf '%-12s %s\n' git_http (test -n "$val" && echo $val || echo "(not set)")
			set -l val (git config --global --get https.proxy 2>/dev/null)
			printf '%-12s %s\n' git_https (test -n "$val" && echo $val || echo "(not set)")
			echo "==================="

		case '*'
			echo "Usage: proxy {on|off|status}"
	end
end
