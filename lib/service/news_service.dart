import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nhk_easy/model/news.dart';

class NewsService {
  Future<List<News>> fetchNewsList(DateTime startDate, DateTime endDate) async {
    final response = await http.get(
        'https://nhk.dekiru.app/news?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}');

    if (response.statusCode == 200) {
      var decoder = Utf8Decoder();
      var newsList = List.of(json.decode(decoder.convert(response.bodyBytes)))
          .map((news) => News.fromJson(news))
          .toList();

      newsList.sort((a, b) => -a.publishedAtUtc.compareTo(b.publishedAtUtc));

      return newsList;
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
