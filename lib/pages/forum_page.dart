import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/contact.dart';
import '../models/topic.dart';
import '../services/forum_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/topic_card.dart';

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

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  List<Topic> _topics = [];

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
      final response = await _forumService.getTopics(page: 1, pageSize: 50);
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
                      const Text(
                        'Yeni Topic Oluştur',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
                  _buildTextField(
                    controller: _contentController,
                    label: 'İçerik',
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'İçerik 10-5000 karakter arasında olmalıdır.';
                      }
                      if (value.trim().length < 10 ||
                          value.trim().length > 5000) {
                        return 'İçerik 10-5000 karakter arasında olmalıdır.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
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
    if (!_formKey.currentState!.validate()) {
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
          ),
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      appBar: const TopAppBarWidget(),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchTopics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Forum',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _openCreateTopicSheet,
                              icon: const Icon(Icons.add),
                              label: const Text('Topic Oluştur'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        else if (_topics.isEmpty)
                          const Text(
                            'Henüz topic bulunmamaktadır.',
                            style: TextStyle(fontSize: 16),
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

