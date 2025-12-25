import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'pages/anasayfa_page.dart';
import 'pages/chat_stj_page.dart';
import 'pages/forum_page.dart';
import 'pages/forum_konu_secimi_page.dart';
import 'pages/hakkinda_page.dart';
import 'pages/iletisim_page.dart';
import 'pages/cv_analiz_page.dart';

void main() {
  runApp(const StajForumApp());
}

class StajForumApp extends StatelessWidget {
  const StajForumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StajForum',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AnasayfaPage(),
        '/anasayfa': (context) => const AnasayfaPage(),
        '/forum': (context) => const ForumPage(),
        '/chatstj': (context) => const ChatStjPage(),
        '/cv-analiz': (context) => const CVAnalizPage(),
        '/hakkinda': (context) => const HakkindaPage(),
        '/iletisim': (context) => const IletisimPage(),
      },
      onGenerateRoute: (settings) {
        // Forum konusu için dinamik route
        if (settings.name != null && settings.name!.startsWith('/forum/')) {
          final id = settings.name!.replaceFirst('/forum/', '');
          return MaterialPageRoute(
            builder: (context) => ForumKonuSecimiPage(id: id),
          );
        }
        return null;
      },
    );
  }
}
