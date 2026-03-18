if not status is-interactive; exit; end # Skip non-interactive shells
if not test -n "$MSYSTEM"; or not test "$MSYSTEM" = "UCRT64"; exit; end # only execute in MSYS2 UCRT64

function fish_greeting
end

set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# add PATH
fish_add_path -g "/d/Program Files/tools"
fish_add_path -g "/c/Program Files/Docker/Docker/resources/bin"
fish_add_path -g (cygpath -u "$LOCALAPPDATA/Programs/Microsoft VS Code/bin")
fish_add_path -g (cygpath -u (uv tool dir --bin))
fish_add_path -g "$HOME/.local/share/fnm"

# Multilevel cd ( .. ... .... , etc)
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.+$' --function multicd

# Prompt (Oh My Posh)
if test "$TERM_PROGRAM" != "vscode" # Skip in VSCode integrated terminal
    # Initialize
    oh-my-posh init fish --config ~/.omp.json | source

    # refresh prompt on directory change
    function rerender_on_dir_change --on-variable PWD
        omp_repaint_prompt
    end
end

# Bat (cat/less replacement)
abbr less bat
abbr cat 'bat -pp'

# Zoxide (smarter cd)
zoxide init fish | source

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

# cd into fzf directory
function cdg --description "Change directory with fzf"
	set dir (fd -td "$argv[1]" "." | fzf)
	test -n "$dir" && cd "$dir"
end

# === Abbreviations ===
# Editor aliases
abbr vi 'nvim --clean'
abbr vim nvim
abbr svi 'sudo nvim'
# Directory listing (lsd)
abbr ls lsd
abbr la 'lsd -a'
abbr ll 'lsd --long --header'
abbr lla 'lsd --long --header -a'
abbr lr 'lsd --tree'
abbr lf 'lsd -l | grep -v "^d"'
abbr ldir 'lsd -l | grep "^d"'
abbr las 'lsd -a | grep "^\."'
# Grep with color
abbr grep 'grep --color=auto'
# Ripgrep
abbr rgi 'rg -i'          # Case insensitive search
abbr rgs 'rg -S'          # Smart-case search
abbr rgh 'rg -i --hidden' # Search everything including hidden files
abbr rgw 'rg -w'          # Whole word matching
abbr rgc 'rg -c'          # Count matches
abbr rgl 'rg -l'          # Only show filenames with matches
abbr rgf 'rg -F'          # Fixed strings (literal) search
abbr rgu 'rg -uu'         # Unrestricted: ignore .gitignore and search hidden
abbr rgp 'rg --sort path' # Sort output by file path
# History search
abbr h 'history -r | grep'
# Process search
abbr p 'ps aux | grep'
