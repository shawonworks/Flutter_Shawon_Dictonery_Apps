import 'dart:async';
import 'package:get/get.dart';
import '../../../data/exceptions/dictionary_exceptions.dart';
import '../../../data/models/meaning.dart';
import '../../../data/models/word_entry.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/repositories/favorites_repository.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/services/voice_service.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../history/controllers/history_controller.dart';

enum WordDetailErrorType { none, notFound, network }

class WordDetailController extends GetxController {
  final DictionaryRepository _dictionaryRepository =
      Get.find<DictionaryRepository>();
  final FavoritesRepository _favoritesRepository =
      Get.find<FavoritesRepository>();
  final HistoryRepository _historyRepository = Get.find<HistoryRepository>();
  final VoiceService _voiceService = Get.find<VoiceService>();

  final String headword;

  WordDetailController({required this.headword});

  final Rx<WordEntry?> entry = Rx<WordEntry?>(null);
  final RxBool isLoading = true.obs;
  final Rx<WordDetailErrorType> errorType = WordDetailErrorType.none.obs;
  final RxBool isFavorite = false.obs;
  
  // Link this to VoiceService's isPlaying state
  RxBool get isPlayingAudio => _voiceService.isPlaying;

  final RxInt selectedMeaningTabIndex = 0.obs;
  final RxBool isTranslating = false.obs;

  bool get hasError => errorType.value != WordDetailErrorType.none;

  @override
  void onInit() {
    super.onInit();
    _load();
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

  void togglePlayback() {
    if (isPlayingAudio.value) {
      _voiceService.stop();
    } else {
      _voiceService.speak(headword, url: entry.value?.audioUrl);
    }
  }

  String get sharePreviewText {
    final e = entry.value;
    if (e == null) return '';

    final pos = partOfSpeechShortCode(e.primaryPartOfSpeech);
    final headwordLine = pos.isNotEmpty ? '${e.headword} ($pos)' : e.headword;

    String? example;
    for (final meaning in e.meanings) {
      for (final def in meaning.definitions) {
        if (def.example != null && def.example!.isNotEmpty) {
          example = def.example;
          break;
        }
      }
      if (example != null) break;
    }

    final synonyms = e.synonyms.take(3).toList();
    final antonyms = e.antonyms.take(3).toList();

    return [
      'Word: $headwordLine',
      if (e.bnHeadword != null) 'Meaning: ${e.bnHeadword!}',
      if (example != null) 'Example: "$example"',
      if (synonyms.isNotEmpty) 'Synonyms: ${synonyms.join(', ')}',
      if (antonyms.isNotEmpty) 'Antonyms: ${antonyms.join(', ')}',
    ].join('\n');
  }
}
