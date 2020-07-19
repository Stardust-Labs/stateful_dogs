import './database_model.dart';

export './database_model.dart';

abstract class StorageContract {
  Future<dynamic> init();
  Future<dynamic> open();
  Future<int> insert(DatabaseModel dbModel);
  Future<void> update(DatabaseModel dbModel);
  Future<DatabaseModel> find(DatabaseModel dbModel, int id);
  Future<DatabaseModel> first(DatabaseModel dbModel);
  Future<DatabaseModel> last(DatabaseModel dbModel);
  Future<List<DatabaseModel>> where(DatabaseModel dbModel, Map<String, dynamic> args);
  Future<DatabaseModel> firstWhere(DatabaseModel dbModel, Map<String, dynamic> args);
  Future<DatabaseModel> lastWhere(DatabaseModel dbModel, Map<String, dynamic> args);
  Future<List<DatabaseModel>> all(DatabaseModel dbModel);
  Future<void> delete(DatabaseModel dbModel);
}