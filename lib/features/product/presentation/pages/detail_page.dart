import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/todo/data/isar_service.dart';
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productService = locator<ProductService>();
    final isarService = locator<IsarService>();

    // Menggunakan palet warna Teal sesuai identitas Angga Antareza
    const Color primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "UTD STORE ANGGA",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Product?>(
        future: productService.fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Area Gambar dengan Badge Promo Ongkir (NIM Genap)
                      Stack(
                        children: [
                          Container(
                            height: 350,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Hero(
                              tag: product.id,
                              child: Image.network(product.image, fit: BoxFit.contain),
                            ),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade800,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.local_shipping_rounded, size: 16, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text(
                                    "PROMO ONGKIR", 
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name, // Nama sudah mengandung [Promo Ongkir] dari Repository
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Rp. 249.000", 
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.redAccent),
                            ),
                            const Divider(height: 40),
                            const Row(
                              children: [
                                Icon(Icons.info_outline_rounded, size: 20, color: primaryColor),
                                SizedBox(width: 8),
                                Text("DESKRIPSI PRODUK", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Produk eksklusif ini dikurasi secara real-time dari API publik. Material berkualitas tinggi dengan finishing detail yang presisi, sangat cocok untuk kebutuhan gaya hidup modern Anda.",
                              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.6),
                            ),
                            const SizedBox(height: 25),
                            // Info Kualitas (Style Grid kecil)
                            _buildFeatureInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Action Bar (Tombol Simpan ke Bookmark)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), 
                      blurRadius: 15, 
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildIconButton(Icons.chat_outlined),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () async {
                            // LOGIKA PERSONAL: Simpan ke Isar dengan Timestamp
                            await isarService.saveBookmark(product.name, product.image);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Berhasil disimpan ke Favorit Angga!'), 
                                  backgroundColor: primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border_rounded),
                              SizedBox(width: 10),
                              Text("SIMPAN KE FAVORIT", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: Colors.teal),
    );
  }

  Widget _buildFeatureInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FeatureItem(Icons.verified_user_outlined, "Original"),
          _FeatureItem(Icons.workspace_premium_outlined, "Premium"),
          _FeatureItem(Icons.local_offer_outlined, "Hemat"),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.teal),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
      ],
    );
  }
}