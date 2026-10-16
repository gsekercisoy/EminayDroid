#Requires -Version 5.1
<#
  CleanDroid kurulum: Temurin JDK 17 + Android SDK (cmdline-tools, platform-tools,
  emulator, google_apis_playstore x86_64 image) + AVD olusturur.
  Reklam / bloat yok: sadece Google'in resmi emulator + Play Store imaji.
#>
$ErrorActionPreference = 'Stop'
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Cfg = Get-Content (Join-Path $Here 'config.json') -Raw | ConvertFrom-Json
$Sdk = $Cfg.sdkRoot

function Need-Admin {
  $id = [Security.Principal.WindowsIdentity]::GetCurrent()
  (New-Object Security.Principal.WindowsPrincipal($id)).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 1) JDK 17 (sdkmanager icin gerekli; mevcut Java 8 yetmez)
$Jdk17 = 'C:\Users\acrom\tools\jdk-17'
if (-not (Get-Command jlink -ErrorAction SilentlyContinue)) {
  Write-Host '[1/5] Temurin JDK 17 kuruluyor...'
  winget install --silent --accept-source-agreements --accept-package-agreements EclipseAdoptium.Temurin.17.JDK
  $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
} else { Write-Host '[1/5] JDK mevcut.' }
if (Test-Path (Join-Path $Jdk17 'bin\java.exe')) {
  $env:JAVA_HOME = $Jdk17
  $env:Path = (Join-Path $Jdk17 'bin') + ';' + $env:Path
  Write-Host "JAVA_HOME=$($env:JAVA_HOME)"
  try { (& (Join-Path $Jdk17 'bin\java.exe') -version 2>&1 | Out-String).Trim().Split("`n")[0] | ForEach-Object { Write-Host "  $_" } } catch { Write-Host '  (java surum ciktisi okunamadi, devam)' }
}

# 2) cmdline-tools
$CmdTools = Join-Path $Sdk 'cmdline-tools\latest\bin\sdkmanager.bat'
if (-not (Test-Path $CmdTools)) {
  Write-Host '[2/5] Android cmdline-tools indiriliyor...'
  New-Item -ItemType Directory -Force -Path (Join-Path $Sdk 'cmdline-tools') | Out-Null
  $zip = "$env:TEMP\cmdtools.zip"
  Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip' -OutFile $zip
  Expand-Archive $zip -DestinationPath (Join-Path $Sdk 'cmdline-tools\tmp') -Force
  New-Item -ItemType Directory -Force -Path (Join-Path $Sdk 'cmdline-tools\latest') | Out-Null
  Copy-Item (Join-Path $Sdk 'cmdline-tools\tmp\cmdline-tools\*') (Join-Path $Sdk 'cmdline-tools\latest') -Recurse -Force
  Remove-Item $zip -Force
  [Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT', $Sdk, 'User')
  $env:ANDROID_SDK_ROOT = $Sdk
} else { Write-Host '[2/5] cmdline-tools mevcut.' }

# 3) Lisans + paketler
Write-Host '[3/5] SDK paketleri kuruluyor (bu ad GB mertebesinde indirebilir)...'
$env:ANDROID_SDK_ROOT = $Sdk
[Environment]::SetEnvironmentVariable('ANDROID_SDK_ROOT', $Sdk, 'User')
# Lisanslara y yaniti ver (bos satir hayir sayilir, o yuzden y gonder)
$oldEa = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
('y' + "`n") * 100 | & $CmdTools --sdk_root=$Sdk --licenses | Out-Null
& $CmdTools --sdk_root=$Sdk 'platform-tools' 'emulator' $Cfg.systemImage
$ErrorActionPreference = $oldEa

# 4) AVD
Write-Host '[4/5] AVD olusturuluyor...'
$AvdMgr = Join-Path $Sdk 'cmdline-tools\latest\bin\avdmanager.bat'
$avdDir = Join-Path $env:USERPROFILE ".android\avd\$($Cfg.avdName).avd"
if (-not (Test-Path $avdDir)) {
  echo no | & $AvdMgr create avd -n $Cfg.avdName -k $Cfg.systemImage -d $Cfg.device --force
  $cfgFile = Join-Path $avdDir 'config.ini'
  (Get-Content $cfgFile) -replace 'hw.ramSize=.*', "hw.ramSize=$($Cfg.ramMB)" `
    -replace 'vm.heapSize=.*', "vm.heapSize=$($Cfg.heapMB)" | Set-Content $cfgFile
  Add-Content $cfgFile "disk.dataPartition.size=$($Cfg.diskGB)G"
} else { Write-Host '[4/5] AVD zaten var.' }

# 5) WHPX / Hypervisor kontrolu
Write-Host '[5/5] Hipervizor kontrolu...'
systeminfo | Select-String 'Hyper-V|Hipervizor|Hypervisor' | ForEach-Object { Write-Host "  $_" }
Write-Host 'Kurulum bitti. Baslatmak icin: .\Start-Emulator.ps1'
if (-not (Need-Admin)) { Write-Host 'Not: ilk AVD acilisi icin admin gerekebilir (WHPX/Hyper-V).' }
