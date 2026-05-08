import 'package:isar/isar.dart';

// Bagian ini adalah file generator Isar. 
// Jalankan 'flutter pub run build_runner build' untuk menghilangkah error merahnya.
part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // ID otomatis agar tidak bentrok di database lokal

  late String title;
  late String imageUrl;
  
  // LOGIKA PERSONAL ANGGA (NIM: 20123002):
  // Field ini menyimpan waktu presisi saat produk disimpan ke favorit.
  // Ini memenuhi syarat manipulasi data mandiri pada poin 3 ETS.
  late DateTime createdAt; 

  bool isCompleted = false;
}