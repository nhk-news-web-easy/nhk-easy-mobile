import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:nhk_easy/service/cached_news_service.dart';
import 'package:nhk_easy/service/config_service.dart';
import 'package:nhk_easy/widget/settings.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news_detail.dart';

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  final _configService = ConfigService();
  final _cachedNewsService = CachedNewsService();
  final _newsList = List<News>();
  final _refreshController = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('NHK NEWS EASY'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _openSettings,
            )
          ],
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: _refreshNewsList,
          onLoading: _loadNewsList,
          child: ListView.separated(
              itemBuilder: (item, i) {
                return _buildNews(_newsList[i]);
              },
              separatorBuilder: (context, i) => Divider(
                    color: Colors.grey,
                  ),
              itemCount: _newsList.length),
        ));
  }

  Widget _buildNews(News news) {
    return ListTile(
      title: Text(news.title),
      subtitle: Text(DateTime.parse(news.publishedAtUtc).toLocal().toString()),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(news.imageUrl),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
          return NewsDetail(news);
        }));
      },
    );
  }

  _refreshNewsList() async {
    final config = await _configService.getConfig();
    final latestNews = _newsList.isEmpty ? null : _newsList.first;
    final useConfigDate = config != null && latestNews == null;
    DateTime newestDate = latestNews == null
        ? (config != null
                ? DateTime.parse(config.newsFetchedEndUtc)
                : DateTime.now().toUtc())
            .subtract(Duration(days: 7))
        : DateTime.parse(latestNews.publishedAtUtc).add(new Duration(days: 1));
    DateTime startDate = DateTime.utc(
        newestDate.year, newestDate.month, newestDate.day, 0, 0, 0);
    DateTime endDate = useConfigDate
        ? DateTime.parse(config.newsFetchedEndUtc)
        : DateTime.utc(
                newestDate.year, newestDate.month, newestDate.day, 23, 59, 59)
            .add(Duration(days: 7));

    _cachedNewsService
        .fetchNewsList(startDate, endDate)
        .then((List<News> newsList) {
      if (newsList.isNotEmpty) {
        setState(() {
          _newsList.insertAll(0, newsList);
        });
      }

      _refreshController.refreshCompleted();
    }).catchError((error, stackTrace) {
      ErrorReporter.reportError(error, stackTrace);

      Fluttertoast.showToast(
          msg: 'Network error', gravity: ToastGravity.CENTER);

      _refreshController.refreshFailed();
    });
  }

  _loadNewsList() {
    final lastNews = _newsList.isEmpty ? null : _newsList.last;
    DateTime oldestDate = lastNews == null
        ? DateTime.now().toUtc()
        : DateTime.parse(lastNews.publishedAtUtc)
            .subtract(new Duration(days: 1));
    DateTime startDate =
        DateTime.utc(oldestDate.year, oldestDate.month, oldestDate.day, 0, 0, 0)
            .subtract(new Duration(days: 7));
    DateTime endDate = DateTime.utc(
        oldestDate.year, oldestDate.month, oldestDate.day, 23, 59, 59);

    _cachedNewsService
        .fetchNewsList(startDate, endDate)
        .then((List<News> newsList) {
      if (newsList.isNotEmpty) {
        setState(() {
          _newsList.addAll(newsList);
        });

        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }).catchError((error, stackTrace) {
      ErrorReporter.reportError(error, stackTrace);

      Fluttertoast.showToast(
          msg: 'Network error', gravity: ToastGravity.CENTER);

      _refreshController.loadFailed();
    });
  }

  void _openSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Settings();
    }));
  }
}
