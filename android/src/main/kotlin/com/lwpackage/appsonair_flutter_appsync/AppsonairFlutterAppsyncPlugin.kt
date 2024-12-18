package com.lwpackage.appsonair_flutter_appsync

import android.app.Activity

import com.appsonair.appsync.interfaces.UpdateCallBack
import com.appsonair.appsync.services.AppSyncService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class AppsonairFlutterAppsyncPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "appsOnAirAppSync")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "isUpdateAvailable") {
            val arguments: Map<String, Any> = call.arguments as? Map<String, Any> ?: emptyMap()
            var options: Map<String, Any> = emptyMap()

            if (arguments.isNotEmpty()) {
                options = arguments
            }

            AppSyncService.sync(
                activity,
                options = options,
                callBack =
                object : UpdateCallBack {
                    override fun onSuccess(response: String?) {
                        result.success(response)
                    }

                    override fun onFailure(message: String?) {
                        result.success(message)
                    }
                },
            )
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}

