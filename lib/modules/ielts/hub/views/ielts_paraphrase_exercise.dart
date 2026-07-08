class IeltsParaphraseExercise {
  final String id;
  final String topic;
  final String original;
  final String targetWord;
  final List<String> hintSynonyms;
  final String sampleParaphrase;

  const IeltsParaphraseExercise({
    required this.id,
    required this.topic,
    required this.original,
    required this.targetWord,
    required this.hintSynonyms,
    required this.sampleParaphrase,
  });

  factory IeltsParaphraseExercise.fromJson(Map<String, dynamic> json) {
    return IeltsParaphraseExercise(
      id: json['id'] as String,
      topic: json['topic'] as String,
      original: json['original'] as String,
      targetWord: json['targetWord'] as String,
      hintSynonyms: (json['hintSynonyms'] as List).map((e) => e as String).toList(),
      sampleParaphrase: json['sampleParaphrase'] as String,
    );
  }
}