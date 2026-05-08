import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan palet warna Teal sesuai identitas Angga Antareza
    const Color primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'UTD STORE ANGGA',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white),
            onPressed: () => context.push('/todo'),
          ),
          IconButton(
            icon: const Icon(Icons.developer_mode_outlined, color: Colors.white),
            onPressed: () => context.push('/native'),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. Tampilan saat Loading
          if (state is ProductLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  SizedBox(height: 20),
                  Text(
                    'MEMUAT KATALOG...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Tampilan saat Sukses (Loaded)
          if (state is ProductLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.products[index];
                return GestureDetector(
                  onTap: () => context.push('/detail/${item.id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Thumbnail Produk dengan Frame
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: const Color(0xFFF9F9F9),
                              child: Image.network(
                                item.image,
                                width: 90,
                                height: 90,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Info Produk
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name, // Nama sudah mengandung [Promo Ongkir] dari Repository
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'ID Produk: ${item.id}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Badge Status NIM Genap
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "TERSEDIA",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // 3. Tampilan saat Error
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off_rounded, color: Colors.redAccent, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    state.message, 
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<ProductCubit>().fetchAllProducts(),
                    child: const Text("COBA LAGI"),
                  )
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        label: const Text(
          'CRYPTO HUB',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        icon: const Icon(Icons.currency_bitcoin_rounded, color: Colors.white),
        backgroundColor: Colors.orange.shade800, // Warna khas Bitcoin
        elevation: 6,
      ),
    );
  }
}