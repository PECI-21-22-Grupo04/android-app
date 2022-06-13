// System Packages
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

// Logic
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const ChewieListItem({
    required this.videoPlayerController,
    required this.looping,
    Key? key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Chewie(
          controller: _chewieController,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}

class VideoPlayAsset extends StatelessWidget {
  final String video;

  const VideoPlayAsset({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        body: ChewieListItem(
      videoPlayerController: VideoPlayerController.asset(
        video,
      ),
      looping: false,
    ));
  }
}

class VideoPlayNetwork extends StatelessWidget {
  final String video;

  const VideoPlayNetwork({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        body: ChewieListItem(
      videoPlayerController: VideoPlayerController.network(
        video,
      ),
      looping: false,
    ));
  }
}
