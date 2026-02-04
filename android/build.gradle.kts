// android/build.gradle.kts

// Repositorios globales
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Si estás usando subprojects para cambiar buildDirectory (opcional)
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

// ¡No pongas plugins ni dependencies aquí!
