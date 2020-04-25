import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          child: WebView(
              initialUrl: Uri.dataFromString(news.body,
                      mimeType: 'text/html', encoding: utf8)
                  .toString())),
    );
  }
}
