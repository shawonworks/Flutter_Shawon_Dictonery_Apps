import 'definition.dart';

enum PartOfSpeech { noun, verb, adjective, adverb, other }

PartOfSpeech partOfSpeechFromString(String value) {
  switch (value.toLowerCase()) {
    case 'noun':
      return PartOfSpeech.noun;
    case 'verb':
      return PartOfSpeech.verb;
    case 'adjective':
      return PartOfSpeech.adjective;
    case 'adverb':
      return PartOfSpeech.adverb;
    default:
      return PartOfSpeech.other;
  }
}

String partOfSpeechToString(PartOfSpeech pos) => pos.name;

String partOfSpeechShortCode(PartOfSpeech pos) {
  switch (pos) {
    case PartOfSpeech.noun:
      return 'n';
    case PartOfSpeech.verb:
      return 'v';
    case PartOfSpeech.adjective:
      return 'adj';
    case PartOfSpeech.adverb:
      return 'adv';
    case PartOfSpeech.other:
      return '';
  }
}


class Meaning {
  final PartOfSpeech partOfSpeech;
  final List<Definition> definitions;

  const Meaning({required this.partOfSpeech, required this.definitions});

  Meaning copyWith({List<Definition>? definitions}) =>
      Meaning(partOfSpeech: partOfSpeech, definitions: definitions ?? this.definitions);

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: partOfSpeechFromString(json['partOfSpeech'] as String),
      definitions: (json['definitions'] as List)
          .map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'partOfSpeech': partOfSpeechToString(partOfSpeech),
    'definitions': definitions.map((d) => d.toJson()).toList(),
  };
}
