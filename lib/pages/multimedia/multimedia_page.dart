import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:repaso2eva/pages/multimedia/youtube_page.dart';
import '../../navigation/drawer_page.dart';
import 'image_page.dart';
import 'audio_page.dart';
import 'video_page.dart';


class MultimediaPage extends StatelessWidget {
  const MultimediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multimedia'),
      ),
      drawer: const DrawerPage(), // tu drawer
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
      ListTile(
      leading: const Icon(Icons.image),
      title: const Text('Imágenes'),
      onTap: () {
        context.go('/images'); // 👈 GoRouter
      },
    ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Audio'),
            onTap: () {
              context.go('/audio');
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Vídeo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.ondemand_video),
            title: const Text('YouTube'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VideoYoutubePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
