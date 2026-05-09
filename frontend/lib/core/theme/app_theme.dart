import 'package:flutter/material.dart';

class AppTheme {
  static const _lightPrimary = Color(0xFF6C63FF);
  static const _darkPrimary = Color(0xFF8F86FF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _lightPrimary,
      primary: _lightPrimary,
      secondary: const Color(0xFFFF6584),
      brightness: Brightness.light,
      surface: const Color(0xFFF5F7FB),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FB),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _lightPrimary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _darkPrimary,
      primary: _darkPrimary,
      secondary: const Color(0xFFFF6584),
      brightness: Brightness.dark,
      surface: const Color(0xFF0D0B14),
    ),
    scaffoldBackgroundColor: const Color(0xFF05040B),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF16142A),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: _darkPrimary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Color(0xFF0A0915),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
