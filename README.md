# flutter_appcenter 

Microsoft AppCenter

## Support Android/iOS to Build, Test, and Distribute, Analytics and Diagnostics services.

---

一、Import
---
```yaml
dependencies:
  flutter_appcenter: lastVersion
```

二、Usage
---
```dart
import 'package:flutter_appcenter/flutter_appcenter.dart';

FlutterAppCenter.init(
  context: context,
  appSecretAndroid: '',//'Your Android App Secret',
  appSecretIOS: '',//'Your iOS App Secret'
  tokenAndroid: '',//'Your Android Token'
  tokenIOS: '',//'Your iOS Token',
  betaUrlIOS: '', //itms-beta
  usePrivateTrack: false,
).then((res) async {
  await FlutterAppCenter.isEnabledForDistribute();
  await FlutterAppCenter.checkForUpdate(
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
});

```