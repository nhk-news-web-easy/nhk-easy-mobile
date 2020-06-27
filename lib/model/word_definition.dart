class WordDefinition {
  String definition;

  String definitionWithRuby;

  WordDefinition();

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    final wordDefinition = WordDefinition();
    wordDefinition.definition = json['definition'];
    wordDefinition.definitionWithRuby = json['definitionWithRuby'];

    return wordDefinition;
  }
}
