import 'package:flutter/material.dart';
import 'package:nhk_easy/widget/news_list.dart';

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
