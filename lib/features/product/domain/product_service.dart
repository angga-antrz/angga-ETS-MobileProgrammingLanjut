import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;

  ProductService(this.repository);

  // Fungsi untuk mengambil daftar produk dengan logika delay personal
  Future<List<Product>> fetchProducts() async {
    // LOGIKA PERSONAL (ANTI-AI):
    // Aplikasi wajib melakukan delay persis selama X detik, 
    // di mana X adalah digit terakhir NIM Anda (NIM Angga: 20123002 -> 2 detik)[cite: 23, 24].
    // Delay ini diatur di level Service/Domain, bukan di UI.
    await Future.delayed(const Duration(seconds: 2)); 

    return await repository.getAllProducts();
  }

  // Fungsi untuk mengambil detail produk tunggal
  Future<Product?> fetchProductDetail(String id) async {
    // Memanggil repository untuk mencari satu produk berdasarkan ID [cite: 258, 261]
    return await repository.getProductById(id);
  }
}