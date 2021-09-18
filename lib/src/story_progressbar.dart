import 'package:flutter/material.dart';

import '../story_video_player.dart';

class StoryProgressBar extends StatelessWidget {
  final StoryPlayerController storyPlayerController;
  final Color color;
  final double progressbarTopMargin;

  const StoryProgressBar(
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

  List<Widget> buildProgressBar(double deviceWidth) {
    List<Widget> progressBarItems = [];

    List<StoryVideo> videos = storyPlayerController.videos;

    for (int i = 0; i < videos.length; i++) {
      double width = deviceWidth / videos.length - 4;

      if (i < storyPlayerController.activeVideoIndex) {
        progressBarItems.add(ProgressBarItem(width: width, color: color));
      } else if (i == storyPlayerController.activeVideoIndex) {
        progressBarItems.add(Container(
          width: width,
          child: Stack(
            children: [
              ProgressBarItem(width: width, color: Colors.black.withAlpha(40)),
              AnimatedProgressBarItem(
                  storyPlayerController: storyPlayerController,
                  width: width,
                  color: color),
            ],
          ),
        ));
      } else {
        progressBarItems.add(
            ProgressBarItem(width: width, color: Colors.black.withAlpha(40)));
      }
    }
    return progressBarItems;
  }
}

class ProgressBarItem extends StatelessWidget {
  final double width;
  final Color color;

  const ProgressBarItem({Key? key, required this.width, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: width,
      color: color,
      margin: EdgeInsets.symmetric(horizontal: 2),
    );
  }
}

class AnimatedProgressBarItem extends StatefulWidget {
  final StoryPlayerController storyPlayerController;
  final double width;
  final Color color;

  const AnimatedProgressBarItem(
      {Key? key,
      required this.storyPlayerController,
      required this.width,
      required this.color})
      : super(key: key);

  @override
  _AnimatedProgressBarItemState createState() =>
      _AnimatedProgressBarItemState();
}

class _AnimatedProgressBarItemState extends State<AnimatedProgressBarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      duration: widget.storyPlayerController
          .videos[widget.storyPlayerController.activeVideoIndex].length,
      vsync: this);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _animationController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();

    // widget.storyPlayerController.setProgressBarController(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: Container(
        height: 2,
        width: widget.width,
        color: widget.color,
        margin: EdgeInsets.symmetric(horizontal: 2),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
