import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextTheme textTheme() {
    final base = GoogleFonts.rubikTextTheme();
    return base.copyWith(
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.stepLabel,
      ),
    );
  }
}
