import 'package:flutter/material.dart';

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: Color(0xFFE0EFFD), // 主色系
  brightness: Brightness.light,
);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: Color(0xFF5846E4),
  brightness: Brightness.light,
  primary: Color(0xFF5846E4),
  onPrimary: Color(0xFFFAF8FE),
  primaryContainer: Color(0xFFC2D8FF),
  onPrimaryContainer: Color(0xFF3A3540),
  secondary: Color(0xFFEEF9FF),
  onSecondary: Color(0xFF3A3540),
  error: Colors.red.shade600,
  onError: Colors.white,
  surface: Color(0xFFFBE7E3),
  onSurface: Color(0xFF3A3540),
  outline: Color(0xFF202483),
);

final customTextTheme = TextTheme(
  headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  bodyMedium: TextStyle(fontSize: 14),
  labelSmall: TextStyle(fontSize: 12, color: Colors.grey[600]),
);

final customTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: customTextTheme,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
    elevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: lightColorScheme.primary,
    unselectedItemColor: lightColorScheme.onPrimary,
    selectedItemColor: lightColorScheme.onPrimaryContainer,
    showUnselectedLabels: true,
    enableFeedback: true,
  ),
);
