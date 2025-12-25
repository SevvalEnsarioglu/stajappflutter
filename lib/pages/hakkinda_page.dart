import 'package:flutter/material.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/common_drawer.dart';
import '../config/theme.dart';

class HakkindaPage extends StatelessWidget {
  const HakkindaPage({super.key});

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
                    children: [
                      _buildSection(
                        context,
                        title: '📋 Forum Nedir?',
                        description:
                            'Forum, StajForum topluluğunun kalbidir. Burada öğrenciler staj deneyimlerini paylaşabilir ve firmalar hakkında sorular sorup cevaplar alabilirsiniz.',
                        features: const [
                          '💬 Tartışma Başlat: Staj ile ilgili sorularınızı sorun ve deneyimli öğrencilerden yardım alın',
                          '⭐ Firma Değerlendir: Staj yaptığınız firmalar hakkında diğer öğrencilere rehberlik edin',
                          '🔍 İçerik Ara: Arşivde benzer sorular ve cevapları bulun',
                          '👥 Topluluk ile Etkileşim: Paylaşılan deneyimlerden faydalanın ve görüş iletin',
                        ],
                      ),
                      _buildSection(
                        context,
                        title: '💬 ChatSTJ Nedir?',
                        description:
                            'ChatSTJ, StajForum\'un canlı sohbet özelliğidir. Gerçek zamanlı olarak yapay zeka ile iletişim kurabilir, sorularınıza anında cevap alabilirsiniz.',
                      ),
                      _buildSection(
                        context,
                        title: '🚀 Nasıl Başlanır?',
                        features: const [
                          '✅ Adım 1: Forum bölümüne giderek başka öğrencilerin paylaşımlarını okuyun',
                          '✅ Adım 2: Siz de bir sorunuz veya deneyiminiz varsa paylaşın (Ad-Soyad girerek)',
                          '✅ Adım 3: Staj başvuru sürecinde topluluktan destek alın',
                          '✅ Adım 4: Staj süreçlerine dair takıldığınız dönüş alamadığınız noktalarda ChatSTJ üzerinden bilgi edinin',
                        ],
                      ),
                      _buildSection(
                        context,
                        title: '📋 Topluluk Kuralları',
                        features: const [
                          '🤝 Saygılı Ol: Tüm üyelere saygı gösterin, kibar kalın',
                          '✅ Doğru Bilgi Paylaş: Yanlış veya yanıltıcı bilgi yayımlamayın',
                          '🚫 Spam Yapmayın: Aynı mesajı tekrar tekrar göndermek yasaktır',
                          '🔒 Gizliliğe Saygı Göster: Kişisel bilgileri başkalarının izni olmadan paylaşmayın',
                          '📌 Tema Dışı Yazı Yazmayın: Staj ve eğitimle ilgili içerikler paylaşın',
                        ],
                      ),
                      _buildSection(
                        context,
                        title: '📞 İletişim & Destek',
                        description:
                            'Sorularınız, önerileriniz veya sorun yaşadığınız durumlarda lütfen iletişime geçin.',
                        features: const [
                          '📧 Email: support@stajforum.com',
                          '🐦 Twitter: @StajForum',
                        ],
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

  Widget _buildSection(
    BuildContext context, {
    required String title,
    String? description,
    List<String>? features,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ),
          if (features != null)
            ...features.map((feature) => _buildFeatureItem(context, feature)),
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
        border: const Border(
          left: BorderSide(color: AppTheme.secondaryColor, width: 4),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}





