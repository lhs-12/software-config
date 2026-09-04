complete -c archupdate -f

complete -c archupdate -l ui-lang -d "UI language (zh|en)" -x -a "zh en"
complete -c archupdate -l news-source -d "News source (official|cn)" -x -a "official cn"
complete -c archupdate -l count -d "Max number of news items" -x
complete -c archupdate -s h -l help -d "Show help message"
