import 'package:nhk_easy/model/config.dart';
import 'package:sembast/sembast.dart';

import 'base_repository.dart';

class ConfigRepository extends BaseRepository {
  final _configStore = intMapStoreFactory.store('config');

  Future<List<Config>> getConfigs() async {
    final database = await getDatabase();
    final snapshots = await _configStore.find(database);

    return snapshots.map((snapshot) {
      return Config.fromJson(snapshot.value);
    }).toList();
  }

  Future<Config> getConfig() async {
    final configs = await getConfigs();

    return (configs != null && configs.length > 0) ? configs.first : null;
  }

  Future<void> save(Config config) async {
    final database = await getDatabase();

    await _configStore.record(config.id).put(database, config.toMap());
  }
}
