import 'meaning.dart';

class WordEntry {
  final String headword;
  final String phonetic;
  final List<Meaning> meanings;
  final List<String> synonyms;
  final List<String> antonyms;
  final List<String> relatedForms;
  final String? audioUrl;

  /// Bangla translation of the headword. Null until translated (lazy, cached).
  final String? bnHeadword;

  const WordEntry({
    required this.headword,
    required this.phonetic,
    required this.meanings,
    this.synonyms = const [],
    this.antonyms = const [],
    this.relatedForms = const [],
    this.audioUrl,
    this.bnHeadword,
  });

  /// First definition text, used for previews (search rows, share text).
  String get previewDefinition {
    if (meanings.isEmpty || meanings.first.definitions.isEmpty) return '';
    return meanings.first.definitions.first.text;
  }

  PartOfSpeech get primaryPartOfSpeech =>
      meanings.isNotEmpty ? meanings.first.partOfSpeech : PartOfSpeech.other;

  bool get isTranslated => bnHeadword != null;

  WordEntry copyWith({List<Meaning>? meanings, String? bnHeadword}) => WordEntry(
    headword: headword,
    phonetic: phonetic,
    meanings: meanings ?? this.meanings,
    synonyms: synonyms,
    antonyms: antonyms,
    relatedForms: relatedForms,
    audioUrl: audioUrl,
    bnHeadword: bnHeadword ?? this.bnHeadword,
  );

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      headword: json['headword'] as String,
      phonetic: json['phonetic'] as String? ?? '',
      meanings: (json['meanings'] as List)
          .map((e) => Meaning.fromJson(e as Map<String, dynamic>))
          .toList(),
      synonyms: (json['synonyms'] as List?)?.map((e) => e as String).toList() ?? const [],
      antonyms: (json['antonyms'] as List?)?.map((e) => e as String).toList() ?? const [],
      relatedForms: (json['relatedForms'] as List?)?.map((e) => e as String).toList() ?? const [],
      audioUrl: json['audioUrl'] as String?,
      bnHeadword: json['bnHeadword'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'headword': headword,
    'phonetic': phonetic,
    'meanings': meanings.map((m) => m.toJson()).toList(),
    'synonyms': synonyms,
    'antonyms': antonyms,
    'relatedForms': relatedForms,
    'audioUrl': audioUrl,
    'bnHeadword': bnHeadword,
  };
}
