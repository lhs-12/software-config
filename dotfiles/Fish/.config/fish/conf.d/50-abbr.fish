# Abbreviations

if not status is-interactive; exit; end # Skip non-interactive shells

# Editor aliases
abbr vi 'nvim --clean'
abbr vim nvim
abbr svi 'sudo nvim'
abbr code 'code --ozone-platform=wayland'

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
abbr h 'history | grep'

# Process search
abbr p 'ps aux | grep'
abbr topcpu '/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'
abbr topmem '/bin/ps -eo pmem,pid,user,args | sort -k 1 -r | head -10'
