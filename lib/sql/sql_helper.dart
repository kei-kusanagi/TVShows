import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:tv_show/api/api.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY,
      api_id INTEGER UNIQUE,
      name TEXT,
      summary TEXT,
      imageOriginal TEXT ,
      imageMedium TEXT,
      imdb TEXT,
      rating REAL,
      favorite BOOL DEFAULT 0
      )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), 'shows.db'),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String api_id,
      String name,
      String summary,
      String? imageOriginal,
      String? imageMedium,
      String? imdb,
      double? rating,
      bool? favorite) async {
    final db = await SQLHelper.db();

    final data = {
      'api_id': api_id,
      'name': name,
      'summary': summary,
      'imageOriginal': imageOriginal,
      'imageMedium': imageMedium,
      'imdb': imdb,
      'rating': rating,
      'favorite': favorite,
    };

    final existingItem = await getapiId(api_id);
    if (existingItem) {
      return -1;
    }

    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<bool> getapiId(String api_id) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('items', where: "api_id = ?", whereArgs: [api_id]);
    return maps.isNotEmpty;
  }

  static Future<int> updateItem(
      int id,
      String api_id,
      String name,
      String summary,
      String image_original,
      String image_medium,
      String imdb,
      double rating,
      bool favorite) async {
    final db = await SQLHelper.db();

    final data = {
      'api_id': api_id,
      'name': name,
      'summary': summary,
      'image_original': image_original,
      'image_medium': image_medium,
      'imdb': imdb,
      'rating': rating,
      'favorite': favorite,
    };

    final result =
        await db.update('items', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._getInstance();
  static sql.Database? _database;

  DatabaseHelper._getInstance();

  Future<sql.Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<sql.Database> _initDatabase() async {
    final String path = join(await sql.getDatabasesPath(), 'shows.db');
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database db, int version) async {
        await db.execute('''
          CREATE TABLE shows (
            id INTEGER PRIMARY KEY,
            api_id TEXT NOT NULL,
            name TEXT NOT NULL,
            summary TEXT NOT NULL,
            image_original TEXT NOT NULL,
            image_medium TEXT NOT NULL,
            imdb TEXT NOT NULL,
            rating REAL NOT NULL,
            favorite BOOL NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> populateDatabase() async {
    final List<Show> shows = await fetchShows();
    final sql.Database db = await database;
    final sql.Batch batch = db.batch();
    shows.forEach((show) {
      batch.insert('shows', show.toMap());
    });
    await batch.commit(noResult: true);
  }

  Future<List<Show>> getAllShows() async {
    final sql.Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('shows');
    return List.generate(maps.length, (i) {
      return Show.fromMap(maps[i]);
    });
  }

  Future<List<Show>> getFavoriteShows() async {
    final sql.Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('shows', where: 'favorite = 1');
    return List.generate(maps.length, (i) {
      return Show.fromMap(maps[i]);
    });
  }
}
