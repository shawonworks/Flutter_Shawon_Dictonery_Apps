import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRecord {
  final String headword;
  final DateTime addedAt;

  const FavoriteRecord({required this.headword, required this.addedAt});

  Map<String, dynamic> toJson() => {'headword': headword, 'addedAt': addedAt.toIso8601String()};

  factory FavoriteRecord.fromJson(Map<String, dynamic> json) => FavoriteRecord(
    headword: json['headword'] as String,
    addedAt: DateTime.parse(json['addedAt'] as String),
  );
}

class FavoritesRepository {
  static const _prefsKey = 'favorites_v1';

  Future<List<FavoriteRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    final list = decoded.map((e) => FavoriteRecord.fromJson(e as Map<String, dynamic>)).toList();
    list.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return list;
  }

  Future<void> add(String headword) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    if (list.any((e) => e.headword == headword)) return;
    list.add(FavoriteRecord(headword: headword, addedAt: DateTime.now()));
    await prefs.setString(_prefsKey, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> remove(String headword) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    list.removeWhere((e) => e.headword == headword);
    await prefs.setString(_prefsKey, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  Future<bool> isFavorite(String headword) async {
    final list = await getAll();
    return list.any((e) => e.headword == headword);
  }
}
