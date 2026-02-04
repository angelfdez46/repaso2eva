import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoYoutubePage extends StatefulWidget {
  const VideoYoutubePage({super.key});

  @override
  State<VideoYoutubePage> createState() => _VideoYoutubePageState();
}

class _VideoYoutubePageState extends State<VideoYoutubePage> {
  VideoPlayerController? _videoPlayerController;
  late Future<void> _resInitializeVideoPlayer;

  Future<void> _initializeVideoPlayer() async {
    final videoId = 'bV0RAcuG2Ao';

    final youtubeExplode = YoutubeExplode();

    final streamManifest = await youtubeExplode.videos.streams.getManifest(
      videoId,
    );

    // información de todos los streams disponibles
    debugPrint(streamManifest.toString());
    /*
format code  extension     resolution  quality       bitrate        size           codecs        info
599          mp4           audio only                31.45 Kbit/s   940.89 KB      mp4a.40.5
600          webm          audio only                33.00 Kbit/s   929.18 KB      opus
139          mp4           audio only                49.02 Kbit/s   1.46 MB        mp4a.40.5
249          webm          audio only                49.32 Kbit/s   1.35 MB        opus
140          mp4           audio only                127.91 Kbit/s  3.86 MB        mp4a.40.2
251          webm          audio only                130.75 Kbit/s  3.55 MB        opus
598          webm          256x144     144p12        25.93 Kbit/s   693.93 KB      vp9                     video only
394          mp4           256x144     144p24        92.25 Kbit/s   1.51 MB        av01.0.00M.08           video only
278          webm          256x144     144p24        93.80 Kbit/s   2.45 MB        vp9                     video only
160          mp4           256x144     144p24        96.58 Kbit/s   1.34 MB        avc1.4d400c             video only
395          mp4           426x240     144p24        147.64 Kbit/s  2.00 MB        av01.0.00M.08           video only
133          mp4           426x240     144p24        159.98 Kbit/s  2.27 MB        avc1.4d4015             video only
242          webm          426x240     144p24        214.80 Kbit/s  2.85 MB        vp9                     video only
18           mp4           640x360     360p24        261.85 Kbit/s  7.99 MB        avc1.42001E, mp4a.40.2  muxed
396          mp4           640x360     360p24        272.86 Kbit/s  3.60 MB        av01.0.01M.08           video only
134          mp4           640x360     360p24        304.70 Kbit/s  4.15 MB        avc1.4d401e             video only
243          webm          640x360     360p24        389.23 Kbit/s  4.91 MB        vp9                     video only
135          mp4           854x480     480p24        508.16 Kbit/s  6.54 MB        avc1.4d401e             video only
397          mp4           854x480     480p24        550.47 Kbit/s  6.13 MB        av01.0.04M.08           video only
244          webm          854x480     480p24        734.29 Kbit/s  7.08 MB        vp9                     video only
136          mp4           1280x720    720p24        964.04 Kbit/s  12.32 MB       avc1.4d401f             video only
398          mp4           1280x720    720p24        972.74 Kbit/s  11.02 MB       av01.0.05M.08           video only
247          webm          1280x720    720p24        1.36 Mbit/s    11.11 MB       vp9                     video only
399          mp4           1920x1080   1080p24       1.46 Mbit/s    18.94 MB       av01.0.08M.08           video only
248          webm          1920x1080   1080p24       2.36 Mbit/s    29.44 MB       vp9                     video only
137          mp4           1920x1080   1080p24       3.99 Mbit/s    46.37 MB       avc1.640028             video only
    */

    // información de cuántos streams disponibles hay de cada tipo
    debugPrint('Streams: ${streamManifest.streams.length}'); // 26
    debugPrint('Con audio : ${streamManifest.audio.length}'); // 7
    debugPrint('Con vídeo: ${streamManifest.video.length}'); // 20
    debugPrint('Con audio y vídeo: ${streamManifest.muxed.length}'); // 1
    debugPrint('Solo audio: ${streamManifest.audioOnly.length}'); // 6
    debugPrint('Solo vídeo: ${streamManifest.videoOnly.length}'); // 19
    debugPrint('HLS: ${streamManifest.hls.length}'); // 0

    // nos quedamos con los que tengan audio y vídeo
    final muxed = streamManifest.muxed;
    if (muxed.isEmpty) throw Exception('No se encontraron streams válidos');

    // nos quedamos con el que tenga mejor calidad
    final muxedWithHighestBitrate = muxed.withHighestBitrate();

    // nos quedamos con su uri
    final uri = muxedWithHighestBitrate.url;

    // inicializamos el player con la uri
    _videoPlayerController = VideoPlayerController.networkUrl(
      uri,
    );

    _videoPlayerController!.addListener(() {
      // bool isFinished = _videoPlayerController!.value.position >= _videoPlayerController!.value.duration;
      //
      // if (isFinished) {
      //   Navigator.pop(context); // al finalizar, cerrar la página
      // }
    });

    await _videoPlayerController!.initialize();

    _videoPlayerController!.seekTo(Duration(seconds: 43)); // mover a una determinada posición
    _videoPlayerController!.play(); // reproducir
  }

  void _play() {
    if (_videoPlayerController != null &&
        !_videoPlayerController!.value.isPlaying) {
      _videoPlayerController!.play();
      setState(() {});
    }
  }

  void _pause() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isPlaying) {
      _videoPlayerController!.pause();
      setState(() {});
    }
  }

  void _stop() async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.pause();
      await _videoPlayerController!.seekTo(Duration.zero);
      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();

    _resInitializeVideoPlayer = _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Vídeo (YouTube)'),
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
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(_videoPlayerController!),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 36,
              onPressed: _play,
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 36,
              onPressed: _pause,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              iconSize: 36,
              onPressed: _stop,
            ),
          ],
        ),
      ],
    );
  }}