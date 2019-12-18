// Provider para conectarnos a SQLITE con el patron singleton

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/ScanModel.dart';
export '../models/ScanModel.dart';


class DBProvider{

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async{

    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {

    Directory documentsDirectory  = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScanDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      },
    );
  }

  // Método para insertar registros en SQLlite
  newScanRaw(ScanModel nuevoScan) async{

    final db = await database;

    final res = await db.rawInsert(
      "INSERT INTO Scans (id, type, value) "
      "VALUES (${ nuevoScan.id}, '${ nuevoScan.type}', '${nuevoScan.value}' )"
    );

    return res;
  }

  // INSERT - Guardar informacion en la base de datos SQLlite
  newScan(ScanModel newScan) async {
    final db  = await database;
    final res = await db.insert('Scans', newScan.toJson());
    return res;
  }

  // SELECT - Obtener información de la base de datos SQLlite

  // Obtener información por Id
  Future<ScanModel> getScanId(int id) async{
    // Obtenemos el estado de la base de datos
    final db = await database;
    // Realizamos nuestra consulta condicionada
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    // Si no hay resultados retornamos el primer registro convertido en un scan model
    // Si esta vacio regresamos un null
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async{
    final db = await database;
    final res = await db.query('Scans');

    // Convertimos el mapa a una lista de ScanModel
    List<ScanModel> list  = res.isNotEmpty 
                          ? res.map( (c) => ScanModel.fromJson(c) ).toList() 
                          : [];

    return list;
  }

  Future<List<ScanModel>> getScanByType(String type) async{
    final db = await database;
    final res = await db.rawQuery("SELECTE * FROM Scans WHERE type = '$type'");

    // Convertimos el mapa a una lista de ScanModel
    List<ScanModel> list  = res.isNotEmpty 
                          ? res.map( (c) => ScanModel.fromJson(c) ).toList() 
                          : [];

    return list;
  }

  // UPDATE - Actualizar registros en la base de dats SQLlite
  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);
    return res;

  }

  // DELETE - Eliminar registros de una base de datos SQLlite
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }

}