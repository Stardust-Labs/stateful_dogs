import 'package:sqflite/sqflite.dart';

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  /// Covert the [Dog] to a [Map] for database interactions.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age
    };
  }

  /// Insert the [Dog] into a given [Database]
  Future<void> insert(Database db) async {
    await db.insert(
      'dogs',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all entries from the [Dog] class's table
  static Future<List<Dog>> all(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (index) {
      return Dog(id: maps[index]['id'], name: maps[index]['name'], age: maps[index]['age']);
    });
  }

  /// Delete the [Dog] with the given [id] from the given [Database]
  static void delete(Database db, int id) {
    db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }

  /// Seed the [Database]'s dog table with starter data
  static Future<void> seed(db) async {
    Dog dog1 = Dog(id: 1, name: 'Mac', age: 15);
    Dog dog2 = Dog(id: 2, name: 'Chica', age: 10);
    Dog dog3 = Dog(id: 3, name: 'Buster', age: 12);
    Dog dog4 = Dog(id: 4, name: 'Bailey', age: 8);
    await dog1.insert(db);
    await dog2.insert(db);
    await dog3.insert(db);
    await dog4.insert(db);
  }
}
