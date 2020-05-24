import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/model/news.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatelessWidget {
  final News news;
  AudioPlayer _audioPlayer;

  NewsDetail({Key key, @required this.news}) : super(key: key) {
    _audioPlayer = AudioPlayer();

    if (_hasAudio()) {
      _audioPlayer.setUrl(news.m3u8Url).catchError((error, stackTrace) {
        ErrorReporter.reportError(error, stackTrace);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasAudio()) {
          try {
            await _audioPlayer.dispose();
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
          child: WebView(
              initialUrl: Uri.dataFromString(_buildHtml(news),
                      mimeType: 'text/html', encoding: utf8)
                  .toString()),
        ),
        floatingActionButton: _hasAudio()
            ? FloatingActionButton(
                onPressed: () async {
                  if (_audioPlayer.playbackState ==
                          AudioPlaybackState.stopped ||
                      _audioPlayer.playbackState == AudioPlaybackState.paused) {
                    _audioPlayer.play().catchError((error, stackTrace) {
                      ErrorReporter.reportError(error, stackTrace);
                    });
                  } else if (_audioPlayer.playbackState ==
                      AudioPlaybackState.playing) {
                    _audioPlayer.pause().catchError((error, stackTrace) {
                      ErrorReporter.reportError(error, stackTrace);
                    });
                  }
                },
                child: _audioPlayer.playbackState == AudioPlaybackState.playing
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow))
            : Container(),
      ),
    );
  }

  _buildHtml(News news) {
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
            rt {
              font-size: 12px;
            }
            img {
              max-width: 100%;
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
    return news.m3u8Url != null && news.m3u8Url != '';
  }
}
