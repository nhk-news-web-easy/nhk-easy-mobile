import 'dart:async';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/widget/news_list.dart';
import 'package:sentry/sentry.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalConfiguration().loadFromAsset('config');
  await Sentry.init(
    (options) {
      options.dsn = GlobalConfiguration().getValue('sentryDsn');
    },
  );

  runZoned<Future<void>>(() async {
    runApp(NhkNewsEasy());
  }, onError: (error, stackTrace) {
    _reportError(error, stackTrace);
  });

  FlutterError.onError = (details, {bool forceReport = false}) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  if (isInDebugMode) {
    print(stackTrace);
  } else {
    ErrorReporter.reportError(error, stackTrace);
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;

  assert(inDebugMode = true);

  return inDebugMode;
}

class NhkNewsEasy extends StatelessWidget {
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
