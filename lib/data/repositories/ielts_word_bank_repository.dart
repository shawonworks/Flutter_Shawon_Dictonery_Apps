import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../modules/ielts_topic/ielts_topic.dart';
import '../../modules/ielts_topic/views/ielts_word_entry.dart';

class IeltsWordBankRepository {
  List<IeltsTopic>? _topics;
  List<IeltsWordEntry>? _words;

  Future<void> _ensureLoaded() async {
    if (_topics != null && _words != null) return;
    final raw = await rootBundle.loadString('assets/data/ielts_word_bank.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _topics = (decoded['topics'] as List).map((e) => IeltsTopic.fromJson(e as Map<String, dynamic>)).toList();
    _words = (decoded['words'] as List).map((e) => IeltsWordEntry.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<IeltsTopic>> topics() async {
    await _ensureLoaded();
    return _topics!;
  }

  Future<List<IeltsWordEntry>> wordsForTopic(String topicId) async {
    await _ensureLoaded();
    return _words!.where((w) => w.topicId == topicId).toList();
  }

  Future<List<IeltsWordEntry>> highFrequencyWords() async {
    await _ensureLoaded();
    return _words!.where((w) => w.highFrequency).toList();
  }

  Future<int> wordCountForTopic(String topicId) async {
    await _ensureLoaded();
    return _words!.where((w) => w.topicId == topicId).length;
  }

  Future<List<IeltsWordEntry>> allWords() async {
    await _ensureLoaded();
    return _words!;
  }
}