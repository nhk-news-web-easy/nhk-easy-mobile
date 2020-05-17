import 'package:nhk_easy/model/config.dart';
import 'package:nhk_easy/service/db_service.dart';
import 'package:sqflite/sqflite.dart';

class ConfigService extends DbService {
  Future<List<Config>> getConfigs() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> rows = await database.query('config');

    return List.generate(rows.length, (i) {
      final row = rows[i];

      return Config(
          id: row['id'],
          newsFetchedStartUtc: row['newsFetchedStartUtc'],
          newsFetchedEndUtc: row['newsFetchedEndUtc']);
    });
  }

  Future<void> addConfig(Config config) async {
    final database = await getDatabase();

    await database.insert('config', config.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
