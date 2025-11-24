import 'package:flutter/material.dart';
import '../config/theme.dart';

class TopAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const TopAppBarWidget({super.key});

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
              return const Icon(Icons.forum, size: 45, color: AppTheme.colorSecondaryDark);
            },
          ),
          const SizedBox(width: 12),
          const Text(
            'StajForum',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.colorSecondaryDark,
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
          _buildNavButton(context, 'Hakkında', '/hakkinda'),
          _buildNavButton(context, 'İletişim', '/iletisim'),
          const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.colorSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}




