class StructuredQuery {
  static const List<String> createTables = [
    'CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT UNIQUE, age INTEGER)'
  ];
}