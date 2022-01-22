import 'package:nhk_easy/model/word_definition.dart';

class Word {
  String idInNews = '';

  String name = '';

  List<WordDefinition> definitions = [];

  Word();

  factory Word.fromJson(Map<String, dynamic> json) {
    final word = Word();
    word.idInNews = json['idInNews'];
    word.name = json['name'];
    word.definitions = new List<WordDefinition>.from(
        json['definitions'].map((x) => WordDefinition.fromJson(x)));

    return word;
  }
}
