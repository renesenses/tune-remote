allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Greffons figes sur un vieux compileSdk.
//
// bonsoir_android 5.1.6 se compile contre l'API 33, mais ses propres
// dependances AndroidX (fragment 1.7.1, window 1.2.0, exifinterface 1.4.1)
// exigent 34 ou plus : sans ce relevement, `checkDebugAarMetadata` echoue avec
// 15 erreurs et l'APK ne se construit pas.
//
// On ne touche QUE le compileSdk des sous-projets, jamais le minSdk ni le
// targetSdk : la liste des appareils vises et le comportement d'execution ne
// changent pas. Le module `app` garde le compileSdk du SDK Flutter.
subprojects {
    if (name == "app") return@subprojects
    afterEvaluate {
        val android = extensions.findByName("android") ?: return@afterEvaluate
        runCatching {
            val current =
                android.javaClass.getMethod("getCompileSdkVersion").invoke(android) as? String
            val level = current?.removePrefix("android-")?.toIntOrNull() ?: 0
            if (level in 1..35) {
                android.javaClass
                    .getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                    .invoke(android, 36)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
