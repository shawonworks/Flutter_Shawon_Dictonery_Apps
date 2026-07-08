enum MiniTestQuestionType { synonymMatch, fillBlank }

class IeltsMiniTestQuestion {
  final MiniTestQuestionType type;
  final String prompt;
  final List<String> options;
  final int correctIndex;

  const IeltsMiniTestQuestion({
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}