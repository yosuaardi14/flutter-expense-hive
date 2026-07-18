import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

val flutterSdk = localProperties.getProperty("flutter.sdk")
    ?: throw GradleException(
        "Flutter SDK not found. Define location with flutter.sdk in the local.properties file."
    )

val flutterVersionCode =
    localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1

val flutterVersionName =
    localProperties.getProperty("flutter.versionName") ?: "1.0"

val flutterTargetSdk =
    localProperties.getProperty("flutter.targetSdkVersion")?.toInt()
        ?: flutter.targetSdkVersion

val flutterCompileSdk =
    localProperties.getProperty("flutter.compileSdkVersion")?.toInt()
        ?: flutter.compileSdkVersion

android {
    namespace = "com.example.flutter_expense_app"
    compileSdk = flutterCompileSdk
    ndkVersion = flutter.ndkVersion//'27.0.12077973'

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_expense_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutterTargetSdk
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

//kotlin {
//    compilerOptions {
//        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
//    }
//}

flutter {
    source = "../.."
}
