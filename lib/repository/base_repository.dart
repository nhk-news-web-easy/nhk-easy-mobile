import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BaseRepository {
  Future<Database> getDatabase() async {
    String databasePath = await getDatabasesPath();
    Future<Database> database = openDatabase(
      join(databasePath, 'nhk-easy.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE config(id INTEGER PRIMARY KEY, newsFetchedStartUtc TEXT, newsFetchedEndUtc TEXT);
          CREATE TABLE news(newsId TEXT PRIMARY KEY, title TEXT, titleWithRuby TEXT, body TEXT, imageUrl TEXT, publishedAtUtc TEXT);
          ''',
        );
      },
      version: 1,
    );

    return database;
  }
}
