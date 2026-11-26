package com.kankoo.kankoo

import android.app.Notification
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.service.notification.StatusBarNotification
import androidx.work.testing.TestListenableWorkerBuilder
import org.junit.After
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import java.io.File
import javax.crypto.KeyGenerator

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class NotificationInboxTest {
    private val context: Context get() = RuntimeEnvironment.getApplication()
    private val file get() = File(context.noBackupFilesDir, "notification-inbox-v1.sqlite")
    private val key = KeyGenerator.getInstance("AES").apply { init(256) }.generateKey()
    private val alert = "Rs.250.00 debited from HDFC A/c XX1234 to AWS. Ref 123456789012"
    @Before fun reset() { file.delete(); NotificationBridge.preferences(context).edit().clear().commit() }
    @After fun clean() { file.delete() }

    @Test fun encryptedQueueSurvivesReopenAndReplaysDeduplicate() {
        NotificationInbox(context, key).use {
            assertTrue(it.append("com.phonepe.app", "notification-1", 1795680000000, alert))
            assertFalse(it.append("com.phonepe.app", "notification-1", 1795680000000, alert))
            assertEquals(1, it.count())
        }
        assertFalse(String(file.readBytes(), Charsets.ISO_8859_1).contains("HDFC"))
        assertFalse(String(file.readBytes(), Charsets.ISO_8859_1).contains("com.phonepe"))
        NotificationInbox(context, key).use {
            assertEquals(alert, it.batch().single()["text"])
            // Reading is non-destructive; death before ledger commit cannot lose a row.
            assertEquals(1, it.count())
            val id = it.batch().single()["id"] as String
            it.acknowledge(listOf(id))
            assertEquals(0, it.count())
            it.acknowledge(listOf(id))
            assertEquals(0, it.count())
        }
    }
    @Test fun corruptedCiphertextIsRetainedAndOtherRecordsRemainReadable() {
        NotificationInbox(context, key).use {
            it.append("com.phonepe.app", "a", 1795680000000, alert)
            it.append("com.phonepe.app", "b", 1795680000001, "Second $alert")
        }
        SQLiteDatabase.openDatabase(file.path, null, SQLiteDatabase.OPEN_READWRITE).use { db ->
            db.execSQL("UPDATE inbox SET payload=X'010203' WHERE rowid=1")
        }
        NotificationInbox(context, key).use {
            assertEquals(1, it.batch().size)
            assertEquals(2, it.count())
            assertEquals(1, it.count(true))
            it.retryQuarantined()
            assertEquals(0, it.count(true))
            assertEquals(1, it.batch().size)
            assertEquals(1, it.count(true))
        }
    }
    @Test fun wrongKeyCannotReplaceOrDeleteEvidence() {
        NotificationInbox(context, key).use { it.append("com.phonepe.app", "a", 1795680000000, alert) }
        val other = KeyGenerator.getInstance("AES").apply { init(256) }.generateKey()
        NotificationInbox(context, other).use { assertTrue(it.batch().isEmpty()); assertEquals(1, it.count(true)) }
        NotificationInbox(context, key).use { it.retryQuarantined(); assertEquals(alert, it.batch().single()["text"]) }
    }
    @Test fun envelopeAuthenticationRejectsSwappedRows() {
        NotificationInbox(context, key).use {
            it.append("com.phonepe.app", "a", 1795680000000, alert)
            it.append("com.phonepe.app", "b", 1795680000001, alert)
        }
        SQLiteDatabase.openDatabase(file.path, null, SQLiteDatabase.OPEN_READWRITE).use {
            it.execSQL("UPDATE inbox SET payload=(SELECT payload FROM inbox WHERE rowid=1) WHERE rowid=2")
        }
        NotificationInbox(context, key).use { assertEquals(1, it.batch().size); assertEquals(1, it.count(true)) }
    }
    @Test fun validationDoesNotStoreTruncatedText() {
        NotificationInbox(context, key).use {
            try { it.append("com.phonepe.app", "a", 1, "x".repeat(NotificationInbox.MAX_TEXT_BYTES + 1)); fail() }
            catch (_: IllegalArgumentException) { }
            assertEquals(0, it.count())
            it.append("com.phonepe.app", "a", 1, alert)
            it.append("com.phonepe.app", "a", 2, alert)
            assertEquals(2, it.count()) // Two genuine same-value alerts retain distinct times.
        }
    }
    @Test fun listenerDoesNotCaptureWithoutConsentOrFromUnselectedApps() {
        val service = Robolectric.buildService(BankNotificationListener::class.java).create().get()
        val n = Notification.Builder(context, "test").setContentTitle("Payment").setContentText(alert).build()
        val sbn = StatusBarNotification("com.phonepe.app", "com.phonepe.app", 1, null, 0, 0, 0, n,
            android.os.Process.myUserHandle(), 1795680000000)
        service.onNotificationPosted(sbn)
        assertFalse(file.exists())
        NotificationBridge.preferences(context).edit().putBoolean("enabled", true)
            .putStringSet("packages", setOf("other.bank")).commit()
        service.onNotificationPosted(sbn)
        assertFalse(file.exists())
    }
    @Test fun interruptedShutdownAlwaysReleasesTheProcessingGate() {
        val worker = TestListenableWorkerBuilder<NotificationWork>(context).build()
        Thread.currentThread().interrupt()
        try { worker.doWork() } catch (_: InterruptedException) { }
        finally { Thread.interrupted() }
        assertTrue("Interrupted worker leaked the processing gate", NotificationWork.gate.tryAcquire())
        NotificationWork.gate.release()
    }
    @Test fun malformedNotificationDoesNotCrashTheListenerOrWritePlaintext() {
        val service = Robolectric.buildService(BankNotificationListener::class.java).create().get()
        NotificationBridge.preferences(context).edit().putBoolean("enabled", true)
            .putStringSet("packages", setOf("com.phonepe.app")).commit()
        val n = Notification.Builder(context, "test").build()
        n.extras = null
        service.onNotificationPosted(StatusBarNotification("com.phonepe.app", "com.phonepe.app", 1, null,
            0, 0, 0, n, android.os.Process.myUserHandle(), 1795680000000))
        assertTrue(NotificationBridge.preferences(context).getBoolean("captureError", false))
        assertFalse(file.exists())
    }
}
