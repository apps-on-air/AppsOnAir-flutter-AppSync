import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_sync_method_channel.dart';

/// An abstract base class for defining the platform interface of the App Sync plugin.
///
abstract class AppSyncPlatformInterface extends PlatformInterface {


  AppSyncPlatformInterface() : super(token: _token);

  /// A private token used to verify platform implementations.
  static final Object _token = Object();

  /// The default instance of [AppSyncPlatformInterface], which defaults
  /// to [AppSyncMethodChannel].
  ///
  static AppSyncPlatformInterface _instance = AppSyncMethodChannel();

  /// Gets the current instance of [AppSyncPlatformInterface].
  ///
  static AppSyncPlatformInterface get instance => _instance;

  /// Sets the current instance of [AppSyncPlatformInterface].
  ///
  static set instance(AppSyncPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initializes the platform-specific method for app sync.
  ///
  /// - [context]: A [BuildContext] used for dialogs and other UI elements.
  /// - [showNativeUI]: A boolean indicating whether to display the native UI dialog.
  ///   Defaults to `true`.
  /// - [customWidget]: An optional function that returns a custom widget for the dialog.
  ///
  /// Throws an [UnimplementedError] if the method is not implemented by a platform.
  Future<void> initMethod(
    BuildContext context, {
    bool showNativeUI = true,
    Widget? Function(Map<String, dynamic>)? customWidget,
  }) {
    throw UnimplementedError('initMethod() has not been implemented.');
  }
}
