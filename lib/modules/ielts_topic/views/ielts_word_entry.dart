import '../../../data/models/meaning.dart';

class IeltsWordEntry {
  final String headword;
  final PartOfSpeech partOfSpeech;
  final String topicId;
  final String bnMeaning;
  final String definition;
  final String example;
  final List<String> synonyms;
  final List<String> antonyms;
  final bool highFrequency;

  const IeltsWordEntry({
    required this.headword,
    required this.partOfSpeech,
    required this.topicId,
    required this.bnMeaning,
    required this.definition,
    required this.example,
    this.synonyms = const [],
    this.antonyms = const [],
    this.highFrequency = false,
  });

  factory IeltsWordEntry.fromJson(Map<String, dynamic> json) {
    return IeltsWordEntry(
      headword: json['headword'] as String,
      partOfSpeech: partOfSpeechFromString(json['pos'] as String),
      topicId: json['topic'] as String,
      bnMeaning: json['bnMeaning'] as String,
      definition: json['definition'] as String,
      example: json['example'] as String,
      synonyms: (json['synonyms'] as List?)?.map((e) => e as String).toList() ?? const [],
      antonyms: (json['antonyms'] as List?)?.map((e) => e as String).toList() ?? const [],
      highFrequency: json['highFrequency'] as bool? ?? false,
    );
  }
}