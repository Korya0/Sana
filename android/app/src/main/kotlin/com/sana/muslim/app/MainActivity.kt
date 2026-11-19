package com.sana.muslim.app

// ⛔ DISABLED: Quran feature (quran_library / audio_service dependency removed).
// import com.ryanheise.audioservice.AudioServiceActivity

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var volumeButtonsEnabled = false
    private var volumeButtonsChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        volumeButtonsChannel =
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "sana/volume_buttons",
            ).also { channel ->
                channel.setMethodCallHandler { call, result ->
                    when (call.method) {
                        "setEnabled" -> {
                            volumeButtonsEnabled = call.arguments as? Boolean ?: false
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                }
            }
    }

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        val isVolumeKey =
            event.keyCode == KeyEvent.KEYCODE_VOLUME_UP ||
                event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN

        if (volumeButtonsEnabled && hasWindowFocus() && isVolumeKey) {
            if (event.action == KeyEvent.ACTION_DOWN && event.repeatCount == 0) {
                val direction =
                    if (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP) "up" else "down"
                volumeButtonsChannel?.invokeMethod("onVolumeButton", direction)
            }
            // Consume down, up and auto-repeat so the system volume never changes.
            return true
        }

        return super.dispatchKeyEvent(event)
    }

    override fun onPause() {
        // Safety net: never intercept volume keys while the activity is not active.
        volumeButtonsEnabled = false
        super.onPause()
    }

    override fun onDestroy() {
        volumeButtonsEnabled = false
        volumeButtonsChannel?.setMethodCallHandler(null)
        volumeButtonsChannel = null
        super.onDestroy()
    }
}
