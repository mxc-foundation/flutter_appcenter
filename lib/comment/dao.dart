import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_appcenter/comment/configs.dart';

class Dao {
  static String baseUrl = Configs.baseUrl;
  static String token = '';

  Response? response;
  late Dio dio;

  // Single Mode
  factory Dao() => _getInstance()!;
  static Dao? get instance => _getInstance();
  static Dao? _instance;

  Dao._internal() {
    // initialization
    dio = new Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {'X-API-Token': token};
  }

  static Dao? _getInstance() {
    if (_instance == null) {
      _instance = new Dao._internal();
    }
    return _instance;
  }

  Future<dynamic> get({required String url, Map? data}) async {
    try {
      Response response = await dio.get(
        url,
        queryParameters:
            data != null ? new Map<String, dynamic>.from(data) : null,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      throw e.response != null ? e.response!.data['message'] : e.message;
    }
  }

  Future<File> downloadAndroid(
      String url, Function showDownloadProgress) async {
    Directory storageDir = (await getExternalStorageDirectory())!;
    String storagePath = storageDir.path;
    File file = new File('$storagePath/download_app');

    if (!file.existsSync()) {
      file.createSync();
    }

    Response response = await dio.get(url,
        onReceiveProgress: showDownloadProgress as void Function(int, int)?,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ));
    file.writeAsBytesSync(response.data);
    return file;
  }
}
