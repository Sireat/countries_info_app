import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'favorites.db');

      // Log database path for debugging

      // Open the database and create table if it doesn't exist
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            '''
            CREATE TABLE favorites (
              commonName TEXT PRIMARY KEY
            )
            ''',
          );
        },
      );
    } catch (e) {
      // Log error details and rethrow for further handling
      rethrow;
    }
  }

  Future<void> addFavorite(String commonName) async {
    try {
      final db = await database;
      await db.insert(
        'favorites',
        {'commonName': commonName},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow; // Optionally rethrow to handle it at a higher level
    }
  }

  Future<void> removeFavorite(String commonName) async {
    try {
      final db = await database;
      await db.delete(
        'favorites',
        where: 'commonName = ?',
        whereArgs: [commonName],
      );
    } catch (e) {
      rethrow; // Optionally rethrow to handle it at a higher level
    }
  }

  Future<List<String>> getFavorites() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('favorites');
      return List.generate(maps.length, (i) => maps[i]['commonName'] as String);
    } catch (e) {
      return [];
    }
  }

  Future<bool> isFavorite(String commonName) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'commonName = ?',
        whereArgs: [commonName],
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
