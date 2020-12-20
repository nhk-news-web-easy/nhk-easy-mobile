import 'package:sentry/sentry.dart';

class ErrorReporter {
  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    Sentry.captureException(error, stackTrace: stackTrace);
  }
}
