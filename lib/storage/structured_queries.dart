import './database_model.dart';
import './dog.dart';

class StructuredQuery {
  static const List<String> createTables = [
    'CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT UNIQUE, age INTEGER)'
  ];

  static List<DatabaseModel> _createStores = [
    Dog()
  ];
  static List<DatabaseModel> get createStores => _createStores;
}