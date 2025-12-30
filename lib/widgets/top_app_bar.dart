import 'package:flutter/material.dart';
import '../config/theme.dart';

class TopAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;

  const TopAppBarWidget({super.key, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/staj-forum-logo-no-background.png',
            height: 45,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.forum, size: 45, color: AppTheme.primaryColor);
            },
          ),
          const SizedBox(width: 12),
          Text(
            'StajForum',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary, // White title
                ),
          ),
        ],
      ),
      actions: [
        // Desktop için navigasyon linkleri
        if (MediaQuery.of(context).size.width > 900) ...[
          _buildNavButton(context, 'Anasayfa', '/anasayfa'),
          _buildNavButton(context, 'Forum', '/forum'),
          _buildNavButton(context, 'ChatSTJ', '/chatstj'),
          _buildNavButton(context, 'CV Analiz', '/cv-analiz'),
          _buildNavButton(context, 'Hakkında', '/hakkinda'),
          _buildNavButton(context, 'İletişim', '/iletisim'),

          const SizedBox(width: 16),
          // Auth Buttons
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/giris'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Giriş Yap'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/kayit'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Kayıt Ol'),
          ),
          const SizedBox(width: 16),
        ],
        if (actions != null) ...actions!,
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    // Highlight current route could be added here later
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primaryColor,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}




