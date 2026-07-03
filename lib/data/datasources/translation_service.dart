import 'package:translator/translator.dart';

/// Bangla translation via the unofficial Google Translate client.
/// This is a best-effort layer: any failure (rate limit, network,
/// unexpected response) is swallowed per-item so a translation problem
/// never blocks the English content from rendering.
class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String?> toBangla(String text) async {
    if (text.trim().isEmpty) return null;
    try {
      final result = await _translator.translate(text, from: 'en', to: 'bn');
      final translated = result.text.trim();
      return translated.isEmpty ? null : translated;
    } catch (_) {
      return null;
    }
  }

  /// Translates each item independently (rather than joining into one
  /// batched call) — the unofficial API can reorder or drop lines when
  /// multiple sentences are joined, which is worse than a partial result.
  /// A small delay between calls reduces the chance of being rate-limited.
  Future<List<String?>> toBanglaBatch(List<String> texts) async {
    final results = <String?>[];
    for (var i = 0; i < texts.length; i++) {
      results.add(await toBangla(texts[i]));
      if (i != texts.length - 1) {
        await Future.delayed(const Duration(milliseconds: 120));
      }
    }
    return results;
  }
}
