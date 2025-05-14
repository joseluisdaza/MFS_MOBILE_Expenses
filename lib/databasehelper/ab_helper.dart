import 'package:sistema_sqlite/modelos/modeloProducto.dart';
import 'package:sistema_sqlite/modelos/modeloRegistroProducto.dart';
import 'package:sistema_sqlite/modelos/modeloTipoProducto.dart';
import 'package:sistema_sqlite/modelos/modeloUsuario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static const String dbName = 'my_db.db';
  static const int dbVersion = 2;

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
      CREATE TABLE tipoProducto (
        pkTipoProducto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreTipo TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE producto (
        pkProducto INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreProducto TEXT NOT NULL UNIQUE,
        CostoProducto REAL NOT NULL,
        pkTipoProducto INTEGER NULL,
      )
    ''');

    await db.execute('''
      CREATE TABLE usuario (
        pkUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreUsuario TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE registroProducto (
        pkRegistro INTEGER PRIMARY KEY AUTOINCREMENT,
        fkProducto INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (fkProducto) REFERENCES producto(pkProducto)
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

  // CRUD TipoProducto
  Future<int> insertaTipoProducto(ModeloTipoProducto tipo) async {
    final db = await database;
    return await db.insert('tipoProducto', tipo.toMap());
  }

  Future<void> eliminarTipoProducto(int pkTipoProducto) async {
    final db = await database;
    await db.delete(
      'tipoProducto',
      where: 'pkTipoProducto = ?',
      whereArgs: [pkTipoProducto],
    );
  }

  Future<void> actualizarTipoProducto(
    ModeloTipoProducto tipo,
    int pkTipoProducto,
  ) async {
    final db = await database;
    await db.update(
      'tipoProducto',
      tipo.toMap(),
      where: 'pkTipoProducto = ?',
      whereArgs: [pkTipoProducto],
    );
  }

  Future<List<ModeloTipoProducto>> getTiposProducto() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tipoProducto');
    return List.generate(
      maps.length,
      (i) => ModeloTipoProducto.fromMap(maps[i]),
    );
  }

  // CRUD Usuario
  Future<int> insertaUsuario(ModeloUsuario usuario) async {
    final db = await database;
    return await db.insert('usuario', usuario.toMap());
  }

  Future<void> eliminarUsuario(int pkUsuario) async {
    final db = await database;
    await db.delete('usuario', where: 'pkUsuario = ?', whereArgs: [pkUsuario]);
  }

  Future<void> actualizarUsuario(ModeloUsuario usuario, int pkUsuario) async {
    final db = await database;
    await db.update(
      'usuario',
      usuario.toMap(),
      where: 'pkUsuario = ?',
      whereArgs: [pkUsuario],
    );
  }

  Future<List<ModeloUsuario>> getUsuarios() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('usuario');
    return List.generate(maps.length, (i) => ModeloUsuario.fromMap(maps[i]));
  }

  // CRUD RegistroProducto
  Future<int> insertaRegistroProducto(ModeloRegistroProducto registro) async {
    final db = await database;
    return await db.insert('registroProducto', registro.toMap());
  }

  Future<void> eliminarRegistroProducto(int pkRegistro) async {
    final db = await database;
    await db.delete(
      'registroProducto',
      where: 'pkRegistro = ?',
      whereArgs: [pkRegistro],
    );
  }

  Future<void> actualizarRegistroProducto(
    ModeloRegistroProducto registro,
    int pkRegistro,
  ) async {
    final db = await database;
    await db.update(
      'registroProducto',
      registro.toMap(),
      where: 'pkRegistro = ?',
      whereArgs: [pkRegistro],
    );
  }

  Future<List<ModeloRegistroProducto>> getRegistrosProducto() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('registroProducto');
    return List.generate(
      maps.length,
      (i) => ModeloRegistroProducto.fromMap(maps[i]),
    );
  }
}
