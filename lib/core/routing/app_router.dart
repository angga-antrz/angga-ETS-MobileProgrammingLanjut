import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import sesuai struktur folder ETS_angga_MPL
import '../../features/product/presentation/pages/splash_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/crypto_page.dart';
import '../../features/native/presentation/pages/native_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../di/injection.dart';

class AppRouter {
  // Mencegah instansiasi class secara manual
  AppRouter._();

  static final router = GoRouter(
    // LOGIKA PERSONAL: Aplikasi wajib mulai dari Splash Screen 
    initialLocation: '/splash',

    routes: [
      // 1. Splash Screen (Menampilkan Nama: Angga Antareza & NIM: 20123002)
      GoRoute(
        path: '/splash', 
        builder: (context, state) => const SplashPage()
      ),

      // 2. Katalog Produk (Halaman Beranda Utama)
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          // Dependency Injection (get_it): Meminta Cubit dari locator [cite: 22, 479]
          create: (context) => locator<ProductCubit>()..fetchAllProducts(),
          child: const ProductPage(),
        ),
      ),

      // 3. Detail Produk (Menggunakan Path Parameter :id) [cite: 689]
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(productId: id);
        },
      ),

      // 4. Monitoring Crypto (Real-time WebSockets & Isolate) [cite: 38]
      GoRoute(
        path: '/crypto', 
        builder: (context, state) => const CryptoPage()
      ),

      // 5. Integrasi Native (Hardware Battery & Native Toast) [cite: 44, 45, 46]
      GoRoute(
        path: '/native', 
        builder: (context, state) => const NativePage()
      ),

      // 6. Bookmark/Favorite (Reactive Isar Database) [cite: 35, 36]
      GoRoute(
        path: '/todo', 
        builder: (context, state) => const TodoPage()
      ),
    ],

    // Fallback jika User membuka path yang tidak terdaftar (Error 404) [cite: 702]
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Maaf, halaman tidak ditemukan!')),
    ),
  );
}