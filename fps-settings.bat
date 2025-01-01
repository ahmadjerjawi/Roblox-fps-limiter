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

:: Verify if RobloxPlayerBeta.exe exists
set "base_path=%LocalAppData%\Roblox\Versions"
for /f "tokens=*" %%i in ('where /r "%base_path%" RobloxPlayerBeta.exe') do (
    set "roblox_folder=%%~dpi"
    goto :applySettings
)

:: If RobloxPlayerBeta.exe isn't found, show an error and exit
echo Roblox Not Found.
echo Please make sure Roblox is installed in the expected directory (AppData\Local\Roblox).
pause
exit /b

:applySettings
:: Set the ClientSettings directory path
set "clientSettingsPath=%roblox_folder%ClientSettings"

:: Create or clean the ClientSettings directory
if exist "%clientSettingsPath%" (
    rmdir /s /q "%clientSettingsPath%"
)
mkdir "%clientSettingsPath%"

:: Write the JSON file with additional settings
set "jsonFilePath=%clientSettingsPath%\ClientAppSettings.json"
(
    echo {
    echo   "DFIntTaskSchedulerTargetFps": !fpsValue!,
    echo   "FFlagReportFpsAndGfxQualityPercentiles": false
    echo }
) > "%jsonFilePath%"

echo Successfully updated settings with FPS value: !fpsValue!.
echo Kindly note that you may need to reapply these settings weekly due to Roblox updates.
pause
exit /b
