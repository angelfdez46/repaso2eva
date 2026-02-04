import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imagen')),
      body: Center(
        child: Image.asset('assets/images/svg/basket.jpg'),
      ),
    );
  }
}
