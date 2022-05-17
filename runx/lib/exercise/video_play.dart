// System Packages
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

// Logic
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
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
    // Wrapper on top of the videoPlayerController
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: widget.looping,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
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
    // IMPORTANT to dispose of all the used resources
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
        backgroundColor: Colors.black,
        body: ChewieListItem(
          videoPlayerController: VideoPlayerController.asset(
            video,
          ),
          looping: true,
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
        backgroundColor: Colors.transparent,
        body: ChewieListItem(
          videoPlayerController: VideoPlayerController.network(
            video,
          ),
          looping: true,
        ));
  }
}
