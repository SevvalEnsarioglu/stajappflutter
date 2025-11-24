class ContactRequest {
  final String name;
  final String email;
  final String subject;
  final String message;

  ContactRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
      };
}

class TopicRequest {
  final String title;
  final String content;
  final String authorName;

  TopicRequest({
    required this.title,
    required this.content,
    required this.authorName,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'authorName': authorName,
      };
}


