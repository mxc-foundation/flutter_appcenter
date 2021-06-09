import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'configs.dart';
import 'update_handler.dart';

class GooglePlayUpdateHandler extends UpdateHandler {
  Future<void> handle({void Function(int, int)? onReceiveProgress}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    try {
      LaunchReview.launch(
        androidAppId: packageInfo.packageName,
      );
    } catch (e) {
      String storeLink = Configs.googlePlayStore(packageInfo.packageName);

      if (await canLaunch(storeLink)) {
        await launch(storeLink);
      } else {
        throw ('can not open google play');
      }
    }
  }
}
