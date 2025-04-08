import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.navBarBackground,
      surfaceTintColor: AppColors.transparent,
      titleTextStyle: AppTextStyles.appBarTitle,
    ),
    textTheme: const TextTheme(
      bodyMedium: AppTextStyles.navLabel,
      titleMedium: AppTextStyles.navLabel,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  // 企业级深色主题（可选）
  static final ThemeData dark = ThemeData.dark().copyWith(
    // 深色模式配置...
  );
}