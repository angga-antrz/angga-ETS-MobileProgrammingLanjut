import 'package:flutter/material.dart';

class AppTheme {
  // Mencegah class ini di-instansiasi secara manual [cite: 892, 893]
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, [cite: 896]
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal, [cite: 899]
        brightness: Brightness.light, [cite: 900]
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true, [cite: 902]
        elevation: 0, [cite: 903]
        backgroundColor: Colors.teal, [cite: 904]
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