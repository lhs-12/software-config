@echo off
title Windows 11 Classic/New Context Menu Switcher

>NUL 2>&1 REG.exe query "HKU\S-1-5-19" || (
    ECHO SET UAC = CreateObject^("Shell.Application"^) > "%TEMP%\Getadmin.vbs"
    ECHO UAC.ShellExecute "%~f0", "%1", "", "runas", 1 >> "%TEMP%\Getadmin.vbs"
    "%TEMP%\Getadmin.vbs"
    DEL /f /q "%TEMP%\Getadmin.vbs" 2>NUL
    Exit /b
)

:menu
cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Please select an option:
echo.&echo  1. Switch to Classic Right-click Menu
echo.&echo  2. Restore New Right-click Menu
echo.&echo Please enter a number and press Enter
echo.

set /p user_input=Enter a number:
if %user_input% equ 1 goto old
if %user_input% equ 2 goto new
echo Invalid input, please enter a valid number.
pause
goto menu

:old
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
taskkill /f /im explorer.exe & start explorer.exe
echo Successfully switched to Classic Right-click Menu
pause
goto menu

:new
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
taskkill /f /im explorer.exe & start explorer.exe
echo Successfully restored New Right-click Menu
pause
goto menu