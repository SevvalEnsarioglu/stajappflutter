import 'package:flutter/foundation.dart';

/// Tek bir yerden API taban adresini yönetmek için yardımcı sınıf.
/// Varsayılan olarak aşağıdaki öncelik sırasıyla adres belirlenir:
/// 1. build/run sırasında verilen --dart-define=API_BASE_URL
/// 2. Web'de bulunduğunuz makinenin host'u + 5236 portu
/// 3. Android emülatörleri için 10.0.2.2
/// 4. Diğer tüm platformlar için localhost
class ApiConfig {
  static const String _envUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get baseUrl {
    if (_envUrl.isNotEmpty) {
      return _envUrl;
    }

    if (kIsWeb) {
      final uri = Uri.base;
      final host = uri.host.isEmpty ? 'localhost' : uri.host;
      final scheme = uri.scheme == 'https' ? 'https' : 'http';
      return '$scheme://$host:5236/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android emülatörlerinde localhost yerine 10.0.2.2 kullanılmalı.
      return 'http://10.0.2.2:5236/api';
    }

    return 'http://localhost:5236/api';
  }
}

