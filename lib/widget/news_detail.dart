import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:nhk_easy/model/word.dart';
import 'package:nhk_easy/service/word_service.dart';

class NewsDetail extends StatefulWidget {
  final News news;

  const NewsDetail(this.news);

  @override
  NewsDetailState createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail> {
  News? _news;
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;
  bool _showDictionary = false;
  Word? _currentWord;
  List<Word> _words = [];
  WordService _wordService = WordService();

  @override
  void initState() {
    super.initState();

    this._news = widget.news;
    _audioPlayer = AudioPlayer();

    if (_hasAudio()) {
      _audioPlayer?.setUrl(_news!.m3u8Url).catchError((error, stackTrace) {
        ErrorReporter.reportError(error, stackTrace);
      });
    }

    _wordService
        .fetchWordList(this._news!.newsId)
        .then((words) => this._words = words)
        .catchError((error, stackTrace) {
      ErrorReporter.reportError(error, stackTrace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasAudio()) {
          try {
            await _audioPlayer?.dispose();
          } catch (error, stackTrace) {
            ErrorReporter.reportError(error, stackTrace);
          }
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('NHK NEWS EASY'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              _buildNewsBody(),
              Container(
                child: _showDictionary ? _buildDictionary() : Container(),
              )
            ],
          ),
        ),
        floatingActionButton: _hasAudio() ? _buildAudioPlayer() : Container(),
      ),
    );
  }

  _buildNewsHtml(News news) {
    final image = news.imageUrl != '' ? '<img src=${news.imageUrl} />' : '';

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
            h1 {
              font-size: 20px;
            }
            rt {
              font-size: 12px;
            }
            img {
              max-width: 100%;
            }
            .under {
              text-decoration-line: underline;
              -webkit-text-decoration-line: underline;
              text-decoration-color: #ff7f00;
              -webkit-text-decoration-color: #ff7f00;
            }
          </style>
          $image
          <h1>${news.titleWithRuby}</h1>
          ${news.body}
        </body>
      </html>
    """;
  }

  bool _hasAudio() {
    return _news?.m3u8Url != null && _news?.m3u8Url != '';
  }

  Widget _buildNewsBody() {
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.dataFromString(_buildNewsHtml(_news!),
              mimeType: 'text/html', encoding: utf8)),
      onWebViewCreated: (InAppWebViewController inAppWebViewController) {
        inAppWebViewController.addJavaScriptHandler(
            handlerName: 'lookup',
            callback: (args) {
              String wordId = args.length > 0 ? args[0] : null;
              Word word =
                  _words.firstWhere((word) => 'id-${word.idInNews}' == wordId);

              if (word != null) {
                setState(() {
                  _currentWord = word;
                  _showDictionary = true;
                });
              }
            });
      },
      onLoadStop: (InAppWebViewController inAppWebViewController, Uri? url) {
        inAppWebViewController.injectJavascriptFileFromAsset(
            assetFilePath: 'assets/js/news-detail.js');
      },
      onConsoleMessage: (InAppWebViewController inAppWebViewController,
          ConsoleMessage consoleMessage) {
        print(consoleMessage.message);

        if (consoleMessage.messageLevel == ConsoleMessageLevel.ERROR) {
          ErrorReporter.reportError(consoleMessage.message, null);
        }
      },
    );
  }

  Widget _buildDictionary() {
    return Center(
      child: Card(
          child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildWordDefinitions(_currentWord),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    setState(() {
                      _currentWord = null;
                      _showDictionary = false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildWordDefinitions(Word? word) {
    if (word == null) {
      return Container();
    }

    final definitions = word.definitions
        .asMap()
        .entries
        .map((entry) => Text(
              '${entry.key + 1}. ${entry.value.definition}',
              style: TextStyle(fontSize: 16),
            ))
        .toList();

    List<Widget> columns = [];
    columns.add(Text(
      word.name,
      style: TextStyle(fontSize: 18),
    ));
    columns.addAll(definitions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns,
    );
  }

  Widget _buildAudioPlayer() {
    return FloatingActionButton(
        onPressed: () async {
          if (_audioPlayer?.playing ?? false) {
            _audioPlayer?.pause().catchError((error, stackTrace) {
              ErrorReporter.reportError(error, stackTrace);
            });
          } else {
            _audioPlayer?.play().catchError((error, stackTrace) {
              ErrorReporter.reportError(error, stackTrace);
            });
          }

          setState(() {
            _isPlaying = _audioPlayer?.playing ?? false;
          });
        },
        child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow));
  }
}
