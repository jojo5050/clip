import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String url;

  const AppVideoPlayer({required this.url, Key? key}) : super(key: key);

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _controller;

  VoidCallback? videoListener;

  @override
  void initState() {
    print(widget.url);
    _controller = VideoPlayerController.network(widget.url);
    _controller!.initialize();
    super.initState();
  }

  @override
  void dispose() {
    if(_controller!.value.isPlaying)
      _controller?.pause();
    // _controller!.removeListener(videoListener!);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          if(_controller!.value.isPlaying){
            _controller!.pause();
          }else{
            _controller!.play();
          }
        });
      },
      child: Stack(
          fit: StackFit.expand,
          children:[ AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
            Positioned(
                top: 10,
                right: 30,
                child: Icon(Icons.video_collection_outlined, color: Colors.amber,)),
          ]
      ),

    );
  }
}