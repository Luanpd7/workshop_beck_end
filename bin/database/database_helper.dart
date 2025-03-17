import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static late Database _database;

  static Future<void> init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final databasePath = join(Directory.current.path, 'meu_banco.db');

    _database = await openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE customer (
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
          CREATE TABLE address (
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
          CREATE TABLE customer (
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
          CREATE TABLE address (
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
      },
    );
  }

  static Database get database => _database;
}
