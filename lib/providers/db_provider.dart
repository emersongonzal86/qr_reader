import 'package:sqflite/sqflite.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async{
    return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database>initDB() async{

  }
}
