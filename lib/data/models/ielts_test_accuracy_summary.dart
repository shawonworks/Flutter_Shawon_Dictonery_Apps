class IeltsTestAccuracySummary {
  final int totalTestsCompleted;
  final double averageAccuracyPercent;

  const IeltsTestAccuracySummary({required this.totalTestsCompleted, required this.averageAccuracyPercent});

  static const empty = IeltsTestAccuracySummary(totalTestsCompleted: 0, averageAccuracyPercent: 0);
}