import 'package:flutter/material.dart';

import 'package:story_video_player/src/story_player_controller.dart';
import 'package:story_video_player/src/story_progressbar.dart';
import 'package:story_video_player/src/story_video.dart';
import 'package:story_video_player/story_video_player.dart';

class StoryPlayer extends StatelessWidget {
  final StoryPlayerController controller;
  final Function(DragEndDetails)? onVerticalDragEnd;
  final Function(DragEndDetails)? onHorizontalDragEnd;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;
  final Color? progressBarColor;
  final double progressbarTopMargin;

  const StoryPlayer({
    Key? key,
    required this.controller,
    this.onVerticalDragEnd,
    this.onHorizontalDragEnd,
    this.progressBarColor,
    this.progressbarTopMargin = 96,
    this.onVerticalDragUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
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
                    color: progressBarColor ?? Colors.green,
                    progressbarTopMargin: progressbarTopMargin,
                  ),
                  GestureDetector(
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
                    onVerticalDragUpdate: onVerticalDragUpdate,
                  )
                ],
              );
            }
            return Container();
          }),
    );
  }
}
