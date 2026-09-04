if not test -n "$MSYSTEM"; or not test "$MSYSTEM" = "UCRT64"; exit; end # only execute in MSYS2 UCRT64

# === Non-interactive shell config ===

# User local binaries
fish_add_path -g "$HOME/.local/bin"

# Mise shims for non-interactive shells (fix MSYS2)
mise activate fish --shims | perl -pe 's{([A-Za-z]:[\x5c/][^\x27:\s]*)}{ my $p = qx(cygpath -u "$1"); chomp $p; $p }eg' | source

if not status is-interactive; exit; end

# === Interactive shell config ===

function fish_greeting
end

set -gx LANG en_US.UTF-8 # zh_CN.UTF-8
set -gx LANGUAGE en_US   # zh_CN:en_US

# add PATH
fish_add_path -g "/c/Program Files/PowerShell/7"
fish_add_path -g "/c/Program Files/WezTerm"
fish_add_path -g (cygpath -u "$LOCALAPPDATA/Programs/Microsoft VS Code/bin")

# Multilevel cd ( .. ... .... , etc)
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.+$' --function multicd

# Prompt (Oh My Posh)
if test "$TERM_PROGRAM" != "vscode" # Skip in VSCode integrated terminal
    # Initialize
    oh-my-posh init fish --config ~/.om-posh.json | source

    # refresh prompt on directory change
    function rerender_on_dir_change --on-variable PWD
        omp_repaint_prompt
    end
end

# Mise activate for interactive shells (fix MSYS2)
function mise_activate
    function __mise_hook_env_fix
        /usr/bin/perl -MIPC::Open2 -e '
            while (<STDIN>) {
                if (/^set -gx PATH (.*)/) {
                    my @p = $1 =~ /\x27([^\x27]*)\x27/g;
                    my $pid = open2(my $out, my $in, "/usr/bin/cygpath", "-u", "-f", "-");
                    print $in join("\n", @p), "\n"; close $in;
                    my @u = <$out>; close $out; waitpid $pid, 0;
                    chomp @u;
                    print "set -gx PATH ", join(" ", map {"\x27$_\x27"} @u), "\n";
                } else { print }
            }
        '
    end
    set -l _mise_path (command -v mise)
    mise activate fish |
    string replace -a -- (cygpath -w "$_mise_path") "$_mise_path" |
    string replace -a -- 'hook-env -s fish | source' 'hook-env -s fish | __mise_hook_env_fix | source' |
    string replace -- '|psub)' '| __mise_hook_env_fix | psub)' | __mise_hook_env_fix | source
end
mise_activate

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
    if read -z raw_cwd < "$tmp"
        set cwd (cygpath -u "$raw_cwd")
        if [ "$cwd" != "$PWD" ]; and test -d "$cwd"
            builtin cd -- "$cwd"
        end
    end
    rm -f -- "$tmp"
end

# === Functions ===
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

# === Abbreviations ===
# Editor aliases
abbr vi 'nvim --clean'
abbr vim nvim
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
# Flush DNS
abbr fdns 'ipconfig -flushdns'
