
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagesCachedNetworkImagePage extends StatefulWidget {
  const ImagesCachedNetworkImagePage({super.key});

  @override
  State<ImagesCachedNetworkImagePage> createState() => _ImagesCachedNetworkImagePageState();
}

class _ImagesCachedNetworkImagePageState extends State<ImagesCachedNetworkImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Imágenes (Cached)'),
      ),
      body: ListView(
        children: [
          _buildImageFromInternetSimple(),
          _buildImageFromInternet(),
          _buildImageFromInternetError(),
        ],
      ),
    );
  }

  final _id = 64; // Random().nextInt(1084) + 1;
  final _sizeOri = 3500;
  final _sizeDest = 200;

  Widget _buildImageFromInternetSimple() {
    return Column(
      children: [
        SizedBox(height: 8),
        Text('Internet - Simple (id: $_id)'),
        SizedBox(
          height: _sizeDest.toDouble(),
          child: CachedNetworkImage(
            imageUrl: 'https://picsum.photos/id/$_id/$_sizeOri',
          ),
        ),
      ],
    );
  }

  Widget _buildImageFromInternet() {
    return Column(
      children: [
        SizedBox(height: 8),
        Text('Internet - Progreso (id: ${_id+1}'),
        SizedBox(
          height: _sizeDest.toDouble(),
          child: CachedNetworkImage(
            imageUrl: 'https://picsum.photos/id/${_id+1}/$_sizeOri',
            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: downloadProgress.progress == null
                  ? SizedBox()
                  : LinearProgressIndicator(
                value: downloadProgress.progress,
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              size: 128,
              color: Colors.red,
            ),
            color: Colors.green,
            colorBlendMode: .darken,
            fit: .cover,
            width: double.infinity,
            height: _sizeDest.toDouble(),
            maxHeightDiskCache: _sizeDest,
            memCacheHeight: _sizeDest,
          ),
        ),
      ],
    );
  }

  Widget _buildImageFromInternetError() {
    return Column(
      children: [
        SizedBox(height: 8),
        Text('Internet - Error (id: 10000)'),
        SizedBox(
          height: _sizeDest.toDouble(),
          child: CachedNetworkImage(
            imageUrl: 'https://picsum.photos/id/10000/$_sizeOri',
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              size: 128,
              color: Colors.red,
            ),
            height: _sizeDest.toDouble(),
          ),
        ),
      ],
    );
  }
}