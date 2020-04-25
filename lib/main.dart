import 'package:flutter/material.dart';
import 'package:nhk_easy/service/news_service.dart';

import 'model/news.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NHK NEWS EASY',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: NewsList(),
    );
  }
}

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
      leading: CircleAvatar(
        backgroundImage: NetworkImage(news.imageUrl),
      ),
    );
  }

  _loadNewsList() {
    _isLoading = true;

    _newsService.fetchNewsList().then((List<News> newsList) {
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
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
