import 'dart:async';
import 'package:get/get.dart';
import '../../../data/exceptions/dictionary_exceptions.dart';
import '../../../data/models/word_entry.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/repositories/favorites_repository.dart';
import '../../../data/repositories/history_repository.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../history/controllers/history_controller.dart';

enum WordDetailErrorType { none, notFound, network }

class WordDetailController extends GetxController {
  final DictionaryRepository _dictionaryRepository = Get.find<DictionaryRepository>();
  final FavoritesRepository _favoritesRepository = Get.find<FavoritesRepository>();
  final HistoryRepository _historyRepository = Get.find<HistoryRepository>();

  final String headword;
  WordDetailController({required this.headword});

  final Rx<WordEntry?> entry = Rx<WordEntry?>(null);
  final RxBool isLoading = true.obs;
  final Rx<WordDetailErrorType> errorType = WordDetailErrorType.none.obs;
  final RxBool isFavorite = false.obs;
  final RxBool isPlayingAudio = false.obs;
  final RxInt selectedMeaningTabIndex = 0.obs;

  /// True once the Bangla translation is loading/loaded — lets the UI
  /// show a small inline spinner next to the translation section
  /// instead of blocking the English content, which arrives first.
  final RxBool isTranslating = false.obs;

  bool get hasError => errorType.value != WordDetailErrorType.none;

  Timer? _audioTimer;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  @override
  void onClose() {
    _audioTimer?.cancel();
    super.onClose();
  }

  Future<void> _load() async {
    isLoading.value = true;
    errorType.value = WordDetailErrorType.none;
    selectedMeaningTabIndex.value = 0;
    try {
      final found = await _dictionaryRepository.fetchDetail(headword);
      entry.value = found;
      isFavorite.value = await _favoritesRepository.isFavorite(headword);
      await _historyRepository.logView(headword);
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().refresh_();
      }
      isLoading.value = false;
      unawaited(_translate());
    } on WordNotFoundException {
      errorType.value = WordDetailErrorType.notFound;
      isLoading.value = false;
    } on DictionaryNetworkException {
      errorType.value = WordDetailErrorType.network;
      isLoading.value = false;
    } catch (_) {
      errorType.value = WordDetailErrorType.network;
      isLoading.value = false;
    }
  }

  /// Fetches the Bangla translation after the English content is already
  /// on screen — translation is strictly additive and should never delay
  /// the initial render.
  Future<void> _translate() async {
    final current = entry.value;
    if (current == null || current.isTranslated) return;
    isTranslating.value = true;
    try {
      entry.value = await _dictionaryRepository.ensureTranslated(current);
    } finally {
      isTranslating.value = false;
    }
  }

  void retry() => _load();

  Future<void> toggleFavorite() async {
    if (isFavorite.value) {
      await _favoritesRepository.remove(headword);
      isFavorite.value = false;
    } else {
      await _favoritesRepository.add(headword);
      isFavorite.value = true;
    }
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().refresh_();
    }
  }

  void selectMeaningTab(int index) => selectedMeaningTabIndex.value = index;

  /// Simulated playback state; structured so a real AudioPlayer can be
  /// dropped in later without touching the UI layer ([entry.audioUrl]
  /// already carries the real pronunciation URL from the API).
  void togglePlayback() {
    if (isPlayingAudio.value) {
      _audioTimer?.cancel();
      isPlayingAudio.value = false;
      return;
    }
    isPlayingAudio.value = true;
    _audioTimer = Timer(const Duration(milliseconds: 1500), () => isPlayingAudio.value = false);
  }

  String get sharePreviewText {
    final e = entry.value;
    if (e == null) return '';
    return '${e.headword} ${e.phonetic}\n${e.previewDefinition}';
  }
}
