package com.kankoo.kankoo

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import org.json.JSONObject
import java.io.File
import java.security.KeyStore
import java.security.MessageDigest
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/** Financial text is only ever persisted as authenticated ciphertext, including SQLite journals. */
class NotificationInbox(private val context: Context, private val suppliedKey: SecretKey? = null) : AutoCloseable {
    private val database: SQLiteDatabase = SQLiteDatabase.openOrCreateDatabase(
        File(context.noBackupFilesDir, "notification-inbox-v1.sqlite"), null
    ).apply {
        execSQL("CREATE TABLE IF NOT EXISTS inbox (id TEXT PRIMARY KEY, payload BLOB NOT NULL, state INTEGER NOT NULL DEFAULT 0)")
    }

    private fun key(): SecretKey = suppliedKey ?: synchronized(keyLock) {
        val store = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (store.getKey(KEY_ALIAS, null) as? SecretKey) ?: run {
            // Never replace a missing key while unreadable evidence still exists.
            check(count() == 0) { "Notification key unavailable" }
            KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore").apply {
                init(KeyGenParameterSpec.Builder(KEY_ALIAS, KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                    .setBlockModes(KeyProperties.BLOCK_MODE_GCM).setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                    .setKeySize(256).build())
            }.generateKey()
        }
    }

    fun append(packageName: String, notificationKey: String, timestamp: Long, text: String): Boolean {
        require(packageName.isNotBlank() && notificationKey.isNotBlank() && timestamp > 0)
        require(text.isNotBlank() && text.toByteArray(Charsets.UTF_8).size <= MAX_TEXT_BYTES)
        val identity = JSONObject().put("package", packageName).put("key", notificationKey)
            .put("timestamp", timestamp).put("text", text).toString()
        val id = MessageDigest.getInstance("SHA-256").digest(identity.toByteArray(Charsets.UTF_8))
            .joinToString("") { "%02x".format(it) }
        database.rawQuery("SELECT 1 FROM inbox WHERE id=?", arrayOf(id)).use { if (it.moveToFirst()) return false }
        val payload = JSONObject().put("id", id).put("package", packageName).put("receivedAt", timestamp)
            .put("text", text).toString().toByteArray(Charsets.UTF_8)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding").apply {
            init(Cipher.ENCRYPT_MODE, key()); updateAAD(id.toByteArray(Charsets.UTF_8))
        }
        val encrypted = byteArrayOf(1) + cipher.iv + cipher.doFinal(payload)
        val values = ContentValues().apply { put("id", id); put("payload", encrypted) }
        return database.insertWithOnConflict("inbox", null, values, SQLiteDatabase.CONFLICT_IGNORE) != -1L
    }

    /** Corrupt rows are quarantined, retained and counted; other evidence can still proceed. */
    fun batch(limit: Int = 20): List<Map<String, Any>> {
        require(limit in 1..100)
        val records = mutableListOf<Pair<String, ByteArray>>()
        database.rawQuery("SELECT id,payload FROM inbox WHERE state=0 ORDER BY rowid LIMIT ?", arrayOf(limit.toString())).use {
            while (it.moveToNext()) records.add(it.getString(0) to it.getBlob(1))
        }
        return records.mapNotNull { (id, bytes) ->
            try {
                check(bytes.size >= 30 && bytes[0] == 1.toByte())
                val cipher = Cipher.getInstance("AES/GCM/NoPadding").apply {
                    init(Cipher.DECRYPT_MODE, key(), GCMParameterSpec(128, bytes.copyOfRange(1, 13)))
                    updateAAD(id.toByteArray(Charsets.UTF_8))
                }
                val json = JSONObject(String(cipher.doFinal(bytes.copyOfRange(13, bytes.size)), Charsets.UTF_8))
                check(json.getString("id") == id)
                mapOf("id" to id, "package" to json.getString("package"), "text" to json.getString("text"),
                    "receivedAt" to json.getLong("receivedAt"))
            } catch (_: Exception) {
                database.execSQL("UPDATE inbox SET state=1 WHERE id=?", arrayOf(id))
                null
            }
        }
    }

    fun acknowledge(ids: List<String>) {
        database.beginTransaction()
        try {
            for (id in ids) { require(id.matches(Regex("[0-9a-f]{64}"))); database.delete("inbox", "id=? AND state=0", arrayOf(id)) }
            database.setTransactionSuccessful()
        } finally { database.endTransaction() }
    }
    fun count(quarantined: Boolean? = null): Int = database.rawQuery(
        "SELECT count(*) FROM inbox" + if (quarantined == null) "" else " WHERE state=${if (quarantined) 1 else 0}", null
    ).use { it.moveToFirst(); it.getInt(0) }
    fun retryQuarantined() { database.execSQL("UPDATE inbox SET state=0 WHERE state=1") }
    override fun close() = database.close()
    companion object {
        const val MAX_TEXT_BYTES = 65536
        private const val KEY_ALIAS = "kankoo.notification-inbox.aes.v1"
        private val keyLock = Any()
    }
}
