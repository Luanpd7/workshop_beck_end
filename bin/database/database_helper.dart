import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    sqfliteFfiInit(); // Inicializa suporte a FFI
    databaseFactory = databaseFactoryFfi;

    final dbPath = join(Directory.current.path, 'meu_banco.db');

    _database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await _createTables(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await _createTables(db);
          }
        },
      ),
    );

    return _database!;
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS customer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        surname TEXT,
        email TEXT,
        document TEXT NOT NULL,
        whatsapp TEXT NOT NULL,
        observation TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS address (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        cep TEXT NOT NULL,
        city TEXT NOT NULL,
        neighborhood TEXT NOT NULL,
        road TEXT NOT NULL,
        number TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE
      )
    ''');
  }
}
