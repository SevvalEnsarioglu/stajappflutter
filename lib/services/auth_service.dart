import 'package:dio/dio.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'api_client.dart';

class AuthService {
  AuthService({Dio? client}) : _client = client ?? ApiClient.instance;

  final Dio _client;

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _client.post(
      '/auth/login',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _client.post(
      '/auth/register',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
