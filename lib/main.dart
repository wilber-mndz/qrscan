import 'package:flutter/material.dart';
import 'package:qrreadearapp/src/page/HomePage.dart';
import 'package:qrreadearapp/src/page/ShowMapPage.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRReader',
      initialRoute: 'home',
      routes: {
        'home'    : (BuildContext context) => HomePage(),
        'showMap' : (BuildContext context) => ShowMapPage()
      },
      // Personaliamos el tema global de la aplicacion
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    );
  }
}