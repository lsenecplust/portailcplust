import 'package:flutter/material.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';

class CustomTheme {
  static LightTheme light = LightTheme();
  static DarkTheme dark = DarkTheme();
}

class LightTheme {
  final ThemeData theme = ThemeData(
    useMaterial3: true,
    appBarTheme:  AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: Colors.white,
    ),
    colorScheme: lightColorScheme,
  );
}

class DarkTheme {
  final ThemeData theme = ThemeData(
    useMaterial3: true,
    appBarTheme:  AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: Colors.white,
    ),
    colorScheme: darkColorScheme,
  );
}
