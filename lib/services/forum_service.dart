import 'package:dio/dio.dart';

import '../models/contact.dart';
import '../models/reply.dart';
import '../models/reply_request.dart';
import '../models/topic.dart';
import 'api_client.dart';

class ForumService {
  ForumService({Dio? client}) : _client = client ?? ApiClient.instance;

  final Dio _client;

  Future<TopicListResponse> getTopics({
    int page = 1,
    int pageSize = 50,
    String? sortBy, // Changed to nullable String? sortBy
    String? search,
  }) async {
    final response = await _client.get(
      '/forum/topics',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (sortBy != null) 'sortBy': sortBy, // Conditionally add sortBy if not null
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return TopicListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Topic> createTopic(TopicRequest request) async {
    final response = await _client.post(
      '/forum/topics',
      data: request.toJson(),
    );
    return Topic.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Topic> getTopicById(int id) async {
    final response = await _client.get('/forum/topics/$id');
    return Topic.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ReplyListResponse> getReplies(
    int topicId, {
    int page = 1,
    int pageSize = 20,
    String sortBy = 'oldest',
  }) async {
    final response = await _client.get(
      '/forum/topics/$topicId/replies',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'sortBy': sortBy,
      },
    );
    return ReplyListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Reply> createReply(int topicId, ReplyRequest request) async {
    final response = await _client.post(
      '/forum/topics/$topicId/replies',
      data: request.toJson(),
    );
    return Reply.fromJson(response.data as Map<String, dynamic>);
  }

  // Kullanıcının topic'lerini getir
  Future<TopicListResponse> getUserTopics(
    int userId, {
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await _client.get(
      '/forum/users/$userId/topics',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    return TopicListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  // Kullanıcının reply'lerini getir
  Future<ReplyListResponse> getUserReplies(
    int userId, {
    int page = 1,
    int pageSize = 50,
  }) async {
    final response = await _client.get(
      '/forum/users/$userId/replies',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    return ReplyListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  // Topic güncelle
  Future<Topic> updateTopic(int id, String title, String content) async {
    final response = await _client.put(
      '/forum/topics/$id',
      data: {
        'title': title,
        'content': content,
      },
    );
    return Topic.fromJson(response.data as Map<String, dynamic>);
  }

  // Topic sil
  Future<void> deleteTopic(int id) async {
    await _client.delete('/forum/topics/$id');
  }

  // Reply güncelle
  Future<Reply> updateReply(int id, String content, String authorName) async {
    final response = await _client.put(
      '/forum/replies/$id',
      data: {
        'content': content,
        'authorName': authorName,
      },
    );
    return Reply.fromJson(response.data as Map<String, dynamic>);
  }

  // Reply sil
  Future<void> deleteReply(int id) async {
    await _client.delete('/forum/replies/$id');
  }
}
