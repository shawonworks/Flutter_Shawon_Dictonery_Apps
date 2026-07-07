import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/ielts_progress_summary/ielts_progress_summary.dart';
import '../../modules/ielts_topic/views/ielts_word_entry.dart';
import 'ielts_word_bank_repository.dart';

class _ProgressData {
  final int currentStreak;
  final int longestStreak;
  final String? lastCompletedDate;
  final int totalDaysCompleted;
  final Set<String> allLearnedHeadwords;

  const _ProgressData({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastCompletedDate,
    required this.totalDaysCompleted,
    required this.allLearnedHeadwords,
  });

  static const empty = _ProgressData(
    currentStreak: 0,
    longestStreak: 0,
    lastCompletedDate: null,
    totalDaysCompleted: 0,
    allLearnedHeadwords: {},
  );

  _ProgressData copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastCompletedDate,
    int? totalDaysCompleted,
    Set<String>? allLearnedHeadwords,
  }) {
    return _ProgressData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      totalDaysCompleted: totalDaysCompleted ?? this.totalDaysCompleted,
      allLearnedHeadwords: allLearnedHeadwords ?? this.allLearnedHeadwords,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastCompletedDate': lastCompletedDate,
    'totalDaysCompleted': totalDaysCompleted,
    'allLearnedHeadwords': allLearnedHeadwords.toList(),
  };

  factory _ProgressData.fromJson(Map<String, dynamic> json) => _ProgressData(
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    lastCompletedDate: json['lastCompletedDate'] as String?,
    totalDaysCompleted: json['totalDaysCompleted'] as int? ?? 0,
    allLearnedHeadwords: ((json['allLearnedHeadwords'] as List?) ?? const []).map((e) => e as String).toSet(),
  );
}

class IeltsProgressRepository {
  static const _progressKey = 'ielts_progress_v1';
  static const _todayKey = 'ielts_today_progress_v1';
  static const dailyChallengeSize = 10;

  final IeltsWordBankRepository _wordBank;

  IeltsProgressRepository({required IeltsWordBankRepository wordBank}) : _wordBank = wordBank;

  String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<List<IeltsWordEntry>> todayChallengeWords() async {
    final all = await _wordBank.allWords();
    if (all.isEmpty) return const [];
    final seed = DateTime.now().difference(DateTime(2024, 1, 1)).inDays;
    final shuffled = List<IeltsWordEntry>.of(all)..shuffle(Random(seed));
    return shuffled.take(dailyChallengeSize).toList();
  }

  Future<Set<String>> _loadTodayTicked() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_todayKey);
    final todayKey = _dateKey(DateTime.now());
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    if (decoded['date'] != todayKey) return {};
    return ((decoded['ticked'] as List?) ?? const []).map((e) => e as String).toSet();
  }

  Future<void> _saveTodayTicked(Set<String> ticked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todayKey, jsonEncode({'date': _dateKey(DateTime.now()), 'ticked': ticked.toList()}));
  }

  Future<Set<String>> tickedHeadwordsToday() => _loadTodayTicked();

  Future<_ProgressData> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_progressKey);
    if (raw == null) return _ProgressData.empty;
    return _ProgressData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> _saveProgress(_ProgressData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(data.toJson()));
  }

  Future<void> toggleWord(String headword) async {
    final ticked = await _loadTodayTicked();
    if (ticked.contains(headword)) {
      ticked.remove(headword);
    } else {
      ticked.add(headword);
    }
    await _saveTodayTicked(ticked);

    var progress = await _loadProgress();
    if (!progress.allLearnedHeadwords.contains(headword) && ticked.contains(headword)) {
      progress = progress.copyWith(allLearnedHeadwords: {...progress.allLearnedHeadwords, headword});
    }

    final todayKey = _dateKey(DateTime.now());
    if (ticked.length >= dailyChallengeSize && progress.lastCompletedDate != todayKey) {
      progress = _applyStreakCompletion(progress, todayKey);
    }

    await _saveProgress(progress);
  }

  _ProgressData _applyStreakCompletion(_ProgressData data, String todayKey) {
    final yesterdayKey = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    final continuesStreak = data.lastCompletedDate == yesterdayKey;
    final newStreak = continuesStreak ? data.currentStreak + 1 : 1;
    return data.copyWith(
      currentStreak: newStreak,
      longestStreak: newStreak > data.longestStreak ? newStreak : data.longestStreak,
      lastCompletedDate: todayKey,
      totalDaysCompleted: data.totalDaysCompleted + 1,
    );
  }

  Future<IeltsProgressSummary> summary() async {
    final progress = await _loadProgress();
    final todayKey = _dateKey(DateTime.now());
    final yesterdayKey = _dateKey(DateTime.now().subtract(const Duration(days: 1)));

    var displayedStreak = progress.currentStreak;
    if (progress.lastCompletedDate != null &&
        progress.lastCompletedDate != todayKey &&
        progress.lastCompletedDate != yesterdayKey) {
      displayedStreak = 0;
    }

    return IeltsProgressSummary(
      currentStreak: displayedStreak,
      longestStreak: progress.longestStreak,
      totalDaysCompleted: progress.totalDaysCompleted,
      totalWordsLearned: progress.allLearnedHeadwords.length,
    );
  }
}