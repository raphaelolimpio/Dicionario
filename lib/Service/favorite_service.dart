import 'package:dicionario/Config/db/favorits.dart';
import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteService with ChangeNotifier {
  Future<Database> get _database async => await DatabaseConfig().database;
  List<PostModel> _favorites = [];
  bool _isLoading = true;
  List<PostModel> get favorites => _favorites;
  bool get isLoading => _isLoading;

  FavoriteService() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    _favorites = maps.map((e) => PostModel.fromJson(e)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFavorite(PostModel item) async {
    if (isFavorite(item.id)) return;

    final db = await _database;
    await db.insert(
      'favorites',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _favorites.add(item);
    notifyListeners();
  }

  Future<PostModel?> removeFavorite(int termoId) async {
    if (!isFavorite(termoId)) return null;

    final db = await _database;

    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [termoId],
    );
    PostModel? removed;
    if (maps.isNotEmpty) {
      removed = PostModel.fromJson(maps.first);
    }

    await db.delete('favorites', where: 'id = ?', whereArgs: [termoId]);

    _favorites.removeWhere((post) => post.id == termoId);
    notifyListeners();

    return removed;
  }

  bool isFavorite(int termoId) {
    return _favorites.any((post) => post.id == termoId);
  }
}
