import 'dart:async';

import 'package:qrreadearapp/src/bloc/validator.dart';

import '../providers/DBProvider.dart';

class ScansBloc with Validators{

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    // Obtener scans de la base de datos
    getScans();
  }

  final _scansStreamController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scanStream      => _scansStreamController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scanStreamHttp  => _scansStreamController.stream.transform(validateHttp);

  dispose(){
    _scansStreamController?.close();
  }

  getScans() async{
    _scansStreamController.add(await DBProvider.db.getAllScans());
  }

  newScan(ScanModel scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleteSan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteScansAll() async {
    await DBProvider.db.deleteAll();
    getScans();
  }



}