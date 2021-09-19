import 'package:flutter/material.dart';

import '../story_video_player.dart';

/// Animated item of the [StoryProgressbar]
class AnimatedProgressbarItem extends StatefulWidget {
  /// Controller of the linked story controller
  final StoryPlayerController storyPlayerController;

  /// Maximum width this progressbar item will have
  final double width;

  /// Color which should represent the current progress
  final Color color;

  const AnimatedProgressbarItem(
      {Key? key,
      required this.storyPlayerController,
      required this.width,
      required this.color})
      : super(key: key);

  @override
  _AnimatedProgressbarItemState createState() =>
      _AnimatedProgressbarItemState();
}

/// State of the progressbar
class _AnimatedProgressbarItemState extends State<AnimatedProgressbarItem>
    with SingleTickerProviderStateMixin {
  /// The animation controller which handles the animation of the progressbar
  late final AnimationController _animationController = AnimationController(
      duration: widget.storyPlayerController
          .videos[widget.storyPlayerController.activeVideoIndex].length,
      vsync: this);

  /// Definition of the used animation
  late final Animation<double> _animation =
      CurvedAnimation(parent: _animationController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    // Sets the progressbar controller in the story controller to this new currently active one
    widget.storyPlayerController.setProgressBarController(_animationController);
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
