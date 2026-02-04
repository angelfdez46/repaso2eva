import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _player.play(AssetSource('audio/audio1.mp3'));
              },
              child: const Text('Reproducir'),
            ),
            ElevatedButton(
              onPressed: () {
                _player.stop();
              },
              child: const Text('Parar'),
            ),
          ],
        ),
      ),
    );
  }
}
