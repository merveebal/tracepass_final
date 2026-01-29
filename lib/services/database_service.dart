import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton Pattern: Uygulama boyunca tek bir nesne üzerinden işlem yapılır.
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tracepass.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // CRUD: Create - Tabloyu oluşturuyoruz.
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        ecoScore REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // Ürün Kaydetme (Create)
  Future<void> addProduct(String name, double score) async {
    final db = await instance.database;
    await db.insert('products', {
      'name': name,
      'ecoScore': score,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Tüm Ürünleri Getirme (Read)
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final db = await instance.database;
    // En yeni okutulan ürünü en üstte görmek için DESC (Azalan) sıralama yapıyoruz.
    return await db.query('products', orderBy: 'id DESC');
  }

  // Veritabanını Temizleme (Delete - Opsiyonel, sınavda sorulabilir)
  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('products');
  }
}