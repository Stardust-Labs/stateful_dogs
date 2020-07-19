import 'package:sqflite/sqflite.dart';
import './database_model.dart';
import './storage.dart';

class Dog extends DatabaseModel {
  String name;
  int age;

  String table = 'dogs';
  ConflictAlgorithm _insertConflictAlgorithm = ConflictAlgorithm.ignore;
  ConflictAlgorithm get insertConflictAlgorithm => _insertConflictAlgorithm;

  Dog({this.name, this.age});

  /// Covert the [Dog] to a [Map] for database interactions.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age
    };
  }
  Dog fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    age = map['age'];
    return this;
  }
  Dog newFromMap(Map<String, dynamic> map) {
    Dog dog = Dog(
      name: map['name'],
      age: map['age']
    );

    dog.id = map['id'];

    return dog;
  }

  Future<List<Dog>> listFactory(List<DatabaseModel> list) async {
    return List<Dog>.from(list);
  }
  Future<Dog> instanceFactory(DatabaseModel model) async {
    return this.newFromMap(model.toMap());
  }

  /// Seed the [Database]'s dog table with starter data
  Future<void> seed() async {
    Dog dog1 = Dog(name: 'Mac', age: 15);
    Dog dog2 = Dog(name: 'Chica', age: 10);
    Dog dog3 = Dog(name: 'Buster', age: 12);
    Dog dog4 = Dog(name: 'Bailey', age: 8);
    await dog1.save();
    await dog2.save();
    await dog3.save();
    await dog4.save();
  }
}
