import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
  // textTheme: GoogleFonts.epilogueTextTheme(),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontWeight: FontWeight.bold),
    titleSmall: TextStyle(fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontWeight: FontWeight.bold),
  ),
  datePickerTheme: const DatePickerThemeData(
    backgroundColor: Colors.white,
  ),
);
