import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static TextTheme get _textLightTheme {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLargeBold,
      bodyMedium: AppTextStyles.bodyLargeMedium,
      bodySmall: AppTextStyles.bodyLargeRegular,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );
  }

  static TextTheme get _textDarkTheme {
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(),
      displayMedium: AppTextStyles.displayMedium.copyWith(),
      displaySmall: AppTextStyles.displaySmall.copyWith(),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(),
      titleLarge: AppTextStyles.titleLarge.copyWith(),
      titleMedium: AppTextStyles.titleMedium.copyWith(),
      titleSmall: AppTextStyles.titleSmall.copyWith(),
      bodyLarge: AppTextStyles.bodyLargeBold.copyWith(),
      bodyMedium: AppTextStyles.bodyLargeMedium.copyWith(),
      bodySmall: AppTextStyles.bodyLargeRegular.copyWith(),
      labelLarge: AppTextStyles.labelLarge.copyWith(),
      labelMedium: AppTextStyles.labelMedium.copyWith(),
      labelSmall: AppTextStyles.labelSmall.copyWith(),
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: ThemeMode.system == ThemeMode.light
          ? _textLightTheme.titleLarge
          : _textDarkTheme.titleLarge,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.errorFair,
        surface: AppColors.backgroundLight,
      ),
      brightness: Brightness.light,
      textTheme: _textLightTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.errorFair,
        surface: AppColors.backgroundLight,
      ),
      brightness: Brightness.dark,
      textTheme: _textDarkTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}
