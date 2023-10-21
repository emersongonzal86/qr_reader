import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:sqflite/sqflite.dart';

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

  // Manera numero uno de como insertar los registros
  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //verificar la base de datos

    final db = await database;

    final res = await db.rawInsert('''

        INSERT INTO Scans( id, tipo, valor)
        VALUES ( $id, '$tipo', '$valor')
''');

    return res;
  }

  //Manera numero 2 de insertar registros

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    //toJson inserta todos los datos que enviemos siempre y cuando esten definidos en la tabla
    final res = await db.insert('Scans', nuevoScan.toJson());
    print(res);
    return res;
  }

// vamos a obtener informacion SELECT

Future<ScanModel?> getScanById ( int id) async {
  final db = await database;
  //los argumentos del whereArgs son posicionales deben ir en el orden del where 
  final res = await db.query('Scans', where: 'id = ?' , whereArgs: [id]);
  return res.isNotEmpty
  ? ScanModel.fromJson(res.first) : null ;
  
}

Future<List<ScanModel>?> getTodosLosScans ( ) async {
  final db = await database;
  final res = await db.query('Scans');
  return res.isNotEmpty
  ? res.map((s)=> ScanModel.fromJson(s)).toList() 
  : [] ;
  
}


Future<List<ScanModel>?> getScansPorTipo ( String tipo ) async {
  final db = await database;
  final res = await db.rawQuery('''
    SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');
  return res.isNotEmpty
  ? res.map((s)=> ScanModel.fromJson(s)).toList() 
  : [] ;
  
}


  Future<int> actualizarScan( ScanModel actualizarScan) async{
    final db = await database;
    final res=await db.update('Scans', actualizarScan.toJson(),where: 'id = ?', whereArgs: [actualizarScan.id]);
    return res;
  }

}
