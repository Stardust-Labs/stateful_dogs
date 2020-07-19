import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../storage/storage.dart';

/// This mantains the app state for [Dogs]
class DogModel extends Model {
  List<Dog> dogs;
  DogModel({this.dogs});

  static DogModel of (BuildContext context) => ScopedModel.of<DogModel>(context);

  void addDog(name, age) async {
    Dog dog = Dog(name: name, age: age);
    await dog.save();
    dogs.add(dog);
    notifyListeners();
  }

  void slaughterDog(Dog deleteDog) {
    dogs.removeWhere((dog) => dog.id == deleteDog.id);
    notifyListeners();
    deleteDog.delete();
  }
}
