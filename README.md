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

>Make sure meta-data name is “appId”.

>Provide your application id in meta-data value.


```sh
</application>
    ...
    <meta-data
        android:name="appId"
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

```sh
<key>AppsOnAirAPIKey</key>
<string>XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX</string>
```

If ```CFBundleDisplayName``` is not added in your app then added in your app info.plist file.

```sh
<key>CFBundleDisplayName</key>
<string>YourAppName</string>
```


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
             "Application Version : ${response["updateData"]["androidBuildNumber"]}",
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
