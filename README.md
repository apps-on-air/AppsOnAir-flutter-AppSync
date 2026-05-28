# AppsOnAir-flutter-AppSync


## Features Overview

- App Update 📤 
>By enabling App Update feature, users will be able to see  any new releases published in this app.

- App Maintenance 🛠️ 
>By enabling Maintenance mode feature, users won’t be able to access the app and will be noted as the app is under Maintenance mode.

#### To learn more about AppsOnAir AppSync, please visit the [AppsOnAir](https://documentation.appsonair.com) website


## Android Setup

### Minimum Requirements

- Android Gradle Plugin (AGP): Version 8.0.2 or higher
- Kotlin: Version 1.7.10 or higher
- Gradle: Version 8.0 or higher

Add meta-data to the app's AndroidManifest.xml file under the application tag.

>Make sure meta-data name is “AppsonairAppId”.

>Provide your application id in meta-data value.


```sh
</application>
    ...
    <meta-data
        android:name="AppsonairAppId"
        android:value="********-****-****-****-************" />
</application>
```

>Make sure meta-data name is “com.appsonair.icon”.

>Provide your application logo in meta-data value.

```sh
</application>
    ...
    <meta-data
       android:name="com.appsonair.icon"
       android:resource="@mipmap/ic_launcher" />
</application>
```


Add below code to setting.gradle.

```sh
pluginManagement {
   ……
   repositories {
       google()
       mavenCentral()
       gradlePluginPortal()
       maven { url 'https://jitpack.io' }
   }
}
```

Add below code to your root level build.gradle

```sh
allprojects {
   repositories {
       google()
       mavenCentral()
       maven { url 'https://jitpack.io' }
   }
}
```

## iOS Setup

### Minimum Requirements

iOS deployment target: 12.0

Provide your application id in your app info.plist file.

```xml
<key>AppsonairAppId</key>
<string>XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX</string>
```

If ```CFBundleDisplayName``` is not added in your app then added in your app info.plist file.

```xml
<key>CFBundleDisplayName</key>
<string>YourAppName</string>
```

---

### iOS Dependency Manager

This plugin supports **both CocoaPods and Swift Package Manager (SPM)**. SPM support requires **Flutter 3.24.0 or higher**.

By default, CocoaPods is used. You can control which dependency manager your project uses by adding the following to your app's `pubspec.yaml`:

#### Option 1 — CocoaPods (default)

Use this if you want to always use CocoaPods regardless of any global Flutter setting:

```yaml
# pubspec.yaml
flutter:
  config:
    # false → always uses CocoaPods (default)
    enable-swift-package-manager: false
```

No other steps needed. Run:

```sh
flutter pub get
cd ios && pod install
```

#### Option 2 — Swift Package Manager

> Requires **Flutter ≥ 3.24.0**. SPM support on iOS is available starting from this version.

Use this to opt into SPM and use `AppsOnAir-iOS-AppSync` via Swift Package Manager:

```yaml
# pubspec.yaml
flutter:
  config:
    # true → uses Swift Package Manager
    enable-swift-package-manager: true
```

Then run:

```sh
flutter pub get
```

Flutter will automatically resolve `AppsOnAir-iOS-AppSync` via SPM. No additional Xcode configuration is required.

> **Note:** You can also enable SPM globally for all your Flutter projects (instead of per-project) by running:
> ```sh
> flutter config --enable-swift-package-manager
> ```
> In that case, you can remove the `config` block from `pubspec.yaml` entirely and Flutter will use SPM automatically.

#### Summary

| `enable-swift-package-manager` | Flutter version | Result |
|:---:|:---:|:---|
| `false` | any | **CocoaPods** — uses `AppsOnAir-iOS-AppSync` |
| `true` | ≥ 3.24.0 | **SPM** — uses `AppsOnAir-iOS-AppSync` |
| not set | any (global off) | **CocoaPods** — default behaviour |
| not set | ≥ 3.24.0 (global on) | **SPM** — Flutter global setting applies |

> 💡 **Recommendation:** We recommend migrating to **Swift Package Manager** — it is Apple's official, actively maintained dependency manager and receives updates first.

---


## Example

Call service into init state, with default design

```sh
@override
void initState() {
   AppSyncService.sync(context);
   super.initState();
}
```

Call service into init state, with custom design.

If you want to show a custom alert for app updates then pass options as map in sync() method. 

‘options’ should have the key-value pair as follows:
options : {‘showNativeUI’ : false}

By default options : {‘showNativeUI’ : true}, it allows apps to show default design for app update alert.

It is necessary to pass customWidget when you are passing param options : {‘showNativeUI’ : false} else it will throw an exception.

Pass a custom widget to show a custom alert for app updates. Use this method as follows: (We have given an example for custom widget over here, users can add their own custom widget design.)


```sh
@override
void initState() {
   AppSyncService.sync(
     context,
     options: {'showNativeUI': false},
     customWidget: (response) {
       return Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           Text("Application Name : ${response["appName"]}"),
           Text(
             "Application Version : ${response["updateData"]["buildNumber"]}",
           ),
           const SizedBox(height: 20),
           ElevatedButton(
             onPressed: () {},
             child: const Text('Update'),
           ),
         ],
       );
     },
   );
super.initState();
}
```
