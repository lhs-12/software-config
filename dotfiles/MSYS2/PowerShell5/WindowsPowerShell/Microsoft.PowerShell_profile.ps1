# $HOME\.local\bin 和 mise shims 从用户环境变量 PATH 继承, 无需在此重复添加

# 非交互 (headless / stdin 或 stdout 被重定向的脚本/agent) 跳过全部交互配置
if (-not [Environment]::UserInteractive -or [Console]::IsInputRedirected -or [Console]::IsOutputRedirected) { return }

# OhMyPosh
if ($Host.Name -eq 'ConsoleHost' -and [Environment]::UserInteractive) {
    oh-my-posh init powershell --config "$HOME\.om-posh.json" | Invoke-Expression
}

# Mise activate for interactive shells
# Mise PowerShell 5 可能有问题, 更建议用 Pwsh
$env:MISE_PWSH_CHPWD_WARNING=0 # 屏蔽 Mise PowerShell 版本告警
$miseScript = & mise activate pwsh
if ($miseScript -notmatch '&\s+"[A-Za-z]:\\[^"]+mise\.exe"') {
    $miseScript = $miseScript -replace '& ([A-Za-z]:\\[^\r\n]+mise\.exe)', '& "$1"'
}
$miseScript | Out-String | Invoke-Expression

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Yazi
Set-Alias -Name yz -Value yazi
function yy {
  $tmp = (New-TemporaryFile).FullName
  yazi.exe @args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp -Encoding UTF8
  if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
    Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
  }
  Remove-Item -Path $tmp
}

function vi { nvim --clean @args }
function vim { nvim @args }
function ll { Get-ChildItem $args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function la { Get-ChildItem -Force $args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function fdns { ipconfig /flushdns }
function Get-Port {
  param([int]$port)
  Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object LocalPort, OwningProcess
}
