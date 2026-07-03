import 'package:get/get.dart';
import '../../../data/models/word_entry.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/repositories/history_repository.dart';

class HistoryGroup {
  final String label;
  final List<_HistoryItem> items;
  const HistoryGroup({required this.label, required this.items});
}

class _HistoryItem {
  final WordEntry entry;
  final DateTime viewedAt;
  const _HistoryItem({required this.entry, required this.viewedAt});
}

class HistoryController extends GetxController {
  final DictionaryRepository _dictionaryRepository = Get.find<DictionaryRepository>();
  final HistoryRepository _historyRepository = Get.find<HistoryRepository>();

  final RxList<HistoryGroup> groups = <HistoryGroup>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    refresh_();
  }

  Future<void> refresh_() async {
    isLoading.value = true;
    final records = await _historyRepository.getAll();
    final items = <_HistoryItem>[];
    for (final record in records) {
      try {
        final entry = await _dictionaryRepository.fetchDetail(record.headword);
        items.add(_HistoryItem(entry: entry, viewedAt: record.viewedAt));
      } catch (_) {
        // Word can't be resolved right now (offline + not cached) —
        // skip it rather than breaking the whole list.
      }
    }
    groups.value = _groupByDay(items);
    isLoading.value = false;
  }

  List<HistoryGroup> _groupByDay(List<_HistoryItem> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final buckets = <String, List<_HistoryItem>>{};
    for (final item in items) {
      final d = item.viewedAt;
      final day = DateTime(d.year, d.month, d.day);
      final label = day == today
          ? 'Today'
          : day == yesterday
          ? 'Yesterday'
          : '${_monthName(d.month)} ${d.day}';
      buckets.putIfAbsent(label, () => []).add(item);
    }
    return buckets.entries.map((e) => HistoryGroup(label: e.key, items: e.value)).toList();
  }

  String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[month - 1];
  }

  Future<void> clearAll() async {
    await _historyRepository.clearAll();
    groups.clear();
  }

  bool get isEmpty => groups.isEmpty;
}
