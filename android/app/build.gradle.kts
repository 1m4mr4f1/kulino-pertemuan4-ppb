import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.warung_pos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            val keyAliasVal = keystoreProperties.getProperty("keyAlias")
            val keyPasswordVal = keystoreProperties.getProperty("keyPassword")
            val storeFileVal = keystoreProperties.getProperty("storeFile")
            val storePasswordVal = keystoreProperties.getProperty("storePassword")

            if (storeFileVal != null && file(storeFileVal).exists()) {
                keyAlias = keyAliasVal
                keyPassword = keyPasswordVal
                storeFile = file(storeFileVal)
                storePassword = storePasswordVal
            } else {
                initWith(getByName("debug"))
            }
        }
    }

    defaultConfig {
        applicationId = "com.example.warung_pos"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
