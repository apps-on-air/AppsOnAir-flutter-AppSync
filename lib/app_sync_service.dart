import 'package:flutter/material.dart';

import 'app_sync_platform_interface.dart';

class AppSyncService {
  /// [customWidget] is used to display a custom-built widget. To enable this, set [showNativeUI] to false in the options.
  ///
  ///List of data which can be pass in options
  ///```
  /// -------------------------------------------------------------------------------
  ///| Parameter       | Type    | Default Value       | Description                 |
  ///|-----------------|---------|---------------------|-----------------------------|
  ///|showNativeUI     | Bool    | true                | Handle custom widget display|
  /// -------------------------------------------------------------------------------
  static Future<void> sync(
    BuildContext context, {
    Map<String, dynamic>? options,
    Widget? Function(Map<String, dynamic>)? customWidget,
  }) async {
    bool showNativeUI = true;
    if ((options ?? {}).isNotEmpty) {
      showNativeUI = options!['showNativeUI'];
    }
    if (!showNativeUI && customWidget == null) {
      throw Exception(
          "set showNativeUI = 'true' to show default UI or/else return your custom widget in from sync() method");
    } else if (showNativeUI && customWidget != null) {
      debugPrint("set showNativeUI = 'false' to show custom UI or/else remove custom widget from sync() method");
    }
    AppSyncPlatformInterface.instance.initMethod(
      context,
      showNativeUI: showNativeUI,
      customWidget: customWidget,
    );
  }
}
