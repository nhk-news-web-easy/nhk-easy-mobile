import 'package:flutter/material.dart';
import 'package:nhk_easy/model/news.dart';

class NewsDetail extends StatelessWidget {
  final News news;

  NewsDetail({Key key, @required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(news.body),
      ),
    );
  }
}
