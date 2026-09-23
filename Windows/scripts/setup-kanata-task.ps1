# 功能: 自动安装 Kanata (下载/解压/配置文件) 并导入任务计划 (需以管理员身份运行 PowerShell)
# 用法: 管理员 PowerShell 中执行: powershell -ExecutionPolicy Bypass -File setup-kanata-task.ps1
# 
# 本脚本模拟以下手工操作:
# 1. 从 [kanata](https://github.com/jtroo/kanata) 下载 `windows-binaries-x64.zip`
# 2. 解压得到 `kanata_windows_gui_winIOv2_x64.exe`
# 3. 将 exe 文件和配置文件 `capslock+.kbd` 放到 `C:\Program Files\kanata`
# 4. 配置 Windows 的 任务计划程序(Task Scheduler)
#     4.1. 按 `Win + R`, 运行 `taskschd.msc`
#     4.2. 右侧点击 "创建任务..." (注意不是基本任务)
#     4.3. `常规`选项卡 -> 名称: `Kanata CapsLock+`, 勾选 "只在用户登录时运行" 和 "使用最高权限运行"
#     4.4. `触发器`选项卡 -> 点击 "新建", 选择 "登录时", 选择 "特定的用户". 设置 "延迟任务时间" 10 秒
#     4.5. `操作`选项卡 -> 点击 "新建", 操作选 "启动程序"
#         - "程序或脚本": `kanata_windows_gui_winIOv2_x64.exe`
#         - "添加参数": `-c capslock+.kbd`
#         - "起始于": `C:\Program Files\kanata\`
#     4.6. `条件`选项卡 -> 取消勾选 "只有在计算机使用交流电源时才启动此任务"
#     4.7. `设置`选项卡 -> 取消勾选 "如果任务运行时间超过以下时间, 停止任务"
#     4.8. 立即使用: 右键点击运行任务计划程序库中的 Kanata 任务

$ErrorActionPreference = "Stop"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "请以管理员身份打开 PowerShell 后重新运行" -ForegroundColor Yellow
    exit 1
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallDir = "C:\Program Files\Kanata"
$ExeName = "kanata_windows_gui_winIOv2_x64.exe"
$KbdName = "capslock+.kbd"

# ===== 1. 下载安装 kanata =====
$ExePath = Join-Path $InstallDir $ExeName
if (-not (Test-Path $ExePath)) {
    Write-Host "正在获取 kanata 最新版本..."
    $Latest = curl.exe -sIL -o NUL -w "%{url_effective}" "https://github.com/jtroo/kanata/releases/latest"
    if ($LASTEXITCODE -ne 0 -or $Latest -notmatch "/tag/([^/]+)/?$") {
        throw "获取 kanata 版本失败: $Latest"
    }
    $Version = $Matches[1]
    $Auth = @()
    if ($env:GITHUB_TOKEN) { $Auth += @("-H", "Authorization: Bearer $env:GITHUB_TOKEN") }
    $Zip = Join-Path $env:TEMP "kanata-bin.zip"
    Write-Host "下载 kanata $Version..."
    curl.exe -fL @Auth -o $Zip "https://github.com/jtroo/kanata/releases/download/$Version/windows-binaries-x64.zip"
    if ($LASTEXITCODE -ne 0) { throw "下载 kanata 失败" }
    # 解压并复制所需 exe
    $ExtractDir = Join-Path $env:TEMP "kanata-extract"
    if (Test-Path $ExtractDir) { Remove-Item $ExtractDir -Recurse -Force }
    Expand-Archive -Path $Zip -DestinationPath $ExtractDir -Force
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Copy-Item (Join-Path $ExtractDir $ExeName) $ExePath -Force
    Remove-Item $ExtractDir -Recurse -Force
    Remove-Item $Zip -Force
    Write-Host "kanata $Version 已安装到 $InstallDir" -ForegroundColor Green
} else {
    Write-Host "kanata 已存在, 跳过下载"
}

# ===== 2. 配置文件 capslock+.kbd (从 repo 复制) =====
$KbdPath = Join-Path $InstallDir $KbdName
$KbdSrc = [System.IO.Path]::GetFullPath((Join-Path $ScriptDir "..\..\dotfiles\Kanata\.config\kanata\capslock+.kbd"))
if (Test-Path $KbdSrc) {
    Copy-Item $KbdSrc $KbdPath -Force
    Write-Host "已复制 $KbdName" -ForegroundColor Green
} else {
    Write-Host "警告: 未找到 $KbdName, 请手动放到 $InstallDir" -ForegroundColor Yellow
}

# ===== 3. 导入任务计划 =====
$TaskName = "Kanata CapsLock+"

# 任务计划模板 (__COMPUTER__/__USER__ 导入前替换为当前机器信息)
# 触发器 UserId 不能省略 (省略=任意用户登录触发)
$Template = @'
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <Principals>
    <Principal id="Author">
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
  </Settings>
  <Triggers>
    <LogonTrigger>
      <Delay>PT10S</Delay>
      <UserId>__COMPUTER__\__USER__</UserId>
    </LogonTrigger>
  </Triggers>
  <Actions Context="Author">
    <Exec>
      <Command>__EXENAME__</Command>
      <Arguments>-c __KBDNAME__</Arguments>
      <WorkingDirectory>__INSTALLDIR__</WorkingDirectory>
    </Exec>
  </Actions>
</Task>
'@

$xml = $Template.TrimStart().
    Replace("__COMPUTER__", $env:COMPUTERNAME).
    Replace("__USER__", $env:USERNAME).
    Replace("__INSTALLDIR__", $InstallDir).
    Replace("__EXENAME__", $ExeName).
    Replace("__KBDNAME__", $KbdName)

# 任务已存在则跳过导入
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Write-Host "任务已存在: $TaskName, 跳过导入"
} else {
    $TempXml = Join-Path $env:TEMP "kanata-task.xml"
    # schtasks 要求 UTF-16 编码, 写入临时文件后导入
    [System.IO.File]::WriteAllText($TempXml, $xml, [System.Text.Encoding]::Unicode)
    try {
        & schtasks /create /tn $TaskName /xml $TempXml /f
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        Write-Host "`n任务已创建: $TaskName" -ForegroundColor Green
    } finally {
        Remove-Item $TempXml -Force -ErrorAction SilentlyContinue
    }
}

if (Get-Process -Name "kanata_windows_gui*" -ErrorAction SilentlyContinue) {
    Write-Host "kanata 已在运行, 无需启动"
} else {
    $run = Read-Host "立即运行 Kanata 任务? (Y/N)"
    if ($run -eq "Y" -or $run -eq "y") {
        & schtasks /run /tn $TaskName
    }
}
