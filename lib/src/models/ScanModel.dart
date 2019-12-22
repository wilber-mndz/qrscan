import 'package:latlong/latlong.dart';

class ScanModel {
    int id;
    String type;
    String value;

    ScanModel({
        this.id,
        this.type,
        this.value,
    }){
      if (this.value.contains('http')) {
        this.type = 'http';
      }else {
        this.type = 'geo';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id    : json["id"],
        type  : json["type"],
        value : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "type"  : type,
        "value" : value,
    };

    LatLng getLanLng(){
      final lalo = value.substring(4).split(',');
      final lan = double.parse(lalo[0]);
      final lng = double.parse(lalo[1]);

      return LatLng(lan, lng);
    }
} 