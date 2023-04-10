import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../api/api.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('DROP TABLE IF EXISTS items');
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      api_id INTEGER UNIQUE,
      name TEXT,
      summary TEXT,
      imageOriginal TEXT ,
      imageMedium TEXT,
      imdb TEXT,
      rating REAL,
      favorite INTEGER DEFAULT 0
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbestech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createItem(
      int apiId,
      String name,
      String summary,
      String imageOriginal,
      String imageMedium,
      String imdb,
      num? rating,
      int favorite) async {
    final db = await SQLHelper.db();
    await db.insert(
      'items',
      {
        'api_id': apiId,
        'name': name,
        'summary': summary,
        'imageOriginal': imageOriginal,
        'imageMedium': imageMedium,
        'imdb': imdb,
        'rating': rating,
        'favorite': favorite,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await SQLHelper.db();
    return await db.query('items',
        where: 'favorite = ?', whereArgs: [true], orderBy: 'id');
  }

  static Future<bool> getIMDB(String imdb) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('items', where: "imdb = ?", whereArgs: [imdb]);
    return maps.isNotEmpty;
  }

  static Future<bool> getItem(int api_id) async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> maps =
        await db.query('items', where: "api_id = ?", whereArgs: [api_id]);
    return maps.isNotEmpty;
  }

  static Future<void> updateFavorite(int id, bool favorite) async {
    final db = await SQLHelper.db();
    await db.update(
      'items',
      {'favorite': favorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteItem(int api_id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [api_id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }

  static Future<void> populateDatabase() async {
    final shows = await fetchShows();

    for (final show in shows) {
      final db = await SQLHelper.db();
      final List<Map<String, dynamic>> maps = await db
          .query('items', where: "api_id = ?", whereArgs: [show.api_id]);

      final isFavorite = maps.isNotEmpty ? maps[0]['favorite'] == 1 : false;

      if (maps.isEmpty) {
        await SQLHelper.createItem(
          show.api_id,
          show.name,
          show.summary,
          show.imageOriginal,
          show.imageMedium,
          show.imdb,
          show.rating,
          0,
        );
      } else {
        await SQLHelper.createItem(
          show.api_id,
          show.name,
          show.summary,
          show.imageOriginal,
          show.imageMedium,
          show.imdb,
          show.rating,
          isFavorite ? 1 : 0,
        );
      }
    }
  }

  static Future<bool> isDatabaseCreated() async {
    final db = await SQLHelper.db();
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='items'");
    return tables.length == 1;
  }

  static Future<void> setDatabaseCreated() async {
    final db = await SQLHelper.db();
    await db.insert('database_created', {'created': 1},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}
