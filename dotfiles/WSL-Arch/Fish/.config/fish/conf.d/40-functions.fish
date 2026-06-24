# Common functions

if not status is-interactive; exit; end # Skip non-interactive shells

function start --description "Open files with the default application"
	/mnt/c/Windows/System32/cmd.exe /c start "" $argv 2>/dev/null
end

function cdg --description "Change directory with fzf"
	set dir (fd -td "$argv[1]" "." | fzf)
	test -n "$dir" && cd "$dir"
end

function mvg --description "Move and go to directory"
	mv "$argv[1]" "$argv[2]"
	test -d "$argv[2]" && cd "$argv[2]"
end

function mkdirg --description "Make directory and go to it"
	mkdir -p "$argv[1]"
	cd "$argv[1]"
end

function lazygit --description "lazygit (zh_CN)"
	LANG=zh_CN.UTF-8 command lazygit
end
