import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:nhk_easy/service/news_service.dart';

import 'news_detail.dart';

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}

class NewsListState extends State<NewsList> {
  final _newsService = NewsService();
  final _newsList = List<News>();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('NHK NEWS EASY')), body: _buildNewsList());
  }

  Widget _buildNewsList() {
    return ListView.separated(
      itemCount: _hasMore ? _newsList.length + 1 : _newsList.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i >= _newsList.length) {
          if (!_isLoading) {
            _loadNewsList();
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return _buildNews(_newsList[i]);
      },
      separatorBuilder: (context, i) => Divider(
        color: Colors.grey,
      ),
    );
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

  _loadNewsList() {
    _isLoading = true;

    var lastNews = _newsList.isEmpty ? null : _newsList.last;
    DateTime prevDate = lastNews == null
        ? DateTime.now().toUtc()
        : DateTime.parse(lastNews.publishedAtUtc)
            .subtract(new Duration(days: 1));
    DateTime startDate =
        DateTime.utc(prevDate.year, prevDate.month, prevDate.day, 0, 0, 0)
            .subtract(new Duration(days: 7));
    DateTime endDate =
        DateTime.utc(prevDate.year, prevDate.month, prevDate.day, 23, 59, 59);

    _newsService.fetchNewsList(startDate, endDate).then((List<News> newsList) {
      if (newsList.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          _newsList.addAll(newsList);
        });
      }
    }).catchError((error) {
      setState(() {
        _hasMore = false;
      });

      Fluttertoast.showToast(
          msg: "Network error", gravity: ToastGravity.CENTER);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
