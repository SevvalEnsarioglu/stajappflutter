import 'package:flutter/material.dart';
import '../services/chat_service.dart';
import '../config/theme.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/common_drawer.dart';

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// ... (keep libraries)

class CVAnalizPage extends StatefulWidget {
  const CVAnalizPage({super.key});

  @override
  State<CVAnalizPage> createState() => _CVAnalizPageState();
}

class _CVAnalizPageState extends State<CVAnalizPage> {
  final TextEditingController _cvController = TextEditingController();
  final ChatService _chatService = ChatService();
  String? _result;
  bool _isLoading = false;

  Future<void> _handlePdfUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _isLoading = true;
          _cvController.text = "PDF Okunuyor...";
        });

        String extractedText = '';
        if (kIsWeb) {
           // Web
           final bytes = result.files.single.bytes!;
           final PdfDocument document = PdfDocument(inputBytes: bytes);
           extractedText = PdfTextExtractor(document).extractText();
           document.dispose();
        } else {
           // Mobile/Desktop
           final path = result.files.single.path!;
           final File file = File(path);
           final bytes = await file.readAsBytes();
           final PdfDocument document = PdfDocument(inputBytes: bytes);
           extractedText = PdfTextExtractor(document).extractText();
           document.dispose();
        }

        setState(() {
            _cvController.text = extractedText;
            _isLoading = false;
        });
      }
    } catch (e) {
        setState(() {
            _isLoading = false;
            _cvController.text = "";
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dosya okuma hatası: $e'), backgroundColor: AppTheme.errorColor),
        );
    }
  }

  Future<void> _handleAnalyze() async {
    final text = _cvController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final analysis = await _chatService.analyzeCV(text);
      if (!mounted) return;
      setState(() {
        _result = analysis;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e'), backgroundColor: AppTheme.errorColor),
      );
    } finally {
      if (mounted) {
        setState(() {
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
      drawer: isMobile ? const CommonDrawer() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'AI CV Analizi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                const Text(
                  "CV'nizi PDF formatında yükleyin, yapay zeka sizin için analiz etsin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                
                 const SizedBox(height: 24),
                 Center(
                   child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handlePdfUpload,
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: const Text('PDF CV Yükle'),
                      style: AppTheme.cvUploadButtonStyle,
                   ),
                 ),

                if (_cvController.text.isNotEmpty && !_isLoading && !_cvController.text.startsWith('PDF')) ...[
                     const SizedBox(height: 16),
                     const Center(
                         child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                                 Icon(Icons.check_circle, color: Colors.green),
                                 SizedBox(width: 8),
                                 Text("PDF Başarıyla Okundu", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                             ],
                         ),
                     ),
                     const SizedBox(height: 24),
                     ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleAnalyze,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.analytics_outlined, color: Colors.white),
                      label: Text(_isLoading ? 'Analiz Ediliyor...' : 'Analizi Başlat'),
                      style: AppTheme.cvAnalyzeButtonStyle,
                    ),
                ],
                if (_result != null) ...[
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.cvResultContainerDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Analiz Sonucu:',
                          style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _result!,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
