# JDK 配置

保存脚本`jdk-path.ps1`, 生成快捷方式  
快捷方式右键属性 -> 快捷方式 -> 目标 -> 改启动方式`powershell -File "文件路径"`

```ps1
$JDK_PATHS = @{
    "8"  = "$env:USERPROFILE\.jdks\adopt-openjdk-1.8.0_302"
    "17" = "$env:USERPROFILE\.jdks\temurin-17.0.10"
    "21" = "$env:USERPROFILE\.jdks\openjdk-21.0.2"
}

Write-Host "current JDK version:"
Write-Host "============================================="
java -version 2>&1 | ForEach-Object { Write-Host $_ }
Write-Host "============================================="

Write-Host "support JDK list:"
$JDK_PATHS.Keys | ForEach-Object { Write-Host "  jdk$_" }
Write-Host "============================================="

$opt = Read-Host "choose JDK version"
if (-not $JDK_PATHS.ContainsKey($opt)) {
    Write-Host "version does not exist !"
    exit 1
}

$JAVA_HOME = $JDK_PATHS[$opt]
Write-Host "JDK Home: $JAVA_HOME"

[Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, "User") # User/Machine
Write-Host "JAVA_HOME updated for user environment"

$regKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Environment", $false)
$rawPath = $regKey.GetValue("Path", "", [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
$regKey.Close()
if ($rawPath -like "*%JAVA_HOME%\bin*") {
    Write-Host "%JAVA_HOME%\bin is already in the user Path"
} else {
    if (!$rawPath.EndsWith(';')) { $rawPath = $rawPath + ";" }
    $newPath = $rawPath + "%JAVA_HOME%\bin;"
    # [Environment]::SetEnvironmentVariable("Path", $newPath, "User") # 有bug, 写入但不刷新
    # Write-Host "%JAVA_HOME%\bin has been added to the user Path"
    Write-Host "need to add %JAVA_HOME%\bin to Path!" -ForegroundColor Red
}

Write-Host "press any key to exit..."
[Console]::ReadKey($true) | Out-Null
```