import 'dart:io';

import 'package:flutter_appcenter/comment/dao.dart';
import 'package:install_plugin/install_plugin.dart';

Future<Null> installApk(String url,String appId,Function showDownloadProgress) async {
  File _apkFile = await Dao().downloadAndroid(url,showDownloadProgress);
  String _apkFilePath = _apkFile.path;

  if (_apkFilePath.isEmpty) {
    print('make sure the apk file is set');
    return;
  }

  InstallPlugin.installApk(_apkFilePath, appId)
  .then((result) {
    print('install apk $result');
  }).catchError((error) {
    print('install apk error: $error');
  });
}