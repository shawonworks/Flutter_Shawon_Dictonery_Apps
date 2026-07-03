import '../datasources/local_wordlist_source.dart';
import '../datasources/remote_dictionary_source.dart';
import '../datasources/translation_service.dart';
import '../models/definition.dart';
import '../models/meaning.dart';
import '../models/word_entry.dart';
import 'word_cache_repository.dart';

abstract class DictionaryRepository {
  /// Instant, offline, local-index prefix search — powers search-as-you-type.
  Future<List<String>> searchHeadwords(String query, {int max});

  /// Bounded-candidate edit-distance suggestions for a "no results" state.
  Future<List<String>> suggestClosest(String query, {int max});

  /// Cache-first: returns a cached entry immediately if we've fetched this
  /// word before (works fully offline), otherwise calls the remote API.
  /// Does NOT translate — call [ensureTranslated] for that, so the English
  /// content can render before the (slower) translation arrives.
  Future<WordEntry> fetchDetail(String headword);

  /// Attaches a Bangla translation to [entry] if it doesn't already have
  /// one, caching the result. Returns the entry unchanged if translation
  /// fails, so a translation outage never blocks the English content.
  Future<WordEntry> ensureTranslated(WordEntry entry);

  String wordOfTheDayHeadword();
  List<String> curatedExploreHeadwords({int count});

  /// Synchronous cache read, used by the search list to opportunistically
  /// show a rich preview for words already looked up before.
  WordEntry? peekCached(String headword);
}

class LiveDictionaryRepository implements DictionaryRepository {
  final LocalWordlistSource _wordlist;
  final RemoteDictionarySource _remote;
  final TranslationService _translationService;
  final WordCacheRepository _cache;

  /// De-dupes concurrent fetches for the same headword (e.g. rapid
  /// double-tap, or a synonym chip tapped twice before the first
  /// request resolves) so we never fire duplicate network calls.
  final Map<String, Future<WordEntry>> _inFlight = {};

  LiveDictionaryRepository({
    required LocalWordlistSource wordlist,
    required RemoteDictionarySource remote,
    required TranslationService translationService,
    required WordCacheRepository cache,
  }) : _wordlist = wordlist,
       _remote = remote,
       _translationService = translationService,
       _cache = cache;

  @override
  Future<List<String>> searchHeadwords(String query, {int max = 40}) => _wordlist.prefixSearch(query, max: max);

  @override
  Future<List<String>> suggestClosest(String query, {int max = 3}) => _wordlist.suggestClosest(query, max: max);

  @override
  String wordOfTheDayHeadword() => _wordlist.wordOfTheDayHeadword();

  @override
  List<String> curatedExploreHeadwords({int count = 6}) => _wordlist.curatedExploreHeadwords(count: count);

  @override
  WordEntry? peekCached(String headword) => _cache.peek(headword);

  @override
  Future<WordEntry> fetchDetail(String headword) async {
    final key = headword.toLowerCase();

    final cached = await _cache.get(key);
    if (cached != null) return cached;

    final existing = _inFlight[key];
    if (existing != null) return existing;

    final future = _remote.fetch(headword).then((entry) async {
      await _cache.put(entry);
      return entry;
    });
    _inFlight[key] = future;
    try {
      return await future;
    } finally {
      _inFlight.remove(key);
    }
  }

  @override
  Future<WordEntry> ensureTranslated(WordEntry entry) async {
    if (entry.isTranslated) return entry;

    // Cap what we translate per word: the headword plus the first
    // meaning's definitions (usually the most-read part of the screen).
    // Keeps latency and rate-limit exposure predictable regardless of
    // how many meanings/definitions a word happens to have.
    final firstMeaning = entry.meanings.isNotEmpty ? entry.meanings.first : null;
    final defTexts = firstMeaning?.definitions.take(4).map((d) => d.text).toList() ?? const <String>[];
    final toTranslate = [entry.headword, ...defTexts];

    final translated = await _translationService.toBanglaBatch(toTranslate);
    final bnHeadword = translated.first;

    if (bnHeadword == null && translated.skip(1).every((t) => t == null)) {
      // Translation service unavailable — fail soft, keep English-only.
      return entry;
    }

    Meaning? updatedFirstMeaning;
    if (firstMeaning != null) {
      final updatedDefs = <Definition>[];
      for (var i = 0; i < firstMeaning.definitions.length; i++) {
        final def = firstMeaning.definitions[i];
        final bnText = i < defTexts.length ? translated[i + 1] : null;
        updatedDefs.add(i < defTexts.length ? def.copyWith(bnText: bnText) : def);
      }
      updatedFirstMeaning = firstMeaning.copyWith(definitions: updatedDefs);
    }

    final updatedMeanings = [
      if (updatedFirstMeaning != null) updatedFirstMeaning,
      ...entry.meanings.skip(1),
    ];

    final result = entry.copyWith(meanings: updatedMeanings, bnHeadword: bnHeadword ?? entry.headword);
    await _cache.put(result);
    return result;
  }
}
