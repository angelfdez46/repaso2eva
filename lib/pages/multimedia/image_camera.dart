import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCameraPage extends StatefulWidget {
  const ImageCameraPage({super.key});

  @override
  State<ImageCameraPage> createState() => _ImageCameraPageState();
}

class _ImageCameraPageState extends State<ImageCameraPage> {
  String? _imagePath;
  int? _imageSize;
  int? _imageWidth;
  int? _imageHeight;

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();

    // obtener imagen de la galería
    XFile? xFile = await picker.pickImage(
      source: .camera,
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 95,
      preferredCameraDevice: .rear,
    );

    // si no ha seleccionado nada => salir
    if (xFile == null) return;

    // opcional - información de la imagen seleccionada
    final bytes = await xFile.readAsBytes();
    ui.Image image = await decodeImageFromList(bytes);
    debugPrint(
      "${image.width}x${image.height}", // 3024x4032
    );

    _imagePath = xFile.path;
    _imageSize = await xFile.length();
    _imageWidth = image.width;
    _imageHeight = image.height;

    // mostrar la imagen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Seleccionar imagen (Cámara)'),
      ),
      body: ListView(
        children: [
          if (_imagePath != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                children: [
                  Text('($_imageSize bytes)'),
                  Text('${_imageWidth}x$_imageHeight => ${((250 * _imageWidth!) / _imageHeight!).toInt()}x250'),
                  Image.file(
                    File(_imagePath!),
                    height: 250,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ElevatedButton(onPressed: _getImage, child: Text('Obtener imagen')),
          ),
        ],
      ),
    );
  }
}