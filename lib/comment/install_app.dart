import 'dart:io';

import 'package:open_file/open_file.dart';

Future<Null> installApk(String url, String appId, File apkFile) async {
  String _apkFilePath = apkFile.path;

  if (_apkFilePath.isEmpty) {
    print('make sure the apk file is set');
    return;
  }

  OpenFile.open(_apkFilePath).then((result) {
    print('install apk $result');
  }).catchError((error) {
    print('install apk error: $error');
  });
}
