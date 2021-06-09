import 'dart:io';

import 'package:app_installer/app_installer.dart';

Future<Null> installApk(String url, String appId, File apkFile) async {
  String _apkFilePath = apkFile.path;

  if (_apkFilePath.isEmpty) {
    print('make sure the apk file is set');
    return;
  }

  AppInstaller.installApk(_apkFilePath).then((_) {
    print('install apk');
  }).catchError((error) {
    print('install apk error: $error');
  });
}
