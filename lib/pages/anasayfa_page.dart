import 'package:flutter/material.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../config/theme.dart';

class AnasayfaPage extends StatelessWidget {
  const AnasayfaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBarWidget(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'StajForum\'a Hoş Geldiniz! 🚀',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'StajForum; öğrencilerin staj süreçlerinde bilgi paylaşımı yapabileceği, deneyimlerini aktarabileceği ve yeni fırsatlara ulaşabileceği bir topluluk platformudur.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.6,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Neler Sunuyoruz
                      _buildInfoSection(
                        context,
                        title: 'Neler Sunuyoruz?',
                        content: const [
                          '🔍 Staj yeri incelemeleri ve yorumlar',
                          '💬 Forum ortamında bilgi paylaşımı',
                          '📄 Staj başvurusu rehberleri',
                          '🎓 Deneyim temelli içerikler ve ipuçları',
                        ],
                      ),

                      // Amacımız
                      _buildInfoSection(
                        context,
                        title: 'Amacımız 💡',
                        isListStyle: false,
                        description:
                            'StajForum, üniversite öğrencileri için staj sürecini daha şeffaf, erişilebilir ve öğretici hale getirmeyi amaçlar. Öğrenciler kendi staj deneyimlerini paylaşabilir, firmalar hakkında yorum yapabilir ve staj başvurusu yapmadan önce gerçek kullanıcı deneyimlerinden faydalanabilir.',
                      ),

                      // Kimler Kullanabilir
                      _buildInfoSection(
                        context,
                        title: 'Kimler Kullanabilir? 👥',
                        isListStyle: false,
                        description:
                            'Platform, öncelikle üniversite öğrencileri, yeni mezunlar ve stajyer arayan firmalar için tasarlanmıştır. Kullanıcılar kayıt olmadan, sadece Ad-Soyad girerek forumda yorum yapabilir ve topluluğa katkı sağlayabilir.',
                      ),

                      // Topluluk Gücü
                      _buildInfoSection(
                        context,
                        title: 'Topluluk Gücü 🌍',
                        isListStyle: false,
                        description:
                            'Her öğrenci kendi deneyimini paylaşarak başkalarının yolunu aydınlatır. StajForum, dayanışma kültürünü dijital ortama taşıyarak bilgiye erişimi kolaylaştırır.',
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
      drawer: MediaQuery.of(context).size.width <= 900
          ? const CommonDrawer()
          : null,
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    List<String>? content,
    String? description,
    bool isListStyle = true,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.6), // Slightly transparent for glass feel
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.surfaceLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          if (isListStyle && content != null)
            ...content.map((item) => _buildFeatureItem(context, item))
          else if (description != null)
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2), // Subtle neon border
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.secondaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}




