# JDK 配置

保存脚本`jdk-path.ps1`, 生成快捷方式  
快捷方式右键属性 -> 快捷方式 -> 目标 -> 改启动方式`powershell -File "文件路径"`

```ps1
$JDK_PATHS = [ordered]@{
    "8"  = "$env:USERPROFILE\.jdks\adopt-openjdk-1.8.0_302"
    "17" = "$env:USERPROFILE\.jdks\temurin-17.0.10"
    "21" = "$env:USERPROFILE\.jdks\openjdk-21.0.2"
}

Write-Host "Current JDK Version:"
Write-Host "============================================="
java -version 2>&1 | Write-Host
Write-Host "============================================="

Write-Host "Supported JDK Versions:"
$JDK_PATHS.Keys | ForEach-Object { Write-Host "  JDK $_" }
Write-Host "============================================="

$opt = Read-Host "Select JDK version"
if (-not $JDK_PATHS.Contains($opt)) {
    Write-Host "Invalid version selected!"
    exit 1
}

$regKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Environment", $false)
$rawPath = $regKey.GetValue("Path", "", [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
$regKey.Close()
if ($rawPath -like "*%JAVA_HOME%\bin*") {
    Write-Host "%JAVA_HOME%\bin already in user Path"
} else {
    if (!$rawPath.EndsWith(';')) { $rawPath += ";" }
    $newPath = $rawPath + "%JAVA_HOME%\bin;"
    Set-ItemProperty -Path "HKCU:\Environment" -Name "Path" -Value $newPath -Type ExpandString
    Write-Host "%JAVA_HOME%\bin added to user Path"
}

$JAVA_HOME = $JDK_PATHS[$opt]
Write-Host "Selected JDK Home: $JAVA_HOME"
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, "User") # User/Machine
Set-ItemProperty -Path "HKCU:\Environment" -Name "JAVA_HOME" -Value $JAVA_HOME -Type ExpandString
Write-Host "JAVA_HOME updated"

Write-Host "Press any key to exit..."
[Console]::ReadKey($true) | Out-Null
```