import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF4A90E2); // 白
  static const accent = Color(0xFF0056F5);  // 深藍強調色
  static const background = Color(0xFFFFFFFF); // 淺背景
  static const text = Color(0xFF000000); // 深灰文字
  static const hint = Color(0xFF2F2F2F); // 輔助文字
  static const error = Color(0xFFE74C3C); // 錯誤紅
}

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    background: AppColors.background,
    error: AppColors.error,
  ),
  textTheme: Typography.material2021().black.copyWith(
    displayLarge: const TextStyle(
      color: Colors.black87,
    ),
    displayMedium: const TextStyle(
      color: Colors.black87,
    ),
    displaySmall: const TextStyle(
      color: Colors.black87,
    ),
    headlineMedium: const TextStyle(
      color: Colors.black87,
    ),
    titleLarge: const TextStyle(
      color: Colors.black87,
    ),
    titleMedium: const TextStyle(
      color: Colors.black87,
    ),
    bodyLarge: const TextStyle(
      color: Colors.black87,
    ),
    bodyMedium: const TextStyle(
      color: Colors.black54,
    ),
    bodySmall: const TextStyle(
      color: Colors.black54,
    ),
    labelLarge: const TextStyle(  // 用於按鈕文字
      color: Colors.black54,
    ),
    labelMedium: const TextStyle(
      color: Colors.black54,
    ),
    labelSmall: const TextStyle(
      color: Colors.black54,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    // 預設邊框
    border: OutlineInputBorder(),

    // 一般啟用狀態下
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFB0BEC5)), // 輕灰
    ),

    // 聚焦時的邊框（例如點進欄位）
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2), // 深藍
    ),

    // 驗證錯誤時的邊框
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE74C3C)), // 鮮紅
    ),

    // 聚焦 + 驗證錯誤時（預設這個會 fallback 成白框，如果你沒設）
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE74C3C), width: 2),
    ),

    // 錯誤文字樣式（可選）
    errorStyle: TextStyle(color: Color(0xFFE74C3C), fontSize: 13),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);
