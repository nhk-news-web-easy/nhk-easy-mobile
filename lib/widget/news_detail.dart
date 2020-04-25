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
          padding: EdgeInsets.all(16.0),
          child: WebView(
              initialUrl: Uri.dataFromString(_buildHtml(news),
                      mimeType: 'text/html', encoding: utf8)
                  .toString()),
        ));
  }

  _buildHtml(News news) {
    final image = news.imageUrl != "" ? "<img src=${news.imageUrl} />" : "";

    return """
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
            img {
              max-width: 100%;
            }
          </style>
          $image
          ${news.body}
        </body>
      </html>
    """;
  }
}
