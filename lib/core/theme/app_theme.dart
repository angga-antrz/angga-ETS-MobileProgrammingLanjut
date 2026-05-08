import 'package:flutter/material.dart';

class AppTheme {
  // Mencegah class ini di-instansiasi secara manual [cite: 892, 893]
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal, 
        foregroundColor: Colors.white, // Menjamin teks "UTD Store Angga" terlihat kontras [cite: 905]
      ),
      // Tambahan style untuk Button agar konsisten di seluruh aplikasi
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}