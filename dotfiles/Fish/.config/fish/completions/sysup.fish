complete -c sysup -f

complete -c sysup -l ui-lang -d "UI language (zh|en)" -x -a "zh en"
complete -c sysup -l news-source -d "News source (official|cn)" -x -a "official cn"
complete -c sysup -l count -d "Max number of news items" -x
complete -c sysup -s h -l help -d "Show help message"
