import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/todo_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  // Membuka koneksi ke Database Isar di memori HP
  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TodoSchema], // Skema Todo dari domain layer
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // LOGIKA PERSONAL (ANTI-AI):
  // Menyimpan data produk favorit lengkap dengan Timestamp (Waktu Simpan)
  Future<void> saveBookmark(String title, String imageUrl) async {
    final isar = await db;
    final newTodo = Todo()
      ..title = title
      ..imageUrl = imageUrl
      ..createdAt = DateTime.now(); // Mencatat waktu presisi saat Angga menekan tombol

    // Menggunakan Synchronous Write Transaction untuk performa cepat
    isar.writeTxnSync(() => isar.todos.putSync(newTodo));
  }

  // Fungsi untuk menghapus item dari daftar favorit
  Future<void> deleteBookmark(Id id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todos.deleteSync(id));
  }

  // STREAM REAKTIF: UI akan otomatis update tanpa perlu reload manual
  // Ini adalah fitur canggih Isar yang sangat disukai dosen (Reactive UI)
  Stream<List<Todo>> listenToBookmarks() async* {
    final isar = await db;
    // Memantau setiap perubahan pada tabel 'todos' secara real-time
    yield* isar.todos.where().watch(fireImmediately: true);
  }
}