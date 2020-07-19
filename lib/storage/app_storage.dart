import '../config/database_config.dart';
import './storage_sembast.dart';
import './storage_sqflite.dart';
import './database_model.dart';

export './dog.dart';

/// This class provides abstract static
/// access to the storage functions for
/// each storage driver as guaranteed
/// by the [StorageContract]
class Storage {
  static const mode = DatabaseConfig.activeDriver;
  static var storage;

  static Future<dynamic> init() async {
    switch (mode) {
      case storageDriver.sqflite:
        storage = StorageSqflite();
        break;
      case storageDriver.sembast:
        storage = StorageSembast();
        break;
    }

    return storage.init();
  }

  static void _abortIfUnitialized() {
    if (storage == null) {
      throw Exception('Storage is uninitialized.');
    }
  }

  static Future<dynamic> open() async {
    _abortIfUnitialized();
    return storage.open();
  }

  static Future<int> insert(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.insert(dbModel);
  }

  static Future<void> update(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.udpate(dbModel);
  }

  static Future<DatabaseModel> find(DatabaseModel dbModel, int id) async {
    _abortIfUnitialized();
    return storage.find(dbModel, id);
  }

  static Future<DatabaseModel> first(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.first(dbModel);
  }

  static Future<DatabaseModel> last(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.last(dbModel);
  }

  static Future<List<DatabaseModel>> where(DatabaseModel dbModel, Map<String, dynamic> args) async {
    _abortIfUnitialized();
    return storage.where(dbModel, args);
  }

  static Future<DatabaseModel> firstWhere(DatabaseModel dbModel, Map<String, dynamic> args) async {
    _abortIfUnitialized();
    return storage.firstWhere(dbModel, args);
  }

  static Future<DatabaseModel> lastWhere(DatabaseModel dbModel, Map<String, dynamic> args) async {
    _abortIfUnitialized();
    return storage.lastWhere(dbModel, args);
  }

  static Future<List<DatabaseModel>> all(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.all(dbModel);
  }

  static Future<void> delete(DatabaseModel dbModel) async {
    _abortIfUnitialized();
    return storage.delete(dbModel);
  }
}