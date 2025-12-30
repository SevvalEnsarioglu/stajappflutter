import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/forum_service.dart';
import '../models/topic.dart';
import '../models/reply.dart';
import '../widgets/user_topic_card.dart';
import '../widgets/user_reply_card.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ForumService _forumService = ForumService();
  
  List<Topic> _userTopics = [];
  List<Reply> _userReplies = [];
  bool _isLoadingTopics = true;
  bool _isLoadingReplies = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserContent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserContent() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    // Load topics
    _loadUserTopics(authProvider.user!.id);
    
    // Load replies
    _loadUserReplies(authProvider.user!.id);
  }

  Future<void> _loadUserTopics(int userId) async {
    setState(() => _isLoadingTopics = true);
    try {
      final response = await _forumService.getUserTopics(userId);
      setState(() {
        _userTopics = response.data;
        _isLoadingTopics = false;
      });
    } catch (e) {
      setState(() => _isLoadingTopics = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konular yüklenirken hata: $e')),
        );
      }
    }
  }

  Future<void> _loadUserReplies(int userId) async {
    setState(() => _isLoadingReplies = true);
    try {
      final response = await _forumService.getUserReplies(userId);
      setState(() {
        _userReplies = response.data;
        _isLoadingReplies = false;
      });
    } catch (e) {
      setState(() => _isLoadingReplies = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yorumlar yüklenirken hata: $e')),
        );
      }
    }
  }

  Future<void> _handleDeleteTopic(int topicId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konuyu Sil'),
        content: const Text('Bu konuyu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _forumService.deleteTopic(topicId);
      setState(() {
        _userTopics.removeWhere((topic) => topic.id == topicId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konu başarıyla silindi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Konu silinirken hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteReply(int replyId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yorumu Sil'),
        content: const Text('Bu yorumu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _forumService.deleteReply(replyId);
      setState(() {
        _userReplies.removeWhere((reply) => reply.id == replyId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yorum başarıyla silindi'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yorum silinirken hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated || authProvider.user == null) {
          // Giriş yapmamış - giriş sayfasına yönlendir
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/giris');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authProvider.user!;

        return Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          appBar: AppBar(
            title: const Text('Profilim'),
            backgroundColor: AppTheme.primaryColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.initials,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Name
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Email
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Logout Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        await authProvider.logout();
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Çıkış Yap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Tab Bar
              Container(
                color: AppTheme.surfaceDark,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondary,
                  indicatorColor: AppTheme.primaryColor,
                  tabs: [
                    Tab(text: 'Konularım (${_userTopics.length})'),
                    Tab(text: 'Yorumlarım (${_userReplies.length})'),
                  ],
                ),
              ),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Topics Tab
                    _isLoadingTopics
                        ? const Center(child: CircularProgressIndicator())
                        : _userTopics.isEmpty
                            ? const Center(
                                child: Text(
                                  'Henüz açtığınız bir konu bulunmuyor.',
                                  style: TextStyle(color: AppTheme.textSecondary),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _userTopics.length,
                                itemBuilder: (context, index) {
                                  return UserTopicCard(
                                    topic: _userTopics[index],
                                    onDelete: () => _handleDeleteTopic(_userTopics[index].id),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/forum/${_userTopics[index].id}',
                                      );
                                    },
                                  );
                                },
                              ),
                    
                    // Replies Tab
                    _isLoadingReplies
                        ? const Center(child: CircularProgressIndicator())
                        : _userReplies.isEmpty
                            ? const Center(
                                child: Text(
                                  'Henüz yaptığınız bir yorum bulunmuyor.',
                                  style: TextStyle(color: AppTheme.textSecondary),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _userReplies.length,
                                itemBuilder: (context, index) {
                                  return UserReplyCard(
                                    reply: _userReplies[index],
                                    onDelete: () => _handleDeleteReply(_userReplies[index].id),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/forum/${_userReplies[index].topicId}',
                                      );
                                    },
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
