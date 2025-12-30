import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../config/theme.dart';
import '../models/topic.dart';

class TopicCardWidget extends StatelessWidget {
  const TopicCardWidget({
    super.key,
    required this.topic,
    required this.onTap,
  });

  final Topic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String cleanContent = topic.content;
    try {
      final document = parse(topic.content);
      cleanContent = document.body?.text ?? topic.content;
    } catch (_) {}

    final description = cleanContent.length > 200
        ? '${cleanContent.substring(0, 200)}...'
        : cleanContent;

    return Card(
      // CardTheme is already defined in theme.dart
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.person,
                        color: AppTheme.primaryColor, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    topic.authorName,
                    style: const TextStyle(
                      color: AppTheme.primaryColor, // Neon Cyan for Author
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(topic.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                topic.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary, // Grey for body text
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.comment, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    '${topic.replyCount} Yanıt',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.remove_red_eye, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    '${topic.viewCount} Görüntüleme',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown Date";
    return "${date.day}/${date.month}/${date.year}";
  }
}


