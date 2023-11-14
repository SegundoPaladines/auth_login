import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/usuario.dart';

class DatabaseHelper {
  static const _databaseName = 'usuarios.db';
  static const _databaseVersion = 1;

  static const table = 'usuarios';

  static const columnId = 'id';
  static const columnUsuario = 'usuario';
  static const columnContrasena = 'contrasena';
  static const columnRostro = 'rostro';
  static const columnHuella = 'huella';

  // Hacer que la clase sea un Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Única instancia de la base de datos
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Crear la tabla de usuarios
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnUsuario TEXT NOT NULL,
        $columnContrasena TEXT NOT NULL,
        $columnRostro BLOB,
        $columnHuella BLOB
      )
    ''');
  }

  // Insertar un usuario en la base de datos
  Future<int> insert(Usuario usuario) async {
    Database db = await instance.database;
    return await db.insert(table, usuario.toMap());
  }

  // Obtener todos los usuarios
  Future<List<Usuario>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((map) => Usuario.fromMap(map)).toList();
  }
}