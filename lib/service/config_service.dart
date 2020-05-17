import 'package:nhk_easy/error_reporter.dart';
import 'package:nhk_easy/model/config.dart';
import 'package:nhk_easy/repository/config_repository.dart';

class ConfigService {
  final _configRepository = ConfigRepository();

  Future<Config> getConfig() async {
    try {
      return await _configRepository.getConfig();
    } catch (error, stackTrace) {
      ErrorReporter.reportError(error, stackTrace);
    }

    return null;
  }
}
