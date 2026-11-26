package com.kankoo.kankoo

import android.content.Context
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Handler
import android.os.Looper
import androidx.test.core.app.ActivityScenario
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import androidx.work.ListenableWorker
import androidx.work.testing.TestListenableWorkerBuilder
import io.flutter.plugin.common.MethodChannel
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import java.io.File
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

/** Real Keystore + SQLite + WorkManager worker + Flutter/SQLCipher with the Activity destroyed. */
@RunWith(AndroidJUnit4::class)
class NotificationBackgroundTest {
    @Test fun backgroundEngineCommitsBeforeRemovingEncryptedEvidence() {
        val context = InstrumentationRegistry.getInstrumentation().targetContext
        NotificationBridge.preferences(context).edit().clear().commit()
        ActivityScenario.launch(MainActivity::class.java).use {
            val deadline = System.currentTimeMillis() + 60000
            while (NotificationBridge.foregroundChannel == null && System.currentTimeMillis() < deadline) Thread.sleep(100)
            assertNotNull("Foreground startup did not complete", NotificationBridge.foregroundChannel)
            val initialized = CountDownLatch(1)
            val ok = AtomicBoolean(false)
            Handler(Looper.getMainLooper()).post {
                NotificationBridge.foregroundChannel!!.invokeMethod("initialize", null, object : MethodChannel.Result {
                    override fun success(result: Any?) { ok.set(result == true); initialized.countDown() }
                    override fun error(code: String, message: String?, details: Any?) { initialized.countDown() }
                    override fun notImplemented() { initialized.countDown() }
                })
            }
            assertTrue("Ledger initialization timed out", initialized.await(60, TimeUnit.SECONDS))
            assertTrue("Ledger initialization failed", ok.get())
        }
        assertFalse(NotificationBridge.activityPresent)
        assertNull(NotificationBridge.foregroundChannel)
        val prefs = NotificationBridge.preferences(context)
        // Synthetic alert from our own UID, selected only by this disposable test.
        // Production configure rejects the app's own package.
        prefs.edit().putBoolean("enabled", true).putStringSet("packages", setOf(context.packageName)).commit()
        val body = "Sent Rs.250.01 From HDFC Bank A/C *4521 To AWS On 26/11/26 Ref 528512345678"
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(NotificationChannel("capture-smoke", "Capture test", NotificationManager.IMPORTANCE_LOW))
        NotificationWork.gate.acquire()
        try {
            manager.notify(9127, Notification.Builder(context, "capture-smoke").setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle("Payment alert").setContentText(body).setWhen(1795674600000).build())
            val captureDeadline = System.currentTimeMillis() + 30000
            var count = 0
            while (count == 0 && System.currentTimeMillis() < captureDeadline) {
                NotificationInbox(context).use { count = it.count() }
                if (count == 0) Thread.sleep(100)
            }
            assertEquals("NotificationListenerService did not persist the alert", 1, count)
            val queuedFile = File(context.noBackupFilesDir, "notification-inbox-v1.sqlite")
            assertFalse(String(queuedFile.readBytes(), Charsets.ISO_8859_1).contains(body))
        } finally {
            NotificationWork.gate.release()
        }
        val worker = TestListenableWorkerBuilder<NotificationWork>(context).build()
        assertEquals(ListenableWorker.Result.success(), worker.doWork())
        NotificationInbox(context).use { assertEquals("Evidence was not acknowledged after commit", 0, it.count()) }
        assertFalse(prefs.getBoolean("processingError", true))
        assertTrue(prefs.getLong("lastProcessed", 0) > 0)
        // App documents SQLCipher file is not a plaintext SQLite database.
        val database = File(context.getDir("flutter", Context.MODE_PRIVATE), "kankoo.sqlite")
        assertTrue("Encrypted ledger missing", database.exists())
        val header = ByteArray(16)
        database.inputStream().use { it.read(header) }
        assertFalse(String(header, Charsets.ISO_8859_1).startsWith("SQLite format 3"))
        prefs.edit().putBoolean("enabled", false).commit()
        manager.cancel(9127)
    }
}
