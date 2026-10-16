@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title EminayDroid Kurulum (reklamsiz Android emulatoru)

rem ---- sabit konum: tasinabilir, yol bagimsiz ----
set SDKROOT=%LOCALAPPDATA%\CleanDroid\sdk
set AVDNAME=EminayDroid
set SYSIMG=system-images;android-34;google_apis_playstore;x86_64
echo SDK konumu: %SDKROOT%
echo.

where winget >nul 2>nul
if errorlevel 1 (
  echo HATA: winget bulunamadi. Microsoft Store'dan "App Installer" kurup tekrar dene.
  pause
  exit /b 1
)

echo [1/5] JDK 17 kontrolu...
where jlink >nul 2>nul
if errorlevel 1 (
  echo   JDK 17 kuruluyor...
  winget install --silent --accept-source-agreements --accept-package-agreements EclipseAdoptium.Temurin.17.JDK
  for /f "usebackq delims=" %%p in (`powershell -NoProfile -Command "[Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')"`) do set "PATH=%%p"
)
where jlink >nul 2>nul
if errorlevel 1 (
  echo HATA: JDK 17 kurulamadi. Manuel kur: https://adoptium.net/temurin/releases/?version=17
  pause
  exit /b 1
)
for /f "delims=" %%j in ('where jlink') do set "JLINK=%%j"
for %%d in ("%JLINK%\..\..") do set "JAVA_HOME=%%~fd"
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo   JAVA_HOME=%JAVA_HOME%
echo.

set CMDTOOLS=%SDKROOT%\cmdline-tools\latest\bin\sdkmanager.bat
if not exist "%CMDTOOLS%" (
  echo [2/5] cmdline-tools indiriliyor...
  mkdir "%SDKROOT%\cmdline-tools\tmp" 2>nul
  powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip' -OutFile \"$env:TEMP\cmdtools.zip\""
  powershell -NoProfile -Command "Expand-Archive \"$env:TEMP\cmdtools.zip\" -DestinationPath '%SDKROOT%\cmdline-tools\tmp' -Force"
  mkdir "%SDKROOT%\cmdline-tools\latest" 2>nul
  xcopy "%SDKROOT%\cmdline-tools\tmp\cmdline-tools\*" "%SDKROOT%\cmdline-tools\latest\" /E /I /Y >nul
  del "%TEMP%\cmdtools.zip"
) else (
  echo [2/5] cmdline-tools mevcut.
)
echo.

echo [3/5] Lisanslar onaylaniyor ve paketler kuruluyor (birkaç GB indirebilir)...
set "ANDROID_SDK_ROOT=%SDKROOT%"
(for /L %%i in (1,1,80) do @echo y) | "%CMDTOOLS%" --sdk_root="%SDKROOT%" --licenses >nul
rem cmd pipe Java'ya ulasmazsa PowerShell ile tekrar dene (kanitlanmis yol)
powershell -NoProfile -Command "('y'+[char]10)*200 | & '%CMDTOOLS%' --sdk_root='%SDKROOT%' --licenses | Out-Null"
"%CMDTOOLS%" --sdk_root="%SDKROOT%" "platform-tools" "emulator" "%SYSIMG%"
if errorlevel 1 (
  echo HATA: SDK paketleri kurulamadi. Interneti kontrol edip tekrar dene.
  pause
  exit /b 1
)
echo.

echo [4/5] AVD olusturuluyor...
set AVDMGR=%SDKROOT%\cmdline-tools\latest\bin\avdmanager.bat
if not exist "%USERPROFILE%\.android\avd\%AVDNAME%.avd" (
  echo no | "%AVDMGR%" create avd -n %AVDNAME% -k "%SYSIMG%" -d pixel_7 --force
  powershell -NoProfile -Command "$c='%USERPROFILE%\.android\avd\%AVDNAME%.avd\config.ini'; (Get-Content $c) -replace 'hw.ramSize=.*','hw.ramSize=4096' -replace 'vm.heapSize=.*','vm.heapSize=1024' | Set-Content $c; Add-Content $c 'disk.dataPartition.size=16G'"
) else (
  echo   AVD zaten var.
)
echo.

echo [5/5] Dosyalar kalici konuma kopyalaniyor ve kisa yol olusturuluyor...
set BINDIR=%LOCALAPPDATA%\CleanDroid
mkdir "%BINDIR%" 2>nul
copy /Y "%~dp0Baslat.bat" "%BINDIR%\" >nul
copy /Y "%~dp0APK-Kur.bat" "%BINDIR%\" >nul
copy /Y "%~f0" "%BINDIR%\Kurulum.bat" >nul
copy /Y "%~dp0eminay.ico" "%BINDIR%\" >nul
powershell -NoProfile -Command "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut(\"$env:USERPROFILE\Desktop\EminayDroid Baslat.lnk\"); $s.TargetPath='%BINDIR%\Baslat.bat'; $s.WorkingDirectory='%BINDIR%'; $s.IconLocation='%BINDIR%\eminay.ico'; $s.Save()"
echo.
echo Kurulum bitti. Masaustundeki "EminayDroid Baslat" ile acabilirsin.
pause
