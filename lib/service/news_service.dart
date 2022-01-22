import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nhk_easy/model/news.dart';

class NewsService {
  Future<List<News>> fetchNewsList(DateTime startDate, DateTime endDate) async {
    final uri = Uri(
        scheme: 'https',
        host: 'nhk.dekiru.app',
        path: 'news',
        queryParameters: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String()
        });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoder = Utf8Decoder();
      final newsList = List.of(json.decode(decoder.convert(response.bodyBytes)))
          .map((news) => News.fromJson(news))
          .toList();

      newsList.sort((a, b) => -a.publishedAtUtc.compareTo(b.publishedAtUtc));

      return newsList;
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
