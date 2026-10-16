<div align="center">

# Windows 11 Tek Tıkla Ayarlar

**Tek çift tıkla Başlat araması yalnızca bilgisayarında arar, Başlat, Ayarlar ve Dosya Gezgini'ndeki reklamlar ve ipuçları kalkar, klasik sağ tık menüsü geri gelir ve Nihai Performans güç planı açılır.**

[![Windows 11](https://img.shields.io/badge/Windows-11-0078D4?logo=windows11&logoColor=white)](#gereksinimler)
[![Batch betiği](https://img.shields.io/badge/betik-.bat-4D4D4D?logo=windowsterminal&logoColor=white)](win11-tweaks.bat)
[![Lisans: MIT](https://img.shields.io/badge/lisans-MIT-2EA44F)](LICENSE)

[English](README.md) · **Türkçe**

</div>

## Neleri değiştirir

| # | Ayar | Önce | Sonra |
|:-:|---|---|---|
| 1 | Başlat aramasında internet sonuçları | Aramaya yazınca Bing sonuçları ve web siteleri çıkar | Yalnızca bu bilgisayardaki uygulamalar, dosyalar ve ayarlar |
| 2 | Hesaplarımda ara | Arama, Microsoft ve iş/okul hesaplarındaki içerikleri de tarar | Kapalı |
| 3 | Arama vurguları | Arama kutusunda gündem başlıkları ve görseller çıkar | Kapalı |
| 4 | Başlat menüsü önerileri | Başlat'ta ipuçları, yeni uygulamalar ve uygulama tanıtımları çıkar | Kapalı |
| 5 | Ayarlar'da öneriler ve teklifler | Ayarlar giriş sayfasında büyük "Microsoft 365'i edinin" kartı | Kalkar |
| 6 | Ayarlar'da bildirimler | Ayarlar'da hesap hatırlatmaları ve tanıtımlar | Kapalı (gerekli bildirimler yine gelir) |
| 7 | Windows ipucu bildirimleri | "İpuçları ve öneriler" bildirimleri, güncelleme sonrası tanıtım ekranı ve "cihazı kurmayı bitir" hatırlatmaları | Kapalı |
| 8 | Dosya Gezgini'nde OneDrive tanıtımları | Gezgin'in üstünde OneDrive ve Microsoft 365 tanıtımları çıkar | Kapalı |
| 9 | Sağ tık menüsü | Seçenekleri "Daha fazla seçenek göster"in arkasına saklayan Windows 11 menüsü | Doğrudan tam klasik menü |
| 10 | Görev çubuğunda Görevi sonlandır | Donan bir uygulamayı kapatmak için Görev Yöneticisi'ni açmak gerekir | Görev çubuğunda uygulamaya sağ tık → **Görevi sonlandır** |
| 11 | Yapışkan Tuşlar uyarısı | 5 kez Shift'e basınca (oyunlarda kolayca olur) Yapışkan Tuşlar penceresi açılır | Uyarı çıkmaz; Yapışkan Tuşlar Ayarlar'dan yine açılabilir |
| 12 | Güç planı | Nihai Performans gizli | Eklenir ve etkinleşir |

Hepsi kullanıcıya ait kayıt defteri ayarları ve bir güç planından ibarettir. İnternetten bir şey indirilmez, hiçbir uygulama kaldırılmaz. Türkçe Windows'ta mesajlar Türkçe, diğerlerinde İngilizce çıkar.

## Kullanım

### Hızlı başlangıç

Başlat'a sağ tıklayıp **Terminal**'i aç (yönetici olarak açmana gerek yok) ve şunu yapıştır:

```powershell
irm https://raw.githubusercontent.com/tahaexe/win11-one-click-tweaks/main/run.ps1 | iex
```

Komut `win11-tweaks.bat` dosyasını geçici klasöre indirip çalıştırır. Yönetici izni penceresinde **Evet**'e tıkla, sonunda yeniden başlatmak için **E**'ye bas.

> [!NOTE]
> Bu komut betiği doğrudan bu repodan çalıştırır. Neyin çalışacağını görmek istersen önce [`run.ps1`](run.ps1) ve [`win11-tweaks.bat`](win11-tweaks.bat) dosyalarına göz at.

### Ya da dosyayı indir

1. [`win11-tweaks.bat`](win11-tweaks.bat) dosyasını indir: dosyayı açıp **Download raw file**'a tıkla ya da **Code → Download ZIP**'i kullan.
2. Dosyaya çift tıkla, yönetici izni penceresinde **Evet**'e tıkla.
3. İş bitince yeniden başlatmak için **E**'ye bas.

> [!NOTE]
> Dosya internetten geldiği için Windows "Windows bilgisayarınızı korudu" uyarısı gösterebilir. **Ek bilgi → Yine de çalıştır**'a tıkla.

> [!TIP]
> Önce hangi komutların çalışacağını görmek istersen terminalde `win11-tweaks.bat /dry` komutunu çalıştır. Komutları listeler, hiçbir şeyi değiştirmez.

## Geri alma

Terminal'e şunu yapıştır ya da [`win11-tweaks-undo.bat`](win11-tweaks-undo.bat) dosyasına çift tıkla:

```powershell
irm https://raw.githubusercontent.com/tahaexe/win11-one-click-tweaks/main/undo.ps1 | iex
```

Bütün ayarları Windows varsayılanına döndürür ve güç planını **Dengeli** yapar. Windows varsayılanı bu olduğu için görev çubuğundaki **Görevi sonlandır** da kapanır. Betiğin oluşturduğu Nihai Performans planını siler, senin daha önce oluşturduğun plana dokunmaz.

## Bilmekte fayda var

- Betik çalıştıktan sonra Ayarlar → Gizlilik ve güvenlik → Ara sayfasında "Bu ayarlardan bazıları kuruluşunuz tarafından yönetilir" yazısı çıkar ve **Arama vurgularını göster** anahtarı gri olur. Windows ilkeyle yapılan ayarları böyle gösterir, normaldir.
- 11. adım yalnızca 5 kez Shift kısayolunu kapatır. Yapışkan Tuşlar'ı istersen **Ayarlar → Erişilebilirlik → Klavye**'den yine açabilirsin.
- Nihai Performans, işlemcinin boştayken yavaşlamasını engeller. Masaüstü bilgisayar için uygundur ama dizüstünde pil daha çabuk biter. İstemiyorsan **Güç Seçenekleri**'nden başka bir plan seç ya da geri alma betiğini çalıştır.
- Modern Bekleme kullanan bazı dizüstüler ek güç planına izin vermez. Bu bilgisayarlarda 12. adım **HATA** gösterebilir, diğer adımlar yine uygulanır.
- Standart bir hesapta izin penceresini bir yönetici onaylayabilir; ayarlar yine betiği başlatan hesaba uygulanır. Windows'un Yönetici koruması açıksa da durum aynıdır.

## Gereksinimler

- Windows 11 (Windows 11 Pro 25H2, derleme 26200 üzerinde geliştirildi)
- Yönetici izni: kendi hesabın ya da izni onaylayan bir yönetici

## Nasıl çalışır

| # | Değişiklik |
|:-:|---|
| 1 | `HKCU\Software\Policies\Microsoft\Windows\Explorer` → `DisableSearchBoxSuggestions` = `1` |
| 2 | `HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings` → `IsMSACloudSearchEnabled` = `0`, `IsAADCloudSearchEnabled` = `0` |
| 3 | Aynı anahtar → `IsDynamicSearchBoxEnabled` = `0` |
| 4 | `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced` → `Start_IrisRecommendations` = `0` |
| 5 | `HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager` → `SubscribedContent-338393Enabled`, `SubscribedContent-353694Enabled`, `SubscribedContent-353696Enabled` = `0` |
| 6 | `HKCU\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications` → `EnableAccountNotifications` = `0` |
| 7 | 5. adımdaki `ContentDeliveryManager` anahtarı → `SubscribedContent-338389Enabled`, `SubscribedContent-310093Enabled` = `0`; `HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement` → `ScoobeSystemSettingEnabled` = `0` |
| 8 | 4. adımdaki `Explorer\Advanced` anahtarı → `ShowSyncProviderNotifications` = `0` |
| 9 | `HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32` → boş varsayılan değer |
| 10 | `Explorer\Advanced\TaskbarDeveloperSettings` → `TaskbarEndTask` = `1` |
| 11 | `HKCU\Control Panel\Accessibility\StickyKeys` → `Flags`: yalnızca kısayol biti kapatılır (varsayılan kurulumda `510`, `506` olur) |
| 12 | `powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61`, ardından `powercfg /setactive`. Daha önce oluşturulmuş bir Nihai Performans planı varsa o kullanılır. |

Buradaki `HKCU`, betiği başlatan hesap demektir. Yönetici olarak çalışan kopya, Windows onu başka bir hesapla yükseltse bile ayarları doğrudan o hesabın kayıt defterine (`HKEY_USERS\<SID>`) yazar.

## Lisans

[MIT](LICENSE)
