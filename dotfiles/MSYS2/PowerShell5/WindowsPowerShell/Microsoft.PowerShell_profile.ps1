if ($Host.Name -eq 'ConsoleHost' -and [Environment]::UserInteractive) {
  oh-my-posh init pwsh --config "$HOME\.omp.json" | Invoke-Expression
}
