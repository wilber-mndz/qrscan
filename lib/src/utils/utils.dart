import 'package:qrreadearapp/src/models/ScanModel.dart';
import 'package:url_launcher/url_launcher.dart';

openScan(ScanModel scan) async {

  if (scan.type == 'http') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
  }else {
    print('GEO...');
  }
  
}