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
      // Menggunakan dio untuk memanggil API produk [cite: 29]
      final response = await _apiClient.dio.get('/products');
      
      final List<dynamic> jsonList = response.data; [cite: 233]
      
      return jsonList.map((json) {
        final product = Product.fromJson(json); [cite: 235]

        // LOGIKA PERSONAL NIM GENAP (NIM Angga: 20123002 -> Digit terakhir 2) 
        // Wajib menambahkan teks [Promo Ongkir] di belakang nama produk 
        // Logika ini wajib dilakukan di layer Service/Repository, bukan di UI 
        return product.copyWith(
          name: "${product.name} [Promo Ongkir]",
        );
      }).toList();
    } on DioException catch (e) {
      // Penanganan error jaringan menggunakan DioException [cite: 236, 239]
      throw Exception('Gagal memuat jaringan Angga: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  // Ambil 1 produk berdasarkan ID untuk halaman detail [cite: 244]
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id'); [cite: 246]
      final product = Product.fromJson(response.data); [cite: 247]

      // LOGIKA PERSONAL: Tambahkan label [Promo Ongkir] agar konsisten 
      return product.copyWith(
        name: "${product.name} [Promo Ongkir]",
      );
    } catch (e) {
      return null; [cite: 249]
    }
  }
}