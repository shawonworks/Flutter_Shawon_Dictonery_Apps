import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ielts_test_accuracy_summary.dart';

class _Attempt {
  final int score;
  final int total;
  const _Attempt({required this.score, required this.total});

  Map<String, dynamic> toJson() => {'score': score, 'total': total};
  factory _Attempt.fromJson(Map<String, dynamic> json) =>
      _Attempt(score: json['score'] as int, total: json['total'] as int);
}

class IeltsTestResultRepository {
  static const _key = 'ielts_test_results_v1';
  static const _maxHistory = 50;

  Future<List<_Attempt>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => _Attempt.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> recordAttempt(int score, int total) async {
    if (total <= 0) return;
    final attempts = await _loadAll();
    attempts.add(_Attempt(score: score, total: total));
    final trimmed = attempts.length > _maxHistory
        ? attempts.sublist(attempts.length - _maxHistory)
        : attempts;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(trimmed.map((e) => e.toJson()).toList()));
  }

  Future<IeltsTestAccuracySummary> summary() async {
    final attempts = await _loadAll();
    if (attempts.isEmpty) return IeltsTestAccuracySummary.empty;
    final totalPercent = attempts.fold<double>(0, (sum, a) => sum + (a.score / a.total * 100));
    return IeltsTestAccuracySummary(
      totalTestsCompleted: attempts.length,
      averageAccuracyPercent: totalPercent / attempts.length,
    );
  }
}