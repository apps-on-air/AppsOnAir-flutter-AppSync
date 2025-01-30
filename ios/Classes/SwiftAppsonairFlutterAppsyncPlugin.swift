import Flutter
import UIKit
import AppsOnAir_AppSync

public class SwiftAppsonairFlutterAppsyncPlugin: NSObject, FlutterPlugin {
    
    let appSyncService = AppSyncService.shared
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
                /// Return error if found something missing in pods like permissions and if not any error then return the update data json
                /// This is a logic for appsOnAir pod integration.
                    appSyncService.sync(directory: args) { appUpdateData in
                        if let error = appUpdateData["error"] {
                            result(["error": error])
                            return
                        }

                        // Create a mutable copy of the dictionary
                        var mutableAppUpdateData = appUpdateData as? [String: Any] ?? [:]
                        
                        // Remove maintenanceData
                           mutableAppUpdateData.removeValue(forKey: "maintenanceData")

                        if let updateData = mutableAppUpdateData["updateData"] as? [String: Any] {
                            let newUpdateData: [String: Any] = [
                                "isUpdateEnabled": updateData["isIOSUpdate"] as? Bool ?? false,
                                "buildNumber": updateData["iosBuildNumber"] as? String ?? "",
                                "minBuildVersion": updateData["iosMinBuildVersion"] as? String ?? "",
                                "updateLink": updateData["iosUpdateLink"] as? String ?? "",
                                "isForcedUpdate": updateData["isIOSForcedUpdate"] as? Bool ?? false
                            ]

                            // Modify the mutable dictionary
                            mutableAppUpdateData["updateData"] = newUpdateData
                        }

                        result(mutableAppUpdateData)
                    }

                } catch let error {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }else {
                result({})
            }
        }else{
            result({})
        }
    }
    /// Handle view visibility in flutter side need to do this for flutter screen access issue below the native screen in iOS.
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
