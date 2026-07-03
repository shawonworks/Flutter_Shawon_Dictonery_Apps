import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRecord {
  final String headword;
  final DateTime viewedAt;

  const HistoryRecord({required this.headword, required this.viewedAt});

  Map<String, dynamic> toJson() => {'headword': headword, 'viewedAt': viewedAt.toIso8601String()};

  factory HistoryRecord.fromJson(Map<String, dynamic> json) =>
      HistoryRecord(headword: json['headword'] as String, viewedAt: DateTime.parse(json['viewedAt'] as String));
}

class HistoryRepository {
  static const _prefsKey = 'history_v1';

  Future<List<HistoryRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    final list = decoded.map((e) => HistoryRecord.fromJson(e as Map<String, dynamic>)).toList();
    list.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
    return list;
  }

  /// Logs a word view. One entry per word — most-recent-activity wins,
  /// rather than duplicating rows for repeat lookups.
  Future<void> logView(String headword) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getAll();
    list.removeWhere((e) => e.headword == headword);
    list.add(HistoryRecord(headword: headword, viewedAt: DateTime.now()));
    list.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
    await prefs.setString(_prefsKey, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  /// Last [max] distinct headwords, most recent first — used for the
  /// "Recent Searches" chip row on Home.
  Future<List<String>> recentHeadwords({int max = 5}) async {
    final list = await getAll();
    return list.take(max).map((e) => e.headword).toList();
  }
}
