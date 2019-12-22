import 'package:flutter/material.dart';
import 'package:qrreadearapp/src/bloc/scans_block.dart';
import 'package:qrreadearapp/src/utils/utils.dart' as utils;

import '../models/ScanModel.dart';


class MapPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scanStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scan = snapshot.data;

        if (scan.length == 0) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
          itemCount: scan.length,
          itemBuilder: (BuildContext context, int i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red,),
            onDismissed: ( direction ){
             scansBloc.deleteSan(scan[i].id); 
            },
            child: ListTile(
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor,),
              title: Text(scan[i].value),
              subtitle: Text('ID: ${scan[i].id}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                utils.openScan(context, scan[i]);
              },
            ),
          ),
        );
        

      },
    );
  }
}