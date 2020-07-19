import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../config/database_config.dart';
import './structured_queries.dart';
import './database_model.dart';

export 'package:sqflite/sqflite.dart';
export './dog.dart';

class Storage {
  // Future<bool> init() async {
  //   String databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, 'dogs_list.db');
  //   _database = await openDatabase(
  //     path,
  //     onCreate: (db, version) => db.execute('CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)'),
  //     version: 1
  //   );
  //   _isDatabaseReady = true;
  //   return isDatabaseReady;
  // }

  // Database _database;
  // Database get database => _database;
  // bool _isDatabaseReady = false;
  // bool get isDatabaseReady => _isDatabaseReady;

  /// Initalize the database at startup
  static Future<Database> init() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DatabaseConfig.path);
    return await openDatabase(
      path,
      onCreate: (db, version) => _initializeTables(db),
      version: DatabaseConfig.version
    );
  }

  /// Return an open [Database] connection
  static Future<Database> open() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DatabaseConfig.path);
    return await openDatabase(path, version: DatabaseConfig.version);
  }

  /// Create database schema during [init]
  static void _initializeTables(db) {
    StructuredQuery.createTables.forEach((query) {
      db.execute(query);
    });
  }

  /// [Insert] new record into table
  static Future<int> insert(DatabaseModel dbModel) async {
    Database db = await Storage.open();
    return db.insert(
      dbModel.table,
      dbModel.toMap(),
      conflictAlgorithm: dbModel.insertConflictAlgorithm
    );
  }

  /// [Update] record in table
  static Future<void> update(DatabaseModel dbModel) async {
    Database db = await Storage.open();
    db.update(
      dbModel.table,
      dbModel.toMap(),
      where: 'id = ?',
      whereArgs: [dbModel.id]
    );
  }

  /// [Find] record by id
  static Future<DatabaseModel> find(DatabaseModel dbModel, int id) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );
    return dbModel.fromMap(maps.first);
  }

  /// Get the [first] model from the database, by id
  static Future<DatabaseModel> first(DatabaseModel dbModel) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      limit: 1
    );
    return dbModel.fromMap(maps.first);
  }

  /// Get the [last] model from the database, by id
  static Future<DatabaseModel> last(DatabaseModel dbModel) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      limit: 1,
      orderBy: 'id DESC'
    );
    return dbModel.fromMap(maps.first);
  }

  /// [Get] from the database [Where] [columns] = [args]
  static Future<List<DatabaseModel>> where(DatabaseModel dbModel, List<String> columns, List<dynamic> args) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: columns.join(', '),
      whereArgs: args
    );
    return List.generate(maps.length, (index) {
      return dbModel.fromMap(maps[index]);
    });
  }

  /// [Get] from the database the first record [Where] [columns] = [args]
  static Future<DatabaseModel> firstWhere(DatabaseModel dbModel, List<String> columns, List<dynamic> args) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: columns.join(', '),
      whereArgs: args,
      limit: 1
    );
    return dbModel.fromMap(maps.first);
  }

  /// [Get] from the database the last record [Where] [columns] = [args]
  static Future<DatabaseModel> lastWhere(DatabaseModel dbModel, List<String> columns, List<dynamic> args) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: columns.join(', '),
      whereArgs: args,
      limit: 1,
      orderBy: 'id DESC'
    );
    return dbModel.fromMap(maps.first);
  }

  /// Get [all] records from the table
  static Future<List<DatabaseModel>> all(DatabaseModel dbModel) async {
    Database db = await Storage.open();
    List<Map<String, dynamic>> maps = await db.query(dbModel.table);
    return List.generate(maps.length, (index) {
      return dbModel.newFromMap(maps[index]);
    });
  }

  /// [Delete] record from table
  static Future<void> delete(DatabaseModel dbModel) async {
    Database db = await Storage.open();
    db.delete(
      dbModel.table,
      where: 'id = ?',
      whereArgs: [dbModel.id]
    );
  }
}
