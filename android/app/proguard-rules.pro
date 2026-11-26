# R8 rules for the release build (minify + resource shrinking).
# Flutter's own rules are added by the Flutter Gradle plugin; plugins ship
# consumer rules where they need them. These cover the gaps.

# Flutter references Play Core (deferred components) that this app doesn't use.
-dontwarn com.google.android.play.core.**

# background_downloader: WorkManager instantiates its workers by class name
# and task data is (de)serialised with kotlinx.serialization.
-keep class com.bbflight.background_downloader.** { *; }

# local_auth: BiometricPrompt callbacks.
-keep class androidx.biometric.** { *; }

# flutter_secure_storage: Tink / keystore-backed ciphers looked up reflectively.
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**

# Our MethodChannel handlers (SMS, device profile, FLAG_SECURE).
-keep class com.kankoo.kankoo.** { *; }

# SQLCipher, SQLite and LiteRT-LM are native libraries loaded through Dart FFI
# (no JNI classes to keep); enough_mail and drift are pure Dart.

# shared_preferences_android: its Pigeon channel handlers and the DataStore /
# protobuf classes they use must survive R8, or every SharedPreferences call
# fails at startup with a PlatformException (blank app, logo only).
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class androidx.datastore.** { *; }
-keep class androidx.datastore.preferences.protobuf.** { *; }
-keepclassmembers class * extends androidx.datastore.preferences.protobuf.GeneratedMessageLite { *; }
