import 'pagination.dart';

class Topic {
  final int id;
  final String title;
  final String content;
  final String authorName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? viewCount;
  final int? replyCount;

  Topic({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    this.createdAt,
    this.updatedAt,
    this.viewCount,
    this.replyCount,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorName: json['authorName'] ?? 'Bilinmeyen',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      viewCount: json['viewCount'],
      replyCount: json['replyCount'],
    );
  }
}

class TopicListResponse {
  final List<Topic> data;
  final Pagination pagination;

  TopicListResponse({
    required this.data,
    required this.pagination,
  });

  factory TopicListResponse.fromJson(Map<String, dynamic> json) {
    return TopicListResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((topicJson) => Topic.fromJson(topicJson))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}


