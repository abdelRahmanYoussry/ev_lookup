import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.pageBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ringValue,
        surface: AppColors.pageBackground,
        error: AppColors.error,
      ),
      textTheme: AppTextStyles.textTheme(),
    );
  }
}
