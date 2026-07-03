import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/word_entry.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/repositories/history_repository.dart';

enum SearchStatus { idle, loading, results, empty }

class HomeSearchController extends GetxController {
  final DictionaryRepository _dictionaryRepository = Get.find<DictionaryRepository>();
  final HistoryRepository _historyRepository = Get.find<HistoryRepository>();

  final TextEditingController textController = TextEditingController();
  final RxString query = ''.obs;
  final Rx<SearchStatus> status = SearchStatus.idle.obs;

  /// Headwords only — full definitions are fetched lazily per word on
  /// Word Detail, never for a whole result list (dictionaryapi.dev has
  /// no batch/search endpoint, so a live-search list of full entries
  /// would mean one network call per row per keystroke).
  final RxList<String> results = <String>[].obs;
  final RxList<String> suggestions = <String>[].obs;

  final Rx<WordEntry?> wordOfTheDay = Rx<WordEntry?>(null);
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<WordEntry> exploreWords = <WordEntry>[].obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _loadHomeContent();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }

  Future<void> _loadHomeContent() async {
    unawaited(_loadWordOfTheDay());
    unawaited(_loadExplore());
    await refreshRecentSearches();
  }

  Future<void> _loadWordOfTheDay() async {
    try {
      wordOfTheDay.value = await _dictionaryRepository.fetchDetail(_dictionaryRepository.wordOfTheDayHeadword());
    } catch (_) {
      // Offline on first launch with nothing cached yet — home simply
      // omits the card rather than showing an error on a passive surface.
    }
  }

  Future<void> _loadExplore() async {
    final headwords = _dictionaryRepository.curatedExploreHeadwords();
    final entries = <WordEntry>[];
    for (final h in headwords) {
      try {
        entries.add(await _dictionaryRepository.fetchDetail(h));
      } catch (_) {
        // Skip words that fail to resolve (offline + not yet cached).
      }
    }
    exploreWords.value = entries;
  }

  Future<void> refreshRecentSearches() async {
    recentSearches.value = await _historyRepository.recentHeadwords();
  }

  void onQueryChanged(String value) {
    query.value = value;
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      status.value = SearchStatus.idle;
      results.clear();
      return;
    }

    status.value = SearchStatus.loading;
    _debounce = Timer(const Duration(milliseconds: 250), () => _runSearch(value));
  }

  Future<void> _runSearch(String value) async {
    final found = await _dictionaryRepository.searchHeadwords(value);
    if (query.value != value) return; // stale response guard

    if (found.isEmpty) {
      suggestions.value = await _dictionaryRepository.suggestClosest(value);
      status.value = SearchStatus.empty;
    } else {
      results.value = found;
      status.value = SearchStatus.results;
    }
  }

  /// Cache-only lookup so a search row can opportunistically show a rich
  /// preview (POS + definition) for a word the user has already opened
  /// before, without any network cost.
  WordEntry? peekCached(String headword) => _dictionaryRepository.peekCached(headword);

  void searchFor(String word) {
    textController.text = word;
    textController.selection = TextSelection.fromPosition(TextPosition(offset: word.length));
    onQueryChanged(word);
  }

  void clearRecentSearches() async {
    await _historyRepository.clearAll();
    await refreshRecentSearches();
  }

  void clearQuery() {
    textController.clear();
    onQueryChanged('');
  }
}
