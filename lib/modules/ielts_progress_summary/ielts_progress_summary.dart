class IeltsProgressSummary {
  final int currentStreak;
  final int longestStreak;
  final int totalDaysCompleted;
  final int totalWordsLearned;

  const IeltsProgressSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDaysCompleted,
    required this.totalWordsLearned,
  });

  static const empty = IeltsProgressSummary(
    currentStreak: 0,
    longestStreak: 0,
    totalDaysCompleted: 0,
    totalWordsLearned: 0,
  );
}