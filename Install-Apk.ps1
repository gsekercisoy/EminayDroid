#Requires -Version 5.1
<# Harici APK kurar: .\Install-Apk.ps1 C:\yol\uygulama.apk #>
$ErrorActionPreference = 'Stop'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Cfg = Get-Content (Join-Path $Here 'config.json') -Raw | ConvertFrom-Json
$Adb = Join-Path $Cfg.sdkRoot 'platform-tools\adb.exe'
if ($args.Count -lt 1) { throw 'Kullanim: .\Install-Apk.ps1 <dosya.apk>' }
$Apk = $args[0]
if (-not (Test-Path $Apk)) { throw "APK bulunamadi: $Apk" }
& $Adb wait-for-device
& $Adb install -r $Apk
