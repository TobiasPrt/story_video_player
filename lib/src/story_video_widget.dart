import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import '../story_video_player.dart';

/// Widget representing a single video instance inside a [StoryPlayer] widget
class StoryVideoWidget extends StatefulWidget {
  /// The linked story video object including all necessary information
  final StoryVideo storyVideo;

  /// The controller managing the parent [StoryPlayer]
  final StoryPlayerController storyController;

  StoryVideoWidget({
    Key? key,
    required this.storyVideo,
    required this.storyController,
  }) : super(key: UniqueKey());

  @override
  _StoryVideoWidgetState createState() => _StoryVideoWidgetState();
}

class _StoryVideoWidgetState extends State<StoryVideoWidget> {
  @override
  void initState() {
    super.initState();
    widget.storyController.play();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
            width: widget.storyVideo.controller.value.size.width,
            height: widget.storyVideo.controller.value.size.height,
            child: VideoPlayer(widget.storyVideo.controller)),
      ),
    );
  }
}
