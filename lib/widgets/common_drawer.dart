import 'package:flutter/material.dart';
import '../config/theme.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundDark,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.surfaceDark,
              border: Border(bottom: BorderSide(color: AppTheme.primaryColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.forum, color: AppTheme.primaryColor, size: 48),
                const SizedBox(height: 12),
                Text(
                  'StajForum',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, 'Anasayfa', '/anasayfa', Icons.home),
          _buildDrawerItem(context, 'Forum', '/forum', Icons.forum),
          _buildDrawerItem(context, 'ChatSTJ', '/chatstj', Icons.chat),
          _buildDrawerItem(context, 'CV Analiz', '/cv-analiz', Icons.analytics),
          _buildDrawerItem(context, 'Hakkında', '/hakkinda', Icons.info),
          _buildDrawerItem(context, 'İletişim', '/iletisim', Icons.contact_mail),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: AppTheme.textPrimary),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}




