# JDK配置

环境变量 -> 用户变量 -> Path增加`%JAVA_HOME%\bin`

保存脚本`jdk-version-script.ps1`, 生成快捷方式  
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

[Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, "User")
# [Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, "Machine")
Write-Host "JAVA_HOME updated for user environment"

Write-Host "press any key to exit..."
[Console]::ReadKey($true) | Out-Null
```