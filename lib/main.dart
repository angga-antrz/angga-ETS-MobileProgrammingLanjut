import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  // 1. WAJIB: Memastikan plugin Flutter terinisialisasi sebelum menjalankan kode async [cite: 790, 792]
  WidgetsFlutterBinding.ensureInitialized();

  // 2. SANGAT PENTING: Inisialisasi Service Locator (GetIt) sebelum aplikasi berjalan 
  // Jika ini lupa dipanggil, aplikasi akan error layar merah 
  setupLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp.router untuk mendukung navigasi Declarative (GoRouter) [cite: 798, 799]
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, [cite: 800]
      // Identitas diubah sepenuhnya menjadi Angga Antareza [cite: 17]
      title: 'UTD Store Angga', [cite: 801]
      // Mengambil tema global Teal dari folder core [cite: 802]
      theme: AppTheme.lightTheme, 
      // Menggunakan konfigurasi rute yang sudah diarahkan ke SplashPage [cite: 804]
      routerConfig: AppRouter.router, 
    );
  }
}