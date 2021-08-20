import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import 'package:story_video_player/story_video_player.dart';

class StoryVideo extends StatefulWidget {
  final String url;
  final StoryPlayerController storyPlayerController;

  StoryVideo({Key? key, required this.url, required this.storyPlayerController})
      : super(key: UniqueKey());

  @override
  _StoryVideoState createState() => _StoryVideoState();
}

class _StoryVideoState extends State<StoryVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((value) {
        widget.storyPlayerController.setVideoPlayerController(_controller);
        setState(() {});
        widget.storyPlayerController.startPlayback();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller)),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
