import 'package:dicionario/Config/db/favorits.dart';
import 'package:dicionario/Config/model/Post_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteService with ChangeNotifier {
  Future<Database> get _database async => await DatabaseConfig().database;
  List<PostModel> _favorites = [];
  List<PostModel> _allFavorites = [];
  List<String> _topics = [];
  bool _isLoading = true;

  List<PostModel> get favorites => _favorites;
  List<String> get topics => _topics;
  bool get isLoading => _isLoading;

  FavoriteService() {
    loadFavorites();
  }

  Future<List<PostModel>> fetchFavorites({String? topico}) async {
    try {
      final db = await _database;
      List<Map<String, dynamic>> maps;
      if (topico != null && topico.isNotEmpty && topico != 'Todas') {
        maps = await db.query(
          'favorites',
          where: 'topico LIKE ?',
          whereArgs: ['%$topico%'],
        );
      } else {
        maps = await db.query('favorites');
      }
      return maps.map((e) => PostModel.fromJson(e)).toList();
    } catch (e, st) {
      debugPrint('fetchFavorites error: $e\n$st');
      return [];
    }
  }

  Future<List<String>> getFavoriteTopics() async {
    try {
      final db = await _database;
      final rows = await db.rawQuery('SELECT DISTINCT topico FROM favorites ORDER BY topico COLLATE NOCASE');
      final topics = rows
          .map((r) => (r['topico'] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .toList();
      return topics;
    } catch (e, st) {
      debugPrint('getFavoriteTopics error: $e\n$st');
      return [];
    }
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    _favorites = maps.map((e) => PostModel.fromJson(e)).toList();

    _allFavorites = maps.map((e) => PostModel.fromJson(e)).toList();

    _topics = _allFavorites.map((post) => post.topico).toSet().toList()..sort();

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? topico, String? nome}){
    var filtered = List<PostModel>.from(_allFavorites);
    if(topico != null && topico.isNotEmpty && topico != "Todas" && topico != "todos"){
      filtered = filtered.where((post) => post.topico == topico).toList();
    }
    if(nome != null && nome.isNotEmpty) {
      final normalizedNome = nome.toLowerCase().trim();
      filtered = filtered
      .where((post) => (post.nome ?? "").toLowerCase().contains(normalizedNome)).toList();
    }
    _favorites = filtered;
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
    await loadFavorites();
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

    await loadFavorites();

    return removed;
  }

  bool isFavorite(int termoId) {
    return _favorites.any((post) => post.id == termoId);
  }
}
