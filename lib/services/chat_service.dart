import 'package:dio/dio.dart';
import '../models/chat_response.dart';
import 'api_client.dart';

class ChatService {
  final Dio _dio = ApiClient.instance;

  Future<ChatResponse> sendMessage(String message, {String? conversationId}) async {
    try {
      final response = await _dio.post(
        '/chat',
        data: {
          'message': message,
          'conversationId': conversationId,
        },
      );
      return ChatResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data['message'] ?? 'Mesaj gönderilemedi');
      }
      throw Exception('Bir hata oluştu: $e');
    }
  }
}
