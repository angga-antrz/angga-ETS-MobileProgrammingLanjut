import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../domain/product_service.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _service;

  // Saat pertama kali diciptakan, set lampu indikator ke 'ProductLoading' [cite: 361, 426]
  ProductCubit(this._service) : super(ProductLoading());

  // Fungsi utama untuk mengambil data produk dari internet [cite: 362, 428]
  Future<void> fetchAllProducts() async {
    // 1. Pancarkan status Loading ke UI [cite: 363, 430]
    emit(ProductLoading()); 
    
    try {
      // 2. Memanggil service untuk mengambil data dari API [cite: 365, 434]
      // Logika Personal NIM 20123002: Delay ditangani di level Service/Repository
      final data = await _service.fetchProducts();
      
      // 3. Jika berhasil, pancarkan state Sukses beserta datanya [cite: 365, 436]
      emit(ProductLoaded(data));
    } catch (e) {
      // 4. Jika terjadi kendala jaringan/sistem, pancarkan state Error [cite: 367, 439]
      emit(ProductError('Gagal memuat produk Angga: $e'));
    }
  }
}