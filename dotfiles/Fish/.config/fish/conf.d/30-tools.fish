# Tools settings

# Exit if not an interactive shell
if not status is-interactive
	exit
end

# Bat (cat/less replacement)
abbr less bat
abbr cat 'bat -pp'
# Batman (man pages with bat)
batman --export-env | source

# Zoxide (smarter cd)
zoxide init fish | source

# Trash
abbr rm 'trash -v'

# Yazi
abbr yz yazi
function yy --description "Yazi with cd"
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
