# Staj App Flutter

StajForum web uygulamasının Flutter ile geliştirilen eşlenik sürümü. React/Vite tabanlı `staj-forum-web` ile aynı ekran akışlarını ve backend API entegrasyonunu içerir.

## Özellikler

- Anasayfa, Forum, ChatSTJ, Hakkında ve İletişim sayfaları
- Forum topic listeleme ve oluşturma (backend entegrasyonlu)
- İletişim formu (backend entegrasyonlu)
- Responsive AppBar / Drawer / Footer bileşenleri
- Dio tabanlı merkezi API istemcisi

## Backend Bağlantısı

Varsayılan API taban adresi `lib/config/api_config.dart` üzerinden belirlenir:

Öncelik sırası:
1. `flutter run --dart-define API_BASE_URL=https://api.ornek.com/api`
2. Flutter Web'de bulunduğunuz host + `:5236/api`
3. Android emülatörleri için `http://10.0.2.2:5236/api`
4. Diğer platformlar için `http://localhost:5236/api`

Yerel geliştirme için:

```bash
# Backend'i başlatın
cd staj-forum-backend
dotnet run

# Flutter Web
cd stajappflutter
flutter run -d chrome --web-hostname localhost --web-port 5174

# Farklı bir API adresi kullanmak isterseniz
flutter run -d chrome --dart-define API_BASE_URL=https://demo.stajforum.com/api
```

Android/iOS cihazlarında kendi makinenize erişebilmek için gerekli network/security ayarlarını `FRONTEND_BACKEND_BAGLANTI_REHBERI.txt` dokümanından kontrol edin.

## Test

```bash
flutter test
```

## Notlar

- Backend API'si çalışır durumda değilse forum ve iletişim sayfaları bağlantı hatası gösterecektir.
- Hata mesajları, kullanılan API adresini de belirterek daha kolay debug edilmesine yardımcı olur.
- Production dağıtımlarında mutlaka gerçek API URL'sini `API_BASE_URL` ile geçin. 
