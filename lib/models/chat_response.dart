class ChatResponse {
  final String response;
  final String conversationId;
  final String timestamp;

  ChatResponse({
    required this.response,
    required this.conversationId,
    required this.timestamp,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] ?? '',
      conversationId: json['conversationId'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
