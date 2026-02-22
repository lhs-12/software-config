# Interactive shell settings

# Exit if not an interactive shell
if not status is-interactive
	exit
end

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
