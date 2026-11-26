package com.kankoo.kankoo

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.work.*
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Semaphore
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

class NotificationWork(context: Context, parameters: WorkerParameters) : Worker(context, parameters) {
    override fun doWork(): Result {
        if (!gate.tryAcquire()) return Result.retry()
        var engine: FlutterEngine? = null
        val main = Handler(Looper.getMainLooper())
        try {
            val prefs = NotificationBridge.preferences(applicationContext)
            if (!prefs.getBoolean("enabled", false)) return Result.success()
            NotificationInbox(applicationContext).use { inbox ->
                val batch = inbox.batch()
                if (batch.isEmpty()) return if (inbox.count(false) > 0) Result.retry() else Result.success()
                val finished = CountDownLatch(1)
                val committed = AtomicBoolean(false)
                val input = mapOf("records" to batch, "homeCurrency" to applicationContext
                    .getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                    .getString("flutter.currency.home", "INR"))
                main.post {
                    try {
                        val foreground = NotificationBridge.foregroundChannel
                        if (NotificationBridge.activityPresent) {
                            if (foreground == null) { finished.countDown(); return@post }
                            foreground.invokeMethod("consume", input, object : MethodChannel.Result {
                                override fun success(result: Any?) { committed.set(result == true); finished.countDown() }
                                override fun error(code: String, message: String?, details: Any?) { finished.countDown() }
                                override fun notImplemented() { finished.countDown() }
                            })
                        } else {
                            val loader = FlutterInjector.instance().flutterLoader()
                            loader.startInitialization(applicationContext)
                            loader.ensureInitializationComplete(applicationContext, null)
                            val background = FlutterEngine(applicationContext)
                            engine = background
                            MethodChannel(background.dartExecutor.binaryMessenger, NotificationBridge.CHANNEL)
                                .setMethodCallHandler { call, result ->
                                    when (call.method) {
                                        "ready" -> result.success(input)
                                        "complete" -> { committed.set(call.arguments == true); result.success(null); finished.countDown() }
                                        else -> result.notImplemented()
                                    }
                                }
                            background.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint(
                                loader.findAppBundlePath(), "notificationWorkerMain"))
                        }
                    } catch (_: Exception) { finished.countDown() }
                }
                if (!finished.await(120, TimeUnit.SECONDS) || !committed.get() || isStopped) {
                    prefs.edit().putBoolean("processingError", true).commit()
                    return Result.retry()
                }
                // Dart confirms only AFTER its SQLCipher transaction commits and DB closes (headless).
                inbox.acknowledge(batch.map { it["id"] as String })
                prefs.edit().putBoolean("processingError", false).putLong("lastProcessed", System.currentTimeMillis()).commit()
                if (inbox.count(false) > 0) enqueue(applicationContext)
                return Result.success()
            }
        } catch (_: Exception) {
            NotificationBridge.preferences(applicationContext).edit().putBoolean("processingError", true).commit()
            return Result.retry()
        } finally {
            val destroyed = CountDownLatch(1)
            main.post { try { engine?.destroy() } finally { destroyed.countDown() } }
            destroyed.await(10, TimeUnit.SECONDS)
            gate.release()
        }
    }
    companion object {
        val gate = Semaphore(1)
        fun enqueue(context: Context) {
            WorkManager.getInstance(context).enqueueUniqueWork("kankoo-notification-drain",
                ExistingWorkPolicy.APPEND_OR_REPLACE, OneTimeWorkRequestBuilder<NotificationWork>()
                    .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 10, TimeUnit.SECONDS).build())
        }
        fun recover(context: Context) {
            if (!NotificationBridge.preferences(context).getBoolean("enabled", false)) return
            WorkManager.getInstance(context).enqueueUniquePeriodicWork("kankoo-notification-recovery",
                ExistingPeriodicWorkPolicy.KEEP, PeriodicWorkRequestBuilder<NotificationWork>(15, TimeUnit.MINUTES).build())
            enqueue(context)
        }
    }
}
