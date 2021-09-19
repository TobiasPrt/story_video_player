import 'package:flutter/material.dart';
import 'package:story_video_player/src/animated_progressbar_item.dart';
import 'package:story_video_player/src/progressbar_item.dart';

import '../story_video_player.dart';

/// This widget represents the progressbar for a [StoryPlayer] instance.
class StoryProgressbar extends StatelessWidget {
  /// The controller of the linked story
  final StoryPlayerController storyPlayerController;

  /// The color the progress should be in
  final Color color;

  /// The margin from the top the progressbar should have. Useful for notched devices or if any
  /// additional widgets are placed on top of the video like a title.
  final double progressbarTopMargin;

  const StoryProgressbar(
      {Key? key,
      required this.storyPlayerController,
      required this.color,
      required this.progressbarTopMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 2,
      width: deviceWidth,
      margin: EdgeInsets.only(top: progressbarTopMargin),
      alignment: Alignment.topCenter,
      child: Stack(alignment: Alignment.center, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [...buildProgressBar(deviceWidth)]),
      ]),
    );
  }

  /// Builds the progressBar and only uses 1 [AnimatedProgressbarItem] at a time. The rest of the bar
  /// is static. This will rebuild any time the user skips around the videos in the story.
  List<Widget> buildProgressBar(double deviceWidth) {
    List<Widget> progressBarItems = [];

    List<StoryVideo> videos = storyPlayerController.videos;

    for (int i = 0; i < videos.length; i++) {
      double width = deviceWidth / videos.length - 4;

      if (i < storyPlayerController.activeVideoIndex) {
        progressBarItems.add(ProgressbarItem(width: width, color: color));
      } else if (i == storyPlayerController.activeVideoIndex) {
        progressBarItems.add(Container(
          width: width,
          child: Stack(
            children: [
              ProgressbarItem(width: width, color: Colors.black.withAlpha(40)),
              AnimatedProgressbarItem(
                  storyPlayerController: storyPlayerController,
                  width: width,
                  color: color),
            ],
          ),
        ));
      } else {
        progressBarItems.add(
            ProgressbarItem(width: width, color: Colors.black.withAlpha(40)));
      }
    }
    return progressBarItems;
  }
}
