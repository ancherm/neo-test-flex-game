pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        properties.getProperty("flutter.sdk")
            ?: error("flutter.sdk not set in local.properties")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // flutter-plugin-loader оставляем
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // объявляем версии плагинов для module-level plugin DSL:
    id("com.android.application")       version "8.7.0" apply false
    id("org.jetbrains.kotlin.android")  version "2.1.0" apply false
    id("com.google.gms.google-services")version "4.4.2" apply false
}

include(":app")
