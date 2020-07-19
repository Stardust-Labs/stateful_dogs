import 'package:flutter/material.dart';

import 'storage/storage_sqflite.dart';
import './widgets/app_widgets.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init();

  await Dog().seed();
  
  List<Dog> dogs = await Dog().all();
  runApp(DogsApp(dogs: dogs));
}
