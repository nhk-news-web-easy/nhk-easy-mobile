import 'package:nhk_easy/model/news.dart';

import 'base_repository.dart';

class NewsRepository extends BaseRepository {
  Future<List<News>> getNews(String startDate, String endDate) async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> rows = await database.rawQuery(
        'select * from news where publishedAtUtc >= ? and publishedAtUtc <= ?',
        [startDate, endDate]);

    return List.generate(rows.length, (i) {
      final row = rows[i];
      final news = News();
      news.newsId = row['newsId'];
      news.title = row['title'];
      news.titleWithRuby = row['titleWithRuby'];
      news.body = row['body'];
      news.imageUrl = row['imageUrl'];
      news.publishedAtUtc = row['publishedAtUtc'];

      return news;
    });
  }
}
