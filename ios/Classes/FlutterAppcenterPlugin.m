#import "FlutterAppcenterPlugin.h"

@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;
@import AppCenterDistribute;

@interface FlutterAppcenterPlugin ()

@property(nonatomic) NSString *updateDialogTitle;
@property(nonatomic) NSString *updateDialogSubTitle;
@property(nonatomic) NSString *updateDialogDetail;
@property(nonatomic) NSString *updateDialogConfirm;
@property(nonatomic) NSString *updateDialogCancel;

@end

@implementation FlutterAppcenterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"flutter_appcenter"
                                  binaryMessenger:[registrar messenger]];

  FlutterAppcenterPlugin* instance = [[FlutterAppcenterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"initAppCenter" isEqualToString:call.method]) {

    NSString *appSecret = call.arguments[@"appSecret"];
    
    NSString *usePrivateTrack = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"usePrivateTrack"]];
    if([@"1" isEqualToString:usePrivateTrack]) {
      MSDistribute.updateTrack = MSUpdateTrackPrivate;
    }

    NSString *automaticCheckForUpdate = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"automaticCheckForUpdate"]];
    if([@"0" isEqualToString:automaticCheckForUpdate]){
      [MSDistribute disableAutomaticCheckForUpdate];
    }

    self.updateDialogTitle = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"updateDialogTitle"]];
    self.updateDialogSubTitle = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"updateDialogSubTitle"]];
    self.updateDialogDetail = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"updateDialogDetail"]];
    self.updateDialogConfirm = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"updateDialogConfirm"]];
    self.updateDialogCancel = [[NSString alloc] initWithFormat:@"%@",call.arguments[@"updateDialogCancel"]];

    BOOL validResult = [self initAppCenter:appSecret];
    if(validResult) {
      result(@("1"));
    }else {
      result(@("0"));
    }

  }else if([@"checkForUpdate" isEqualToString:call.method]) {
    [MSDistribute checkForUpdate];
  }else if([@"isEnabledForDistribute" isEqualToString:call.method]) {
    [MSDistribute isEnabled] ? result(@("1")) : result(@("0"));
  }else {
    result(FlutterMethodNotImplemented);
  }

}

- (BOOL)initAppCenter:(NSString *)appSecret {
  BOOL valid = [self isNotEmpty:appSecret];

  if(valid){
    // #if DEBUG
    //   [MSAppCenter start:appSecret withServices:@[
    //     [MSAnalytics class],
    //     [MSCrashes class]
    //   ]];
    // #else
      [MSAppCenter start:appSecret withServices:@[
        [MSAnalytics class],
        [MSCrashes class],
        [MSDistribute class]
      ]];
    // #endif
  }

  return valid;
}

- (BOOL) isNotEmpty:(NSString *)string {
  if(string == nil || string == NULL) {
    return NO;
  }
  
  if([string isKindOfClass:[NSNull class]]) {
    return NO;
  }
  if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
    return NO;
  }

  return YES;
}
@end
