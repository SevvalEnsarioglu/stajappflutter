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
}


