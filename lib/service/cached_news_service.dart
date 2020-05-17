import 'package:nhk_easy/model/news.dart';
import 'package:nhk_easy/repository/news_repository.dart';
import 'package:nhk_easy/service/news_service.dart';

class CachedNewsService {
  final _newsRepository = NewsRepository();
  final _newsService = NewsService();

  Future<List<News>> fetchNewsList(DateTime startDate, DateTime endDate) async {
    return _newsService.fetchNewsList(startDate, endDate);
  }
}
