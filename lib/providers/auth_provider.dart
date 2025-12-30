import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/auth_request.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _loadUserFromStorage();
  }

  // SharedPreferences'dan kullanıcı bilgilerini yükle
  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');

      if (token != null && userData != null) {
        _user = User.fromJson(json.decode(userData) as Map<String, dynamic>);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from storage: $e');
    }
  }

  // Kullanıcı bilgilerini kaydet
  Future<void> _saveUserToStorage(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', json.encode(user.toJson()));
  }

  // Kullanıcı bilgilerini temizle
  Future<void> _clearUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      _user = response.user;
      _isAuthenticated = true;
      await _saveUserToStorage(response.user, response.token);
      await ApiClient.saveToken(response.token);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      final response = await _authService.register(request);

      _user = response.user;
      _isAuthenticated = true;
      await _saveUserToStorage(response.user, response.token);
      await ApiClient.saveToken(response.token);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    await _clearUserFromStorage();
    await ApiClient.clearToken();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Error message helper
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('Email already exists')) {
      return 'Bu e-posta adresi zaten kullanılıyor.';
    } else if (error.toString().contains('Wrong password')) {
      return 'Hatalı şifre.';
    } else if (error.toString().contains('User not found')) {
      return 'Kullanıcı bulunamadı.';
    } else if (error.toString().contains('SocketException')) {
      return 'İnternet bağlantınızı kontrol edin.';
    }
    return 'Bir hata oluştu. Lütfen tekrar deneyin.';
  }
}
