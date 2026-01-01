# Staj Forum Mobil Uygulamasi

Staj Forum platformunun Flutter ile gelistirilmis mobil uygulamasidir. Web platformu ile es zamanli calisarak stajyerlere mobil cihazlarda forum, kullanici kimlik dogrulama, sohbet ve analiz hizmetleri sunar.

## Ozellikler

*   **Kullanici Kimlik Dogrulama:**
    *   JWT tabanlı güvenli giriş ve kayıt sistemi
    *   Provider pattern ile state yönetimi
    *   SharedPreferences ile oturum kalıcılığı
    *   Profil sayfası ile kullanıcı bilgileri ve içerik yönetimi
    *   Otomatik token yönetimi (Dio interceptor)

*   **Forum:**
    *   Forum konularini listeleme ve detaylarini inceleme
    *   **Akıllı Sıralama:** "En Yeni", "En Eski" ve "En Çok Görüntülenen" kriterleri
    *   **Arama Fonksiyonu:** Konu başlıklarında arama
    *   **Rich Text Editor:** Flutter Quill ile HTML destekli içerik oluşturma
    *   **Konu Detay Sayfası:** Yorumlar, görüntülenme sayısı ve yanıt ekleme
    *   **Kullanıcı Bazlı İçerik:** Sadece kendi konularını düzenleyebilme/silebilme
    *   **Sayfalama:** Performanslı içerik yükleme

*   **AI Sohbet Asistani (ChatStj):**
    *   Google Gemini API entegrasyonu
    *   Staj hakkindaki sorulari yanitlayan interaktif asistan
    *   Conversation ID ile sohbet geçmişi takibi
    *   Gerçek zamanlı yazıyor göstergesi
    *   Otomatik scroll ve kullanıcı dostu mesajlaşma arayüzü

*   **Mobil CV Analizi:**
    *   Cihazdan PDF formatinda CV yukleme
    *   Syncfusion PDF ile metin çıkarma (Web ve mobil desteği)
    *   Yapay zeka destekli detaylı analiz
    *   Güçlü/zayıf yön belirleme
    *   10 üzerinden puanlama
    *   Stratejik kariyer tavsiyeleri

*   **İletişim Formu:**
    *   Backend'e mesaj gönderme sistemi
    *   Form validasyonu
    *   Başarı/hata bildirimleri

*   **Modern Arayuz:**
    *   Özel tasarlanmış koyu tema (Dark Mode)
    *   Neon renk paleti (Cyan ve Purple)
    *   Material Design 3 desteği
    *   Responsive tasarım (mobil ve tablet)
    *   Özel animasyonlar ve geçişler

## Teknolojiler ve Paketler

### Core
*   **Framework:** Flutter (SDK ^3.9.2)
*   **Dil:** Dart
*   **Material Design:** Material 3

### State Yönetimi
*   **Provider:** 6.1.1 (State management)
*   **SharedPreferences:** 2.2.2 (Local storage)

### Networking
*   **Dio:** 5.7.0 (HTTP client)
*   **JWT:** Otomatik token yönetimi

### UI ve Görsel
*   **Google Fonts:** 6.3.3 (Typography)
*   **Cupertino Icons:** 1.0.8 (iOS style icons)

### Dosya ve PDF İşleme
*   **File Picker:** 8.1.1 (Dosya seçimi)
*   **Syncfusion Flutter PDF:** 28.1.33 (PDF parsing)

### Rich Text Editing
*   **Flutter Quill:** 11.5.0 (Rich text editor)
*   **VSC Quill Delta to HTML:** 1.0.5 (Delta to HTML conversion)
*   **Flutter Widget from HTML:** 0.17.1 (HTML rendering)
*   **HTML:** 0.15.6 (HTML parsing)

### Localization
*   **Flutter Localizations:** SDK (Türkçe ve İngilizce desteği)

### Development
*   **Flutter Lints:** 5.0.0 (Code quality)

## Kurulum ve Calistirma

### Gereksinimler
*   Flutter SDK 3.9.2 veya üzeri
*   Dart SDK
*   Android Studio / Xcode (platform bazlı)
*   Backend API'nin çalışır durumda olması

### Adımlar

1.  **Flutter SDK'yi Kurun:**
    Flutter SDK'nin kurulu olduğundan emin olun:
    ```bash
    flutter doctor
    ```

2.  **Bagimliliklari Yukleyin:**
    Proje dizininde aşağıdaki komutu çalıştırın:
    ```bash
    flutter pub get
    ```

3.  **API Yapılandırması (Opsiyonel):**
    Backend API adresi otomatik olarak belirlenir, ancak özel bir adres kullanmak için:
    ```bash
    flutter run --dart-define=API_BASE_URL=http://your-api-url:5276/api
    ```

4.  **Uygulamayi Baslatin:**
    Bir emulator veya fiziksel cihaz bağladıktan sonra:
    ```bash
    flutter run
    ```

5.  **Platform Bazlı Build (Opsiyonel):**
    ```bash
    # Android APK
    flutter build apk --release
    
    # iOS
    flutter build ios --release
    
    # Web
    flutter build web
    ```

## Proje Mimarisi

### Dizin Yapısı

```
lib/
├── config/                 # Yapılandırma dosyaları
│   ├── api_config.dart     # API base URL yönetimi
│   └── theme.dart          # Uygulama teması ve renkler
│
├── models/                 # Veri modelleri
│   ├── user.dart           # Kullanıcı modeli
│   ├── auth_request.dart   # Login/Register request modelleri
│   ├── auth_response.dart  # Auth response modeli
│   ├── topic.dart          # Forum topic modeli
│   ├── reply.dart          # Forum reply modeli
│   ├── reply_request.dart  # Reply request modeli
│   ├── chat_response.dart  # Chat response modeli
│   ├── contact.dart        # İletişim mesajı modeli
│   └── pagination.dart     # Sayfalama modeli
│
├── pages/                  # Uygulama sayfaları
│   ├── anasayfa_page.dart  # Ana sayfa
│   ├── forum_page.dart     # Forum listesi
│   ├── forum_konu_secimi_page.dart  # Konu detay sayfası
│   ├── chat_stj_page.dart  # AI sohbet sayfası
│   ├── cv_analiz_page.dart # CV analiz sayfası
│   ├── giris_page.dart     # Giriş sayfası
│   ├── kayit_page.dart     # Kayıt sayfası
│   ├── profil_page.dart    # Kullanıcı profil sayfası
│   ├── hakkinda_page.dart  # Hakkında sayfası
│   └── iletisim_page.dart  # İletişim sayfası
│
├── providers/              # State yönetimi
│   └── auth_provider.dart  # Auth state provider
│
├── services/               # API servisleri
│   ├── api_client.dart     # Dio client ve interceptor
│   ├── auth_service.dart   # Kimlik doğrulama servisi
│   ├── forum_service.dart  # Forum CRUD işlemleri
│   ├── chat_service.dart   # AI chat servisi
│   └── contact_service.dart # İletişim servisi
│
├── widgets/                # Yeniden kullanılabilir widget'lar
│   ├── top_app_bar.dart    # Üst navigasyon çubuğu
│   ├── bottom_bar.dart     # Alt bilgi çubuğu
│   ├── common_drawer.dart  # Yan menü (drawer)
│   ├── topic_card.dart     # Forum konu kartı
│   ├── user_topic_card.dart # Kullanıcı konu kartı
│   ├── user_reply_card.dart # Kullanıcı yorum kartı
│   └── rich_text_editor.dart # Rich text editör widget
│
└── main.dart               # Uygulama giriş noktası
```

## Özellikler Detayı

### 1. Kimlik Doğrulama Sistemi

**AuthProvider (`providers/auth_provider.dart`):**
*   JWT token yönetimi
*   Kullanıcı bilgileri (user, isAuthenticated, isLoading, error)
*   Login/Register/Logout fonksiyonları
*   SharedPreferences ile persist
*   Otomatik hata mesajları (Türkçe)

**API Interceptor:**
*   Her istekte otomatik JWT token ekleme
*   401 Unauthorized durumunda token temizleme
*   SharedPreferences'dan token okuma

**Sayfalar:**
*   `giris_page.dart`: Email/şifre ile giriş
*   `kayit_page.dart`: Yeni kullanıcı kaydı
*   `profil_page.dart`: Kullanıcı profili ve içerikleri

### 2. Forum Sistemi

**Özellikler:**
*   Konu listeleme (sayfalama ile)
*   Sıralama: newest, oldest, popular
*   Arama fonksiyonu
*   Rich text editor ile konu oluşturma
*   Konu detay sayfası
*   Yorum ekleme/görüntüleme
*   Kullanıcı bazlı düzenleme/silme

**Widget'lar:**
*   `forum_page.dart`: Ana forum sayfası
*   `forum_konu_secimi_page.dart`: Konu detay sayfası
*   `topic_card.dart`: Konu kartı widget
*   `rich_text_editor.dart`: HTML editör widget

**API Servisleri:**
*   `getTopics()`: Konu listesi
*   `getTopicById()`: Konu detayı
*   `createTopic()`: Yeni konu
*   `updateTopic()`: Konu güncelleme
*   `deleteTopic()`: Konu silme
*   `getReplies()`: Yorumları getir
*   `createReply()`: Yeni yorum
*   `updateReply()`: Yorum güncelleme
*   `deleteReply()`: Yorum silme
*   `getUserTopics()`: Kullanıcı konuları
*   `getUserReplies()`: Kullanıcı yorumları

### 3. AI Sohbet Asistanı (ChatStj)

**Özellikler:**
*   Google Gemini API entegrasyonu
*   Conversation ID ile sohbet takibi
*   Gerçek zamanlı mesajlaşma
*   Yazıyor göstergesi (typing indicator)
*   Otomatik scroll
*   Mesaj geçmişi

**Widget:**
*   `chat_stj_page.dart`: Ana chat sayfası
*   `_ChatBubble`: Mesaj balonu widget

**API:**
*   `sendMessage()`: Mesaj gönder ve yanıt al

### 4. CV Analizi

**Özellikler:**
*   PDF yükleme (file_picker)
*   PDF parsing (Syncfusion PDF)
*   Web ve mobil desteği
*   AI ile analiz
*   Güçlü/zayıf yönler
*   Puanlama (1-10)
*   Kariyer tavsiyeleri

**Teknik:**
*   Platform bazlı PDF okuma (kIsWeb kontrolü)
*   Byte array ile dosya işleme
*   PdfTextExtractor kullanımı
*   Backend'e metin gönderme

**API:**
*   `analyzeCV()`: CV analizi yap

### 5. Tema Sistemi

**Dark Mode Palette (`config/theme.dart`):**
*   **Primary Color:** #00E5FF (Neon Cyan)
*   **Secondary Color:** #D946EF (Neon Purple)
*   **Background:** #0F172A (Deep Blue-Grey)
*   **Surface:** #1E293B (Lighter Blue-Grey)
*   **Text Primary:** #F8FAFC (White-ish)
*   **Text Secondary:** #94A3B8 (Grey-ish)

**Theme Components:**
*   AppBar theme (transparent background, neon icons)
*   Card theme (dark surface, border)
*   Button themes (elevated, outlined)
*   Input decoration (dark filled, neon focus)
*   Custom styles (CV buttons, result containers)

**Responsive:**
*   Mobile-first yaklaşım
*   Drawer için breakpoint (900px)
*   Flexible layouts

## API Servisleri

### api_client.dart (Base Client)

**Özellikler:**
*   Dio instance oluşturma
*   Base URL yönetimi (ApiConfig)
*   Request interceptor (JWT token ekleme)
*   Error interceptor (401 handling)
*   SharedPreferences entegrasyonu
*   Timeout ayarları (10s connect, 15s receive)

### auth_service.dart

*   `login(request)`: Kullanıcı girişi
*   `register(request)`: Yeni kullanıcı kaydı

### forum_service.dart

*   `getTopics(page, pageSize, sortBy, search)`: Konu listesi
*   `getTopicById(id)`: Konu detayı
*   `createTopic(request)`: Yeni konu
*   `updateTopic(id, title, content)`: Konu güncelle
*   `deleteTopic(id)`: Konu sil
*   `getReplies(topicId, page, pageSize)`: Yorumları getir
*   `createReply(topicId, request)`: Yeni yorum
*   `updateReply(id, content, authorName)`: Yorum güncelle
*   `deleteReply(id)`: Yorum silme
*   `getUserTopics(userId, page, pageSize)`: Kullanıcı konuları
*   `getUserReplies(userId, page, pageSize)`: Kullanıcı yorumları

### chat_service.dart

*   `sendMessage(message, conversationId)`: Chat mesajı gönder
*   `analyzeCV(cvText)`: CV analizi yap

### contact_service.dart

*   `sendContactMessage(contact)`: İletişim mesajı gönder

## Routing Yapısı

```dart
/                    → Anasayfa
/anasayfa           → Anasayfa
/forum              → Forum listesi
/forum/:id          → Konu detay sayfası (dinamik route)
/chatstj            → AI sohbet
/cv-analiz          → CV analizi
/giris              → Giriş sayfası
/kayit              → Kayıt sayfası
/profil             → Kullanıcı profili
/hakkinda           → Hakkında
/iletisim           → İletişim formu
```

## State Yönetimi

### Provider Pattern

**AuthProvider:**
*   `user`: Kullanıcı bilgileri (User?)
*   `isAuthenticated`: Giriş durumu (bool)
*   `isLoading`: Yükleme durumu (bool)
*   `error`: Hata mesajı (String?)

**Actions:**
*   `login(email, password)`: Giriş yap
*   `register(firstName, lastName, email, password)`: Kayıt ol
*   `logout()`: Çıkış yap
*   `clearError()`: Hata temizle

**Persist:**
*   SharedPreferences'da `auth_token` ve `user_data` anahtarları ile saklanır
*   Uygulama yeniden başlatıldığında oturum korunur

## Yapilandirma

### API Configuration (`config/api_config.dart`)

**Otomatik Base URL Belirleme:**
1.  `--dart-define=API_BASE_URL` (en yüksek öncelik)
2.  Web'de: `window.location.host:5276/api`
3.  Android emulator: `10.0.2.2:5276/api`
4.  Diğer platformlar: `localhost:5276/api`

**Örnek Kullanım:**
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:5276/api
```

## Platform Desteği

*   ✅ Android
*   ✅ iOS
*   ✅ Web
*   ✅ macOS
*   ✅ Windows
*   ✅ Linux

## Güvenlik Özellikleri

*   JWT token tabanlı kimlik doğrulama
*   Otomatik token yönetimi (Dio interceptor)
*   SharedPreferences ile güvenli token saklama
*   401 Unauthorized durumunda otomatik logout
*   Protected routes (auth kontrolü)
*   Input validasyonu

## Performans Optimizasyonları

*   Sayfalama ile veri yükleme
*   Lazy loading (sayfa bazlı)
*   Dio interceptor ile merkezi hata yönetimi
*   Efficient state management (Provider)
*   Image caching
*   PDF parsing client-side (backend yükü azaltma)

## Build ve Deployment

### Development
```bash
flutter run                 # Development mode
flutter run --release       # Release mode
flutter analyze             # Code analysis
```

### Production Builds

**Android:**
```bash
flutter build apk --release                    # APK
flutter build appbundle --release              # AAB (Play Store)
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

**Desktop:**
```bash
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

## Localization

**Desteklenen Diller:**
*   Türkçe (tr)
*   İngilizce (en)

**Flutter Quill Localization:**
*   Rich text editor Türkçe desteği
*   Otomatik dil seçimi

## Geliştirme Notları

*   Material Design 3 kullanılmıştır
*   Dark mode varsayılan temadır
*   Page transitions devre dışı bırakılmıştır (NoAnimationPageTransitionsBuilder)
*   Syncfusion PDF ücretsiz community lisansı ile kullanılabilir
*   Flutter Quill HTML desteği için delta-to-html conversion kullanılır

## Bilinen Sorunlar ve Çözümler

### Android Emulator Network Hatası
**Sorun:** localhost'a erişilemiyor  
**Çözüm:** `ApiConfig` otomatik olarak `10.0.2.2` kullanır

### PDF Parsing Hatası
**Sorun:** PDF okunamıyor  
**Çözüm:** Syncfusion PDF paketi doğru versiyonda kurulu olmalı

### Token Expire
**Sorun:** Token süresi dolduğunda 401 hatası  
**Çözüm:** Interceptor otomatik olarak token'ı temizler ve kullanıcıyı logout eder

## Lisans

Bu proje özel bir projedir ve ticari kullanım için izin gereklidir.
