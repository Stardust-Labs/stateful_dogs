import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './dogs_list.dart';
import '../storage/storage_sqflite.dart';
import '../models/app_models.dart';

/// Root [Widget] for the application
class DogsApp extends StatelessWidget {
  DogsApp({this.dogs, this.storage});
  final List<Dog> dogs;
  final Storage storage;

  @override
  Widget build (BuildContext context) {
    return ScopedModel<DogModel> (
      model: DogModel(dogs: dogs),
      child: MaterialApp(
          title: 'Dogs Database App',
          home: DogsList()
        )
    );
  }
}