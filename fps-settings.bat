@echo off

setlocal enabledelayedexpansion

:chooseMode
cls
echo Choose an option:
echo 1. Normal mode (FPS 60)
echo 2. AFK mode (FPS 10)
echo 3. Custom FPS value

set /p choice="Enter your choice (1, 2, or 3): "
if "%choice%"=="1" (
    set "fpsValue=60"
) else if "%choice%"=="2" (
    set "fpsValue=10"
) else if "%choice%"=="3" (
    set /p customFps="Enter custom FPS value: "
    set "fpsValue=!customFps!"
) else (
    echo Invalid choice. Please select 1, 2, or 3.
    timeout /t 2 /nobreak > nul
    goto chooseMode
)

:: Set the target directory
set "targetDirectory=%LocalAppData%\Roblox\Versions"

:: Iterate through each version directory
for /d %%A in ("%targetDirectory%\version-*") do (
    set "clientSettingsDirectory=%%A\ClientSettings"
    if exist "!clientSettingsDirectory!" (
        rmdir /s /q "!clientSettingsDirectory!"
    )
    mkdir "!clientSettingsDirectory!"
    set "jsonFilePath=!clientSettingsDirectory!\ClientAppSettings.json"
    (
        echo {
        echo    "DFIntTaskSchedulerTargetFps": !fpsValue!
        echo }
    ) > "!jsonFilePath!"
)

echo Settings updated with FPS value: !fpsValue!
pause
exit
