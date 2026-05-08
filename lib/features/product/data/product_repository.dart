import 'package:dio/dio.dart';
import '../domain/product_model.dart';
import '../../../../core/di/injection.dart'; 
import '../../../../core/network/api_client.dart'; 

class ProductRepository {
  // Ambil ApiClient (Dio) dari Pelayan (get_it) agar tidak inisialisasi manual 
  final ApiClient _apiClient = locator<ApiClient>();

  // Fungsi mengambil semua produk dari FakeStoreAPI [cite: 29]
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _apiClient.dio.get('/products');
      
      final List<dynamic> jsonList = response.data; 
      
      return jsonList.map((json) {
        final product = Product.fromJson(json); 


        return product.copyWith(
          name: "${product.name} [Promo Ongkir]",
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception('Gagal memuat jaringan Angga: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  // Ambil 1 produk berdasarkan ID untuk halaman detail [cite: 244]
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      final product = Product.fromJson(response.data); 

      // LOGIKA PERSONAL: Tambahkan label [Promo Ongkir] agar konsisten 
      return product.copyWith(
        name: "${product.name} [Promo Ongkir]",
      );
    } catch (e) {
      return null; 
    }
  }
}