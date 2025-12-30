import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiClient {
  ApiClient._();

  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {'Content-Type': 'application/json'},
        ),
      );

      // JWT Token Interceptor
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // SharedPreferences'dan token'ı al
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('auth_token');
            
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            
            handler.next(options);
          },
          onError: (error, handler) async {
            // 401 Unauthorized - Token geçersiz
            if (error.response?.statusCode == 401) {
              // Token'ı temizle
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');
              await prefs.remove('user_data');
            }
            handler.next(error);
          },
        ),
      );
    }
    return _dio!;
  }

  // Token'ı kaydet
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Token'ı al
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Token'ı sil
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
