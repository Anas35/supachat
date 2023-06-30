import 'package:flutter/material.dart';

class SupaTheme {

  final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    primaryColor: const Color(0xFF2E384D),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color(0xFFFF4081),
      backgroundColor: const Color(0xFF1E2335),
    ),
    textTheme: const TextTheme().apply(
      displayColor: const Color(0xFFFFFFFF),
      bodyColor: const Color(0xFFA6A6A6),
    ),
    dividerColor: const Color(0xFF404B69),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF546E96),
    ),
  );

  final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    primaryColor: const Color(0xFF1976D2),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color(0xFFFF5722),
      backgroundColor: const Color(0xFFF5F5F5),
    ),
    textTheme: const TextTheme().apply(
      displayColor: const  Color(0xFF333333),
      bodyColor: const Color(0xFF808080),
    ),
    dividerColor: const Color(0xFFE0E0E0),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF2196F3),
    ),
  );

}
