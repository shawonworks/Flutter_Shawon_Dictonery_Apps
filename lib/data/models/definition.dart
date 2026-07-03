class Definition {
  final String text;
  final String? example;

  /// Bangla translation of [text]. Null until translated (lazy, cached).
  final String? bnText;

  const Definition({required this.text, this.example, this.bnText});

  Definition copyWith({String? bnText}) =>
      Definition(text: text, example: example, bnText: bnText ?? this.bnText);

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      text: json['text'] as String,
      example: json['example'] as String?,
      bnText: json['bnText'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'example': example, 'bnText': bnText};
}
