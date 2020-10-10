import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class BaseRepository {
  Future<Database> getDatabase() async {
    final databasePath = await _getDatabasePath();
    final databaseFactory = databaseFactoryIo;

    return await databaseFactory.openDatabase(databasePath);
  }

  Future<void> dropDatabase() async {
    final databasePath = await _getDatabasePath();
    final fileType = await FileSystemEntity.type(databasePath);

    if (fileType == FileSystemEntityType.notFound) {
      return;
    }

    final file = File(databasePath);

    await file.delete();
  }

  Future<String> _getDatabasePath() async {
    final documentDirectory = await getApplicationDocumentsDirectory();

    return join(documentDirectory.path, 'nhk.db');
  }
}
