import 'package:flutter/material.dart';

import '../services/chat_service.dart';
import '../config/theme.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../widgets/top_app_bar.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatStjPage extends StatefulWidget {
  const ChatStjPage({super.key});

  @override
  State<ChatStjPage> createState() => _ChatStjPageState();
}

class _ChatStjPageState extends State<ChatStjPage> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text:
          'Merhaba! Staj hakkında sorularınızı sorabilirsiniz. Size nasıl yardımcı olabilirim?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final ChatService _chatService = ChatService();
  String? _conversationId;

  // ... (dispose and _scrollToBottom methods remain the same)

  Future<void> _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isBotTyping) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
      _isBotTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await _chatService.sendMessage(text, conversationId: _conversationId);
      
      if (_conversationId == null && response.conversationId.isNotEmpty) {
        _conversationId = response.conversationId;
      }

      final botMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: response.response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      if (!mounted) return;
      setState(() {
        _messages.add(botMessage);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
       // Add error message to chat
      final errorMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: "Üzgünüm, şu an bağlantı kuramıyorum. Lütfen daha sonra tekrar deneyin.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(errorMessage);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBotTyping = false;
        });
        _scrollToBottom();
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
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.surfaceLight,
                              ),
                              child: const Icon(Icons.forum, color: AppTheme.primaryColor)),
                          const SizedBox(width: 12),
                          const Text(
                            'ChatSTJ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.surfaceLight),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _messages.length + (_isBotTyping ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (_isBotTyping && index == _messages.length) {
                                    return _buildTypingIndicator();
                                  }
                                  final message = _messages[index];
                                  return _ChatBubble(message: message);
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    minLines: 1,
                                    maxLines: 4,
                                    style: const TextStyle(color: AppTheme.textPrimary),
                                    decoration: const InputDecoration(
                                      hintText: 'Mesajınızı yazın...',
                                      hintStyle: TextStyle(color: AppTheme.textSecondary),
                                      border: OutlineInputBorder(),
                                    ),
                                    onSubmitted: (_) => _handleSendMessage(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _handleSendMessage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.secondaryColor,
                                    padding: const EdgeInsets.all(16),
                                  ),
                                  child: const Icon(Icons.send, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor),
            ),
            SizedBox(width: 8),
            Text('Yazıyor...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor =
        message.isUser ? AppTheme.primaryColor.withValues(alpha: 0.2) : AppTheme.surfaceLight;
    final borderColor =
        message.isUser ? AppTheme.primaryColor : Colors.transparent;
    final textColor =
        message.isUser ? AppTheme.textPrimary : AppTheme.textPrimary;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor, fontSize: 15),
        ),
      ),
    );
  }
}

