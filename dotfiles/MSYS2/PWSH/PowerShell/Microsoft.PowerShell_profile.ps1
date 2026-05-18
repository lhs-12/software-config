$PSStyle.FileInfo.Directory = "`e[38;2;54;178;212m"
if ($Host.Name -eq 'ConsoleHost' -and [Environment]::UserInteractive) {
  oh-my-posh init pwsh --config "$HOME\.omp.json" | Invoke-Expression
}
