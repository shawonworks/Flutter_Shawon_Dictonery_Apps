import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../modules/ielts/hub/views/ielts_paraphrase_exercise.dart';
class IeltsParaphraseRepository {
  List<IeltsParaphraseExercise>? _exercises;

  Future<List<IeltsParaphraseExercise>> all() async {
    if (_exercises != null) return _exercises!;
    final raw = await rootBundle.loadString('assets/data/ielts_paraphrase_bank.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _exercises = (decoded['exercises'] as List)
        .map((e) => IeltsParaphraseExercise.fromJson(e as Map<String, dynamic>))
        .toList();
    return _exercises!;
  }
}