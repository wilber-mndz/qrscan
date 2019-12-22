import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreadearapp/src/bloc/scans_block.dart';
import 'package:qrreadearapp/src/page/DirectionPage.dart';
import 'package:qrreadearapp/src/page/MapPage.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreadearapp/src/utils/utils.dart' as utils;

import '../models/ScanModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (){
              scansBloc.deleteScansAll();
            },
          )
        ],
      ),
      body: _loadPage(currentPage),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: (){
          // Acceder a la camara 
          _scanQR(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

   _scanQR(BuildContext context) async {

    // "https://www.youtube.com/user/tamashidroid"
    // geo:13.580605482448895,-88.08716311892397

    String futureString ;

    try {
        futureString = await BarcodeScanner.scan();
        if ( futureString != null ) {
          
          final scan = ScanModel(value: futureString);
          scansBloc.newScan(scan);

          if (Platform.isIOS) {
            Future.delayed(Duration(microseconds: 750), (){
              utils.openScan(context, scan);    
            });
          }else{
            utils.openScan(context, scan);
          }

        }
    } catch (e) {
      futureString = e.toString();
    }
 

  }

  Widget _loadPage(int currentPage){

    switch (currentPage) {
      case 0 : return MapPage();
      case 1 : return DirectionPage();
      default:
        return MapPage();
    }

  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      onTap: (index) {
        setState(() {
          currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapa')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud_queue),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}