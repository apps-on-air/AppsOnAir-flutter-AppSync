import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_sync_method_channel.dart';

abstract class AppSyncPlatformInterface extends PlatformInterface {
  AppSyncPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static AppSyncPlatformInterface _instance = AppSyncMethodChannel();

  static AppSyncPlatformInterface get instance => _instance;

  static set instance(AppSyncPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initMethod(
    BuildContext context, {
    bool showNativeUI = true,
    Widget? Function(Map<String, dynamic>)? customWidget,
  }) {
    throw UnimplementedError('initMethod() has not been implemented.');
  }
}
