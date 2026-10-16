<div align="center">

# Windows 11 Tek Tıkla Ayarlar

**Tek çift tıkla Başlat araması yalnızca bilgisayarında arar, Ayarlar'daki Microsoft 365 reklamı kalkar, klasik sağ tık menüsü geri gelir ve Nihai Performans güç planı açılır.**

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
| 4 | Ayarlar'da öneriler ve teklifler | Ayarlar giriş sayfasında büyük "Microsoft 365'i edinin" kartı | Kalkar |
| 5 | Ayarlar'da bildirimler | Ayarlar'da hesap hatırlatmaları ve tanıtımlar | Kapalı (gerekli bildirimler yine gelir) |
| 6 | Sağ tık menüsü | Seçenekleri "Daha fazla seçenek göster"in arkasına saklayan Windows 11 menüsü | Doğrudan tam klasik menü |
| 7 | Güç planı | Nihai Performans gizli | Eklenir ve etkinleşir |

Hepsi kullanıcıya ait kayıt defteri ayarları ve bir güç planından ibarettir. İnternetten bir şey indirilmez, hiçbir uygulama kaldırılmaz. Türkçe Windows'ta mesajlar Türkçe, diğerlerinde İngilizce çıkar.

## Kullanım

1. [`win11-tweaks.bat`](win11-tweaks.bat) dosyasını indir: dosyayı açıp **Download raw file**'a tıkla ya da **Code → Download ZIP**'i kullan.
2. Dosyaya çift tıkla, yönetici izni penceresinde **Evet**'e tıkla.
3. İş bitince yeniden başlatmak için **E**'ye bas.

> [!TIP]
> Önce hangi komutların çalışacağını görmek istersen terminalde `win11-tweaks.bat /dry` komutunu çalıştır. Komutları listeler, hiçbir şeyi değiştirmez.

> [!NOTE]
> Dosya internetten geldiği için Windows "Windows bilgisayarınızı korudu" uyarısı gösterebilir. **Ek bilgi → Yine de çalıştır**'a tıkla.

## Geri alma

[`win11-tweaks-undo.bat`](win11-tweaks-undo.bat) dosyasına çift tıkla. Bütün ayarları Windows varsayılanına döndürür ve güç planını **Dengeli** yapar. Betiğin oluşturduğu Nihai Performans planını siler, senin daha önce oluşturduğun plana dokunmaz.

## Bilmekte fayda var

- Betik çalıştıktan sonra Ayarlar → Gizlilik ve güvenlik → Ara sayfasında "Bu ayarlardan bazıları kuruluşunuz tarafından yönetilir" yazısı çıkar ve **Arama vurgularını göster** anahtarı gri olur. Windows ilkeyle yapılan ayarları böyle gösterir, normaldir.
- Nihai Performans, işlemcinin boştayken yavaşlamasını engeller. Masaüstü bilgisayar için uygundur ama dizüstünde pil daha çabuk biter. İstemiyorsan **Güç Seçenekleri**'nden başka bir plan seç ya da geri alma betiğini çalıştır.
- Modern Bekleme kullanan bazı dizüstüler ek güç planına izin vermez. Bu bilgisayarlarda 7. adım **HATA** gösterebilir, diğer adımlar yine uygulanır.
- Betiği yönetici hesabından çalıştır. İzin penceresinde başka bir hesabın şifresini girersen ayarlar o hesaba uygulanır.

## Gereksinimler

- Windows 11 (Windows 11 Pro 25H2, derleme 26200 üzerinde geliştirildi)
- Yönetici hesabı

## Nasıl çalışır

| # | Değişiklik |
|:-:|---|
| 1 | `HKCU\Software\Policies\Microsoft\Windows\Explorer` → `DisableSearchBoxSuggestions` = `1` |
| 2 | `HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings` → `IsMSACloudSearchEnabled` = `0`, `IsAADCloudSearchEnabled` = `0` |
| 3 | Aynı anahtar → `IsDynamicSearchBoxEnabled` = `0` |
| 4 | `HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager` → `SubscribedContent-338393Enabled`, `SubscribedContent-353694Enabled`, `SubscribedContent-353696Enabled` = `0` |
| 5 | `HKCU\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications` → `EnableAccountNotifications` = `0` |
| 6 | `HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32` → boş varsayılan değer |
| 7 | `powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61`, ardından `powercfg /setactive`. Daha önce oluşturulmuş bir Nihai Performans planı varsa o kullanılır. |

## Lisans

[MIT](LICENSE)
