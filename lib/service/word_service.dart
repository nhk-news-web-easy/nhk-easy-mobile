import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nhk_easy/model/word.dart';

class WordService {
  Future<List<Word>> fetchWordList(String newsId) async {
    final uri = Uri(
        scheme: 'https',
        host: 'nhk.dekiru.app',
        path: 'words',
        queryParameters: {'newsId': newsId});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoder = Utf8Decoder();
      final wordList = List.of(json.decode(decoder.convert(response.bodyBytes)))
          .map((news) => Word.fromJson(news))
          .toList();

      return wordList;
    } else {
      throw Exception('Failed to fetch words');
    }
  }
}
