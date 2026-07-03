import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_entry.dart';

/// Cache-aside store for fully-resolved (fetched + translated) word
/// entries, keyed by lowercase headword. Hydrated into memory once at
/// startup so synchronous reads are possible (e.g. showing a rich
/// preview in a search result row without an async gap), and persisted
/// to SharedPreferences on every write so it survives app restarts and
/// lets Favorites/History render fully offline after the first lookup.
class WordCacheRepository {
  static const _prefsKey = 'word_cache_v1';

  final Map<String, WordEntry> _memory = {};
  bool _hydrated = false;

  Future<void> _ensureHydrated() async {
    if (_hydrated) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        _memory[key] = WordEntry.fromJson(value as Map<String, dynamic>);
      });
    }
    _hydrated = true;
  }

  Future<WordEntry?> get(String headword) async {
    await _ensureHydrated();
    return _memory[headword.toLowerCase()];
  }

  /// Synchronous read for already-hydrated cache — used opportunistically
  /// by the search list to show a rich preview for words the user has
  /// already opened before, with zero async cost per keystroke.
  WordEntry? peek(String headword) => _memory[headword.toLowerCase()];

  Future<void> put(WordEntry entry) async {
    await _ensureHydrated();
    _memory[entry.headword.toLowerCase()] = entry;
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_memory.map((key, value) => MapEntry(key, value.toJson())));
    await prefs.setString(_prefsKey, encoded);
  }
}
