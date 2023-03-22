import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    api_id INTEGER,
    name TEXT,
    summary TEXT,
    imageOriginal TEXT ,
    imageMedium TEXT,
    imdb TEXT,
    rating REAL,
    )
    ''');
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

  static Future<int> createItem(
      String api_id,
      String name,
      String summary,
      String image_original,
      String image_medium,
      String imdb,
      double rating) async {
    final db = await SQLHelper.db();

    final data = {
      'api_id': api_id,
      'name': name,
      'summary': summary,
      'image_original': image_original,
      'image_medium': image_medium,
      'imdb': imdb,
      'rating': rating
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }
}
