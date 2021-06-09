import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_appcenter/comment/dao.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

import 'install_app.dart';
import 'update_handler.dart';

// WARNING!! ACHTUNG!! ВНИМАНИЕ!! 警告!!
// MUST BE IN SEPARATED FILE AND THIS FILE CANNOT BE IMPORTED FROM GOOGLE PLAY DISTIRBUTED APP
// IT VIOLATES GOOGLE PLAY RULES

class ApkUpdateHandler extends UpdateHandler {
  final String downloadUrl;

  ApkUpdateHandler(this.downloadUrl);

  Future<File> download(String url,
      {void Function(int, int) onReceiveProgress}) async {
    final dio = Dao().dio;

    Directory storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir.path;
    File file = new File('$storagePath/download_app');

    if (!file.existsSync()) {
      file.createSync();
    }

    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      file.writeAsBytesSync(response.data);
      return file;
    } catch (e) {
      print(e);
      return e;
    }
  }

  @override
  Future<void> handle({void Function(int, int) onReceiveProgress}) async {
    final file =
        await download(downloadUrl, onReceiveProgress: onReceiveProgress);
    final packageInfo = await PackageInfo.fromPlatform();
    await installApk(downloadUrl, packageInfo.packageName, file);
  }
}
