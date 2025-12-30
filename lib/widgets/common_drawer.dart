import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final bool isAuthenticated = authProvider.isAuthenticated;
        final user = authProvider.user;

        return Drawer(
          backgroundColor: AppTheme.backgroundDark,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceDark,
                  border: Border(bottom: BorderSide(color: AppTheme.primaryColor)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isAuthenticated && user != null) ...[
                      // User Avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            user.initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ] else ...[
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
                  ],
                ),
              ),
              
              // Menu Items
              _buildDrawerItem(context, 'Anasayfa', '/anasayfa', Icons.home),
              _buildDrawerItem(context, 'Forum', '/forum', Icons.forum),
              _buildDrawerItem(context, 'ChatSTJ', '/chatstj', Icons.chat),
              _buildDrawerItem(context, 'CV Analiz', '/cv-analiz', Icons.analytics),
              _buildDrawerItem(context, 'Hakkında', '/hakkinda', Icons.info),
              _buildDrawerItem(context, 'İletişim', '/iletisim', Icons.contact_mail),
              
              const Divider(),
              
              // Auth Items
              if (isAuthenticated) ...[
                _buildDrawerItem(context, 'Profilim', '/profil', Icons.person),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.primaryColor),
                  title: const Text(
                    'Çıkış Yap',
                    style: TextStyle(color: AppTheme.textPrimary),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                ),
              ] else ...[
                _buildDrawerItem(context, 'Giriş Yap', '/giris', Icons.login),
                _buildDrawerItem(context, 'Kayıt Ol', '/kayit', Icons.person_add),
              ],
            ],
          ),
        );
      },
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
        style: const TextStyle(color: AppTheme.textPrimary),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
