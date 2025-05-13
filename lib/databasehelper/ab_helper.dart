import 'package:sistema_sqlite/modelos/modeloProducto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static const String dbName = 'my_db.db';
  static const int dbVersion = 1;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);

    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE producto (
        pkProducto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreProducto TEXT NOT NULL UNIQUE,
        CostoProducto REAL NOT NULL
      )
    ''');
  }

  // Método para insertar un nuevo producto
  Future<int> insertaProducto(ModeloProducto producto) async {
    final db = await database;
    return await db.insert('producto', producto.toMap());
  }

  Future<void> eliminarProducto(ModeloProducto producto) async {
    final db = await database;
    await db.delete(
      'producto',
      where: 'pkProducto = ?',
      whereArgs: [producto.pkProducto],
    );
  }

  Future<void> actualizarProducto(ModeloProducto producto, pkProducto) async {
    final db = await database;

    await db.update(
      'producto',
      producto.toMap(),
      where: 'pkProducto = ?',
      whereArgs: [pkProducto],
    );
  }

  Future<List<ModeloProducto>> getProductos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('producto');
    return List.generate(maps.length, (i) {
      return ModeloProducto.fromMap(maps[i]);
    });
  }

  Future<bool> existeNombreProducto(String nombreProducto) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'producto',
      columns: [
        'pkProducto',
      ], // Solo necesitamos una columna para saber si existe la fila
      where: 'nombreProducto = ?',
      whereArgs: [nombreProducto],
      limit: 1, // Solo necesitamos una fila si existe
    );

    return result.isNotEmpty;
  }
}
