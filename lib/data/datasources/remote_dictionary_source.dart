import 'package:dio/dio.dart';
import '../exceptions/dictionary_exceptions.dart';
import '../models/definition.dart';
import '../models/meaning.dart';
import '../models/word_entry.dart';

/// Free Dictionary API (https://dictionaryapi.dev) client.
/// Exact-word lookup only — no search/autocomplete endpoint, which is why
/// typing suggestions come from LocalWordlistSource instead.
class RemoteDictionarySource {
  static const _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  final Dio _dio;

  RemoteDictionarySource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  Future<WordEntry> fetch(String headword) async {
    try {
      final response = await _dio.get<List<dynamic>>('$_baseUrl/${Uri.encodeComponent(headword)}');
      final list = response.data;
      if (list == null || list.isEmpty) {
        throw WordNotFoundException(headword);
      }
      return _parse(list.first as Map<String, dynamic>, fallbackHeadword: headword);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw WordNotFoundException(headword);
      }
      throw DictionaryNetworkException(e.message ?? 'Failed to reach the dictionary service');
    }
  }

  WordEntry _parse(Map<String, dynamic> json, {required String fallbackHeadword}) {
    final phoneticsRaw = (json['phonetics'] as List?) ?? const [];

    String phonetic = (json['phonetic'] as String?) ?? '';
    String? audioUrl;
    for (final p in phoneticsRaw) {
      final map = p as Map<String, dynamic>;
      if (phonetic.isEmpty && (map['text'] as String?)?.isNotEmpty == true) {
        phonetic = map['text'] as String;
      }
      final audio = map['audio'] as String?;
      if (audioUrl == null && audio != null && audio.isNotEmpty) {
        audioUrl = audio.startsWith('//') ? 'https:$audio' : audio;
      }
    }

    final meaningsRaw = (json['meanings'] as List?) ?? const [];
    final meanings = <Meaning>[];
    final synonyms = <String>{};
    final antonyms = <String>{};

    for (final m in meaningsRaw) {
      final meaningMap = m as Map<String, dynamic>;
      final defsRaw = (meaningMap['definitions'] as List?) ?? const [];
      final definitions = defsRaw
          .map((d) {
            final defMap = d as Map<String, dynamic>;
            final defSynonyms = (defMap['synonyms'] as List?)?.cast<String>() ?? const [];
            final defAntonyms = (defMap['antonyms'] as List?)?.cast<String>() ?? const [];
            synonyms.addAll(defSynonyms);
            antonyms.addAll(defAntonyms);
            return Definition(text: defMap['definition'] as String? ?? '', example: defMap['example'] as String?);
          })
          .where((d) => d.text.isNotEmpty)
          .toList();

      if (definitions.isEmpty) continue;

      synonyms.addAll((meaningMap['synonyms'] as List?)?.cast<String>() ?? const []);
      antonyms.addAll((meaningMap['antonyms'] as List?)?.cast<String>() ?? const []);

      meanings.add(
        Meaning(
          partOfSpeech: partOfSpeechFromString(meaningMap['partOfSpeech'] as String? ?? ''),
          definitions: definitions,
        ),
      );
    }

    return WordEntry(
      headword: (json['word'] as String?) ?? fallbackHeadword,
      phonetic: phonetic,
      meanings: meanings,
      synonyms: synonyms.take(8).toList(),
      antonyms: antonyms.take(8).toList(),
      audioUrl: audioUrl,
    );
  }
}
