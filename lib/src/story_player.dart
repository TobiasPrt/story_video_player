import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:story_video_player/src/story_player_controller.dart';
import 'package:story_video_player/src/story_progressbar.dart';
import 'package:story_video_player/src/story_video.dart';
import 'package:story_video_player/story_video_player.dart';

class StoryPlayer extends StatelessWidget {
  final StoryPlayerController controller;
  final Function(DragEndDetails)? onVerticalDragEnd;
  final Function(DragEndDetails)? onHorizontalDragEnd;
  final Color? progressBarColor;

  const StoryPlayer({
    Key? key,
    required this.controller,
    this.onVerticalDragEnd,
    this.onHorizontalDragEnd,
    this.progressBarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: GestureDetector(
          onTapUp: (TapUpDetails details) {
            if (details.globalPosition.dx > deviceWidth / 2) {
              controller.nextVideo();
            }
            if (details.globalPosition.dx < deviceWidth / 2) {
              controller.previousVideo();
            }
          },
          onVerticalDragEnd: onVerticalDragEnd,
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: StreamBuilder<StoryVideoInfo>(
              stream: controller.activeVideo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      StoryVideo(
                          url: snapshot.data!.url,
                          storyPlayerController: controller),
                      StoryProgressBar(
                          storyPlayerController: controller,
                          color: progressBarColor ?? Colors.green),
                    ],
                  );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
