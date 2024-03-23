# JDK配置

系统变量PATH增加`%JAVA_HOME%\bin`

配置JDK版本切换脚本, 管理员权限运行
```bat
@echo off
:init
set JAVA_HOME_08=C:\Users\L\.jdks\adopt-openjdk-1.8.0_302
set JAVA_HOME_17=C:\Users\L\.jdks\temurin-17.0.10
set JAVA_HOME_21=C:\Users\L\.jdks\openjdk-21.0.2
:start

echo current JDK version:
echo =============================================
java -version
echo =============================================
echo support JDK list:
echo  jdk8
echo  jdk17
echo  jdk21
echo =============================================
:select
set /p opt=choose JDK version:
if %opt%==8 (
    set JAVA_HOME=%JAVA_HOME_08%
)
if %opt%==17 (
    set JAVA_HOME=%JAVA_HOME_17%
)
if %opt%==21 (
    set JAVA_HOME=%JAVA_HOME_21%
)

echo choose JDK path:%JAVA_HOME%

wmic ENVIRONMENT where "name='JAVA_HOME'" delete
wmic ENVIRONMENT create name="JAVA_HOME",username="<system>",VariableValue="%JAVA_HOME%"

echo press any key to exit
pause>nul

@echo on
```