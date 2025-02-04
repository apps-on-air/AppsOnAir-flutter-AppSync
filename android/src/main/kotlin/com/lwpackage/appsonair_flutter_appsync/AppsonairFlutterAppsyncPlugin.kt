package com.lwpackage.appsonair_flutter_appsync

import android.app.Activity
import android.util.Log

import com.appsonair.appsync.interfaces.UpdateCallBack
import com.appsonair.appsync.services.AppSyncService

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import org.json.JSONObject

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
                        response?.let {
                            try {
                                val jsonObject = JSONObject(it)

                                // Remove maintenanceData
                                jsonObject.remove("maintenanceData")

                                val updateData = jsonObject.getJSONObject("updateData")

                                // Creating a new object with modified keys
                                val newUpdateData = JSONObject().apply {
                                    put("isUpdateEnabled", updateData.getBoolean("isAndroidUpdate"))
                                    put("buildNumber", updateData.getString("androidBuildNumber"))
                                    put("minBuildVersion", updateData.optString("androidMinBuildVersion", ""))
                                    put("updateLink", updateData.getString("androidUpdateLink"))
                                    put("isForcedUpdate", updateData.getBoolean("isAndroidForcedUpdate"))
                                }

                                // Updating the original JSON
                                jsonObject.put("updateData", newUpdateData)

                                // Returning the modified response
                                result.success(jsonObject.toString())
                            } catch (e: Exception) {
                                Log.e("JSONParsingError", "Error modifying updateData: ${e.message}")
                                result.error("JSON_ERROR", "Failed to process update data", null)
                            }
                        } ?: run {
                            result.error("NULL_RESPONSE", "Response is null", null)
                        }
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

