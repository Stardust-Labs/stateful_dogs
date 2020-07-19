import 'package:flutter/material.dart';

import './storage/storage.dart';
import './widgets/app_widgets.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Storage storage = Storage();
  await storage.init();

  await Dog.seed(storage.database);
  
  List<Dog> dogs = await Dog.all(storage.database);
  runApp(DogsApp(dogs: dogs, storage: storage));
}
