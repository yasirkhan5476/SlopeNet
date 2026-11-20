# Preserve Flutter wrapper and embedding classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods intact
-keepclasseswithmembernames class * {
    native <methods>;
}

-keepattributes SourceFile,LineNumberTable
-keepattributes Signature,InnerClasses,EnclosingMethod

# Fix R8 missing Play Core classes referenced by Flutter engine
-dontwarn com.google.android.play.core.**

# Preserve Mapbox Maps SDK classes & native/JNI bridges
-keep class com.mapbox.** { *; }
-dontwarn com.mapbox.**

# Preserve Geolocator classes if needed
-keep class com.baseflow.geolocator.** { *; }