import Flutter
import UIKit
import AppsOnAir_AppSync

public class SwiftAppsonairFlutterAppsyncPlugin: NSObject, FlutterPlugin {
    
    let appSyncService = AppSyncService()
    static var channel:FlutterMethodChannel = FlutterMethodChannel()
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onViewVisibilityChanged(_:)), name: .visibilityChanges, object: nil)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        self.channel = FlutterMethodChannel(name: "appsOnAirAppSync", binaryMessenger: registrar.messenger())
      
        let instance = SwiftAppsonairFlutterAppsyncPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
       if("isUpdateAvailable" == call.method){
            if let args = call.arguments as? NSDictionary {
                do{
                    appSyncService.sync(directory: args) { appUpdateData in
                        if appUpdateData["error"] != nil {
                            result(["error" : appUpdateData["error"]])
                        }
                        result(appUpdateData)
                    }
                }catch let error {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }else {
                result({})
            }
        }else{
            result({})
        }
    }
    
    @objc public func onViewVisibilityChanged(_ notification: NSNotification) {
        if let isPresented = notification.userInfo?["isPresented"] as? Bool {
            if(isPresented == true) {
                SwiftAppsonairFlutterAppsyncPlugin.channel.invokeMethod("openDialog", arguments:true)
            } else {
                SwiftAppsonairFlutterAppsyncPlugin.channel.invokeMethod("closeDialog", arguments:true)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .visibilityChanges, object: nil)
    }
    
}

extension Notification.Name {
 static let visibilityChanges = NSNotification.Name("visibilityChanges")
}
