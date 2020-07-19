import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../storage/storage.dart';

/// This mantains the app state for [Dogs]
class DogModel extends Model {
  List<Dog> dogs;
  DogModel({this.dogs});

  static DogModel of (BuildContext context) => ScopedModel.of<DogModel>(context);

  void addDog(name, age, storage) {
    Dog dog = Dog(id: dogs.length + 1, name: name, age: age);
    dogs.add(dog);
    notifyListeners();
    dog.insert(storage.database);
  }

  void slaughterDog(storage, id) {
    dogs.removeWhere((dog) => dog.id == id);
    notifyListeners();
    Dog.delete(storage.database, id);
  }
}
