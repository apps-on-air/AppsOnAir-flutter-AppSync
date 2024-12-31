import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_sync_platform_interface.dart';

/// A method channel implementation for handling app sync functionality.
class AppSyncMethodChannel extends AppSyncPlatformInterface {
  /// The `BuildContext` used for dialogs.
  late BuildContext context;
  bool _dialogOpen = false;

  /// The method channel used for communication with the native platform.
  final methodChannel = const MethodChannel('appsOnAirAppSync');

  /// Initializes the method channel and listens to native method calls.
  ///
  /// - [context]: The `BuildContext` used for dialogs.
  /// - [showNativeUI]: Determines if the native UI dialog should be shown.
  /// - [customWidget]: A function that returns a custom widget for the dialog.
  @override
  Future<void> initMethod(
    BuildContext context, {
    bool showNativeUI = true,
    Widget? Function(Map<String, dynamic> response)? customWidget,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      this.context = context;
      _listenToNativeMethod();
      final appUpdateResponse = await _check(showNativeUI);
      if (customWidget != null) {
        final widget = customWidget.call(appUpdateResponse);

        /// Displays a custom UI dialog.
        if (!showNativeUI && widget != null) {
          _alertDialog(widget);
        }
      }
    });
  }

  /// Listens to native method calls from the platform for block Flutter UI interactions.
  void _listenToNativeMethod() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      methodChannel.setMethodCallHandler((call) {
        switch (call.method) {
          case "openDialog":
            _showIgnorePointerDialog();
            break;
          case "closeDialog":
            if (_dialogOpen) {
              _dialogOpen = false;
              _closeDialog();
            }
            break;
        }
        return Future.sync(() => _dialogOpen);
      });
    }
  }

  /// Displays a transparent dialog when a native dialog is open.
  void _showIgnorePointerDialog() {
    if (!_dialogOpen) {
      _dialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        barrierColor: Colors.transparent,
        builder: (context) => Container(
          color: Colors.transparent,
        ),
      );
    }
  }

  /// Closes the currently displayed dialog when a native dialog is close.
  void _closeDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// Displays an alert dialog with a custom widget.
  ///
  /// - [widget]: The widget to display inside the dialog.
  void _alertDialog(Widget widget) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: widget,
          ),
        );
      },
    );
  }

  /// Checks for app updates by invoking the native platform method.
  ///
  /// - [showNativeUI]: Determines if the native UI dialog should be shown.
  /// - Returns a [Map] containing the response from the native platform.
  Future<Map<String, dynamic>> _check(bool showNativeUI) async {
    String updateCheck = '';
    try {
      final result = await methodChannel.invokeMethod('isUpdateAvailable', {"showNativeUI": showNativeUI});
      if (result != null && result is String) {
        return Map<String, dynamic>.from(json.decode(result));
      } else if (result != null && result["error"] != null) {
        log(result["error"]);
      }
      return Map<String, dynamic>.from(((result ?? {}) as Map));
    } on PlatformException catch (e) {
      updateCheck = "Failed to check for update: '${e.message}'.";
    }
    if (kDebugMode) {
      print(updateCheck);
    }
    return {"exception": updateCheck};
  }
}
