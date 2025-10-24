import 'package:sqflite/sqflite.dart';
import 'package:dicionario/Config/db/favorits.dart';
import 'package:dicionario/Config/model/Post_model.dart';

class FavoriteService {
  static Future<Database> get _database async =>
      await DatabaseConfig().database;

  static Future<List<PostModel>> getFavorites() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((e) => PostModel.fromJson(e)).toList();
  }

  static Future<void> addFavorite(PostModel item) async {
    final db = await _database;
    await db.insert(
      'favorites',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<PostModel?> removeFavorite(int termoId) async {
    final db = await _database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [termoId],
    );
    PostModel? removed;
    if (maps.isNotEmpty) {
      removed = PostModel.fromJson(maps.first);
      await db.delete('favorites', where: 'id = ?', whereArgs: [termoId]);
    }
    return removed;
  }

  static Future<bool> isFavorite(int termoId) async {
    final db = await _database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [termoId],
    );
    return maps.isNotEmpty;
  }
}
