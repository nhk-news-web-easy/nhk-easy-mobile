import 'package:nhk_easy/model/news.dart';
import 'package:sembast/sembast.dart';

import 'base_repository.dart';

class NewsRepository extends BaseRepository {
  final _newsStore = stringMapStoreFactory.store('news');

  Future<List<News>> getNews(DateTime startDate, DateTime endDate) async {
    final database = await getDatabase();
    final finder = Finder(
        filter: Filter.and([
      Filter.greaterThanOrEquals(
          'publishedAtEpoch', startDate.millisecondsSinceEpoch),
      Filter.lessThanOrEquals(
          'publishedAtEpoch', endDate.millisecondsSinceEpoch)
    ]));

    final rows = await _newsStore.find(database, finder: finder);

    return rows.map((n) {
      return News.fromJson(n.value);
    }).toList();
  }

  Future<void> saveAll(List<News> news) async {
    final database = await getDatabase();

    await Future.wait(news.map((n) async {
      await _newsStore.record(n.newsId).put(database, n.toMap());
    }));
  }
}
