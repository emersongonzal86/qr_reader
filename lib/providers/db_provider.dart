import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Path de donde almacenaremos la base de datos 
    // la ruta fisica en la maquina local es /home/emerson/.cache/Google/AndroidStudio2022.3/device-explorer/Note-10 API 30/data/user/0/com.example.qr_reader/app_flutter
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //crear base de datos

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          tipo TEXT,
          valor TEXT
        )
        ''');
    });
  }
}
