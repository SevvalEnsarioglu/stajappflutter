import 'package:flutter/material.dart';

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
    final description = topic.content.length > 200
        ? '${topic.content.substring(0, 200)}...'
        : topic.content;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.colorBgTertiary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: AppTheme.colorSecondary, size: 18),
                const SizedBox(width: 8),
                Text(
                  topic.authorName,
                  style: const TextStyle(
                    color: AppTheme.colorSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              topic.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.colorTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppTheme.colorTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


