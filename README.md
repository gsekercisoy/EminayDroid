# EminayDroid — reklamsız, bloat'suz Android emülatörü

Resmi Google Android Emulator + `google_apis_playstore` x86_64 imajı kullanır.
Reklam yok, gereksiz uygulama yok. Play Store bağlantısı ve harici APK kurulumu çalışır.

## Hızlı kurulum (önerilen)

1. `EminayDroid-Setup.exe` dosyasını indirip çalıştır
2. Masaüstüne gelen **"EminayDroid Baslat"** kısayoluyla aç
3. Play Store'a giriş yap, uygulamalarını kur

Kurulum internet gerektirir (JDK 17 + SDK + emülatör + Play imajı, ~2.5 GB tek seferlik iner).
Sonrası offline çalışır.

## El ile kurulum (alternatif)

```powershell
.\Setup.ps1        # SDK + imaj + AVD kurar
.\Start-Emulator.ps1
.\Install-Apk.ps1 C:\yol\uygulama.apk
```

`Baslat.bat` / `APK-Kur.bat` aynı işi çift tıkla yapar.

## Gereksinim

- Windows 10/11 64-bit, BIOS'ta VT-x/AMD-V açık
- ~20 GB boş alan, internet

## Dosyalar

| Dosya | Açıklama |
|---|---|
| `EminayDroid-Setup.exe` | Tek dosyalık kurucu (C# stub + bat paketi) |
| `Kurulum.bat`, `Baslat.bat`, `APK-Kur.bat` | Kurulum paketinin kaynakları |
| `Setup.ps1`, `Start-Emulator.ps1`, `Install-Apk.ps1` | PowerShell alternatifleri |
| `config.json` | RAM/CPU/disk/imaj ayarları |
| `stub.cs` | Setup.exe'nin C# kaynağı |
| `eminay.ico` | Uygulama simgesi |

## Lisans notu

Bu repo yalnızca kurulum scriptleri içerir; Android SDK bileşenleri kurulumda
Google sunucularından iner ve Google lisanslarına tabidir (kurulumda onaylanır).
