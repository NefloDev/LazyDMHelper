import 'package:flutter/material.dart';
import 'package:lazy_dm_helper/constants/colors.dart';

class Themes{
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: CustomColors.primaryLight,
        onPrimary: CustomColors.onPrimaryLight,
        secondary: CustomColors.secondaryLight,
        onSecondary: CustomColors.onSecondaryLight,
        error: CustomColors.errorLight,
        onError: CustomColors.onErrorLight,
        background: CustomColors.bgLight,
        onBackground: CustomColors.onBgLight,
        surface: CustomColors.surfaceContainerHighLight,
        onSurface: CustomColors.onSurfaceLight,
        primaryContainer: CustomColors.primaryContainerLight,
        secondaryContainer: CustomColors.secondaryContainerLight,
        onSecondaryContainer: CustomColors.onSecondaryContainerLight,
        surfaceTint: CustomColors.surfaceContainerLowLight,
        surfaceVariant: CustomColors.onSurfaceVariantLight,
        outlineVariant: CustomColors.outlineVariantLight
    ),
    useMaterial3: true,
    fontFamily: "JakartaSans"
  );

  static final ThemeData darkTheme = ThemeData(
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: CustomColors.primaryDark,
          onPrimary: CustomColors.onPrimaryDark,
          secondary: CustomColors.secondaryDark,
          onSecondary: CustomColors.onSecondaryDark,
          error: CustomColors.errorDark,
          onError: CustomColors.onErrorDark,
          background: CustomColors.bgDark,
          onBackground: CustomColors.onBgDark,
          surface: CustomColors.surfaceContainerHighDark,
          onSurface: CustomColors.onSurfaceDark,
          primaryContainer: CustomColors.primaryContainerDark,
          secondaryContainer: CustomColors.secondaryContainerDark,
          onSecondaryContainer: CustomColors.onSecondaryContainerDark,
          surfaceTint: CustomColors.surfaceContainerLowDark,
          surfaceVariant: CustomColors.onSurfaceVariantDark,
          outlineVariant: CustomColors.outlineVariantDark
      ),
      useMaterial3: true,
      fontFamily: "JakartaSans"
  );
}