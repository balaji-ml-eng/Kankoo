package com.kankoo.kankoo

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

class BankNotificationListener : NotificationListenerService() {
    override fun onListenerConnected() {
        try { NotificationWork.recover(applicationContext) } catch (_: Exception) {
            NotificationBridge.preferences(this).edit().putBoolean("captureError", true).commit()
        }
        // Android can redeliver active notifications after reconnect; identities deduplicate them.
        try { activeNotifications?.forEach { onNotificationPosted(it) } } catch (_: Exception) {
            NotificationBridge.preferences(this).edit().putBoolean("captureError", true).commit()
        }
    }
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val prefs = NotificationBridge.preferences(this)
        if (!prefs.getBoolean("enabled", false) ||
            !prefs.getStringSet("packages", emptySet())!!.contains(sbn.packageName)) return
        if ((sbn.notification.flags and Notification.FLAG_GROUP_SUMMARY) != 0) return
        try {
            val extras = sbn.notification.extras
            val body = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
                ?: extras.getCharSequence(Notification.EXTRA_TEXT)?.toString().orEmpty()
            val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString().orEmpty()
            val text = listOf(title, body).filter { it.isNotBlank() }.distinct().joinToString("\n")
            if (text.isBlank()) return
            // Commit encrypted evidence BEFORE enqueueing work or returning from this callback.
            NotificationInbox(this).use {
                it.append(sbn.packageName, sbn.key, sbn.notification.`when`.takeIf { t -> t > 0 } ?: sbn.postTime, text)
            }
            NotificationWork.enqueue(this)
        } catch (_: Exception) {
            // No message text, key material or exception details in logs/preferences.
            prefs.edit().putBoolean("captureError", true).commit()
        }
    }
}
