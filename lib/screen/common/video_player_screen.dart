import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _controller = VideoPlayerController.network(widget.videoUrl);

    await _controller!.initialize();

    if (!mounted) return;

    _isReady = true;

    if (widget.autoPlay) {
      _controller!.play();
    }

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant VideoPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isReady || _controller == null) return;

    if (widget.autoPlay) {
      _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FULL PLACEHOLDER — NO BLACK FLASH
    if (!_isReady || _controller == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _controller!.value.isPlaying
            ? _controller!.pause()
            : _controller!.play();
        setState(() {});
      },
      child: Stack(
        children: [
          // 🎥 VIDEO
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),

          // ▶ PLAY ICON
          if (!_controller!.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                size: 64,
                color: Colors.white,
              ),
            ),

          // 📏 PROGRESS BAR
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _controller!,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: AppColor().colorPrimary,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
