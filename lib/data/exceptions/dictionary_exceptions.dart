/// Thrown when the remote dictionary API returns 404 for a headword.
class WordNotFoundException implements Exception {
  final String headword;
  const WordNotFoundException(this.headword);

  @override
  String toString() => 'WordNotFoundException: "$headword" not found';
}

/// Thrown when the lookup fails due to connectivity/timeout/server error,
/// as opposed to a genuine "word doesn't exist" 404.
class DictionaryNetworkException implements Exception {
  final String message;
  const DictionaryNetworkException([this.message = 'Network error']);

  @override
  String toString() => 'DictionaryNetworkException: $message';
}
