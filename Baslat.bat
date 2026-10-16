@echo off
chcp 65001 >nul
setlocal
set SDKROOT=%LOCALAPPDATA%\CleanDroid\sdk
if not exist "%SDKROOT%\emulator\emulator.exe" (
  echo Emulator bulunamadi: %SDKROOT%
  echo Once Kurulum.bat calistir.
  pause
  exit /b 1
)
echo EminayDroid baslatiliyor...
start "EminayDroid" "%SDKROOT%\emulator\emulator.exe" -avd EminayDroid -netdelay none -netspeed full -no-snapshot-save
"%SDKROOT%\platform-tools\adb.exe" wait-for-device
"%SDKROOT%\platform-tools\adb.exe" devices
echo Hazir. Kapatmak icin emulator penceresini kapatman yeterli.
pause
