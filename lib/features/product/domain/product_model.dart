import 'package:isar/isar.dart';

// Penting untuk Isar Database: baris ini memberitahu generator untuk membuat file .g.dart
part 'product_model.g.dart';

@collection
class Product {
  // Id Isar wajib ada untuk penyimpanan lokal reaktif
  Id isarId = Isar.autoIncrement;

  final String id;
  final String name;
  final String image;
  
  // LOGIKA PERSONAL ETS: Wajib menyisipkan timestamp saat disimpan ke Isar
  String? savedAt;

  Product({
    required this.id,
    required this.name,
    required this.image,
    this.savedAt,
  });

  // Fungsi untuk mengubah JSON dari API menjadi Objek Dart
  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    
    // Penyesuaian format gambar agar fleksibel sesuai standar industri 
    if (json['image'] != null) {
      imageUrl = json['image'].toString();
    } else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0].toString();
      imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    }

    return Product(
      id: json['id'].toString(),
      // Nama dibiarkan murni, manipulasi [Promo Ongkir] dilakukan di layer Repository [cite: 33]
      name: json['title'] ?? 'Tanpa Nama', 
      image: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
    );
  }

  // Method copyWith untuk memudahkan manipulasi data NIM di level Service/Repository [cite: 33]
  Product copyWith({
    String? id,
    String? name,
    String? image,
    String? savedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      savedAt: savedAt ?? this.savedAt,
    );
  }
}