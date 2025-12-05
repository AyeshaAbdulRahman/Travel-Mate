import 'package:flutter/material.dart';

class AppTheme {
  // Your theme colors
  static const Color background = Color(0xFFF1F3E0);
  static const Color cardColor = Color(0xFFA1BC98);
  static const Color softSurface = Color(0xFFD2DCB6);
  static const Color textColor = Color(0xFF778873);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Main Background Color
    scaffoldBackgroundColor: background,

    // Color Seed (for material 3 tones)
    colorSchemeSeed: cardColor,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: cardColor,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textColor),
    ),

    // Cards
    cardTheme: CardThemeData(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: softSurface,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
    ),

    // Text Theme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor, fontSize: 16),
      bodyMedium: TextStyle(color: textColor),
      headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      fillColor: softSurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF9BAA8F),
        fontSize: 14,
      ),
    ),
  );
}

