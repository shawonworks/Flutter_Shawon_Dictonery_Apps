class AppApiUrl {
  AppApiUrl._();

  /// Lexicon is fully offline today, so no base URL is prefixed.
  /// Kept as the single seam AppImage relies on if a remote image
  /// source (e.g. CDN-hosted illustrations) is added later.
  static String resolveImageUrl(String path) => path;
}
