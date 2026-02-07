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
    bodyLarge: AppTypography.bodyLargeDark,
    bodyMedium: AppTypography.bodyDark,
    bodySmall: AppTypography.subTextDark,
    labelMedium: AppTypography.subTextDark
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 58),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(29),
      ),
      textStyle: AppTypography.buttonTextDark,
      elevation: 0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      textStyle: AppTypography.buttonTextDark,
    )
  ),
  inputDecorationTheme: InputDecorationThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 29, vertical: 20),
    hintStyle: AppTypography.hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(29),
      borderSide: const BorderSide(color: AppColors.secondary, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(29),
      borderSide: const BorderSide(color: AppColors.secondary, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(29),
      borderSide: const BorderSide(color: AppColors.secondary, width: 2),
    ),
    isDense: true,
  ),
);