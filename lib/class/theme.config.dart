import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';

class CustomTheme {
  static LightTheme light = LightTheme();
  static DarkTheme dark = DarkTheme();
}

class LightTheme {
  final ThemeData theme = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: Colors.white,
      ),
      colorScheme: lightColorScheme,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: lightColorScheme.outline.withOpacity(0.7),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w200)));
}

class DarkTheme {
  final ThemeData theme = ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: Colors.white,
      ),
      colorScheme: darkColorScheme,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: lightColorScheme.outline.withOpacity(0.7),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w200)));
}
