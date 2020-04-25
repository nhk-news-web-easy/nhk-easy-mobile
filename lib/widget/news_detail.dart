import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatelessWidget {
  final News news;

  NewsDetail({Key key, @required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final html = """
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body>
          <style>
            * {
              font-size: 16px;
            }
            rt {
              font-size: 12px;
            }
          </style>
          ${news.body}
        </body>
      </html>
    """;

    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: WebView(
              initialUrl: Uri.dataFromString(html,
                      mimeType: 'text/html', encoding: utf8)
                  .toString())),
    );
  }
}
