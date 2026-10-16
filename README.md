<div align="center">

**English** | [Türkçe](README_tr.md)

# EminayDroid

**Ad-free, bloat-free Android emulator — one-click setup**

Uses the official Google Android Emulator + Play Store image. No bloatware, no ads.

[![Release](https://img.shields.io/github/v/release/gsekercisoy/EminayDroid)](https://github.com/gsekercisoy/EminayDroid/releases/latest)
[![License: Scripts MIT](https://img.shields.io/badge/scripts-MIT-green)](LICENSE)

[**⬇ Download EminayDroid-Setup.exe (v1.0.0)**](https://github.com/gsekercisoy/EminayDroid/releases/download/v1.0.0/EminayDroid-Setup.exe)

</div>

---

## Setup in 30 seconds

1. Download and run `EminayDroid-Setup.exe` from the link above
2. Double-click the **"EminayDroid Baslat"** shortcut on your desktop
3. Sign in to the Play Store — done

> Setup requires internet once (JDK 17 + Android SDK + emulator + Play image,
> ~2.5 GB one-time download). Works offline afterwards.

## Features

| | EminayDroid | Typical free emulators |
|---|---|---|
| Ads | None | Usually present |
| Preinstalled bloatware | None | Usually present |
| Play Store | Yes (official image) | Varies |
| External APK install (`APK-Kur.bat`) | Yes | Yes |
| Sources | Open scripts | Black box |

## Requirements

- Windows 10/11 64-bit
- Virtualization enabled in BIOS (VT-x / AMD-V)
- ~20 GB free disk space
- Internet for the initial setup

## Manual setup (alternative)

If you prefer not to use the setup exe:

```powershell
.\Setup.ps1        # installs SDK + image + AVD
.\Start-Emulator.ps1
.\Install-Apk.ps1 C:\path\to\app.apk
```

`Baslat.bat` / `APK-Kur.bat` do the same with a double click.
Settings (`config.json`): 4 GB RAM, 16 GB disk, Pixel 7 profile, Play Store image.

## Files

| File | Description |
|---|---|
| `EminayDroid-Setup.exe` | Single-file installer (recommended path) |
| `Kurulum.bat`, `Baslat.bat`, `APK-Kur.bat` | Installer source scripts |
| `Setup.ps1`, `Start-Emulator.ps1`, `Install-Apk.ps1` | PowerShell alternatives |
| `config.json` | RAM / disk / device / image settings |
| `stub.cs` | C# source of Setup.exe (build with `csc.exe`) |
| `eminay.ico` | App icon |

## FAQ

**Why does setup need internet?**
The exe is small (~90 KB); the JDK, SDK, emulator and system image download
from Google/Microsoft servers during installation. Like Chrome's web installer.

**Will it conflict with my old emulator?**
No. The SDK goes to `%LOCALAPPDATA%\CleanDroid` and the AVD is named
`EminayDroid`. Other emulators are untouched.

**Where is my data?**
AVD data lives under `%USERPROFILE%\.android\avd\EminayDroid.avd`.
Delete that folder (while the emulator is closed) for a fresh start.

## License note

Scripts in this repo are MIT licensed (see `LICENSE`).
Android SDK components downloaded during installation remain subject to
Google's licenses, accepted during setup.
