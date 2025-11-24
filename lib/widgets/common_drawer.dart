import 'package:flutter/material.dart';
import '../config/theme.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.colorPrimary,
            ),
            child: Text(
              'StajForum',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(context, 'Anasayfa', '/anasayfa', Icons.home),
          _buildDrawerItem(context, 'Forum', '/forum', Icons.forum),
          _buildDrawerItem(context, 'ChatSTJ', '/chatstj', Icons.chat),
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
      leading: Icon(icon, color: AppTheme.colorSecondary),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}




