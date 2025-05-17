import 'dart:ui';

import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: Color(0xFFE0EFFD), // 主色系
  brightness: Brightness.light,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: Color(0xFFE0EFFD),
  brightness: Brightness.dark,
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
);

void printColorScheme(ColorScheme scheme) {
  print('🎨 Seed generated color scheme:');
  print('primary: ${colorToHex(scheme.primary)}');
  print('onPrimary: ${colorToHex(scheme.onPrimary)}');
  print('secondary: ${colorToHex(scheme.secondary)}');
  print('onSecondary: ${colorToHex(scheme.onSecondary)}');
  print('surface: ${colorToHex(scheme.surface)}');
  print('background: ${colorToHex(scheme.background)}');
  print('error: ${colorToHex(scheme.error)}');
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
