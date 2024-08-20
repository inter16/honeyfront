package com.honeycombo.app.name

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "your.channel.name/foreground_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startForegroundService") {
                val intent = Intent(this, YourForegroundService::class.java)
                startForegroundService(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}