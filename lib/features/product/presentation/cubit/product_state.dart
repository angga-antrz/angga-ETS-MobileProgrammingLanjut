import 'package:equatable/equatable.dart';
import '../../domain/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// 1. Status saat aplikasi sedang menunggu data dari API (Loading) [cite: 343, 405]
class ProductLoading extends ProductState {}

// 2. Status saat data berhasil didapat dan siap ditampilkan di UI [cite: 344, 407]
class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products]; // Memastikan perubahan data terdeteksi [cite: 412]
}

// 3. Status saat terjadi masalah jaringan atau sistem (Error) [cite: 345, 414]
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message]; // Membawa pesan error ke UI [cite: 418]
}