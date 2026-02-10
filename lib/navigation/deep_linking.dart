import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pantalla que recibe un parámetro desde la URL
// Ejemplo de deep linking con GoRouter
class DeepLinkingPage extends StatelessWidget {
  final String id;

  const DeepLinkingPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Linking Page con Item ID'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Has navegado al item con ID: $id'),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.goNamed('home');
              },
              child: Text('Volver a Home'),
            ),
          ],
        ),
      ),
    );
  }
}