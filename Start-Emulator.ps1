#Requires -Version 5.1
<#
  Temiz emulatoru baslatir: resmi Android Emulator + Play Store imaji.
  Ag NAT (Play baglantisi), ADB 5555, donanim HIZ (WHPX otomatik).
#>
$ErrorActionPreference = 'Stop'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Cfg = Get-Content (Join-Path $Here 'config.json') -Raw | ConvertFrom-Json
$Emu = Join-Path $Cfg.sdkRoot 'emulator\emulator.exe'
$Adb = Join-Path $Cfg.sdkRoot 'platform-tools\adb.exe'
if (-not (Test-Path $Emu)) { throw "Emulator yok. Once .\Setup.ps1 calistir. ($Emu)" }

Write-Host "AVD '$($Cfg.avdName)' baslatiliyor..."
$args = @('-avd', $Cfg.avdName, '-netdelay', 'none', '-netspeed', 'full',
  '-read-only', '-no-snapshot-save')
Start-Process $Emu -ArgumentList $args
Write-Host 'Acilis bekleniyor (adb wait-for-device)...'
& $Adb wait-for-device
& $Adb devices
Write-Host 'Hazir. APK kurmak icin: .\Install-Apk.ps1 <dosya.apk>'
