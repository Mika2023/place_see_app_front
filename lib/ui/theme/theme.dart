import 'package:flutter/material.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/theme/app_typography.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.secondary,
    error: AppColors.accentTwo
  ),
  textTheme: TextTheme(
    headlineLarge: AppTypography.heading1Dark,
    headlineMedium: AppTypography.heading2Dark,
    headlineSmall: AppTypography.chapterHeadingDark,
    bodyMedium: AppTypography.bodyDark,
    bodySmall: AppTypography.subTextDark
  ),
);