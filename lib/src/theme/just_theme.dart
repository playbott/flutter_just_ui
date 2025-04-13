import 'package:flutter/material.dart';
import 'package:just_ui/just_ui.dart';

class JustTheme {
  static ThemeData light() {
    return ThemeData(
      primaryColor: Colors.pinkAccent,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(JustUiConstants.defaultBorderRadius),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14.0),
        labelMedium: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
    );
  }
}