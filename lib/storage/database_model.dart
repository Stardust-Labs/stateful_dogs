import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import './app_storage.dart';

abstract class DatabaseModel {
  int _id;
  @protected
  set id (int id) { _id = id; }
  int get id => _id;

  /// Getters must be implemented with private property
  String get table;
  List<String> get uniqueConstraints;
  ConflictAlgorithm get insertConflictAlgorithm;

  /// Descendants must implement a way to convert from Storage maps to
  /// an instance of the model and vice versa
  Map<String, dynamic> toMap();
  DatabaseModel fromMap(Map<String, dynamic> map);

  /// Descendants must implement a factory to convert from
  /// DatabaseModel instances to their own type
  Future<List<DatabaseModel>> listFactory(List<DatabaseModel> list);
  Future<DatabaseModel> instanceFactory(DatabaseModel model);

  /// Insert or update the model as needed
  Future<void> save() async {
    if (id == null) {
      _id = await Storage.insert(this);
    } else {
      Storage.update(this);
    }
  }

  /// Wrapper for the [Storage] find method
  Future<DatabaseModel> find(int id) async {
    return instanceFactory(await Storage.find(this, id));
  }

  /// Wrapper for the [Storage] first method
  Future<DatabaseModel> first() async {
    return instanceFactory(await Storage.first(this));
  }

  /// Wrapper for the [Storage] last method
  Future<DatabaseModel> last() async {
    return instanceFactory(await Storage.last(this));
  }

  /// Wrapper for the [Storage] where method
  Future<List<DatabaseModel>> where(Map<String, dynamic> args) async {
    return listFactory(await Storage.where(this, args));
  }

  /// Wrapper for the [Storage] firstWhere method
  Future<DatabaseModel> firstWhere(Map<String, dynamic> args) async {
    return instanceFactory(await Storage.firstWhere(this, args));
  }

  /// Wrapper for the [Storage] lastWhere method
  Future<DatabaseModel> lastWhere(Map<String, dynamic> args) async {
    return instanceFactory(await Storage.lastWhere(this, args));
  }

  /// Wrapper for the [Storage] all method
  Future<List<DatabaseModel>> all() async {
    return listFactory(await Storage.all(this));
  }

  /// [Delete] the model from the database
  Future<void> delete() async {
    await Storage.delete(this);
    _id = null;
  }
}