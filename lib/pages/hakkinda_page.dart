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
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      _buildSection(
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
                        title: '💬 ChatSTJ Nedir?',
                        description:
                            'ChatSTJ, StajForum\'un canlı sohbet özelliğidir. Gerçek zamanlı olarak yapay zeka ile iletişim kurabilir, sorularınıza anında cevap alabilirsiniz.',
                      ),
                      _buildSection(
                        title: '🚀 Nasıl Başlanır?',
                        features: const [
                          '✅ Adım 1: Forum bölümüne giderek başka öğrencilerin paylaşımlarını okuyun',
                          '✅ Adım 2: Siz de bir sorunuz veya deneyiminiz varsa paylaşın (Ad-Soyad girerek)',
                          '✅ Adım 3: Staj başvuru sürecinde topluluktan destek alın',
                          '✅ Adım 4: Staj süreçlerine dair takıldığınız dönüş alamadığınız noktalarda ChatSTJ üzerinden bilgi edinin',
                        ],
                      ),
                      _buildSection(
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

  Widget _buildSection({
    required String title,
    String? description,
    List<String>? features,
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
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: AppTheme.colorTextPrimary,
                ),
              ),
            ),
          if (features != null)
            ...features.map((feature) => _buildFeatureItem(feature)),
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





