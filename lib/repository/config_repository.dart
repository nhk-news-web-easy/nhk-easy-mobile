import 'package:nhk_easy/model/config.dart';
import 'package:sqflite/sqflite.dart';

import 'base_repository.dart';

class ConfigRepository extends BaseRepository {
  Future<List<Config>> getConfigs() async {
    final database = await getDatabase();
    final rows = await database.query('config');

    return List.generate(rows.length, (i) {
      final row = rows[i];

      return Config(
          id: row['id'],
          newsFetchedStartUtc: row['newsFetchedStartUtc'],
          newsFetchedEndUtc: row['newsFetchedEndUtc']);
    });
  }

  Future<Config> getConfig() async {
    final configs = await getConfigs();

    return (configs != null && configs.length > 0) ? configs.first : null;
  }

  Future<void> save(Config config) async {
    final database = await getDatabase();

    await database.insert('config', config.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
