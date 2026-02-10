import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:native_exif/native_exif.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/permissions.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  String? _imagePath;
  String? _imageName;
  int? _imageSize;

  int? _imageWidth;
  int? _imageHeight;

  ExifLatLong? _exifLatLong;
  Map<String, Object>? _exifAtributes;
  String? _exifAtributeOrientation;
  DateTime? _exifOriginalDate;

  // obtener una imagen
  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();

    // obtener imagen de la galería
    XFile? xFile = await picker.pickImage(
      source: .gallery,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 90,
    );

    // si no ha seleccionado nada => salir
    if (xFile == null) return;

    // en _xFile se almacena la imagen seleccionada
    _imagePath = xFile.path;
    _imageName = xFile.name;
    _imageSize = await xFile.length();

    // opcional - información del archivo seleccionado
    debugPrint(
      "'${xFile.path}'"
          " '${xFile.name}'" // Captura de pantalla 2025-12-10 a las 14.29.44.png
          " '${xFile.mimeType}'" // image/png (solo en web)
          " $_imageSize" // 442728
          " '${await xFile.lastModified()}'", // 2025-12-10 14:29:44.736
    );
    /*
    path:
      Android:          /data/user/0/com.example.pmdm_2526_multimedia/cache/7899701e-ab74-434c-b798-8c49648ac655/19.jpg
      iOS:              /private/var/mobile/Containers/Data/Application/E8EDA87E-59CB-478A-8AFA-63B5877DF87A/tmp/image_picker_F1A6C381-EA1C-4008-9985-F0D2CD1BFCE1-50912-00001BAF663B4416.jpg
      iOS (simulador):  /Users/aj/Library/Developer/CoreSimulator/Devices/1BE8DF11-4E74-45C9-B162-20A40984637C/data/Containers/Data/Application/77E9E771-D5AF-4306-BFF2-091AD2AB33C6/tmp/image_picker_5864BC08-1DEB-423D-98DA-F7B6F518DACD-92855-0000030C859ECF25.jpg
      macOS:            /Users/aj/Documents/Captura de pantalla 2025-12-10 a las 14.29.19.png
      web:              blob:http://localhost:62041/add9d9e9-6bf5-4390-930b-832326260cbe
    */

    // opcional - información de la imagen seleccionada
    final bytes = await xFile.readAsBytes();
    ui.Image image = await decodeImageFromList(bytes);

    _imageWidth = image.width;
    _imageHeight = image.height;

    debugPrint(
      "${_imageWidth}x$_imageHeight", // 3024x4032
    );

    // opcional - comprobar permiso de acceso a las coordenadas de la imagen
    if (Platform.isAndroid) {
      if (mounted) {
        await permissionHandle(
          context,
          Permission.accessMediaLocation,
          'Acceder a la biblioteca multimedia del dispositivo',
          'Necesitamos este permiso para acceder a las coordenadas de la imagen.',
        );
      }
    }

    // opcional - obtener información adicional de la imagen
    if (Platform.isAndroid || Platform.isIOS) {
      final exif = await Exif.fromPath(xFile.path);
      _exifOriginalDate = await exif.getOriginalDate(); // 2026-01-02 14:27:21.000
      _exifAtributes = await exif.getAttributes();
      /*
      Android:
      "ApertureValue" -> "2/1"
      "GPSLatitude" -> 42.55592130025227
      "GPSAltitude" -> "2206008/1000"
      "ExposureProgram" -> "2"
      "GPSAltitudeRef" -> "0"
      "GPSProcessingMethod" -> "fused"
      "GPSTimeStamp" -> "13:25:43"
      "ImageLength" -> "405"
      "GPSDateStamp" -> "2026:01:02"
      "DateTime" -> "2026:01:02 14:27:21"
      "DateTimeOriginal" -> "2026:01:02 14:27:21"
      "SubSecTimeOriginal" -> "174424"
      "WhiteBalance" -> "0"
      "GPSLatitudeRef" -> "N"
      "ExposureTime" -> "5.082339043524396E-4"
      "ImageWidth" -> "720"
      "Flash" -> "16"
      "SubSecTime" -> "174424"
      "FNumber" -> "2.0"
      "ISOSpeedRatings" -> "41"
      "GPSLongitudeRef" -> "E"
      "Make" -> "Google"
      "GPSLongitude" -> 0.5564587995741103
      "Orientation" -> "1"
      "SubSecTimeDigitized" -> "174424"
      "DigitalZoomRatio" -> "2.02"
      "DateTimeDigitized" -> "2026:01:02 14:27:21"
      "FocalLength" -> "223/100"
      "Model" -> "Pixel 8 Pro"
      "Software" -> "HDR+ 1.0.839895461nd"

      iOS:
      "ExifVersion" -> [_List]
      "Flash" -> 16
      "GPSImgDirection" -> 199.2980652962515
      "GPSLatitudeRef" -> "N"
      "LensModel" -> "iPhone 12 Pro Max back triple camera 5.1mm f/1.6"
      "GPSDestBearing" -> 199.2980652962515
      "OffsetTimeDigitized" -> "+01:00"
      "SubsecTimeOriginal" -> "856"
      "LensSpecification" -> [_List]
      "ExposureMode" -> 0
      "CompositeImage" -> 2
      "LensMake" -> "Apple"
      "GPSLongitudeRef" -> "W"
      "FNumber" -> 1.6
      "OffsetTimeOriginal" -> "+01:00"
      "GPSHPositioningError" -> 4.748651528267963
      "GPSSpeed" -> 32.34999847295605
      "PixelYDimension" -> 405
      "ApertureValue" -> 1.3561438092556088
      "ExposureBiasValue" -> 0.0
      "MeteringMode" -> 5
      "ISOSpeedRatings" -> [_List]
      "GPSLongitude" -> 1.2677366666666667
      "ShutterSpeedValue" -> 12.683641067858403
      "GPSDestBearingRef" -> "T"
      "FocalLength" -> 5.1
      "DateTimeOriginal" -> "2026:01:05 12:22:52"
      "SceneType" -> 1
      "Orientation" -> 1
      "ColorSpace" -> 65535
      "SubjectArea" -> [_List]
      "GPSAltitude" -> 935.8156424581006
      "PixelXDimension" -> 720
      "FocalLenIn35mmFilm" -> 25
      "SensingMethod" -> 2
      "OffsetTime" -> "+01:00"
      "SubsecTimeDigitized" -> "856"
      "GPSAltitudeRef" -> 0
      "GPSDateStamp" -> "2026:01:05"
      "GPSLatitude" -> 40.922286666666665
      "BrightnessValue" -> 10.727119358920287
      "DateTimeDigitized" -> "2026:01:05 12:22:52"
      "WhiteBalance" -> 0
      "ExposureTime" -> 0.0001519987840097279
      "GPSImgDirectionRef" -> "T"
      "GPSSpeedRef" -> "K"
      "ExposureProgram" -> 2
      "GPSTimeStamp" -> "11:22:52"
       */
      _exifAtributeOrientation = _exifAtributes?['Orientation']?.toString(); // 1
      _exifLatLong = await exif.getLatLong(); // ExifLatLong(lat: 42.55592130025227, long: 0.5564587995741103)

      debugPrint(
        "$_exifOriginalDate\n"
            "$_exifAtributes\n"
            "$_exifLatLong\n",
      );

      exif.close();
    }

    // asegurar que la imagen esté en la orientación correcta
    if (_exifAtributeOrientation != '1') {
      _imagePath = (await FlutterExifRotation.rotateImage(path: xFile.path)).path;
    }

    // mostrar la imagen
    setState(() {});
  }

  // convertir un número de orientación a texto
  String _orientationToText(String orientation) {
    switch (orientation) {
      case '1':
        return 'Normal'; // La imagen está en orientación correcta (arriba es arriba, izquierda es izquierda)
      case '2':
        return 'Voltear Horizontal'; // Imagen volteada horizontalmente
      case '3':
        return 'Rotar 180°'; // Imagen rotada 180 grados (está boca abajo)
      case '4':
        return 'Voltear Vertical'; // Imagen volteada verticalmente (espejo)
      case '5':
        return 'Rotar 90° + Voltear Horizontal'; // Rotada 90 grados en sentido horario y luego volteada
      case '6':
        return 'Rotar 90°'; // Rotada 90 grados en sentido horario (la orientación de la cámara era vertical, ahora es horizontal)
      case '7':
        return 'Rotar 270° + Voltear Horizontal'; // Rotada 270 grados en sentido horario y luego volteada
      case '8':
        return 'Rotar 270°'; // Rotada 270 grados en sentido horario (la orientación de la cámara era vertical, ahora es horizontal, pero al revés)
    }
    return '?';
  }

  // navegar a la ubicación de la foto
  Future<void> _navigate() async {
    if (_exifLatLong == null) return;

    // obtener la lista de mapas disponibles
    final availableMaps = await MapLauncher.installedMaps;

    debugPrint(availableMaps.toString());
    /*
    { mapName: Apple Maps, mapType: apple }
    { mapName: Google Maps, mapType: google }
    */

    // navegar usando Google Maps, si está disponible
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.showDirections(
        mapType: MapType.google,
        destination: Coords(
          _exifLatLong!.latitude,
          _exifLatLong!.longitude,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Seleccionar imagen (Galería)'),
      ),
      body: ListView(
        children: [
          if (_imagePath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                children: [
                  Text('$_imageName'),
                  Text('$_imageSize bytes'),
                  if (_exifOriginalDate != null) Text('${_exifOriginalDate!.toLocal()}'),
                  if (_exifAtributeOrientation != null) Text('Orientación: ${_orientationToText(_exifAtributeOrientation!)}'),
                  Text('${_imageWidth}x$_imageHeight => ${((250 * _imageWidth!) / _imageHeight!).toInt()}x250'),
                  kIsWeb
                  // en web
                      ? Container(
                    color: Colors.black,
                    child: Image.network(
                      _imagePath!,
                      height: 250,
                    ),
                  )
                  // en el resto
                      : Container(
                    color: Colors.black,
                    child: Image.file(
                      File(_imagePath!),
                      height: 250,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ElevatedButton(onPressed: _getImage, child: Text('Obtener imagen')),
          ),
          if (_exifLatLong != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                children: [
                  Text('${_exifLatLong!.latitude}º ${_exifLatLong!.latitude > 0 ? "N" : "S"}'),
                  Text('${_exifLatLong!.longitude}º ${_exifLatLong!.longitude > 0 ? "E" : "W"}'),
                  ElevatedButton(onPressed: _navigate, child: Text('Navegar')),
                ],
              ),
            ),
        ],
      ),
    );
  }
}