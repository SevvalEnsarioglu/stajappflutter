import 'pagination.dart';

class Reply {
  final int id;
  final int topicId;
  final String content;
  final String authorName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reply({
    required this.id,
    required this.topicId,
    required this.content,
    required this.authorName,
    this.createdAt,
    this.updatedAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'] as int,
      topicId: json['topicId'] as int,
      content: json['content'] ?? '',
      authorName: json['authorName'] ?? 'Bilinmeyen',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class ReplyListResponse {
  final List<Reply> data;
  final Pagination pagination;

  ReplyListResponse({
    required this.data,
    required this.pagination,
  });

  factory ReplyListResponse.fromJson(Map<String, dynamic> json) {
    return ReplyListResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((replyJson) => Reply.fromJson(replyJson))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
