import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoUrlPage extends StatefulWidget {
  const VideoUrlPage({super.key});

  @override
  State<VideoUrlPage> createState() => _VideoUrlPageState();
}

class _VideoUrlPageState extends State<VideoUrlPage> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _resInitializeVideoPlayer;

  Future<void> _initializeVideoPlayer() async {
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
  }

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
    );

    _resInitializeVideoPlayer = _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Vídeo (URL)'),
      ),
      body: FutureBuilder(
        future: _resInitializeVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .done) {
            // terminado
            if (snapshot.hasError) {
              // con error
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              // sin error
              return _buildVideo();
            }
          } else {
            // espera
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildVideo() {
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController),
        ),
      ],
    );
  }
}