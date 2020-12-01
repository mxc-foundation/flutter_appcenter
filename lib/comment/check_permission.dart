
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if(status.isGranted){
      return true;
    }else if(await Permission.storage.request().isGranted){
      return true;
    }
  } else {
    return false;
  }

  return false;
}