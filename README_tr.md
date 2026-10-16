<div align="center">

**English** | [Türkçe](README_tr.md)

# EminayDroid

**Reklamsız, bloat'suz Android emülatörü — tek tıkla kurulum**

Resmi Google Android Emulator + Play Store imajı. Gereksiz uygulama yok, reklam yok.

[![Release](https://img.shields.io/github/v/release/gsekercisoy/EminayDroid)](https://github.com/gsekercisoy/EminayDroid/releases/latest)
[![License: Scripts MIT](https://img.shields.io/badge/scripts-MIT-green)](LICENSE)

[**⬇ EminayDroid-Setup.exe indir (v1.0.0)**](https://github.com/gsekercisoy/EminayDroid/releases/download/v1.0.0/EminayDroid-Setup.exe)

</div>

---

## 30 saniyede kurulum

1. Yukarıdaki **indir** bağlantısından `EminayDroid-Setup.exe` dosyasını alıp çalıştır
2. Kurulum bitince masaüstündeki **"EminayDroid Baslat"** kısayoluna çift tıkla
3. Play Store'a giriş yap — bitti

> Kurulum bir kez internet gerektirir (JDK 17 + Android SDK + emülatör + Play imajı,
> ~2.5 GB tek seferlik iner). Sonrasında internet olmadan da çalışır.

## Özellikler

| | EminayDroid | Tipik ücretsiz emülatörler |
|---|---|---|
| Reklam | Yok | Genelde var |
| Ön yüklü gereksiz uygulama | Yok | Genelde var |
| Play Store | Var (resmi imaj) | Değişken |
| Harici APK kurulumu (`APK-Kur.bat`) | Var | Var |
| Kaynak | Açık scriptler | Kapalı kutu |

## Gereksinim

- Windows 10/11 64-bit
- BIOS'ta sanallaştırma açık (VT-x / AMD-V)
- ~20 GB boş disk alanı
- İlk kurulum için internet

## El ile kurulum (alternatif)

Setup.exe kullanmak istemezsen:

```powershell
.\Setup.ps1            # SDK + imaj + AVD kurar
.\Start-Emulator.ps1   # emülatörü başlatır
.\Install-Apk.ps1 C:\yol\uygulama.apk   # harici APK kurar
```

`Baslat.bat` ve `APK-Kur.bat` aynı işleri çift tıkla yapar.
Ayarlar (`config.json`): 4 GB RAM, 16 GB disk, Pixel 7 profili, Play Store imajı.

## Dosyalar

| Dosya | Açıklama |
|---|---|
| `EminayDroid-Setup.exe` | Tek dosyalık kurucu (önerilen yol) |
| `Kurulum.bat`, `Baslat.bat`, `APK-Kur.bat` | Kurucunun kaynak scriptleri |
| `Setup.ps1`, `Start-Emulator.ps1`, `Install-Apk.ps1` | PowerShell alternatifleri |
| `config.json` | RAM / disk / cihaz / imaj ayarları |
| `stub.cs` | Setup.exe'nin C# kaynağı (derleme: `csc.exe` ile) |
| `eminay.ico` | Uygulama simgesi |

## Sık sorulanlar

**Kurulum neden internet istiyor?**
APK'nın içi küçüktür (~90 KB); JDK, SDK, emülatör ve sistem imajı kurulum
anında Google/Microsoft sunucularından iner. Tıpkı Chrome'un web kurucusu gibi.

**Eski emülatörümle çakışır mı?**
Hayır. SDK `%LOCALAPPDATA%\CleanDroid`, AVD `EminayDroid` adıyla kurulur.
Başka emülatörlere dokunmaz.

**Verilerim nerede?**
AVD verileri `%USERPROFILE%\.android\avd\EminayDroid.avd` altındadır.
Silmek istersen emülatör kapalıyken bu klasörü silmen yeterli.

## Lisans notu

Bu repodaki scriptler MIT ile lisanslıdır (bkz. `LICENSE`).
Kurulum sırasında indirilen Android SDK bileşenleri Google lisanslarına
tabidir ve kurulumda onaylanır.
