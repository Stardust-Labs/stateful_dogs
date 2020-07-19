import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../storage/storage.dart';

/// This keeps the persistent [Storage] connection
/// in app state so it can be accessed for writes as
/// needed
class StorageModel extends Model {
  Storage storage;
  StorageModel({this.storage});

  static StorageModel of (BuildContext context) => ScopedModel.of<StorageModel>(context);

  Database get database => storage.database;
}