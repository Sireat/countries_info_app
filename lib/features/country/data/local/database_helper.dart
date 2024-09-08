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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

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
  }

  Future<void> addFavorite(String commonName) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'commonName': commonName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String commonName) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'commonName = ?',
      whereArgs: [commonName],
    );
  }

  Future<List<String>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) => maps[i]['commonName'] as String);
  }

  Future<bool> isFavorite(String commonName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'commonName = ?',
      whereArgs: [commonName],
    );
    return maps.isNotEmpty;
  }
}
