# Staj Forum Mobil Uygulamasi

Staj Forum platformunun Flutter ile gelistirilmis mobil uygulamasidir. Web platformu ile es zamanli calisarak stajyerlere mobil cihazlarda forum, sohbet ve analiz hizmetleri sunar.

## Ozellikler

*   **Forum Goruntuleme:** Forum konularini listeleme ve detaylarini inceleme.
    *   **Akıllı Sıralama:** Konuları "En Yeni", "En Eski" ve "En Çok Görüntülenen" kriterlerine göre sıralayabilme.
    *   **Kullanıcı Dostu Arayüz:** AppBar üzerinden kolay erişilebilir sıralama menüsü.
*   **AI Sohbet Asistani (ChatStj):** Google Gemini entegrasyonu ile kullanicilarin staj hakkindaki sorularini yanitlayan interaktif asistan.
*   **Mobil CV Analizi:** Cihazdan PDF formatinda CV yukleme, metin cikartma ve yapay zeka destekli detayli analiz.
*   **Modern Arayuz:** Ozel olarak tasarlanmis koyu tema (Dark Mode) ve neon renk paleti.

## Teknolojiler ve Paketler

*   **Framework:** Flutter
*   **Dil:** Dart
*   **HTTP Istekleri:** Dio
*   **Dosya Secimi:** file_picker
*   **PDF Isleme:** syncfusion_flutter_pdf
*   **Yazi Tipleri:** google_fonts

## Kurulum ve Calistirma

Uygulamayi calistirmak icin Flutter SDK'nin kurulu oldugundan emin olun.

1.  **Bagimliliklari Yukleyin:**
    Proje dizininde asagidaki komutu calistirin:
    ```bash
    flutter pub get
    ```

2.  **Uygulamayi Baslatin:**
    Bir emulator veya fiziksel cihaz bagladiktan sonra:
    ```bash
    flutter run
    ```

## Proje Yapisi

*   `lib/config`: Uygulama genelindeki ayarlar (API URL'leri, Tema dosyalari).
*   `lib/models`: Veri modelleri ve JSON donusum siniflari.
*   `lib/pages`: Uygulama ekranlari (Anasayfa, Chat, CV Analiz vb.).
*   `lib/services`: Backend API ile iletisimi saglayan servis katmani.
*   `lib/widgets`: Tekrar kullanilabilir arayuz bilesenleri (App Bar, Drawer vb.).

## Yapilandirma

Backend API adresi `lib/config/api_config.dart` dosyasi icerisinde tanimlanmistir. Yerel testler icin bu adresi kendi sunucu adresinizle guncellemeniz gerekebilir.
