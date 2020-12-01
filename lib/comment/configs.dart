class Configs {
  static const baseUrl = 'https://api.appcenter.ms';
  static String googlePlayStore(String appId) => 'https://play.google.com/store/apps/details?id=$appId';
  static String latestVersionUrl(String appSecret) => '/v0.1/public/sdk/apps/$appSecret/releases/latest';
}