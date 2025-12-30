import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../config/theme.dart';
import '../models/contact.dart';
import '../models/topic.dart';
import '../services/forum_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/topic_card.dart';
import '../widgets/rich_text_editor.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final ForumService _forumService = ForumService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final String _apiBaseUrl = ApiConfig.baseUrl;

  String _sortBy = "newest";

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  List<Topic> _topics = [];
  String? _contentError;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _fetchTopics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _forumService.getTopics(page: 1, pageSize: 50, sortBy: _sortBy);
      setState(() {
        _topics = response.data;
      });
    } catch (error) {
      setState(() {
        _errorMessage = _describeError(error);
        _topics = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openCreateTopicSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        'Yeni Konu Oluştur',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _authorController,
                    label: 'Ad Soyad',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ad-Soyad 2-100 karakter arasında olmalıdır.';
                      }
                      if (value.trim().length < 2 || value.trim().length > 100) {
                        return 'Ad-Soyad 2-100 karakter arasında olmalıdır.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Başlık',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Başlık 3-200 karakter arasında olmalıdır.';
                      }
                      if (value.trim().length < 3 || value.trim().length > 200) {
                        return 'Başlık 3-200 karakter arasında olmalıdır.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Text(
                    'İçerik',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  RichTextEditorWidget(
                    onChanged: (html) {
                      _contentController.text = html;
                      if (_contentError != null) {
                        setState(() {
                          _contentError = null;
                        });
                      }
                    },
                    height: 300,
                  ),
                  if (_contentError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12),
                      child: Text(
                        _contentError!,
                        style: TextStyle(color: AppTheme.errorColor, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                        ),
                        child: const Text('İptal'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitTopic,
                        child: Text(_isSubmitting ? 'Kaydediliyor...' : 'Kaydet'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitTopic() async {
    setState(() {
      _contentError = null;
    });

    final isFormValid = _formKey.currentState!.validate();
    
    // Manual validation for content
    final content = _contentController.text.trim();
    final isContentValid = content.isNotEmpty && content != '<p><br></p>';
    
    if (!isContentValid) {
      setState(() {
        _contentError = 'İçerik girilmesi zorunludur.';
      });
    }

    if (!isFormValid || !isContentValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final request = TopicRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      authorName: _authorController.text.trim(),
    );

    try {
      await _forumService.createTopic(request);
      if (!mounted) return;
      Navigator.of(context).pop();
      _authorController.clear();
      _titleController.clear();
      _contentController.clear();
      _contentError = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Topic başarıyla oluşturuldu.')),
      );
      await _fetchTopics();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _describeError(error),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: TopAppBarWidget(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: AppTheme.textPrimary),
            tooltip: 'Sırala',
            onSelected: (String result) {
              setState(() {
                _sortBy = result;
              });
              _fetchTopics();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'newest',
                child: Text('En Yeni'),
              ),
              const PopupMenuItem<String>(
                value: 'oldest',
                child: Text('En Eski'),
              ),
              const PopupMenuItem<String>(
                value: 'popular',
                child: Text('En Çok Görüntülenen'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchTopics,
              color: AppTheme.primaryColor,
              backgroundColor: AppTheme.surfaceDark,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Forum 💬',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: _openCreateTopicSheet,
                              icon: const Icon(Icons.add),
                              label: const Text('Konu Oluştur'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.black,
                                elevation: 8,
                                shadowColor: AppTheme.primaryColor.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.errorColor),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppTheme.errorColor),
                            ),
                          )
                        else if (_topics.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.inbox, size: 60, color: AppTheme.textSecondary),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Henüz konu bulunmamaktadır.',
                                    style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Column(
                            children: _topics
                                .map(
                                  (topic) => TopicCardWidget(
                                    topic: topic,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/forum/${topic.id}',
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const BottomBarWidget(),
        ],
      ),
      drawer: isMobile ? const CommonDrawer() : null,
    );
  }

  String _describeError(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      final serverMessage = responseData is Map<String, dynamic>
          ? (responseData['error'] ?? responseData['message'])
          : responseData?.toString();

      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown) {
        return 'Backend ile bağlantı kurulamadı. API adresi: $_apiBaseUrl. '
            'Lütfen backend\'i çalıştırıp bu adrese erişebildiğinizden emin olun.';
      }

      if (serverMessage is String && serverMessage.isNotEmpty) {
        return serverMessage;
      }

      if (error.message != null && error.message!.isNotEmpty) {
        return error.message!;
      }
    }

    return 'Beklenmeyen bir hata oluştu. Detay: $error';
  }
}
