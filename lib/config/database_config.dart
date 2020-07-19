enum storageDriver {
  sqflite,
  sembast
}

class DatabaseConfig {
  static const version = 1;
  static const path = 'dogs_list.db';
  static const activeDriver = storageDriver.sembast;
}
