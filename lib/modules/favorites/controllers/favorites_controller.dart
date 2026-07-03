import 'package:get/get.dart';
import '../../../data/models/word_entry.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/repositories/favorites_repository.dart';

enum FavoritesSort { recentlyAdded, alphabetical, byPartOfSpeech }

class FavoritesController extends GetxController {
  final DictionaryRepository _dictionaryRepository = Get.find<DictionaryRepository>();
  final FavoritesRepository _favoritesRepository = Get.find<FavoritesRepository>();

  final RxList<WordEntry> favorites = <WordEntry>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<FavoritesSort> sort = FavoritesSort.recentlyAdded.obs;

  @override
  void onInit() {
    super.onInit();
    refresh_();
  }

  Future<void> refresh_() async {
    isLoading.value = true;
    final records = await _favoritesRepository.getAll();
    final entries = <WordEntry>[];
    for (final record in records) {
      try {
        entries.add(await _dictionaryRepository.fetchDetail(record.headword));
      } catch (_) {
        // Word can't be resolved right now (offline + not cached) —
        // skip it rather than breaking the whole list; it reappears
        // once resolvable again.
      }
    }
    _applySort(entries);
    isLoading.value = false;
  }

  void _applySort(List<WordEntry> entries) {
    switch (sort.value) {
      case FavoritesSort.recentlyAdded:
        favorites.value = entries; // already most-recent-first from repository
        break;
      case FavoritesSort.alphabetical:
        favorites.value = [...entries]..sort((a, b) => a.headword.compareTo(b.headword));
        break;
      case FavoritesSort.byPartOfSpeech:
        favorites.value = [...entries]
          ..sort((a, b) => a.primaryPartOfSpeech.index.compareTo(b.primaryPartOfSpeech.index));
        break;
    }
  }

  void changeSort(FavoritesSort value) {
    sort.value = value;
    refresh_();
  }

  Future<void> remove(String headword) async {
    await _favoritesRepository.remove(headword);
    favorites.removeWhere((e) => e.headword == headword);
  }

  Future<void> undoRemove(String headword) async {
    await _favoritesRepository.add(headword);
    refresh_();
  }

  Future<void> clearAll() async {
    await _favoritesRepository.clearAll();
    favorites.clear();
  }
}
