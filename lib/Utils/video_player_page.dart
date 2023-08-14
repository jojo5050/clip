import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieVideoPlayer extends StatefulWidget {
  final String videoUrl;

  ChewieVideoPlayer({required this.videoUrl});

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Center(
        child: CircularProgressIndicator(),
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
