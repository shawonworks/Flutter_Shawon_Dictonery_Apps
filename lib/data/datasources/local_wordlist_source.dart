import 'package:flutter/services.dart' show rootBundle;

/// Loads the bundled, alphabetically-sorted English wordlist and serves:
/// - instant prefix search (binary search, O(log n) + O(k) for k matches)
/// - closest-match suggestions for a "no results" state (bounded candidate
///   set, never a full O(n) Levenshtein scan)
/// - a small curated pool used for Word of the Day / Explore
///
/// This is intentionally offline-only: `dictionaryapi.dev` has no
/// search/autocomplete endpoint, so live suggestions must come from a
/// local index. Full definitions are fetched remotely only once a
/// headword is actually opened (see RemoteDictionarySource).
class LocalWordlistSource {
  static const _assetPath = 'assets/data/words_en.txt';

  /// A hand-picked pool of genuinely interesting words for the "Annotated
  /// Paper" home surface, so Word of the Day / Explore don't surface
  /// dull three-letter words from the raw list.
  static const curatedPool = <String>[
    'serendipity', 'ephemeral', 'meticulous', 'ambiguous', 'resilient',
    'candid', 'elaborate', 'pragmatic', 'ubiquitous', 'cognizant',
    'benevolent', 'articulate', 'nostalgia', 'diligent', 'obscure',
    'tenacious', 'lucid', 'aloof', 'candor', 'fickle', 'vindicate',
    'wary', 'zealous', 'quaint', 'novel', 'coherent', 'frugal',
    'gregarious', 'immaculate', 'jubilant', 'labyrinth', 'malleable',
    'nuance', 'opaque', 'prudent', 'quandary', 'reticent', 'sanguine',
    'taciturn', 'unwavering', 'verbose', 'whimsical', 'zenith',
  ];

  List<String>? _cache;

  Future<List<String>> _load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(_assetPath);
    _cache = raw.split('\n').where((w) => w.isNotEmpty).toList(growable: false);
    return _cache!;
  }

  /// Words the wordlist confirms exist (case-insensitive exact match).
  Future<bool> exists(String word) async {
    final list = await _load();
    return _binarySearch(list, word.toLowerCase()) != -1;
  }

  /// Prefix match via binary search: find the lower bound of [query],
  /// then walk forward while the prefix still matches.
  Future<List<String>> prefixSearch(String query, {int max = 40}) async {
    final list = await _load();
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return [];

    final start = _lowerBound(list, lower);
    final results = <String>[];
    for (var i = start; i < list.length && results.length < max; i++) {
      if (!list[i].startsWith(lower)) break;
      results.add(list[i]);
    }
    return results;
  }

  /// Closest headwords by edit-distance for the "no results" state.
  /// Candidates are pre-filtered to the same starting letter and a
  /// similar length before scoring, so this never scans all 274k words.
  Future<List<String>> suggestClosest(String query, {int max = 3}) async {
    final list = await _load();
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return [];

    final firstLetter = lower[0];
    final candidates = list
        .where((w) => w.isNotEmpty && w[0] == firstLetter && (w.length - lower.length).abs() <= 3)
        .take(4000)
        .toList();

    final scored = candidates.map((w) => MapEntry(w, _levenshtein(lower, w))).toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return scored.take(max).map((e) => e.key).toList();
  }

  /// Date-seeded so the pick rotates daily without a backend.
  String wordOfTheDayHeadword() {
    final dayIndex = DateTime.now().difference(DateTime(2024, 1, 1)).inDays;
    return curatedPool[dayIndex % curatedPool.length];
  }

  List<String> curatedExploreHeadwords({int count = 6}) {
    final start = DateTime.now().day % (curatedPool.length - count).clamp(1, curatedPool.length);
    final end = (start + count).clamp(0, curatedPool.length);
    return curatedPool.sublist(start, end);
  }

  int _lowerBound(List<String> sorted, String target) {
    var lo = 0, hi = sorted.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (sorted[mid].compareTo(target) < 0) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  int _binarySearch(List<String> sorted, String target) {
    var lo = 0, hi = sorted.length - 1;
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      final cmp = sorted[mid].compareTo(target);
      if (cmp == 0) return mid;
      if (cmp < 0) {
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return -1;
  }

  int _levenshtein(String a, String b) {
    final la = a.length, lb = b.length;
    final dp = List.generate(la + 1, (_) => List.filled(lb + 1, 0));
    for (var i = 0; i <= la; i++) dp[i][0] = i;
    for (var j = 0; j <= lb; j++) dp[0][j] = j;
    for (var i = 1; i <= la; i++) {
      for (var j = 1; j <= lb; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost].reduce((v, e) => v < e ? v : e);
      }
    }
    return dp[la][lb];
  }
}
