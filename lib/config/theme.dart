import 'package:flutter/material.dart';

class AppTheme {
  // Dark Mode Palette
  static const Color primaryColor = Color(0xFF00E5FF); // Neon Cyan
  static const Color secondaryColor = Color(0xFFD946EF); // Neon Purple
  
  static const Color backgroundDark = Color(0xFF0F172A); // Deep Blue-Grey
  static const Color surfaceDark = Color(0xFF1E293B); // Lighter Blue-Grey
  static const Color surfaceLight = Color(0xFF334155); // Even lighter for hovers/borders
  
  static const Color textPrimary = Color(0xFFF8FAFC); // White-ish
  static const Color textSecondary = Color(0xFF94A3B8); // Grey-ish
  
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF00E676);

  // --- Backward Compatibility Mappings (Restoring missing static members) ---
  // Mapping old names to new dark mode colors
  static const Color colorPrimary = primaryColor;
  static const Color colorPrimaryDark = Color(0xFF00B2CC); // Darker Cyan
  static const Color colorPrimaryLight = surfaceLight; // Used for backgrounds often
  
  static const Color colorSecondary = secondaryColor; 
  static const Color colorSecondaryDark = Color(0xFFAB2BC0); // Darker Purple
  static const Color colorSecondaryLight = primaryColor; // Mapping to accent
  
  static const Color colorAccent = primaryColor;
  static const Color colorAccentLight = surfaceLight;
  
  // Backgrounds
  // colorBgPrimary was mostly white effectively. In dark mode, this is deep dark.
  static const Color colorBgPrimary = backgroundDark;
  static const Color colorBgSecondary = surfaceDark;
  static const Color colorBgTertiary = surfaceDark; // Used for cards
  
  // Text
  static const Color colorTextPrimary = textPrimary;
  static const Color colorTextSecondary = textSecondary;
  static const Color colorTextLight = textPrimary;
  static const Color colorTextMuted = textSecondary;
  
  // Borders
  static const Color colorBorderLight = surfaceLight;
  static const Color colorBorderLighter = surfaceLight;
  static const Color colorBorderAccent = primaryColor;

  // The main.dart expects 'lightTheme', so we provide the dark theme here
  // to toggle the whole app to dark mode immediately.
  static ThemeData get lightTheme => darkTheme;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryColor,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceDark,
        background: backgroundDark,
        error: errorColor,
        onPrimary: Colors.black, // Dark text on neon
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: surfaceLight, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        clipBehavior: Clip.antiAlias,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration (Forms)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: surfaceLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: surfaceLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        prefixIconColor: textSecondary,
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      
      dividerTheme: const DividerThemeData(
        color: surfaceLight,
        thickness: 1,
      ),
      
      // Default Text Theme (without Google Fonts for now)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
          height: 1.5,
        ),
      ),
      
      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
          TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
          TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
          TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
          TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
        },
      ),
    );
  }

  // --- Custom Styles for Specific Pages (e.g. CV Analiz) ---
  
  static final ButtonStyle cvUploadButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  static final ButtonStyle cvAnalyzeButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    backgroundColor: secondaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );

  static final BoxDecoration cvResultContainerDecoration = BoxDecoration(
    color: surfaceLight,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: primaryColor),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

/// A custom page transition builder that disables all animations.
class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
