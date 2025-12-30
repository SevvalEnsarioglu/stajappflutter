import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../config/theme.dart';
import '../models/reply.dart';
import '../models/reply_request.dart';
import '../models/topic.dart';
import '../services/forum_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/rich_text_editor.dart';

class ForumKonuSecimiPage extends StatefulWidget {
  final String id;

  const ForumKonuSecimiPage({super.key, required this.id});

  @override
  State<ForumKonuSecimiPage> createState() => _ForumKonuSecimiPageState();
}

class _ForumKonuSecimiPageState extends State<ForumKonuSecimiPage> {
  final ForumService _forumService = ForumService();
  bool _isLoading = true;
  String? _errorMessage;
  Topic? _topic;
  List<Reply> _replies = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final topicId = int.tryParse(widget.id);
      if (topicId == null) {
        throw Exception("Geçersiz konu ID");
      }

      final topic = await _forumService.getTopicById(topicId);
      // Yanıtları da çekebiliriz - sayfa 1
      final repliesResponse = await _forumService.getReplies(topicId);

      if (mounted) {
        setState(() {
          _topic = topic;
          _replies = repliesResponse.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is DioException
              ? (e.response?.data['message'] ?? e.message)
              : e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: const TopAppBarWidget(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          'Hata: $_errorMessage',
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Topic Header Card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryColor.withValues(alpha: 0.05),
                                        blurRadius: 20,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _topic?.title ?? 'Konu Başlığı',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: AppTheme.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.person,
                                                  size: 16,
                                                  color: AppTheme.secondaryColor),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Yazar: ${_topic?.authorName}',
                                                style: const TextStyle(
                                                    color: AppTheme.textSecondary),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Tarih: ${_formatDate(_topic?.createdAt)}',
                                            style: const TextStyle(
                                                color: AppTheme.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Topic Content
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundDark,
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: AppTheme.surfaceLight),
                                  ),
                                  child: HtmlWidget(
                                    _topic?.content ?? '',
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppTheme.textPrimary,
                                          height: 1.6,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Replies Section
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: AppTheme.surfaceLight),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Yanıtlar',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color: AppTheme.primaryColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '(${_replies.length})',
                                                style: const TextStyle(
                                                    color: AppTheme.textSecondary),
                                              ),
                                            ],
                                          ),
                                          TextButton.icon(
                                            onPressed: () => _showAddReplySheet(),
                                            icon: const Icon(Icons.add_comment, size: 18),
                                            label: const Text("Yanıtla"),
                                            style: TextButton.styleFrom(
                                              foregroundColor: AppTheme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      if (_replies.isEmpty)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppTheme.backgroundDark
                                                .withValues(alpha: 0.5),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: AppTheme.surfaceLight),
                                          ),
                                          child: Text(
                                            'Henüz yanıt bulunmamaktadır.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppTheme.textSecondary,
                                                ),
                                          ),
                                        )
                                      else
                                        ..._replies.map((reply) => _buildReplyItem(reply)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
          const BottomBarWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReplySheet(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.comment, color: Colors.black),
      ),
      drawer: isMobile ? const CommonDrawer() : null,
    );
  }

  void _showAddReplySheet() {
    final TextEditingController nameController = TextEditingController(text: " ");
    final TextEditingController contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yanıt Gönder',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.surfaceLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RichTextEditorWidget(
                 height: 250,
                 placeholder: 'Yanıtınızı buraya yazın...',
                 onChanged: (html) {
                   contentController.text = html;
                 },
               ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (contentController.text.trim().isEmpty || contentController.text == '<p><br></p>') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen bir yanıt yazın.'),
                          backgroundColor: AppTheme.errorColor,
                        ),
                      );
                      return;
                    }

                    try {
                      Navigator.pop(context); // Close sheet immediately to feel faster
                      
                      // Show loading via global isLoading if desired, or optimistic UI.
                      // For now we just call API and refresh.

                      final request = ReplyRequest(
                        content: contentController.text.trim(),
                        authorName: nameController.text.trim().isNotEmpty
                            ? nameController.text.trim()
                            : "Misafir",
                      );

                      if (widget.id.isEmpty) return;
                      final topicId = int.tryParse(widget.id);
                      if (topicId == null) return;

                      // Call backend
                      await _forumService.createReply(topicId, request);
                      
                      // Refresh list
                      await _fetchData();
                         
                      if (context.mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(
                             content: Text('Yanıtınız gönderildi!'),
                             backgroundColor: AppTheme.successColor,
                           ),
                         );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Hata: $e'),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('GÖNDER', style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReplyItem(Reply reply) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reply.authorName,
                style: const TextStyle(
                  color: AppTheme.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDate(reply.createdAt),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          HtmlWidget(
            reply.content,
            textStyle: const TextStyle(
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown Date";
    return "${date.day}/${date.month}/${date.year}";
  }
}
