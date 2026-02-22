# Common functions

if not status is-interactive; exit; end # Skip non-interactive shells

# Open with default app (Windows Style)
function start --description "Open files with the default application"
	env LANGUAGE=zh_CN.UTF-8 nohup xdg-open $argv </dev/null >/dev/null 2>&1 &
end

# cd into fzf directory
function cdg --description "Change directory with fzf"
	set dir (fd -td "$argv[1]" "." | fzf)
	test -n "$dir" && cd "$dir"
end

# Move and go to directory
function mvg --description "Move and go to directory"
	mv "$argv[1]" "$argv[2]"
	test -d "$argv[2]" && cd "$argv[2]"
end

# Create and go to directory
function mkdirg --description "Make directory and go to it"
	mkdir -p "$argv[1]"
	cd "$argv[1]"
end
