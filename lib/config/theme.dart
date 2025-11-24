import 'package:flutter/material.dart';

class AppTheme {
  // Renkler - Ana Palet
  static const Color colorPrimary = Color(0xFFBF092F);
  static const Color colorPrimaryDark = Color(0xFF8B0620);
  static const Color colorPrimaryLight = Color(0xFFE0F7FA);
  
  static const Color colorSecondary = Color(0xFF16476A);
  static const Color colorSecondaryDark = Color(0xFF132440);
  static const Color colorSecondaryLight = Color(0xFF3B9797);
  
  static const Color colorAccent = Color(0xFF3B9797);
  static const Color colorAccentLight = Color(0xFFD0F0F5);
  
  // Arkaplan Renkleri
  static const Color colorBgPrimary = Color(0xFFFFFFFF);
  static const Color colorBgSecondary = Color(0xFFF9FAFB);
  static const Color colorBgTertiary = Color(0xFFF3F7FA);
  
  // Metin Renkleri
  static const Color colorTextPrimary = Color(0xFF132440);
  static const Color colorTextSecondary = Color(0xFF16476A);
  static const Color colorTextLight = Color(0xFFFFFFFF);
  static const Color colorTextMuted = Color(0xFF6B7280);
  
  // Kenarlık Renkleri
  static const Color colorBorderLight = Color(0xFFE0E0E0);
  static const Color colorBorderLighter = Color(0xFFF3F4F6);
  static const Color colorBorderAccent = Color(0xFF3B9797);

  static ThemeData lightTheme = ThemeData(
    primaryColor: colorPrimary,
    scaffoldBackgroundColor: colorBgPrimary,
    colorScheme: const ColorScheme.light(
      primary: colorPrimary,
      secondary: colorSecondary,
      surface: colorBgPrimary,
      error: colorPrimary,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: colorBgPrimary,
      elevation: 1,
      shadowColor: Colors.black12,
      iconTheme: IconThemeData(color: colorSecondaryDark),
      titleTextStyle: TextStyle(
        color: colorSecondaryDark,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.bold,
        color: colorTextPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorTextPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: colorPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: colorTextPrimary,
        height: 1.7,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        color: colorTextPrimary,
        height: 1.7,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPrimary,
        foregroundColor: colorTextLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    cardTheme: CardThemeData(
      color: colorBgTertiary,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
    ),
  );
}

