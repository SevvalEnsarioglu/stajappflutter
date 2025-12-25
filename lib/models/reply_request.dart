class ReplyRequest {
  final String content;
  final String authorName;

  ReplyRequest({
    required this.content,
    required this.authorName,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'authorName': authorName,
    };
  }
}
