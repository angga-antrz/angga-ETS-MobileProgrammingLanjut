import 'package:get_it/get_it.dart';
// Menggunakan Package Import agar lebih stabil
import 'package:ets_angga_mpl/core/network/api_client.dart';
import 'package:ets_angga_mpl/features/product/data/product_repository.dart';
import 'package:ets_angga_mpl/features/product/domain/product_service.dart';
import 'package:ets_angga_mpl/features/product/presentation/cubit/product_cubit.dart';
import 'package:ets_angga_mpl/features/todo/data/isar_service.dart';
// Inisialisasi sang 'Pelayan' (Service Locator) secara global
final locator = GetIt.instance;

void setupLocator() {
  // 1. Mendaftarkan API Client (Dio) sebagai Singleton
  // Objek hanya dibuat 1x untuk efisiensi memori aplikasi Angga
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // 2. Mendaftarkan Isar Service untuk Database Lokal (Fitur Todo)
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Mendaftarkan Repository Produk (Sumber Data)
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());

  // 4. Mendaftarkan Service Produk (Jembatan Logika Bisnis)
  // locator() akan otomatis mencari ProductRepository yang sudah terdaftar
  locator.registerFactory<ProductService>(() => ProductService(locator()));

  // 5. Mendaftarkan Cubit untuk State Management
  // registerFactory digunakan agar state selalu segar saat halaman dibuka
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator()));
}