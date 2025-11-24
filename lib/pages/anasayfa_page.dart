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
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.colorBgTertiary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'StajForum\'a Hoş Geldiniz!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colorTextPrimary,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'StajForum; öğrencilerin staj süreçlerinde bilgi paylaşımı yapabileceği, deneyimlerini aktarabileceği ve yeni fırsatlara ulaşabileceği bir topluluk platformudur.',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.7,
                                color: AppTheme.colorTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Neler Sunuyoruz
                      _buildInfoSection(
                        title: '🚀 Neler Sunuyoruz?',
                        content: const [
                          '🔍 Staj yeri incelemeleri ve yorumlar',
                          '💬 Forum ortamında bilgi paylaşımı',
                          '📄 Staj başvurusu rehberleri',
                          '🎓 Deneyim temelli içerikler ve ipuçları',
                        ],
                      ),

                      // Amacımız
                      _buildInfoSection(
                        title: '💡 Amacımız',
                        isListStyle: false,
                        description:
                            'StajForum, üniversite öğrencileri için staj sürecini daha şeffaf, erişilebilir ve öğretici hale getirmeyi amaçlar. Öğrenciler kendi staj deneyimlerini paylaşabilir, firmalar hakkında yorum yapabilir ve staj başvurusu yapmadan önce gerçek kullanıcı deneyimlerinden faydalanabilir.',
                      ),

                      // Kimler Kullanabilir
                      _buildInfoSection(
                        title: '👥 Kimler Kullanabilir?',
                        isListStyle: false,
                        description:
                            'Platform, öncelikle üniversite öğrencileri, yeni mezunlar ve stajyer arayan firmalar için tasarlanmıştır. Kullanıcılar kayıt olmadan, sadece Ad-Soyad girerek forumda yorum yapabilir ve topluluğa katkı sağlayabilir.',
                      ),

                      // Topluluk Gücü
                      _buildInfoSection(
                        title: '🌍 Topluluk Gücü',
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

  Widget _buildInfoSection({
    required String title,
    List<String>? content,
    String? description,
    bool isListStyle = true,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.colorBgTertiary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.colorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (isListStyle && content != null)
            ...content.map((item) => _buildFeatureItem(item))
          else if (description != null)
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
                color: AppTheme.colorTextPrimary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.colorPrimaryLight,
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          left: BorderSide(color: AppTheme.colorBorderAccent, width: 5),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppTheme.colorTextPrimary,
        ),
      ),
    );
  }
}




