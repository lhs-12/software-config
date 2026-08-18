# $HOME\.local\bin 和 mise shims 从用户环境变量 PATH 继承, 无需在此重复添加

# 非交互 (headless / stdin 或 stdout 被重定向的脚本/agent) 跳过全部交互配置
if (-not [Environment]::UserInteractive -or [Console]::IsInputRedirected -or [Console]::IsOutputRedirected) { return }

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete # Tab 补全菜单
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# OhMyPosh
if ($Host.Name -eq 'ConsoleHost' -and $env:TERM_PROGRAM -ne 'vscode') {
  oh-my-posh init powershell --config "$HOME\.om-posh.json" | Invoke-Expression
}

# Mise activate for interactive shells
# Mise PowerShell 5 可能有问题, 更建议用 Pwsh
$env:MISE_PWSH_CHPWD_WARNING=0 # 屏蔽 Mise PS5 版本告警 (没有 chpwd 能力)
(& mise activate pwsh) | Out-String | Invoke-Expression

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Yazi
Set-Alias yz yazi
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
function eprofile { nvim $PROFILE }
function reload { . $PROFILE }
function fdns { ipconfig /flushdns }
function print_path { $env:Path -split ';' | Where-Object { $_ } }
function which {
    param([Parameter(Mandatory)][string]$Command)
    $result = Get-Command $Command -ErrorAction SilentlyContinue
    if ($null -eq $result) {
        Write-Output "$Command not found"
        return
    }
    $result.Source
}
function get_port {
  param( [Parameter(Mandatory)] [int]$Port)
  Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
    ForEach-Object {
      $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
      [PSCustomObject]@{
        LocalAddress  = $_.LocalAddress
        LocalPort     = $_.LocalPort
        State         = $_.State
        PID           = $_.OwningProcess
        Process       = $process.ProcessName
      }
    }
}
