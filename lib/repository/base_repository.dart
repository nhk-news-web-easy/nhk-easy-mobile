import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseRepository {
  Future<Database> getDatabase() async {
    String databasePath = await _getDatabasePath();
    Future<Database> database = openDatabase(
      databasePath,
      onCreate: (db, version) {
        _executeScript(db);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        _executeScript(db);
      },
      version: 3,
    );

    return database;
  }

  Future<void> dropDatabase() async {
    String databasePath = await _getDatabasePath();

    await deleteDatabase(databasePath);
  }

  Future<String> _getDatabasePath() async {
    String databasePath = await getDatabasesPath();

    return join(databasePath, 'nhk-easy.db');
  }

  void _executeScript(Database db) {
    final batch = db.batch();
    batch.execute(
        'CREATE TABLE IF NOT EXISTS config(id INTEGER PRIMARY KEY, newsFetchedStartUtc TEXT, newsFetchedEndUtc TEXT)');
    batch.execute(
        'CREATE TABLE IF NOT EXISTS news(newsId TEXT PRIMARY KEY, title TEXT, titleWithRuby TEXT, body TEXT, imageUrl TEXT, publishedAtUtc TEXT, publishedAtEpoch INTEGER)');

    batch.commit();
  }
}
