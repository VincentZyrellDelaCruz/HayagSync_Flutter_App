import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewDialog extends StatefulWidget {
  const VideoPreviewDialog({super.key, required this.file});

  final File file;

  @override
  State<VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<VideoPreviewDialog> {
  late VideoPlayerController _controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: AspectRatio(
        aspectRatio: isInitialized ? _controller.value.aspectRatio : 16 / 9,
        child: isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
