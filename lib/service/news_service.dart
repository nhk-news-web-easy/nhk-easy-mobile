import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nhk_easy/model/news.dart';

class NewsService {
  Future<List<News>> fetchNewsList() async {
    final response = await http.get(
        'https://nhk.dekiru.app/news?startDate=2020-04-01T02:30:00.000Z&endDate=2020-04-30T02:30:00.000Z');

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
