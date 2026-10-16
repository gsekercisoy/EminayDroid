@echo off
chcp 65001 >nul
setlocal
set SDKROOT=%LOCALAPPDATA%\CleanDroid\sdk
if "%~1"=="" (
  echo Kullanim: APK-Kur.bat uygulama.apk
  echo   ornek: APK-Kur.bat C:\Indirilenler\oyun.apk
  pause
  exit /b 1
)
if not exist "%~1" (
  echo APK bulunamadi: %~1
  pause
  exit /b 1
)
"%SDKROOT%\platform-tools\adb.exe" wait-for-device
"%SDKROOT%\platform-tools\adb.exe" install -r "%~1"
pause
