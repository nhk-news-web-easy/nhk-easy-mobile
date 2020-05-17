import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/model/config.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:nhk_easy/repository/config_repository.dart';
import 'package:nhk_easy/repository/news_repository.dart';
import 'package:nhk_easy/service/config_service.dart';
import 'package:nhk_easy/service/news_service.dart';

class CachedNewsService {
  final _configRepository = ConfigRepository();
  final _newsRepository = NewsRepository();
  final _configService = ConfigService();
  final _newsService = NewsService();

  Future<List<News>> fetchNewsList(DateTime startDate, DateTime endDate) async {
    final config = await _configService.getConfig();

    if (config != null && (_newsFetched(config, startDate, endDate))) {
      try {
        return await _newsRepository.getNews(startDate, endDate);
      } catch (error, stackTrace) {
        ErrorReporter.reportError(error, stackTrace);

        return _newsService.fetchNewsList(startDate, endDate);
      }
    } else {
      final news = await _newsService.fetchNewsList(startDate, endDate);

      if (news == null || news.length == 0) {
        return [];
      }

      final newsFetchedStartUtc = news.last.publishedAtUtc;
      final newsFetchedEndUtc = news.first.publishedAtUtc;
      final newConfig =
          _createNewConfig(config, newsFetchedStartUtc, newsFetchedEndUtc);

      try {
        _newsRepository.saveAll(news);
        _configRepository.save(newConfig);
      } catch (error, stackTrace) {
        ErrorReporter.reportError(error, stackTrace);
      }

      return news;
    }
  }

  bool _newsFetched(Config config, DateTime startDate, DateTime endDate) {
    final newsFetchedStartDate = DateTime.parse(config.newsFetchedStartUtc);
    final newsFetchedEndDate = DateTime.parse(config.newsFetchedEndUtc);

    return newsFetchedStartDate.compareTo(startDate) <= 0 &&
        newsFetchedEndDate.compareTo(endDate) >= 0;
  }

  Config _createNewConfig(
      Config config, String newsFetchedStartUtc, String newsFetchedEndUtc) {
    if (config != null) {
      final newsFetchedStartUtcNew = DateTime.parse(newsFetchedStartUtc)
                  .compareTo(DateTime.parse(config.newsFetchedStartUtc)) <=
              0
          ? newsFetchedStartUtc
          : config.newsFetchedStartUtc;
      final newsFetchedEndUtcNew = DateTime.parse(newsFetchedEndUtc)
                  .compareTo(DateTime.parse(config.newsFetchedEndUtc)) >=
              0
          ? newsFetchedEndUtc
          : config.newsFetchedEndUtc;

      return Config(
          id: config.id,
          newsFetchedStartUtc: newsFetchedStartUtcNew,
          newsFetchedEndUtc: newsFetchedEndUtcNew);
    } else {
      return Config(
          id: 1,
          newsFetchedStartUtc: newsFetchedStartUtc,
          newsFetchedEndUtc: newsFetchedEndUtc);
    }
  }
}
