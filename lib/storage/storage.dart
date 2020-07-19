import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

export 'package:sqflite/sqflite.dart';
export './dog.dart';

class Storage {
  Future<bool> init() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dogs_list.db');
    _database = await openDatabase(
      path,
      onCreate: (db, version) => db.execute('CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)'),
      version: 1
    );
    _isDatabaseReady = true;
    return isDatabaseReady;
  }

  Database _database;
  Database get database => _database;
  bool _isDatabaseReady = false;
  bool get isDatabaseReady => _isDatabaseReady;
}
