import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../config/theme.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../widgets/top_app_bar.dart';

class IletisimPage extends StatefulWidget {
  const IletisimPage({super.key});

  @override
  State<IletisimPage> createState() => _IletisimPageState();
}

class _IletisimPageState extends State<IletisimPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ContactService _contactService = ContactService();
  final String _apiBaseUrl = ApiConfig.baseUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _showSuccess = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final request = ContactRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    try {
      await _contactService.sendContact(request);
      if (!mounted) return;
      setState(() {
        _showSuccess = true;
        _errorMessage = null;
      });
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();

      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _showSuccess = false;
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _describeError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
            child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                      'İletişim',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sorularınız, önerileriniz veya destek talepleriniz için bizimle iletişime geçebilirsiniz.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      if (_showSuccess)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Text(
                            '✓ Başarılı! Mesajınız başarıyla gönderildi. En kısa sürede size dönüş yapacağız.',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            '✗ Hata: $_errorMessage',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildFormField(
                              controller: _nameController,
                              label: 'Ad Soyad *',
                              hint: 'Ad Soyad',
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Ad Soyad zorunludur.';
                                }
                                if (text.length < 2) {
                                  return 'Ad Soyad en az 2 karakter olmalıdır.';
                                }
                                if (text.length > 100) {
                                  return 'Ad Soyad en fazla 100 karakter olabilir.';
                                }
                                return null;
                              },
                            ),
                            _buildFormField(
                              controller: _emailController,
                              label: 'E-posta *',
                              hint: 'ornek@email.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                final emailRegex =
                                    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                                if (text.isEmpty) {
                                  return 'E-posta zorunludur.';
                                }
                                if (!emailRegex.hasMatch(text)) {
                                  return 'Geçerli bir e-posta adresi giriniz.';
                                }
                                if (text.length > 255) {
                                  return 'E-posta en fazla 255 karakter olabilir.';
                                }
                                return null;
                              },
                            ),
                            _buildFormField(
                              controller: _subjectController,
                              label: 'Konu *',
                              hint: 'Mesajınızın konusu',
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Konu zorunludur.';
                                }
                                if (text.length < 3) {
                                  return 'Konu en az 3 karakter olmalıdır.';
                                }
                                if (text.length > 200) {
                                  return 'Konu en fazla 200 karakter olabilir.';
                                }
                                return null;
                              },
                            ),
                            _buildFormField(
                              controller: _messageController,
                              label: 'Mesaj *',
                              hint: 'Mesajınızı buraya yazın...',
                              maxLines: 6,
                              helper:
                                  '${_messageController.text.length} / 2000 karakter',
                              validator: (value) {
                                final text = value?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Mesaj zorunludur.';
                                }
                                if (text.length < 10) {
                                  return 'Mesaj en az 10 karakter olmalıdır.';
                                }
                                if (text.length > 2000) {
                                  return 'Mesaj en fazla 2000 karakter olabilir.';
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _handleSubmit,
                                child: Text(
                                  _isSubmitting
                                      ? 'Gönderiliyor...'
                                      : 'Mesaj Gönder',
                                ),
                              ),
                            ),
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
      drawer: isMobile ? const CommonDrawer() : null,
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? helper,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.colorTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
          if (helper != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                helper,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.colorTextMuted,
                ),
              ),
            ),
        ],
      ),
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
        return 'Backend ile bağlantı kurulamadı. '
            'API adresi: $_apiBaseUrl. Lütfen backend servisinin çalıştığını doğrulayın.';
      }

      if (serverMessage is String && serverMessage.isNotEmpty) {
        return serverMessage;
      }

      if (error.message != null && error.message!.isNotEmpty) {
        return error.message!;
      }
    }

    return 'Mesaj gönderilirken bir hata oluştu. Detay: $error';
  }
}

