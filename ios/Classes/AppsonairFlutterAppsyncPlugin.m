#import "AppsonairFlutterAppsyncPlugin.h"
#if __has_include(<appsonair_flutter_appsync/appsonair_flutter_appsync-Swift.h>)
#import <appsonair_flutter_appsync/appsonair_flutter_appsync-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appsonair_flutter_appsync-Swift.h"
#endif

@implementation AppsonairFlutterAppsyncPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppsonairFlutterAppsyncPlugin registerWithRegistrar:registrar];
}
@end
