package com.kankoo.kankoo

import android.content.Context
import android.content.Intent
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/** Settings/status only: queue text is exposed solely to the background consumer. */
class NotificationBridge(private val context: Context, messenger: BinaryMessenger) : AutoCloseable {
    private val io = Executors.newSingleThreadExecutor()
    private val main = android.os.Handler(android.os.Looper.getMainLooper())
    private val channel = MethodChannel(messenger, CHANNEL)
    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "foregroundReady" -> { foregroundChannel = channel; result.success(null); NotificationWork.recover(context) }
                "waitIdle" -> io.execute {
                    NotificationWork.gate.acquire()
                    NotificationWork.gate.release()
                    main.post { result.success(null) }
                }
                "openSettings" -> {
                    context.startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                    result.success(null)
                }
                "status", "configure", "retry" -> io.execute {
                    try {
                        val prefs = preferences(context)
                        if (call.method == "configure") {
                            val enabled = call.argument<Boolean>("enabled") == true
                            val packages = call.argument<List<String>>("packages").orEmpty().toSet()
                            require(packages.all { it.matches(Regex("[a-zA-Z0-9_]+(\\.[a-zA-Z0-9_]+)+")) && it != context.packageName })
                            require(!enabled || packages.isNotEmpty())
                            check(prefs.edit().putBoolean("enabled", enabled).putStringSet("packages", packages).commit())
                            if (enabled) NotificationWork.recover(context)
                        }
                        NotificationInbox(context).use { inbox ->
                            if (call.method == "retry") {
                                inbox.retryQuarantined()
                                check(prefs.edit().putBoolean("captureError", false).commit())
                                NotificationWork.recover(context)
                            }
                            val state = mapOf("enabled" to prefs.getBoolean("enabled", false),
                                "accessGranted" to NotificationManagerCompat.getEnabledListenerPackages(context).contains(context.packageName),
                                "packages" to prefs.getStringSet("packages", emptySet())!!.toList().sorted(),
                                "pending" to inbox.count(false), "quarantined" to inbox.count(true),
                                "captureError" to prefs.getBoolean("captureError", false),
                                "processingError" to prefs.getBoolean("processingError", false),
                                "lastProcessed" to prefs.getLong("lastProcessed", 0))
                            main.post { result.success(state) }
                        }
                    } catch (_: Exception) { main.post { result.error("notification_storage", "Notification storage is unavailable; existing evidence was kept.", null) } }
                }
                else -> result.notImplemented()
            }
        }
    }
    override fun close() {
        if (foregroundChannel === channel) foregroundChannel = null
        channel.setMethodCallHandler(null); io.shutdown()
    }
    companion object {
        const val CHANNEL = "kankoo/notification-inbox"
        @Volatile var foregroundChannel: MethodChannel? = null
        @Volatile var activityPresent = false
        fun preferences(context: Context) = context.getSharedPreferences("notification-capture-v1", Context.MODE_PRIVATE)
    }
}
