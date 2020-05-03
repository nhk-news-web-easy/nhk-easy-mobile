import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:nhk_easy/service/news_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news_detail.dart';

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  final _newsService = NewsService();
  final _newsList = List<News>();
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _loadNewsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('NHK NEWS EASY')),
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
        backgroundImage: NetworkImage(news.imageUrl),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
          return NewsDetail(news: news);
        }));
      },
    );
  }

  _refreshNewsList() {
    var firstNews = _newsList.isEmpty ? null : _newsList.first;
    DateTime newestDate = firstNews == null
        ? DateTime.now().toUtc()
        : DateTime.parse(firstNews.publishedAtUtc).add(new Duration(days: 1));
    DateTime startDate = DateTime.utc(
        newestDate.year, newestDate.month, newestDate.day, 0, 0, 0);
    DateTime endDate = DateTime.utc(
            newestDate.year, newestDate.month, newestDate.day, 23, 59, 59)
        .add(Duration(days: 7));

    _newsService.fetchNewsList(startDate, endDate).then((List<News> newsList) {
      if (newsList.isNotEmpty) {
        setState(() {
          _newsList.insertAll(0, newsList);
        });
      }

      _refreshController.refreshCompleted();
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Network error", gravity: ToastGravity.CENTER);

      _refreshController.refreshFailed();
    });
  }

  _loadNewsList() {
    var lastNews = _newsList.isEmpty ? null : _newsList.last;
    DateTime oldestDate = lastNews == null
        ? DateTime.now().toUtc()
        : DateTime.parse(lastNews.publishedAtUtc)
            .subtract(new Duration(days: 1));
    DateTime startDate =
        DateTime.utc(oldestDate.year, oldestDate.month, oldestDate.day, 0, 0, 0)
            .subtract(new Duration(days: 7));
    DateTime endDate = DateTime.utc(
        oldestDate.year, oldestDate.month, oldestDate.day, 23, 59, 59);

    _newsService.fetchNewsList(startDate, endDate).then((List<News> newsList) {
      if (newsList.isNotEmpty) {
        setState(() {
          _newsList.addAll(newsList);
        });

        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Network error", gravity: ToastGravity.CENTER);

      _refreshController.loadFailed();
    });
  }
}
