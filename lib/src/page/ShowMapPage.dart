import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreadearapp/src/models/ScanModel.dart';

class ShowMapPage extends StatefulWidget {

  @override
  _ShowMapPageState createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPage> {
  String typeMap = 'streets';

  final map = new MapController();

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Navegacion QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLanLng(), 15.0);
            },
          )
        ],
      ),
      body: _createMap(scan),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  FloatingActionButton _createFloatingActionButton (BuildContext context){
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.repeat),
      onPressed: (){
        setState(() {
          if (typeMap == 'streets') {
          typeMap = 'dark';
        }else if (typeMap == 'dark'){
          typeMap = 'light';
        }else if (typeMap == 'light') {
          typeMap = 'outdoors';
        }else if (typeMap == 'outdoors'){
          typeMap = 'satellite';
        }else {
          typeMap = 'streets';
        }
        });
      },
    );
  }

  Widget _createMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLanLng(),
        zoom: 10,
      ),
      layers: [
        _drawMap(),
        _markers(scan)
      ],
    );
  }

  _drawMap(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoibWVuZGV6d2lsYmVyOTQiLCJhIjoiY2s0Yzc0ZmYyMGw1dDNvcDg0bWxvOWtybSJ9.wCfNO76ZpEhdgVtVRlaBRQ',
        'id' : 'mapbox.$typeMap'
      }
    );
  }

  _markers(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLanLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 45.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        ),
      ]
    );
  }
}