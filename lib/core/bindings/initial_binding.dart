import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../data/datasources/local_wordlist_source.dart';
import '../../data/datasources/remote_dictionary_source.dart';
import '../../data/datasources/translation_service.dart';
import '../../data/repositories/dictionary_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/word_cache_repository.dart';
import '../theme/theme_controller.dart';
import '../theme/text_scale_controller.dart';

/// Registered once at app start. Repositories and cross-screen
/// controllers live here as permanent singletons so every module
/// (Home, Word Detail, Favorites, History, Settings) shares one
/// source of truth instead of re-reading SharedPreferences separately.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Dio(
      BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)),
    );
    Get.put<Dio>(dio, permanent: true);

    Get.put(WordCacheRepository(), permanent: true);
    Get.put(FavoritesRepository(), permanent: true);
    Get.put(HistoryRepository(), permanent: true);

    Get.put<DictionaryRepository>(
      LiveDictionaryRepository(
        wordlist: LocalWordlistSource(),
        remote: RemoteDictionarySource(dio: dio),
        translationService: TranslationService(),
        cache: Get.find<WordCacheRepository>(),
      ),
      permanent: true,
    );

    Get.put(ThemeController(), permanent: true);
    Get.put(TextScaleController(), permanent: true);
  }
}
