import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_appcenter/flutter_appcenter.dart';
import 'package:package_info/package_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Main()
    );
  }
}

class Main extends StatefulWidget{
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  bool _initResult = false;
  bool _isUpdate = false;
  bool _isEnabledForDistribute = false;
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Futter Appcenter'),
      ),
      body: Center(
        child: Text('Running on: FlutterAppCenter v$_version+${_version == _buildNumber ? 0 : _buildNumber} \nresult: ${_initResult ? 'Initialize Successly' : 'appSecret must be not null'}\nApp Center Distribute is ${_isEnabledForDistribute ? 'enable' : 'disable'}\n${_isUpdate ? 'It has the latest version' : 'It\'s the latest version.' }'),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => checkForUpdate(context),
        tooltip: 'Update',
        child: new Icon(Icons.update),
      )
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FlutterAppCenter.init(
      appSecretAndroid: '',//'Your Android App Secret',
      appSecretIOS: '',//'Your iOS App Secret'
      tokenAndroid: '',//'Your Android Token'
      tokenIOS: '',//'Your iOS Token',
      appIdIOS: '',
      betaUrlIOS: 'itms-beta://',
      usePrivateTrack: false,
    ).then((res) async {
      bool enable = await FlutterAppCenter.isEnabledForDistribute();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _isUpdate = await checkForUpdate(context);

      setState(() {
        _version = packageInfo.version;
        _buildNumber = packageInfo.buildNumber;
        _initResult = res;
        _isEnabledForDistribute = enable;
      });
      
    });
  }
}

Future<bool> checkForUpdate(BuildContext context) async{
  return await FlutterAppCenter.checkForUpdate( 
    context,
    downloadUrlAndroid: '',
    dialog: {
      'title': 'App Update Avaiable',
      'subTitle': 'Enjoy the lastest version',
      'content': 'There is a new version available with the most advanced features, please click confirm to upgrade!',
      'middleButtonText': 'TestFlight', // only support iOS
      'confirmButtonText': 'Store',
      'cancelButtonText': 'Postpone',
      'downloadingText': 'Downloading File...'
    }
  );
}
