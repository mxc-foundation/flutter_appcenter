library flutter_appcenter;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appcenter/comment/configs.dart';
import 'package:flutter_appcenter/comment/dao.dart';
import 'package:flutter_appcenter/comment/update_handler.dart';
import 'package:flutter_appcenter/components/update_dialog.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
export 'comment/update_handler.dart';
import 'components/progress_dialog.dart';

class FlutterAppCenter {
  static const MethodChannel _channel =
      const MethodChannel('flutter_appcenter');
  static String? appSecret = '';
  static String token = '';
  static String appId = '';
  static String betaUrl = '';

  static var dialogUpdateSingle;

  /// start running the AppCenert
  static Future<bool> init({
    String? appSecretAndroid,
    String? appSecretIOS,
    String? tokenAndroid,
    String? tokenIOS,
    String? appIdAndroid,
    String? appIdIOS,
    String? betaUrlAndroid,
    String? betaUrlIOS,

    /// set private or public distribution group
    /// defualut value is publice
    bool usePrivateTrack = false,

    /// when automaticCheckForUpdate is false, can use checkForUpdate method to update
    // bool automaticCheckForUpdate = true,
  }) async {
    Map<String, Object?> args = {
      'appSecret': Platform.isAndroid ? appSecretAndroid : appSecretIOS,
      'usePrivateTrack': usePrivateTrack,

      /// if true, check update for showing dialog
      'automaticCheckForUpdate': false,
    };

    appSecret = args['appSecret'] as String?;
    if (Platform.isAndroid) {
      token = tokenAndroid ?? '';
      appId = appIdAndroid ?? '';
      betaUrl = betaUrlAndroid ?? '';
    } else {
      token = tokenIOS ?? '';
      appId = appIdIOS ?? '';
      betaUrl = betaUrlIOS ?? '';
    }

    assert(appSecret != null && appSecret!.isNotEmpty,
        'appSecret must be not null.');
    assert(token.isNotEmpty, 'token must be not null.');

    try {
      String? result = await _channel.invokeMethod('initAppCenter', args);
      return result == '1';
    } on PlatformException catch (e) {
      print("Failed to start running the AppCenert: '${e.message}'.");
      return false;
    }
  }

  /// Check if App Center Distribute is enabled
  static Future<bool> isEnabledForDistribute() async {
    try {
      String? result = await _channel.invokeMethod('isEnabledForDistribute');
      return result == '1';
    } on PlatformException catch (e) {
      print("Failed to check for Distribute: '${e.message}'.");
      return false;
    }
  }

  static GlobalKey<ProgressDialogState> _dialogKey = GlobalKey();

  /// update dialog
  static Future<bool> checkForUpdate(
    BuildContext context,
    UpdateHandler handler, {
    required Map<String, String?> dialog,
  }) async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    var _requestResult;

    dialog['title'] =
        dialog.containsKey('title') ? dialog['title'] : 'App update avaiable';
    dialog['subTitle'] =
        dialog.containsKey('subTitle') ? dialog['subTitle'] : '';
    dialog['content'] = dialog.containsKey('content')
        ? dialog['content']
        : ''; // defualt to show the releaseNotes and version
    dialog['confirmButtonText'] = dialog.containsKey('confirmButtonText')
        ? dialog['confirmButtonText']
        : 'Confirm';
    dialog['middleButtonText'] = dialog.containsKey('middleButtonText')
        ? dialog['middleButtonText']
        : '';
    dialog['cancelButtonText'] = dialog.containsKey('cancelButtonText')
        ? dialog['cancelButtonText']
        : 'Postpone';
    dialog['downloadingText'] = dialog.containsKey('downloadingText')
        ? dialog['downloadingText']
        : 'Downloading File...';

    if (dialog['middleButtonText']!.isNotEmpty) {
      assert(betaUrl.isNotEmpty,
          'middleButtonText and betaUrl both must be not null or empty.');
    }

    void onProgress(int progress, int total) async {
      _dialogKey.currentState!.setValue(progress / total);

      if (progress == total) {
        Navigator.of(_dialogKey.currentContext!).pop();
      }
    }

    void checkUpdateForAndroid() async {
      await handler.handle(onReceiveProgress: onProgress);
      if (_dialogKey.currentContext != null)
        Navigator.of(_dialogKey.currentContext!).pop();
    }

    void checkUpdateAppForBeta() async {
      if (await canLaunch(betaUrl)) {
        await launch(betaUrl);
      } else {
        if (betaUrl.contains('itms-beta')) {
          await launch(betaUrl.replaceFirst(new RegExp(r'itms-beta'), 'https'));
        } else {
          print('can not open testflight');
        }
      }
    }

    void checkUpdateAppForIOS() async {
      if (appId.isNotEmpty) {
        LaunchReview.launch(
          iOSAppId: appId,
        );
      } else {
        checkUpdateAppForBeta();
      }
    }

    void showUpdateDialog() async {
      String? content = '';
      dialog['subTitle'] = dialog['subTitle']! +
          ' ${_requestResult['short_version']}(${_requestResult['version']})';

      if (dialog['content']!.isNotEmpty) {
        content = dialog['content'];
      } else {
        content = _requestResult['release_notes'];
      }

      if (dialogUpdateSingle == null) {
        dialogUpdateSingle = await showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return UpdateDialog(
                mandatoryUpdate: _requestResult['mandatory_update'],
                title: '${dialog['title']}',
                subTitle: dialog['subTitle'],
                content: content,
                confirmButtonText: dialog['confirmButtonText'],
                middleButtonText: dialog['middleButtonText'],
                cancelButtonText: dialog['cancelButtonText'],
                onMiddle: () async {
                  if (Platform.isIOS && betaUrl.isNotEmpty) {
                    checkUpdateAppForBeta();
                  }
                },
                onConfirm: () async {
                  _dialogKey = GlobalKey();

                  await showDialog<dynamic>(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => WillPopScope(
                      onWillPop: () async => false,
                      child: Dialog(
                        backgroundColor: Colors.white,
                        insetAnimationCurve: Curves.easeInOut,
                        insetAnimationDuration: Duration(milliseconds: 100),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: ProgressDialog(
                          key: _dialogKey,
                          text: dialog['downloadingText'],
                        ),
                      ),
                    ),
                  );
                  if (Platform.isAndroid) {
                    checkUpdateForAndroid();
                  } else {
                    Navigator.of(_dialogKey.currentContext!).pop();
                    checkUpdateAppForIOS();
                  }
                },
              );
            });
      } else {
        dialogUpdateSingle();
      }
    }

    /// step 1: abtain the app vesion
    String _version = _packageInfo.version;
    String _buildNumber = _packageInfo.buildNumber;
    print('local version: $_version+$_buildNumber');
    if (_version == _buildNumber) {
      _buildNumber = '0';
    }

    /// step 2: require latest version from AppCenter
    Dao.token = token;
    var dao = new Dao();
    _requestResult = await dao.get(url: Configs.latestVersionUrl(appSecret));

    print('latestUrl:${Configs.latestVersionUrl(appSecret)}');
    print(
        'remote version: ${_requestResult['short_version']}+${_requestResult['version']}');

    /// step 3: compare the app's verion and build number with the remote's
    if (_version != _requestResult['short_version']) {
      List<String> versionArr = _version.split('.');
      List<String> remoteVersionArr =
          _requestResult['short_version'].split('.');

      for (int i = 0; i < remoteVersionArr.length; i++) {
        if (int.parse(remoteVersionArr[i]) > int.parse(versionArr[i])) {
          showUpdateDialog();
          return true;
        }
      }
    } else if (_buildNumber != _requestResult['version'] &&
        int.parse(_requestResult['version']) > int.parse(_buildNumber)) {
      showUpdateDialog();
      return true;
    }

    return false;
  }
}
