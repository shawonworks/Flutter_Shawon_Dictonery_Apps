import 'dart:math';
import '../../modules/ielts/hub/views/ielts_mini_test_question.dart';
import '../../modules/ielts_topic/views/ielts_word_entry.dart';

class IeltsMiniTestGenerator {
  IeltsMiniTestGenerator._();

  static List<IeltsMiniTestQuestion> generate(List<IeltsWordEntry> pool, {int count = 10}) {
    final eligible = pool.where((w) => w.synonyms.isNotEmpty).toList();
    if (eligible.length < 4) return const [];

    final rnd = Random();
    final shuffled = List<IeltsWordEntry>.of(eligible)..shuffle(rnd);
    final selected = shuffled.take(count).toList();

    final questions = <IeltsMiniTestQuestion>[];
    for (final entry in selected) {
      final canFillBlank = _containsWholeWord(entry.example, entry.headword);
      final useFillBlank = canFillBlank && rnd.nextBool();
      questions.add(
        useFillBlank ? _buildFillBlank(entry, pool, rnd) : _buildSynonymMatch(entry, pool, rnd),
      );
    }
    questions.shuffle(rnd);
    return questions;
  }

  static bool _containsWholeWord(String text, String word) {
    final pattern = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
    return pattern.hasMatch(text);
  }

  static IeltsMiniTestQuestion _buildSynonymMatch(IeltsWordEntry entry, List<IeltsWordEntry> pool, Random rnd) {
    final correct = entry.synonyms.first;
    final distractors = <String>{};
    final shuffledPool = List<IeltsWordEntry>.of(pool)..shuffle(rnd);
    for (final other in shuffledPool) {
      if (other.headword == entry.headword || other.synonyms.isEmpty) continue;
      final candidate = other.synonyms.first;
      if (candidate.toLowerCase() == correct.toLowerCase()) continue;
      distractors.add(candidate);
      if (distractors.length == 3) break;
    }
    final options = [correct, ...distractors]..shuffle(rnd);
    return IeltsMiniTestQuestion(
      type: MiniTestQuestionType.synonymMatch,
      prompt: "Which word is closest in meaning to '${entry.headword}'?",
      options: options,
      correctIndex: options.indexOf(correct),
    );
  }

  static IeltsMiniTestQuestion _buildFillBlank(IeltsWordEntry entry, List<IeltsWordEntry> pool, Random rnd) {
    final pattern = RegExp(r'\b' + RegExp.escape(entry.headword) + r'\b', caseSensitive: false);
    final blanked = entry.example.replaceFirst(pattern, '_____');

    final distractors = <String>{};
    final shuffledPool = List<IeltsWordEntry>.of(pool)..shuffle(rnd);
    for (final other in shuffledPool) {
      if (other.headword.toLowerCase() == entry.headword.toLowerCase()) continue;
      distractors.add(other.headword);
      if (distractors.length == 3) break;
    }
    final options = [entry.headword, ...distractors]..shuffle(rnd);
    return IeltsMiniTestQuestion(
      type: MiniTestQuestionType.fillBlank,
      prompt: blanked,
      options: options,
      correctIndex: options.indexOf(entry.headword),
    );
  }
}