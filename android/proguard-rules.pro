# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Kotlin metadata
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Facebook SDK
-keep class com.facebook.** { *; }
-dontwarn com.facebook.**

# Branch SDK
-keep class io.branch.** { *; }
-dontwarn io.branch.**

# Keep annotations
-keepattributes *Annotation*
