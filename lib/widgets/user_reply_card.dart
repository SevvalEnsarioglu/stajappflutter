import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import '../config/theme.dart';
import '../models/reply.dart';

class UserReplyCard extends StatelessWidget {
  final Reply reply;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UserReplyCard({
    super.key,
    required this.reply,
    required this.onDelete,
    required this.onTap,
  });

  String _stripHtml(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final plainContent = _stripHtml(reply.content);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.surfaceLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content
              Text(
                plainContent,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Meta Info
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(reply.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                
                  
                  const Spacer(),
                  
                  // Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    iconSize: 20,
                    onPressed: onDelete,
                    tooltip: 'Sil',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
