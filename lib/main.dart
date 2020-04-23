import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class NewsListState extends State<NewsList> {
  final _newsList = List<News>();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('NHK NEWS EASY')), body: _buildNewsList());
  }

  Widget _buildNewsList() {
    return ListView.builder(
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
    );
  }

  Widget _buildNews(News news) {
    return ListTile(title: Text(news.title));
  }

  Future<List<News>> _fetchNewsList() async {
    final response = await http.get(
        "https://nhk.dekiru.app/news?startDate=2020-04-01T02:30:00.000Z&endDate=2020-04-30T02:30:00.000Z");

    if (response.statusCode == 200) {
      var decoder = Utf8Decoder();
      var newsList = List.of(json.decode(decoder.convert(response.bodyBytes)));

      return newsList.map((news) => News.fromJson(news)).toList();
    } else {
      throw Exception("Failed to fetch news");
    }
  }

  _loadNewsList() {
    _isLoading = true;

    _fetchNewsList().then((List<News> newsList) {
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

class NewsList extends StatefulWidget {
  @override
  NewsListState createState() => NewsListState();
}
