import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:flutter_appcenter/comment/dao.dart';

Future<Null> installApk(
    String url, String appId, Function showDownloadProgress) async {
  File _apkFile = await Dao().downloadAndroid(url, showDownloadProgress);
  String _apkFilePath = _apkFile.path;

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
