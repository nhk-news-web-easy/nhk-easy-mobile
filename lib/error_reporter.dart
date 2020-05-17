import 'package:global_configuration/global_configuration.dart';
import 'package:sentry/sentry.dart';

class ErrorReporter {
  static final SentryClient _sentryClient =
      SentryClient(dsn: GlobalConfiguration().getString('sentryDsn'));

  static Future<Null> reportError(dynamic error, dynamic stackTrace) async {
    final SentryResponse response = await _sentryClient.captureException(
      exception: error,
      stackTrace: stackTrace,
    );

    if (response.isSuccessful) {
      print('Success! Event ID: ${response.eventId}');
    } else {
      print('Failed to report to Sentry.io: ${response.error}');
    }
  }
}
