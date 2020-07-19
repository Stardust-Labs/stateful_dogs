import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../config/database_config.dart';
import './database_model.dart';

export 'dog.dart';

class Storage {
  /// Construct the [path] for the application database
  static Future<String> constructPath() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return join(dir.path, DatabaseConfig.path);
  }

  /// Initialize the database at startup
  static Future<Database> init() async {
    return open();
  }

  /// Return an open [Database] connection
  static Future<Database> open() async {
    return await databaseFactoryIo.openDatabase(await constructPath());
  }

  /// [Insert] new record into table
  static Future<int> insert (DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    // Check unique constraints
    if (dbModel.uniqueConstraints.length > 0) {
      Map<String, dynamic> queryParams = dbModel.toMap();
      List<dynamic> args = List.generate(dbModel.uniqueConstraints.length, (index) {
        return queryParams[dbModel.uniqueConstraints[index]];
      });
      DatabaseModel uniqueCheck = await firstWhere(dbModel, dbModel.uniqueConstraints, args);
      if (uniqueCheck != null) {
        return null;
      }
    }

    int id;
    await db.transaction((txn) async {
      id = await store.add(txn, dbModel.toMap());
    });
    return id;
  }

  /// [Update] record in table
  static Future<void> update(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();
    await store.record(dbModel.id).update(db, dbModel.toMap());
  }

  /// [Find] record by id
  static Future<DatabaseModel> find(DatabaseModel dbModel, int id) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    Map<String, dynamic> map = Map.from(await store.record(id).get(db));
    if (map == null) return null;

    map['id'] = id;
    return dbModel.fromMap(map);
  }

  /// Get the [first] model from the store, by id
  static Future<DatabaseModel> first(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    var record = await store.findFirst(db);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(map);
  }

  /// Get the [last] model from the store, by id
  static Future<DatabaseModel> last(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();
    Finder finder = Finder(sortOrders: [SortOrder(Field.key, false)]);

    var record = await store.findFirst(db, finder: finder);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(map);
  }

  /// Get from the database where [columns] = [args]
  static Future<List<DatabaseModel>> where(DatabaseModel dbModel, List<String> columns, List<dynamic> args) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    List<Filter> filters = List.generate(columns.length, (index) {
      return Filter.equals(columns[index], args[index]);
    });
    Finder finder = Finder(filter: Filter.and(filters));

    var records = await store.find(db, finder: finder);
    if (records == null) return null;

    List<DatabaseModel> models = [];
    records.forEach((record) {
      Map<String, dynamic> map = Map.from(record.value);
      map['id'] = record.key;
      models.add(dbModel.fromMap(map));
    });

    return models;
  }

  /// Get from the store the first record where [columns] = [args]
  static Future<DatabaseModel> firstWhere(DatabaseModel dbModel, List<String> columns, List<dynamic> args) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    List<Filter> filters = List.generate(columns.length, (index) {
      return Filter.equals(columns[index], args[index]);
    });
    Finder finder = Finder(filter: Filter.and(filters));

    var record = await store.findFirst(db, finder: finder);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(record.value);
  }

  /// Get from the store the last record where [columns] = [args]
  static Future<DatabaseModel> lastWhere(DatabaseModel dbModel, List<String> columns, List<dynamic> args) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    List<Filter> filters = List.generate(columns.length, (index) {
      return Filter.equals(columns[index], args[index]);
    });
    Finder finder = Finder(
      filter: Filter.and(filters),
      sortOrders: [SortOrder(Field.key, false)]
    );

    var record = await store.findFirst(db, finder: finder);
    if (record == null) return null;

    Map<String, dynamic> map = Map.from(record.value);
    map['id'] = record.key;
    return dbModel.fromMap(map);
  }

  /// Get [all] records from the store
  static Future<List<DatabaseModel>> all(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();

    var records = await store.find(db);
    if (records == null) return null;

    List<DatabaseModel> models = [];
    records.forEach((record) {
      Map<String, dynamic> map = Map.from(record.value);
      map['id'] = record.key;
      models.add(dbModel.fromMap(map));
    });

    return models;
  }

  /// [Delete] record from table
  static Future<void> delete(DatabaseModel dbModel) async {
    StoreRef store = intMapStoreFactory.store(dbModel.table);
    Database db = await open();
    Finder finder = Finder(
      filter: Filter.equals(Field.key, dbModel.id)
    );

    store.delete(db, finder: finder);
  }
}
