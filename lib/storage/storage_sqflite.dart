import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../config/database_config.dart';
import 'structured_queries.dart';
import 'database_model.dart';
import './storage_abstract.dart';

class StorageSqflite extends StorageContract {
  /// Construct the [path] for the application database
  Future<String> constructPath() async {
    return join(await getDatabasesPath(), DatabaseConfig.path);
  }

  /// Initalize the database at startup
  Future<Database> init() async {
    return await openDatabase(
      await constructPath(),
      onCreate: (db, version) => _initializeTables(db),
      version: DatabaseConfig.version
    );
  }

  /// Return an open [Database] connection
  Future<Database> open() async {
    return await openDatabase(
      await constructPath(), 
      version: DatabaseConfig.version
    );
  }

  /// Create database schema during [init]
  void _initializeTables(db) {
    StructuredQuery.createTables.forEach((query) {
      db.execute(query);
    });
  }

  /// [Insert] new record into table
  Future<int> insert(DatabaseModel dbModel) async {
    Database db = await open();
    return db.insert(
      dbModel.table,
      dbModel.toMap(),
      conflictAlgorithm: dbModel.insertConflictAlgorithm
    );
  }

  /// [Update] record in table
  Future<void> update(DatabaseModel dbModel) async {
    Database db = await open();
    db.update(
      dbModel.table,
      dbModel.toMap(),
      where: 'id = ?',
      whereArgs: [dbModel.id]
    );
  }

  /// [Find] record by id
  Future<DatabaseModel> find(DatabaseModel dbModel, int id) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );
    return dbModel.fromMap(maps.first);
  }

  /// Get the [first] model from the database, by id
  Future<DatabaseModel> first(DatabaseModel dbModel) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      limit: 1
    );
    return dbModel.fromMap(maps.first);
  }

  /// Get the [last] model from the database, by id
  Future<DatabaseModel> last(DatabaseModel dbModel) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      limit: 1,
      orderBy: 'id DESC'
    );
    return dbModel.fromMap(maps.first);
  }

  /// [Get] from the database [Where] [columns] = [args]
  Future<List<DatabaseModel>> where(DatabaseModel dbModel, Map<String, dynamic> args) async {
    Database db = await open();
    Map<String, dynamic> whereStatements = _buildWhereStatements(args);

    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: whereStatements['where'],
      whereArgs: whereStatements['args']
    );
    return List.generate(maps.length, (index) {
      return dbModel.fromMap(maps[index]);
    });
  }

  /// [Get] from the database the first record [Where] [columns] = [args]
  Future<DatabaseModel> firstWhere(DatabaseModel dbModel, Map<String, dynamic> args) async {
    Database db = await open();
    Map<String, dynamic> whereStatements = _buildWhereStatements(args);
    
    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: whereStatements['where'],
      whereArgs: whereStatements['args'],
      limit: 1
    );
    return dbModel.fromMap(maps.first);
  }

  /// [Get] from the database the last record [Where] [columns] = [args]
  Future<DatabaseModel> lastWhere(DatabaseModel dbModel, Map<String, dynamic> args) async {
    Database db = await open();
    Map<String, dynamic> whereStatements = _buildWhereStatements(args);

    List<Map<String, dynamic>> maps = await db.query(
      dbModel.table,
      where: whereStatements['where'],
      whereArgs: whereStatements['args'],
      limit: 1,
      orderBy: 'id DESC'
    );
    return dbModel.fromMap(maps.first);
  }

  Map<String, dynamic> _buildWhereStatements(Map<String, dynamic> args) {
    String whereQuery = '';
    List<dynamic> whereArgs;
    args.forEach((column, arg) {
      whereQuery += '$column = ?, ';
      whereArgs.add(arg);
    });
    whereQuery = whereQuery.replaceAll(r', $', '');

    return {
      'where': whereQuery,
      'args': whereArgs
    };
  }

  /// Get [all] records from the table
  Future<List<DatabaseModel>> all(DatabaseModel dbModel) async {
    Database db = await open();
    List<Map<String, dynamic>> maps = await db.query(dbModel.table);
    return List.generate(maps.length, (index) {
      return dbModel.fromMap(maps[index]);
    });
  }

  /// [Delete] record from table
  Future<void> delete(DatabaseModel dbModel) async {
    Database db = await open();
    db.delete(
      dbModel.table,
      where: 'id = ?',
      whereArgs: [dbModel.id]
    );
  }
}
