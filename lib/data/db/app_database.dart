import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class AppDatabase {
  //the only available intance of this Appdatabase class
  // is stored in this private field
  static final AppDatabase _singleton = AppDatabase._();

//this instance get-only property is the only way for other classes to acess
//the single AppDatabase object.
  static AppDatabase get instance => _singleton;

//Completer is used for transforming synchrounus code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

//A private constructor
//if a class specifies its own constructor, it immidiately loses the default one
//this means that by providing constructor we can create a new instance
//only from within this sembastDb class itslf.

  AppDatabase._();

  late Database _database;

  Future<Database> get database async {
    //if the completer is null,database is not yet opened.
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      //calling _openDatabase will also completed the completer with database instance
      _openDatabase();
    }
    //If the database is already opened , return immediatly.
    //otherwise, wait until complete() is called on the completer in _openDatabase().
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    //Get a platform-specific directory where persistent app data can be stored.
    final appDocumentDir = await getApplicationDocumentsDirectory();
    //path with the form: /platform-specific-directory/contacts.db
    final dbPath = await join(appDocumentDir.path, 'contacts.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);
    _dbOpenCompleter?.complete(database);
  }
}
