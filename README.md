pmdm_2526_multimedia

Multimedia.
Imagen

Display images from the internet

Para mostrar imágenes Flutter recomienda usar el widget Image
- Formatos

Image puede mostrar los siguientes formatos: JPEG, PNG, GIF, WebP, BMP y WBMP
- Cargar imagen desde los recursos

  Añadir archivo de imagen al proyecto:
  assets/images/image01.jpg
  Cargar imagen

  Image.asset(
  'assets/images/image01.jpg',
  )

- Cargar imagen desde URL

  Añadir permiso de Internet

<manifest ...">
<uses-permission android:name="android.permission.INTERNET"/>
<application ...

    Cargar imagen

Image.network(
'https://picsum.photos/id/1/3500',
)

- Cargar imagen desde memoria

  Permite carga una imagen a partir de una lista de enteros de 8 bits sin signo.
  Cargar imagen

  Uint8List bytes;
  ...    
  Image.memory(
  bytes,
  )

- Opciones de Image

  Especificar ancho y alto de la imagen.

  width: 300,
  height: 200,

  Encajar la imagen dentro del espacio del widget.

  fit: BoxFit.x,

  Colorear la imagen.

  color: Colors.x,
  colorBlendMode: BlendMode.x,

- Fundido de imágenes con un marcador de posición

Fade in images with a placeholder

Para mostrar una imagen que hace de marcador de posición mientras se carga la imagen de destino y luego se desvanece en la nueva imagen cuando se carga, Flutter recomienda usar el widget FadeInImage

    Placeholder + FadeIn

FadeInImage.assetNetwork(
placeholder: 'assets/images/espere.webp',
image: 'https://picsum.photos/id/1/3500',  
)

Imagen (con caché en disco)

cached_network_image

Usar Image.network para cargar imágenes de Internet tiene el problema que no hace caché de disco, solo en memoria.
Al cerrar la aplicación e intentar cargar una imagen ya anteriormente cargada se la vuelve a descargar.
Esto conlleva más tráfico, más lentitud y, en definitiva, una peor experiencia de usuario.

Con el plugin cached_network_image se consigue caché de disco y otras mejoras como el control de errores.
- Añadir librería

flutter pub add cached_network_image

- Cargar imagen de Internet

  CachedNetworkImage(
  imageUrl: 'https://picsum.photos/id/1/3500',
  ),

- Progreso y control de errores

  CachedNetworkImage(
  imageUrl: 'https://picsum.photos/id/1/3500',
  placeholder: (context, url) => Center(
  child: CircularProgressIndicator(),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),   
  ),

- Caché

Por defecto, las imágenes se almacenan en el directorio de caché temporal del sistema operativo (Android o iOS).
Android: Generalmente en /data/data/com.tu.paquete/cache/libCachedNetworkImage.
iOS: En la carpeta Library/Caches de la aplicación.
Web: Utiliza IndexedDB del navegador para persistir las imágenes.

Se borra de forma automática o se puede forzar de forma manual:

DefaultCacheManager().emptyCache()

También se puede ajustar lo que debe ocupar la imagen cacheada tanto en disco como en memoria:

CachedNetworkImage(
...
maxHeightDiskCache: X,
memCacheHeight: X,
),

Imagen (SVG)

flutter_svg

Flutter no incluye soporte nativo para archivos SVG de forma predeterminada debido a decisiones de diseño de su motor gráfico (Skia / Impeller) y a la complejidad técnica que implica el estándar SVG.

Con el plugin flutter_svg se consigue mostrar archivos SVG desde los recursos, Internet, memoría, cadena de texto, etc.
- Añadir librería

flutter pub add flutter_svg

- Cargar imagen de los recursos

  SvgPicture.asset(
  'assets/images/svg/basketball.svg',
  ),

- Cargar imagen de Internet

  SvgPicture.network(
  'https://www.svgrepo.com/show/535115/alien.svg',
  ),

- Configuración SVG recomendada para Adobe Illustrator

  Estilo:
  Atributos de presentación en lugar de CSS en línea, ya que CSS no es totalmente compatible.
  Imágenes:
  Incrustar, no vincular a otro archivo, para obtener un único SVG sin dependencia de otros archivos.
  Id de objetos:
  Nombres de capa para agregar cada nombre de capa a las etiquetas SVG o puede usar el formato mínimo.
  Decimales:
  2
  Marcar Minify y Responsive

- Vector Graphics

Vector Graphics es un formato binario intermedio (vec) que actúa como un puente entre un archivo de diseño (como un SVG) y el motor de renderizado de Flutter.
Diseñado para solucionar los problemas históricos del formato SVG (XML, metadatos, espacios: lento).
- De SVG a VEC

vector_graphics_compiler
vector_graphics

    Instalar vector_graphics_compiler como un ejecutable

dart pub global activate vector_graphics_compiler

    Convertir un SVG a VEC en la línea de comandos

dart run vector_graphics_compiler -i assets/foo.svg -o assets/foo.vec

    Si surgen problemas al convertir se puede indicar que no intente optimizar

dart run vector_graphics_compiler --no-optimize-overdraw --no-optimize-masks -i assets/foo.svg -o assets/foo.vec

    Ej. SVG: 15,6MB (en XML) => VEC: 8.9MB (en binario)

dart run vector_graphics_compiler --no-optimize-overdraw --no-optimize-masks -i assets/images/svg/amhara_topographic_map.svg -o assets/images/svg/amhara_topographic_map.vec

    Cargar el .vec en lugar del .svg
    Se puede usar un SvgPicture o un VectorGraphic pero que utilizar AssetBytesLoader para leer los bytes del .vec

SvgPicture(
AssetBytesLoader('assets/images/svg/amhara_topographic_map.vec'),   
),

Vídeo

Play and pause a video
Video Player plugin for Flutter

Para mostrar vídeo en Flutter vamos a usar evideo_player es un plugin oficial de Flutter que permite reproducir vídeos dentro de una aplicación multiplataforma (Android, iOS, macOS y Web).

No soporta ni Windows ni Linux. Para ello podríamos usar el plugin: media_kit
- Añadir librería

flutter pub add video_player

- Formatos

Video Player usa, en cada plataforma, de forma interna un reproductor para mostrar los vídeos. Eso determina los formatos de vídeo que se pueden reproducir.

    En iOS y macOS, usa AVPlayer.
    En Android, usa ExoPlayer. Formatos compatibles.
    En Web, usa el plugin video_player_web. Los formatos compatibles dependen del navegador y versión del usuario.

- Crear un controlador

VideoPlayerController class

late VideoPlayerController _videoPlayerController;
...
@override
void initState() {
...
_videoPlayerController = VideoPlayerController.x(...);    
}

@override
void dispose() {
_videoPlayerController.dispose();
...
}

- Cargar el vídeo

late Future<void> _resInitializeVideoPlayer;
...
@override
void initState() {
...
_resInitializeVideoPlayer = _initializeVideoPlayer();    
}

Future<void> _initializeVideoPlayer() async {
await _videoPlayerController.initialize();
_videoPlayerController.play(); // reproducir el vídeo al cargar
}

- Mostrar el vídeo

VideoPlayer class

    Utilizar un FutureBuilder para esperar que el vídeo se cargue.
    Comprobar si el estado no es done para mostrar un indicador de carga.
    Cuando el estado sea done, comprobar si ha habido errores.
    Si no hay errores, mostrar el vídeo en un widget VideoPlayer.
    Encerrar VideoPlayer dentro de un AspectRatio para asegurar que la proporción del vídeo sea la correcta.

FutureBuilder(
future: _resInitializeVideoPlayer,
builder: (context, snapshot) {
if (snapshot.connectionState == .done) {
if (snapshot.hasError) {
return Text(snapshot.error.toString());
} else {           
return AspectRatio(
aspectRatio: _videoPlayerController.value.aspectRatio,
child: VideoPlayer(_videoPlayerController),
)
}
} else {
return const Center(child: CircularProgressIndicator());
}
},
)

- Controlar el vídeo

  Pausar la reproducción

  _videoPlayerController.pause();

  Reanudar la reproducción

  _videoPlayerController.play();

  Cambiar la posición actual

  _videoPlayerController.seekTo(.zero);

  Detectar cambios en la reproducción del vídeo

  _videoPlayerController.addListener(() {
  bool isPlaying = _videoPlayerController.value.isPlaying;
  bool isFinished = _videoPlayerController.value.position >= _videoPlayerController.value.duration;

  ...    
  });

- Cargar vídeo desde los recursos

  Añadir archivo del vídeo al proyecto:
  assets/videos/steamboat_willie.mp4
  Modificar pubspec.yaml para que use los archivos de vídeo:

flutter:
assets:
- assets/videos/

    Crear VideoPlayerController a partir de un asset:

_videoPlayerController = VideoPlayerController.asset(
'assets/videos/steamboat_willie.mp4',
);

- Cargar vídeo desde URL

  Añadir permiso de Internet

<manifest ...">
<uses-permission android:name="android.permission.INTERNET"/>
<application ...

    Crear VideoPlayerController a partir de una URL:

_videoPlayerController = VideoPlayerController.networkUrl(
Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
);

Vídeo (YouTube)

youtube_explode_dart

No se puede reproducir un vídeo de YouTube usando su URL. Hay que obtener primero la URL del vídeo en formato mp4.
- Añadir librería

dart pub add youtube_explode_dart

- Crear objeto para acceder a la información del vídeo

  final youtubeExplode = YoutubeExplode();

- Obtener información de un vídeo determinado

  final videoId = 'bV0RAcuG2Ao';

  final streamManifest = await youtubeExplode.videos.streams.getManifest(
  videoId,
  );

- Obtener el stream que contenga audio y vídeo y que sea el de mayor calidad

  final muxedWithHighestBitrate = streamManifest.muxed.withHighestBitrate();

- Obtener URI para usar con VideoPlayer

  final uri = muxedWithHighestBitrate.url;

Seleccionar una imagen

image_picker

Para seleccionar una imagen existente de la galería o una nueva con la cámara vamos a usar el plugin image_picker.
- Añadir librería

flutter pub add image_picker

- Añadir permisos

  Android
  No es necesario realizar ninguna acción.
  iOS Añadir a ios/Runner/Info.plist NSPhotoLibraryUsageDescription, NSCameraUsageDescription y NSMicrophoneUsageDescription. Ej: NSPhotoLibraryUsageDescription Esta aplicación necesita acceso a la galería para que puedas seleccionar fotos. NSCameraUsageDescription Esta aplicación necesita acceso a la cámara para que puedas tomar fotos. NSMicrophoneUsageDescription Esta aplicación necesita acceso al micrófono para grabar el audio de tus videos.
  macOS
  Añadir a los macos/Runner/DebugProfile.entitlements y Release.entitlements:
  com.apple.security.files.user-selected.read-only
  web
  No es necesario realizar ninguna acción.

- Crear objeto ImagePicker

  final ImagePicker picker = ImagePicker();

- Seleccionar una imagen de la galería.

pickImage() puede devolver nulo si no se selecciona ninguna imagen. Devuelve un objeto XFile. En xFile.path se obtiene la ruta de la imagen.

XFile? xFile = await picker.pickImage(source: .gallery);
String? path = xFile?.path;

Opciones:

    maxHeight y maxWidth
    Devuelve una imagen con esas dimensiones máximas. Si la original es más ancha o alta la reduce proporcionalmente.
    imageQuality
    Calidad de la imagen si soporta compresión. null o no indicaarlo devuelve la calidad original. Un rango de 0 a 100.

picker.pickImage(
...
maxHeight: 720,
maxWidth: 720,
imageQuality: 90,
)

- Mostrar la imagen

Se puede mostrar utilizando el widget Image mediante Image.file().
Antes hay que crear un File a partir de la ruta de la imagen.

Image.file(
File(path),
),

- Mostrar la imagen en web

En web se puede mostrar utilizando el widget Image pero mediante Image.network().
Para comprobar si se está en web se puede usar la constante kIsWeb de la librería foundation.

kIsWeb ? Image.network(path) : Image.file(...);

- Seleccionar una imagen de la cámara.

De la misma forma se puede obtener una imagen nueva con la cámara.

XFile? xFile = await picker.pickImage(source: .camera);
String? path = xFile?.path;

Opciones:

    maxHeight, maxWidth y imageQuality
    Igual que al obtener una imagen de la galería.
    preferredCameraDevice
    Para elegir la cámara inicial (delantera o trasera)

picker.pickImage(
...
preferredCameraDevice: .rear,
)

Notas:

    Por defecto, obtener una imagen de la cámara no funciona directamente en Linux, macOS, Web y Windows.

- Persistencia en Android e iOS

"Las imágenes (y los vídeos seleccionados con la cámara) se guardan en la caché local de la aplicación, por lo que solo estarán disponibles temporalmente.
Si necesita que la imagen seleccionada se almacene permanentemente, es su responsabilidad moverla a una ubicación más permanente."
Permisos

En la mayoría de los sistemas operativos, los permisos no se otorgan únicamente al instalar las aplicaciones.
Los desarrolladores deben solicitar algunos permisos al usuario mientras la aplicación se ejecuta.

permission_handler

El plugin permission_handler proporciona una API multiplataforma (iOS, Android) para solicitar permisos y comprobar su estado.
También permite abrir la configuración de la aplicación del dispositivo para que los usuarios puedan concederlos.
En Android, se puede justificar la solicitud de permiso.
- Añadir librería

flutter pub add permission_handler

- Añadir permisos
  Android

  Listado de permisos en Android
  Todos los permisos 'dangerous' hay que añadirlos al manifest y comprobarlos en tiempo de ejecución. Ej:
  El permiso INTERNET es normal => hay que añadirlo al manifest pero no es necesario comprobarlo en tiempo de ejecución.
  El permiso ACCESS_FINE_LOCATION es dangerous => hay que añadirlo al manifest y es necesario comprobarlo en tiempo de ejecución.

  <manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

iOS

    Los permisos hay que añadirlos al archivo ios/Runner/Info.plist

<key>NSLocationWhenInUseUsageDescription</key>
<string>Necesitamos tu ubicación para mostrarte los servicios cercanos mientras usas la app.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Necesitamos tu ubicación incluso en segundo plano.</string>

    Además, para que funcione permission_handler, hay que añadir los permisos que se quiera utilizar en ios/Podfile

post_install do |installer|
installer.pods_project.targets.each do |target|
flutter_additional_ios_build_settings(target)

    target.build_configurations.each do |config|      
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',

        'PERMISSION_LOCATION_WHENINUSE=1',
      ]
    end

end
end

- Solicitar / Comprobar el estado de los permisos

  El de un permiso

  final status = await Permission.contacts.request();

  El estado de un grupo de permisos

  Map<Permission, PermissionStatus> statuses = await [
  Permission.location,
  Permission.storage,
  ].request();

Obtener información extra de la imagen

En ciertas ocasiones se hace interesante obtener información extra de la imagen: los datos EXIF.
EXIF (Exchangeable Image File Format) son metadatos incrustados en archivos de imagen digitales que almacenan información detallada sobre la toma, como fecha, hora, ajustes de cámara (apertura, velocidad ISO, obturador), modelo del dispositivo, lente, y hasta ubicación GPS.

Para ello, en Android e iOS, podemos utilizar el plugin native_exif
- Añadir librería

flutter pub add native_exif

- Añadir permisos
  Android

  Si se quiere obtener las coordenadas en las que fue tomada la imagen habrá que:
  Añadir el permiso ACCESS_MEDIA_LOCATION al manifiesto.
  Comprobar el estado del permiso Permission.accessMediaLocation en tiempo de ejecución.

iOS

    No es necesario hacer nada.

- Obtener la información EXIF

  Obtener la información EXIF a partir de la ruta de la imagen.

  final exif = await Exif.fromPath(xFile.path);

- Orientación

  Unos de los datos EXIF importantes es la orientación de la imagen.

  final exifAtributeOrientation = _exifAtributes?['Orientation']?.toString();

  1 significa que la imagen está en la orientación correcta (arriba es arriba, izquierda es izquierda).
  Pero los valores del 2 al 8 indican que la imagen está girada y/o volteada. Ver el método _orientationToText(String orientation) del proyecto.
  Algunos dispositivos guardan las imágenes de forma horizontal e indican en el atributo Orientation si está girada.
  Esto es muy importante para saber cómo mostrar la imagen y, por ejemplo, a la hora de enviar la imagen a un servidor.

- Corregir orientación

Se podría girar la imagen de forma manual pero es más sencillo usar la librería flutter_exif_rotation.

    Corregir orientación si es la orientación normal

if (exifAtributeOrientation != '1') {
imagePath = (await FlutterExifRotation.rotateImage(path: xFile.path)).path;
}

    En imagePath está la ruta del archivo corregido.







pmdm_2526_publicar

A new Flutter project.
Flutter Launcher Icons
Instalar

flutter pub add flutter_launcher_icons

Añade el paquete flutter_launcher_icons al proyecto.
Crear archivo de configuración

dart run flutter_launcher_icons:generate

Genera archivo de configuración flutter_launcher_icons.yaml con valores por defecto.
Añadir imágenes que vayan a utilizarse como iconos

Copiar archivos .png en una carpeta (p.ej. en assets/)
Establecer configuración

Modificar flutter_launcher_icons.yaml con la configuración que deseemos
Generar iconos para las diversas plataformas

dart run flutter_launcher_icons
Firmar la aplicación
Certificado de depuración
Obtener huellas del certificado de depuración

    Windows

keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

    macOS / Linux

keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

SHA1: F2:00:EE:56:04:C7:33:FB:11:F4:95:2A:6C:31:58:4F:XX:XX:XX:XX
SHA256: 58:BD:4C:70:BF:97:96:63:18:21:4D:1F:B8:C9:B4:98:A4:B3:CE:05:2F:7C:F0:53:B0:B4:3C:5B:XX:XX:XX:XX
Certificado de subida
Crear certificado de subida

    De forma genérica:

keytool -genkey -v -keystore <DESTINO> -keyalg RSA -keysize <TAMAÑO> -validity <VALIDEZ> -alias <ALIAS>

: ubicación del almacén de claves.
<TAMAÑO>: número de bits de la clave criptográfica. 2048 recomendado.
: validez en días. 10000 (+de 27 años). Google recomienda += 25 años (si caduca antes no se podría actualizar la app).
: alias para esta aplicación.

    Windows

keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
keytool -list -v -alias androiddebugkey -keystore $env:USERPROFILE\.android\debug.keystore -storepass android -keypass android


    macOS / Linux

keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
Hacer referencia al almacén de claves desde la aplicación

    Crear archivo android/key.properties

    storePassword=<contraseña del keystore>  
    keyPassword=<contraseña del alias (clave)>  
    keyAlias=<nombre del alias dentro del keystore>  
    storeFile=<ruta al archivo keystore (relativa a android/ o absoluta)>

Configurar la firma en Gradle

    android/app/build.gradle.kts

// importar librerías necesarias
import java.util.Properties
import java.io.FileInputStream

plugins {
...
}

// cargar archivo de propiedades

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("<ruta al archivo key.properties relativa a android>")
if (keystorePropertiesFile.exists()) {
keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
...

// crear configuración de firma de lanzamiento
signingConfigs {
create("release") {
keyAlias = keystoreProperties["keyAlias"] as String
keyPassword = keystoreProperties["keyPassword"] as String
storeFile = keystoreProperties["storeFile"]?.let { file(it) }
storePassword = keystoreProperties["storePassword"] as String
}
}

// indicar que, en lanzamiento, use la configuración de firma de lanzamiento
buildTypes {
release {
signingConfig = signingConfigs.getByName("release")
}
}

...

    Generar APK para probar

flutter build apk --release
Revisar la aplicación
Revisar el manifiesto de la aplicación

    android/app/src/main/AndroidManifest.xml

Nombre de la aplicación:
manifest > application > android:label

Permisos de la aplicación:
manifest > <uses-permission ...
Revisar la configuración de la compilación

    android/app/build.gradle.kts

android {
namespace = "<com.dominio.app>"

    ...

    defaultConfig {
        applicationId = "<com.dominio.app>"

Actualizar el número de versión de la aplicación

    pubspec.yaml

version: x.y.z+n
Construir la aplicación para su lanzamiento
Construir un APK

    1 solo archivo para todas las plataformas.

flutter build apk  
✓ Built build/app/outputs/flutter-apk/app-release.apk (42.4MB)

    1 archivo por plataforma.

flutter build apk --split-per-abi
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (12.6MB)     
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (15.3MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (16.6MB)

    1 archivo por plataforma con ofuscación de código.

flutter build apk --split-per-abi  --split-debug-info=<directorio donde guardar los mapas de símbolos>
✓ Built build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (12.0MB)
✓ Built build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (14.8MB)
✓ Built build/app/outputs/flutter-apk/app-x86_64-release.apk (16.1MB)

Instalar un APK en un dispositivo conectado

flutter install
Construir un AAB

    1 archivo por plataforma con ofuscación de código.

flutter build appbundle --split-debug-info=<directorio donde guardar los mapas de símbolos>
✓ Built build/app/outputs/bundle/release/app-release.aab (38.0MB)










pmdm_2526_firebase

Firebase
Firebase

Firebase - Overview

Firebase es una plataforma de desarrollo de aplicaciones Backend-as-a-Service (BaaS) que proporciona servicios de backend alojados, como una base de datos en tiempo real, almacenamiento en la nube, autenticación, informes de fallos, aprendizaje automático, configuración remota y alojamiento para sus archivos estáticos.
Agregar Firebase a una app

Agregar Firebase a tu app de Flutter
- Firebase CLI

Referencia de Firebase CLI

Firebase CLI (Command Line Interface) proporciona una variedad de herramientas para administrar, implementar y visualizar en proyectos de Firebase desde la línea de comandos.

    Instalar

Windows

-OPCIÓN: NPM

=> Instalar nvm (Node Version Manager)

-Ir a coreybutler/nvm-windows > Assets > Descargar nvm-setup.exe (5.35 MB)
-Ejecutar
-Instalar todo por defecto
-Cerrar PowerShell
-Abrir "Símbolo del sistema" y comprobar

> nvm version
1.2.2

=> Instalar una versión LTS de Node:

-Ir a Node.js para ver cuál es la última versión LTS: 24.13.0
-Abrir "Símbolo del sistema" e Instalar

> nvm install 24.13.0

-Activar

> nvm use 24.13.0

-Comprobar node

> node -v
v24.13.0

-Comprobar npm

> npm -v
11.6.2

=> Instala Firebase CLI a través de npm: -Abrir "Símbolo del sistema" e Instalar

> npm install -g firebase-tools

-Comprobar

> firebase -V
15.4.0

-OPCIÓN: Objeto binario independiente

Descargar e instalar

macOS / Linux

% curl -sL https://firebase.tools | bash

Si todo ha ido bien mostrará algo similar a:

-- Setting permissions on binary... /usr/local/bin/firebase
-- Checking your PATH variable...
-- firebase-tools@15.2.1 is now installed
-- All Done!

    Acceder

% firebase login

Seguir los pasos
Aceptar condiciones

✔  Success! Logged in as antoniojose.garcia8@murciaeduca.es

    Listar proyectos de Firebase

% firebase projects:list

Si no tenemos ningún proyecto creado nos saldrá

No projects found.

    Actualizar CLI de Firebase

Windows

Descargar la versión nueva y reemplázarla en el sistema.

macOS / Linux

% curl -sL https://firebase.tools | upgrade=true bash

- FlutterFire CLI

FlutterFire CLI
Complementos disponibles de FlutterFire

Una CLI (Command Line Interface) que ayuda a usar FlutterFire en las aplicaciones Flutter.

FlutterFire es el conjunto oficial de complementos (plugins) de código abierto que permiten integrar las aplicaciones desarrolladas en Flutter con los servicios de Firebase.

    Instalar

%  dart pub global activate flutterfire_cli

No se debe olvidar añadir flutterfire al path del sistema operativo.
- Configurar la app para usar Firebase

Configura tus apps para usar Firebase

Usar la CLI de FlutterFire para configurar la app de Flutter para conectarte a Firebase.

    Desde el directorio del proyecto de Flutter, ejecutar el siguiente comando para iniciar el flujo de trabajo de configuración de la app

% flutterfire configure

Si no hay proyectos creados en Firebase lo dirá y pedirá un id para crear un proyecto nuevo.

i Found 0 Firebase projects.                                                                                                                                                                                                                                                                                         
? Enter a project id for your new Firebase project (e.g. my-cool-project) ›  pmdm-2526-firebase
i New Firebase project pmdm-2526-firebase created successfully.

Si hay proyectos creados en Firebase los mostrará para seleccionar uno.
Con las flechas del teclado nos podemos mover arriba y abajo en la lista. Con la tecla espacio podemos seleccionar un proyecto.
También se puede crear uno nuevo.

i Found 1 Firebase projects.                                                                                                                                                                                                                                                                                         
? Select a Firebase project to configure your Flutter application with ›                                                                                                                                                                                                                                             
❯ pmdm-2526-firebase (pmdm-2526-firebase)                                                                                                                                                                                                                                                                            
<create a new project>

Pide que indiquemos las plataformas compatibles con la app.
Con las flechas del teclado nos podemos mover arriba y abajo en la lista. Con la tecla espacio podemos de/seleccionar una plataforma.
Dejarlas todas marcadas y pulsar intro.

? Which platforms should your configuration support (use arrow keys & space to select)? ›                                                                                                                                                                                                                            
✔ android                                                                                                                                                                                                                                                                                                            
✔ ios                                                                                                                                                                                                                                                                                                                
✔ macos                                                                                                                                                                                                                                                                                                              
✔ web                                                                                                                                                                                                                                                                                                                
✔ windows

Informa que ha registrado todas las plataformas en Firebase.

i Firebase android app com.example.pmdm_2526_firebase is not registered on Firebase project pmdm-2526-firebase.                                                                                                                                                                                                      
i Registered a new Firebase android app on Firebase project pmdm-2526-firebase.

i Firebase ios app com.example.pmdm2526Firebase is not registered on Firebase project pmdm-2526-firebase.                                                                                                                                                                                                            
i Registered a new Firebase ios app on Firebase project pmdm-2526-firebase.

i Firebase macos app com.example.pmdm2526Firebase registered.

i Firebase web app pmdm_2526_firebase (web) is not registered on Firebase project pmdm-2526-firebase.                                                                                                                                                                                                                
i Registered a new Firebase web app on Firebase project pmdm-2526-firebase.

i Firebase windows app pmdm_2526_firebase (windows) is not registered on Firebase project pmdm-2526-firebase.                                                                                                                                                                                                        
i Registered a new Firebase windows app on Firebase project pmdm-2526-firebase.

Tambien Informa que ha creado el archivo lib/firebase_options.dart de configuración de Firebase.

Firebase configuration file lib/firebase_options.dart generated successfully with the following Firebase apps:

Platform  Firebase App Id
web       1:869466723818:web:7f8904e6eec48143ab0e93
android   1:869466723818:android:6cbe68641ff06f03ab0e93
ios       1:869466723818:ios:4effe51022ff21daab0e93
macos     1:869466723818:ios:4effe51022ff21daab0e93
windows   1:869466723818:web:bf6ff6e3244f81e5ab0e93

En función de las plataformas seleccionadas, se crearán los archivos correspondientes.
-ios/Runner/GoogleService-Info.plist (nuevo)
-macos/Runner/GoogleService-Info.plist (nuevo)

En Android también añade el plugin de Gradle para el desarrollo de aplicaciones que utilizan servicios de Google o Firebase.
-app/google-services.json (nuevo)
-app/build.gradle.kts (modificado)
-settings.gradle.kts (modificado)

NOTA: Todos los ficheros nuevos creados desde la línea de comandos no se añaden al control de versiones de forma automática. No se debe olvidar añadirlos de forma manual desde IDE para evitar perderlos.

    Toda esta configuración se puede ver desde la consola de Firebase

https://console.firebase.google.com/project/<PROJECT_ID>/settings/general

En el ejemplo <PROJECT_ID> es pmdm-2526-firebase
- Inicializar Firebase en la app

Inicializa Firebase en tu app

    Desde el directorio del proyecto de Flutter, ejecutar el siguiente comando para instalar el plugin principal: firebase_core

% flutter pub add firebase_core

Esto añade firebase_core a pubspec.yaml

    Ejecutar el siguiente comando para asegurar que la configuración de Firebase de la app de Flutter esté actualizada

% flutterfire configure

Nos dirá que ya existe un archivo firebase.json y si lo queremos reusar: yes

    Modificar lib/main.dart para inicializar Firebase

...
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);

runApp(const MyApp());
}

Si hay algún error en la configuración se producirá una excepción.
Complementos de Firebase

Complementos disponibles

Los complementos de Firebase (comúnmente conocidos como Firebase Extensions) son soluciones empaquetadas de código que automatizan tareas comunes de desarrollo y añaden funcionalidades preconfiguradas a tus aplicaciones.
- Agregar un complemento

Agrega complementos de Firebase

    Desde el directorio del proyecto de Flutter, ejecutar el siguiente comando para añadir el plugin:

% flutter pub add <PLUGIN_NAME>

Donde PLUGIN_NAME será: firebase_auth, firebase_messaging, firebase_storage, ...

    Desde el directorio del proyecto de Flutter, ejecutar el siguiente comando para asegurar que la app está actualizada:

% flutterfire configure

Firebase Authentication

Web de Firebase Authentication
Documentación de Firebase Authentication Primeros pasos con Firebase Authentication en Flutter Complemento firebase_auth

Firebase Authentication busca simplificar la creación de sistemas de autenticación seguros, a la vez que mejora la experiencia de inicio de sesión e incorporación de los usuarios de la aplicación.
Ofrece una solución de identidad integral, compatible con cuentas de correo electrónico y contraseña, autenticación telefónica, inicio de sesión en Google, Apple, X, Facebook, GitHub y más.
- Escuchar cambios en el usuario

Es necesario suscribirse a todos los cambios de usuario, como la vinculación y desvinculación de credenciales, y las actualizaciones del perfil de usuario.
Con el siguiente código se escuchan las actualizaciones en tiempo real del estado del usuario (inicio de sesión, cierre de sesión, actualización de usuario y token) y luego rehidratar los cambios en la aplicación.

User? _user;
StreamSubscription<User?> _userChangesSubscription;

void userChanges(User? user) {
_user = user;
}

@override
void initState() {
super.initState();
_userChangesSubscription = FirebaseAuth.instance.userChanges().listen(_userChanges);
...

@override
void dispose() {
_userChangesSubscription?.cancel();
...

- Cerrar sesión

FirebaseAuth.instance.signOut();

- Borrar cuenta

FirebaseAuth.instance.currentUser?.delete();

- Cuentas de usuario

  Persistencia

Por defecto, cuando un usuario inicia sesión su información persiste. Es decir, si se cierra la aplicación y se vuelve abrir, el usuario continuará con la sesión iniciada.

    Listado de cuentas de usuario

Es posible ver todos los usuarios registrados en Firebase:
Firebase Console > Proyecto > Authentication > Usuarios

Desde ahí se puede inhabilitar y borrar un cuenta en concreto.

    Obtener información del usuario

-user.uid: ID único de usuario.
-user.isAnonymous: Si el usuario es anónimo o no.
-user.metadata.creationTime?.toLocal(): Fecha (local) de creación del usuario.
- Autenticación anónima

Autentica con Firebase de forma anónima

Permitir la autenticación anónima tiene sentido por varios motivos:
-Es posible que Apple o Google restringan la publicación de una app si es obligatorio el registro para ser usada. Con la autenticación anónima se puede poner el típico 'Continuar sin iniciar sesión'. Por debajo, el usuario se estará registrando en el sistema anque no se guarden sus datos (nombre, email, etc.)
-Aunque los usuarios no se hayan registrado, permite trabajar con datos protegidos de Firebase mediante reglas de seguridad.

NOTA: Cada vez que un usuario inicia sesión de forma anónima, se crea una nueva cuenta en Firebase, aunque sea en la misma app y dispositivo.

    Habilitar el método de acceso anónimo en Firebase Console

Firebase Console > Proyecto > Authentication > Métodos de acceso > Anónimo > Habilitar > Guardar

    Autenticación de forma anónima en la app

UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();

    Pasar cuenta anónima a cuenta normal

Un usuario registrado de forma anónima se puede convertir en un usuario 'normal' posteriormente.
P.ej: ha iniciado sesion de forma anónima, ha visto nuestros productos, ha añadido algunos al carrito y ahora quiere pagar. Se le puede ofrecer la posibilidad crear una cuenta sin perder los datos.
Ver Convierte una cuenta anónima en una permanente
- Autenticación con correo electŕonico y contraseña

Autentica con Firebase mediante cuentas con contraseña en Flutter

    Habilitar el método de acceso con correo electŕonico y contraseña en Firebase Console

Firebase Console > Proyecto > Authentication > Métodos de acceso >
Agregar proveedor nuevo > Proveedores nativos > Correo electrónico/contraseña > Correo electrónico/contraseña > Habilitar > Guardar

    Política de contraseñas

Firebase Console > Proyecto > Authentication > Configuración > Política de contraseñas
Se puede establecer los siguientes requisitos:
-Exigir caracteres en mayúscula
-Exigir caracteres en minúscula
-Exigir caracteres especiales
-Exigir caracteres numéricos
-Forzar la actualización durante el acceso
-Longitud mínima de la contraseña (por defecto: 6)
-Longitud máxima de la contraseña (por defecto: 4096)

NOTA: En realidad, en el Firebase Auth “gratuito / estándar” solo aplica la longitud mínima de 6 caracteres.
Cualquier otra opción (símbolos, mayúsculas, números) no se hace cumplir en el backend.

    Registrarse con correo electrónico/contraseña en la app

Crea una cuenta con contraseña

UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
email: email,
password: password,
);

    Iniciar sesión con correo electrónico/contraseña en la app

Permite que un usuario acceda con una dirección de correo electrónico y una contraseña

UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
email: email,
password: password,
);

    Validar correo electrónico

Al registrar un usuario o iniciar sesión no se valida que el correo exista y pertenecezca al usuario.
Se puede comprobar mediante la propiedad emailVerified de User.

-Enviar correo de verificación

await user.sendEmailVerification();

-Configurar correo de confirmación que se envía

Cómo personalizar los correos electrónicos de administración de cuentas

Firebase Console > Proyecto > Authentication > Plantillas > Verificación de dirección de correo electrónico
Se puede establecer los siguientes ajustes:
-Idioma de la plantilla
-Remitente
-Asunto

    Restablecer contraseña

-Enviar correo para iniciar proceso para cambiar contraseña

await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);

Cloud Firestore

Cloud Firestore
Primeros pasos con Cloud Firestore Cloud Firestore vs Realtime Database Complemento cloud_firestore

Base de datos NoSQL flexible, escalable y en la nube, creada en la infraestructura de Google Cloud, para almacenar y sincronizar datos para el desarrollo tanto del lado del cliente como del servidor.
- Ediciones

Descripción general de las ediciones

    Edición Standard

Proporciona un paquete integral de funciones como una base de datos de documentos, incluidos SDKs fluidos para una gran cantidad de lenguajes de programación, asistencia en tiempo real y sin conexión, alta disponibilidad en parámetros de configuración regionales y multirregionales, y un conveniente modelo operativo sin servidores con escalado automático.

Precios

1 base de datos gratuita por proyecto.

    Edición Enterprise

Proporciona compatibilidad con MongoDB y un nuevo motor de consultas que admite una mayor cantidad de funciones y límites más altos.

Precios

1 base de datos gratuita por proyecto.
- Ubicaciones

La diferencia clave es la disponibilidad y durabilidad.
Las ubicaciones regionales son más económicas y se enfocan en una región específica (con redundancia entre zonas), ideales para aplicaciones con una audiencia concentrada.
Las multi-regionales replican datos en un conjunto de regiones geográficas, ofreciendo mayor resistencia ante fallos a gran escala y baja latencia global, a un costo mayor.

Se elige regional para menor latencia y costo local, y multi-regional para máxima disponibilidad y recuperación ante desastres.

Una vez creada una base de datos en una región no podrá cambiarse.
- Modos de funcionamiento

Una vez creada la base de datos hay que aplicar unas reglas de seguridad para acceder a los datos.

    Modo de producción

Lus datos son privados de forma predeterminada.
El acceso de lectura/escritura de los clientes solo se otorgará como se indica en tus reglas de seguridad.

    Modo de prueba

Para permitir una configuración rápida, los datos se abren de forma predeterminada. Sin embargo, debes actualizar las reglas de seguridad en un plazo de 30 días para habilitar el acceso de lectura/escritura a largo plazo para los clientes.
- Crear una base de datos

Firebase Console > Proyecto > Compilación > Firestore Database > Crear base de datos >
-Edición: Standard (o Enterprise)
-Ubicación: europe-southwest1 (Madrid) (u otro sitio)
-Modo de funcionamiento: producción
Crear
- Crear una colección de datos

Modelo de datos de Cloud Firestore
Tipos de datos

Se puede pensar en una colección como en una tabla de una base de datos relacional.

    Inicia una colección

        Asignar un ID a la colección (sería como el nombre de la tabla)
            heroes

        Agregar el primer documento (sería como la primera fila de la tabla que además define la estructura)
            ID de documento Hacer click Automático para obtener un id aleatório (jtA1MiKpNlyUNq9sDdvC)
                Campo Tipo (valor primer registro)
                real_name string Tony Stark
                hero_name string Iron Man
                description string Genius, billionaire, playboy, philanthropist
                image string
                created_at timestamp 14 ene 2026 12:00:00
                updated_at timestamp 14 ene 2026 12:00:00

- Reglas de seguridad

Comienza a usar las reglas de seguridad de Cloud Firestore
Firebase Security Rules

Las reglas de seguridad proporcionan control de acceso y validación de datos.

    Editar reglas

Firebase Console > Proyecto > Compilación > Firestore Database > Base de datos > Reglas

Algunos conjuntos de reglas predefinidos:

    Permitir todo

Permitir acceso de lectura y escritura a todos los usuarios bajo cualquier condición.
NUNCA usar este conjunto de reglas en producción; permite que cualquiera sobrescriba toda la base de datos.

service cloud.firestore {
match /databases/{database}/documents {
match /{document=**} {
allow read, write: if true;
}
}
}

    Rechazar todo

Denegar el acceso de lectura/escritura a todos los usuarios bajo cualquier condición.

service cloud.firestore {
match /databases/{database}/documents {
match /{document=**} {
allow read, write: if false;
}
}
}

    Permitir todo a los que hayan iniciado sesión

Permitir acceso de lectura y escritura a todos los documentos a cualquier usuario que haya iniciado sesión (aunque sea de forma anónima) en la aplicación.

service cloud.firestore {
match /databases/{database}/documents {
match /{document=**} {
allow read, write: if request.auth != null;
}
}
}

- Listar, crear, modificar y borrar datos en la app

Cloud Firestore

    Inicializar instancia de Cloud Firestore

FirebaseFirestore db = FirebaseFirestore.instance;

    Obtener una referencia a una colección

Referencia simple a una colección

CollectionReference collectionRef = db.collection('heroes');

Referencia con conversores Cloud Firestore <-> objetos

CollectionReference<MyHero> collectionRef = db
.collection('heroes')
.withConverter(
fromFirestore: MyHero.fromFirestore,
toFirestore: (MyHero hero, options) => hero.toFirestore(),
);

Referencia a un documento (conociendo su id)

DocumentReference<MyHero> documentRef = collectionRef.doc('fxMV9m3z8TsBOCi5gxNO');

    Filtrar datos

Realiza consultas simples y compuestas en Cloud Firestore
Ordena y limita datos con Cloud Firestore

Query<MyHero> query = collectionRef
.where('description', isGreaterThan: 'a')
.orderBy('hero_name', descending: false)
.limit(10);

    Obtener datos

Obtén datos con Cloud Firestore

A partir de un DocumentReference, CollectionReference o Query.
Esta es la instrucción que verdaderamente obtiene los datos.

Obtener una lista de datos (con una referencia a una colección con conversión)

QuerySnapshot<MyHero> querySnapshot = await query.get();
List<QueryDocumentSnapshot<MyHero>> docs = querySnapshot.docs;
List<MyHero>? data =d ocs.map((doc) => doc.data()).toList();

Obtener un solo dato (con una referencia a una colección con conversión)

DocumentSnapshot<MyHero> documentSnapshot = await documentRef.get();
MyHero? item = documentSnapshot.data();

    Obtener actualizaciones de los datos

Obtén actualizaciones en tiempo real con Cloud Firestore

Se puede escuchar los cambios producidos desde la misma aplicación o de forma externa en un documento, colección o query.

Obtener un Stream para los cambios

Stream<QuerySnapshot<MyHero>>? querySnapshotStreams = query.snapshots();

Escuchar los cambios con listen

final listener = querySnapshotStreams?.listen(
(event) => print("current data: ${event.data()}"),
onError: (error) => print("Listen failed: $error"),
);
...
listener.cancel();

O atender los cambios con un StreamBuilder

StreamBuilder<QuerySnapshot<MyHero>>(
stream: _querySnapshotStreams,
builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<MyHero>> snapshot) {
...
);

    Agregar / Modificar datos

Agrega datos a Cloud Firestore
add se usa para añadir un elemento si éste no tiene un id y se quiere que lo genere Cloud Firestore.

DocumentReference documentRef = await collectionRef.add(item);
item.id = documentRef.id;

set se usa para modificar o añadir un elemento si éste tiene un id

await collectionRef.doc(item.id).set(item);

    Borrar datos

Borra datos de Cloud Firestore

await collectionRef.doc(item.id).delete();

AGREGAR HUELLA 

keytool -list -v -alias androiddebugkey -keystore $env:USERPROFILE\.android\debug.keystore -storepass android -keypass android


FIN
